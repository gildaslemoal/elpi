package org.ofbiz.frontend;

import java.security.SecureRandom;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import org.ofbiz.base.crypto.HashCrypt;
import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.UtilDateTime;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilProperties;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.util.EntityUtil;
import org.ofbiz.party.contact.ContactMechWorker;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;
import org.ofbiz.service.ServiceUtil;

import com.ibm.icu.util.Calendar;

/**
 * Created by julien on 16/02/15.
 */
public class FrontendServices {
    public static final String module = FrontendServices.class.getName();
    public static final String resource = "FrontEndUiLabels";
    public static final String errors = "FrontEndErrorUiLabels";
    /**
     * this service is similar to that of ContactMechService.java but it check that there is a login with the given email address
     */

    public static Map<String, Object> createEmailAddressVerification(DispatchContext dctx, Map<String, ? extends Object> context) {
        Delegator delegator = dctx.getDelegator();
        Locale locale = (Locale) context.get("locale");
        String emailAddress = (String) context.get("emailAddress");
        String verifyHash = null;

        String expireTime = UtilProperties.getPropertyValue("security", "email_verification.expire.hours");
        Integer expTime = Integer.valueOf(expireTime);
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.HOUR, expTime.intValue());
        Date date = calendar.getTime();
        Timestamp expireDate = UtilDateTime.toTimestamp(date);

        SecureRandom secureRandom = new SecureRandom();

        synchronized(FrontendServices.class) {
            while (true) {
                Long random = secureRandom.nextLong();
                verifyHash = HashCrypt.digestHash("MD5", Long.toString(random).getBytes());
                if (UtilValidate.isNotEmpty(verifyHash) && verifyHash.startsWith("{MD5}")) {
                    verifyHash = verifyHash.replace("{MD5}", "");
                }
                try {
                    //first check if there is a login for this email address
                    GenericValue userLogin = delegator.findOne("UserLogin", UtilMisc.toMap("userLoginId", emailAddress), false);
                    if (UtilValidate.isEmpty(userLogin)) {
                        Map<String, Object> result =  ServiceUtil.returnError(UtilProperties.getMessage(errors, "FrontEndEmailUnkownAsUserLogin", locale));
                        result.put("mailVerify", "Y");
                        return result;
                    }
                    delegator.removeByCondition("EmailAddressVerification", EntityCondition.makeCondition("emailAddress", emailAddress));
                } catch (GenericEntityException e) {
                    Debug.logError(e.getMessage(), module);
                    return ServiceUtil.returnError(e.getMessage());
                }
                GenericValue emailAddressVerification = delegator.makeValue("EmailAddressVerification");
                emailAddressVerification.set("emailAddress", emailAddress);
                emailAddressVerification.set("verifyHash", verifyHash);
                emailAddressVerification.set("expireDate", expireDate);
                try {
                    delegator.create(emailAddressVerification);
                } catch (GenericEntityException e) {
                    Debug.logError(e.getMessage(),module);
                    return ServiceUtil.returnError(e.getMessage());
                }
                break;
            }
        }
        try {
            Map<String, Object> mailCtx = dctx.makeValidContext("sendPasswordResetLink", "IN", context);
            mailCtx.put("emailAddress", emailAddress);
            dctx.getDispatcher().runAsync("sendPasswordResetLink", context);
        } catch (GenericServiceException e) {
            Debug.logError(e.getMessage(),module);
            return ServiceUtil.returnError(e.getMessage());
        }
        Map<String, Object> result = ServiceUtil.returnSuccess(UtilProperties.getMessage(resource, "FrontEndNotificationMailConfim", locale));
        result.put("verifyHash", verifyHash);
        return result;
    }

    public static Map<String, Object> sendPasswordResetLink(DispatchContext dctx, Map<String, ? extends Object> context) {
        Delegator delegator = dctx.getDelegator();
        String emailAddress = (String) context.get("emailAddress");
        try {
            GenericValue emailverif = delegator.findOne("EmailAddressVerification", UtilMisc.toMap("emailAddress", emailAddress), false);
            if (UtilValidate.isEmpty(emailAddress)) {
                Debug.logError("Email address has no verification can not send password reset link", module);
                return ServiceUtil.returnSuccess();
            }
            GenericValue ets = delegator.findOne("EmailTemplateSetting", UtilMisc.toMap("emailTemplateSettingId", "SUP_REQ_PWD_RESET"), false);
            if (UtilValidate.isEmpty(ets) || UtilValidate.isEmpty(ets.getString("bodyScreenLocation"))) {
                Debug.logError("Email tempalte for password reset link does not exists or has no bodyScreenLocation, can not send password reset link", module);
                return ServiceUtil.returnSuccess();
            }
            Map<String, Object> emailParams = dctx.makeValidContext("sendMailFromScreen", "IN", context);
            emailParams.put("sendTo", emailAddress);
            emailParams.put("subject", ets.get("subject"));
            emailParams.put("sendFrom", ets.get("fromAddress"));
            emailParams.put("sendCc", ets.get("ccAddress"));
            emailParams.put("sendBcc", ets.get("bccAddress"));
            emailParams.put("contentType", ets.get("contentType"));
            emailParams.put("bodyScreenUri", ets.get("bodyScreenLocation"));
            emailParams.put("bodyParameters", UtilMisc.toMap("verifyHash", emailverif.get("verifyHash"), "expireDate", emailverif.get("expireDate")));
            dctx.getDispatcher().runSync("sendMailFromScreen", emailParams);

        } catch (GenericEntityException gee) {
            Debug.logError("Can not send password reset link due to folowing error" + gee.getMessage(), module);
        }
        catch (GenericServiceException gse) {
            Debug.logError("Can not send password reset link due to folowing error" + gse.getMessage(), module);
        }
        return ServiceUtil.returnSuccess();
    }

    public static Map<String, Object> requestPasswordReset(DispatchContext dctx, Map<String, ? extends Object> context) {
        Locale locale = (Locale) context.get("locale");
        Delegator delegator = dctx.getDelegator();
        String verifyHash = (String) context.get("verifyHash");
        try {
            GenericValue emailverif = EntityUtil.getFirst(delegator.findByAnd("EmailAddressVerification", UtilMisc.toMap("verifyHash", verifyHash), null, false));
            if (UtilValidate.isEmpty(emailverif)) {
                return ServiceUtil.returnError(UtilProperties.getMessage(errors, "FrontEndResetPasswordBadLinkError", locale));
            }
            if(UtilDateTime.nowTimestamp().after(emailverif.getTimestamp("expireDate"))) {
                return ServiceUtil.returnError(UtilProperties.getMessage(errors, "FrontEndResetPasswordExpiredLinkError", locale));
            }
            Map<String, Object> result = ServiceUtil.returnSuccess();
            result.put("emailAddress", emailverif.getString("emailAddress"));
            return result;
        } catch (GenericEntityException gee) {
            Debug.logError("Can not send password reset link due to folowing error" + gee.getMessage(), module);
            return ServiceUtil.returnError("Error processing verifyHash dur to " + gee.getMessage());
        }
    }

    public static Map<String, Object> resetPassword(DispatchContext dctx, Map<String, ? extends Object> context) {
        Locale locale = (Locale) context.get("locale");
        Delegator delegator = dctx.getDelegator();
        String emailAddress = (String) context.get("emailAddress");
        try {
            GenericValue emailverif = delegator.findOne("EmailAddressVerification", UtilMisc.toMap("emailAddress", emailAddress), false);
            if (UtilValidate.isEmpty(emailverif)) {
                return ServiceUtil.returnError(UtilProperties.getMessage(errors, "FrontEndResetPasswordBadLinkError", locale));
            }
            GenericValue userLogin = delegator.findOne("UserLogin", UtilMisc.toMap("userLoginId", emailAddress), false);
            if (UtilValidate.isEmpty(userLogin)) {
                return ServiceUtil.returnError(UtilProperties.getMessage(errors, "FrontEndResetPasswordBadLinkError", locale));
            }

            Map<String, Object> callCtx = dctx.makeValidContext("updatePassword", "IN", context);
            GenericValue sys = delegator.findOne("UserLogin", UtilMisc.toMap("userLoginId", "system"), false);
            callCtx.put("userLogin", sys);
            callCtx.put("userLoginId", userLogin.get("userLoginId"));
            callCtx.put("currentPassword", userLogin.get("currentPassword"));
            callCtx.put("newPassword", context.get("password"));
            callCtx.put("newPasswordVerify", context.get("rpassword"));

            Map<String, Object> result = dctx.getDispatcher().runSync("updatePassword", callCtx);
            if (ServiceUtil.isError(result)) {
                return result;
            }
            emailverif.remove();
            return ServiceUtil.returnSuccess();
        } catch (GenericEntityException gee) {
            Debug.logError("Can not change supplier password due to folowing error" + gee.getMessage(), module);
            return ServiceUtil.returnError("Can not change supplier password due to folowing error" + gee.getMessage());
        }
        catch (GenericServiceException gse) {
            Debug.logError("Can not change supplier password due to folowing error" + gse.getMessage(), module);
            return ServiceUtil.returnError("Can not change supplier password due to folowing error" + gse.getMessage());
        }
    }

    public static Map<String, Object> createProfil(DispatchContext dctx, Map<String, Object> context) throws GenericServiceException, GenericEntityException {
        Map<String, Object> result = ServiceUtil.returnSuccess();
        LocalDispatcher dispatcher = dctx.getDispatcher();

        String userBirthDate = (String) context.get("USER_BIRTHDATE");
        //Timestamp birthDate = UtilDateTime.stringToTimeStamp(userBirthDate, "dd/MM/yyyy", (TimeZone) context.get("timeZone"), (Locale) context.get("locale"));
        //Debug.log("birthDate",birthDate);
        result.put("USER_BIRTHDATE",userBirthDate);
        //context.put("USER_BIRTHDATE",userBirthDate);

//        String USER_TITLE = (String) context.get("USER_TITLE");
//        String USER_LAST_NAME = (String) context.get("USER_LAST_NAME");
//        String USER_FIRST_NAME = (String) context.get("USER_FIRST_NAME");
//        String USER_BIRTHDATE = userBirthDate;
//        String CUSTOMER_HOME_CONTACT = (String) context.get("CUSTOMER_HOME_CONTACT");
//        String CUSTOMER_MOBILE_CONTACT = (String) context.get("CUSTOMER_MOBILE_CONTACT");
//        String CUSTOMER_ADDRESS1 = (String) context.get("CUSTOMER_ADDRESS1");
//        String CUSTOMER_ADDRESS2 = (String) context.get("CUSTOMER_ADDRESS2");
//        String CUSTOMER_POSTAL_CODE = (String) context.get("CUSTOMER_POSTAL_CODE");
//        String CUSTOMER_CITY = (String) context.get("CUSTOMER_CITY");
//        String CUSTOMER_COUNTRY = (String) context.get("CUSTOMER_COUNTRY");
//        String CUSTOMER_STATE = (String) context.get("CUSTOMER_STATE");
//        String CUSTOMER_EMAIL = (String) context.get("CUSTOMER_EMAIL");
//        String PASSWORD = (String) context.get("PASSWORD");
//        String CUSTOMER_EMAIL_ALLOW_SOL = (String) context.get("CUSTOMER_EMAIL_ALLOW_SOL");
//        if (UtilValidate.isEmpty(CUSTOMER_EMAIL_ALLOW_SOL)) {
//            CUSTOMER_EMAIL_ALLOW_SOL = "N";
//        }
//
//        GenericValue party = dctx.getDelegator().makeValidValue("Party", context);
//        String partyId = dctx.getDelegator().getNextSeqId("Party");
//        party.put("partyId", partyId);
//        party.put("statusId", "PARTY_DISABLED");
//        party.create();
//
//        GenericValue userLogin = dctx.getDelegator().findOne("UserLogin", Boolean.TRUE, UtilMisc.toMap("userLoginId", "system"));
//        context.put("userLogin", userLogin);
//
//        Map<String, Object> createPartyAttributeMap = dctx.makeValidContext("createPartyAttribute", "IN", context);
//        createPartyAttributeMap.put("partyId", partyId);
//        createPartyAttributeMap.put("attrName", "USER_TITLE");
//        createPartyAttributeMap.put("attrValue", USER_TITLE);
//        result = dispatcher.runSync("createPartyAttribute", createPartyAttributeMap);
//        if (ServiceUtil.isError(result)) throw new GenericServiceException(ServiceUtil.getErrorMessage(result));
//
//        createPartyAttributeMap.clear();
//        createPartyAttributeMap = dctx.makeValidContext("createPartyAttribute", "IN", context);
//        createPartyAttributeMap.put("partyId", partyId);
//        createPartyAttributeMap.put("attrName", "USER_LAST_NAME");
//        createPartyAttributeMap.put("attrValue", USER_LAST_NAME);
//        result = dispatcher.runSync("createPartyAttribute", createPartyAttributeMap);
//        if (ServiceUtil.isError(result)) throw new GenericServiceException(ServiceUtil.getErrorMessage(result));
//
//        createPartyAttributeMap.clear();
//        createPartyAttributeMap = dctx.makeValidContext("createPartyAttribute", "IN", context);
//        createPartyAttributeMap.put("partyId", partyId);
//        createPartyAttributeMap.put("attrName", "USER_FIRST_NAME");
//        createPartyAttributeMap.put("attrValue", USER_FIRST_NAME);
//        result = dispatcher.runSync("createPartyAttribute", createPartyAttributeMap);
//        if (ServiceUtil.isError(result)) throw new GenericServiceException(ServiceUtil.getErrorMessage(result));
//
//        createPartyAttributeMap.clear();
//        createPartyAttributeMap = dctx.makeValidContext("createPartyAttribute", "IN", context);
//        createPartyAttributeMap.put("partyId", partyId);
//        createPartyAttributeMap.put("attrName", "USER_BIRTHDATE");
//        createPartyAttributeMap.put("attrValue", USER_BIRTHDATE);
//        result = dispatcher.runSync("createPartyAttribute", createPartyAttributeMap);
//        if (ServiceUtil.isError(result)) throw new GenericServiceException(ServiceUtil.getErrorMessage(result));
//
//        createPartyAttributeMap.clear();
//        createPartyAttributeMap = dctx.makeValidContext("createPartyAttribute", "IN", context);
//        createPartyAttributeMap.put("partyId", partyId);
//        createPartyAttributeMap.put("attrName", "CUSTOMER_HOME_CONTACT");
//        createPartyAttributeMap.put("attrValue", CUSTOMER_HOME_CONTACT);
//        result = dispatcher.runSync("createPartyAttribute", createPartyAttributeMap);
//        if (ServiceUtil.isError(result)) throw new GenericServiceException(ServiceUtil.getErrorMessage(result));
//
//        createPartyAttributeMap.clear();
//        createPartyAttributeMap = dctx.makeValidContext("createPartyAttribute", "IN", context);
//        createPartyAttributeMap.put("partyId", partyId);
//        createPartyAttributeMap.put("attrName", "CUSTOMER_MOBILE_CONTACT");
//        createPartyAttributeMap.put("attrValue", CUSTOMER_MOBILE_CONTACT);
//        result = dispatcher.runSync("createPartyAttribute", createPartyAttributeMap);
//        if (ServiceUtil.isError(result)) throw new GenericServiceException(ServiceUtil.getErrorMessage(result));
//
//        createPartyAttributeMap.clear();
//        createPartyAttributeMap = dctx.makeValidContext("createPartyAttribute", "IN", context);
//        createPartyAttributeMap.put("partyId", partyId);
//        createPartyAttributeMap.put("attrName", "CUSTOMER_ADDRESS1");
//        createPartyAttributeMap.put("attrValue", CUSTOMER_ADDRESS1);
//        result = dispatcher.runSync("createPartyAttribute", createPartyAttributeMap);
//        if (ServiceUtil.isError(result)) throw new GenericServiceException(ServiceUtil.getErrorMessage(result));
//
//        createPartyAttributeMap.clear();
//        createPartyAttributeMap = dctx.makeValidContext("createPartyAttribute", "IN", context);
//        createPartyAttributeMap.put("partyId", partyId);
//        createPartyAttributeMap.put("attrName", "CUSTOMER_ADDRESS2");
//        createPartyAttributeMap.put("attrValue", CUSTOMER_ADDRESS2);
//        result = dispatcher.runSync("createPartyAttribute", createPartyAttributeMap);
//        if (ServiceUtil.isError(result)) throw new GenericServiceException(ServiceUtil.getErrorMessage(result));
//
//        createPartyAttributeMap.clear();
//        createPartyAttributeMap = dctx.makeValidContext("createPartyAttribute", "IN", context);
//        createPartyAttributeMap.put("partyId", partyId);
//        createPartyAttributeMap.put("attrName", "CUSTOMER_POSTAL_CODE");
//        createPartyAttributeMap.put("attrValue", CUSTOMER_POSTAL_CODE);
//        result = dispatcher.runSync("createPartyAttribute", createPartyAttributeMap);
//        if (ServiceUtil.isError(result)) throw new GenericServiceException(ServiceUtil.getErrorMessage(result));
//
//        createPartyAttributeMap.clear();
//        createPartyAttributeMap = dctx.makeValidContext("createPartyAttribute", "IN", context);
//        createPartyAttributeMap.put("partyId", partyId);
//        createPartyAttributeMap.put("attrName", "CUSTOMER_CITY");
//        createPartyAttributeMap.put("attrValue", CUSTOMER_CITY);
//        result = dispatcher.runSync("createPartyAttribute", createPartyAttributeMap);
//        if (ServiceUtil.isError(result)) throw new GenericServiceException(ServiceUtil.getErrorMessage(result));
//
//        createPartyAttributeMap.clear();
//        createPartyAttributeMap = dctx.makeValidContext("createPartyAttribute", "IN", context);
//        createPartyAttributeMap.put("partyId", partyId);
//        createPartyAttributeMap.put("attrName", "CUSTOMER_COUNTRY");
//        createPartyAttributeMap.put("attrValue", CUSTOMER_COUNTRY);
//        result = dispatcher.runSync("createPartyAttribute", createPartyAttributeMap);
//        if (ServiceUtil.isError(result)) throw new GenericServiceException(ServiceUtil.getErrorMessage(result));
//
//        createPartyAttributeMap.clear();
//        createPartyAttributeMap = dctx.makeValidContext("createPartyAttribute", "IN", context);
//        createPartyAttributeMap.put("partyId", partyId);
//        createPartyAttributeMap.put("attrName", "CUSTOMER_STATE");
//        createPartyAttributeMap.put("attrValue", CUSTOMER_STATE);
//        result = dispatcher.runSync("createPartyAttribute", createPartyAttributeMap);
//        if (ServiceUtil.isError(result)) throw new GenericServiceException(ServiceUtil.getErrorMessage(result));
//
//        createPartyAttributeMap.clear();
//        createPartyAttributeMap = dctx.makeValidContext("createPartyAttribute", "IN", context);
//        createPartyAttributeMap.put("partyId", partyId);
//        createPartyAttributeMap.put("attrName", "CUSTOMER_EMAIL");
//        createPartyAttributeMap.put("attrValue", CUSTOMER_EMAIL);
//        result = dispatcher.runSync("createPartyAttribute", createPartyAttributeMap);
//        if (ServiceUtil.isError(result)) throw new GenericServiceException(ServiceUtil.getErrorMessage(result));
//
//        createPartyAttributeMap.clear();
//        createPartyAttributeMap = dctx.makeValidContext("createPartyAttribute", "IN", context);
//        createPartyAttributeMap.put("partyId", partyId);
//        createPartyAttributeMap.put("attrName", "PASSWORD");
//        createPartyAttributeMap.put("attrValue", PASSWORD);
//        result = dispatcher.runSync("createPartyAttribute", createPartyAttributeMap);
//        if (ServiceUtil.isError(result)) throw new GenericServiceException(ServiceUtil.getErrorMessage(result));
//
//        createPartyAttributeMap.clear();
//        createPartyAttributeMap = dctx.makeValidContext("createPartyAttribute", "IN", context);
//        createPartyAttributeMap.put("partyId", partyId);
//        createPartyAttributeMap.put("attrName", "CUSTOMER_EMAIL_ALLOW_SOL");
//        createPartyAttributeMap.put("attrValue", CUSTOMER_EMAIL_ALLOW_SOL);
//        result = dispatcher.runSync("createPartyAttribute", createPartyAttributeMap);
//        if (ServiceUtil.isError(result)) throw new GenericServiceException(ServiceUtil.getErrorMessage(result));

//        result.put("partyId", partyId);
        return result;
    }

    public static Map<String, Object> updateProfil(DispatchContext dctx, Map<String, ? extends Object> context) {
        Locale locale = (Locale) context.get("locale");
        Delegator delegator = dctx.getDelegator();
        Map<String, Object> result = ServiceUtil.returnSuccess();
        String contactMechTypeId ;
        String contactMechId ;
        boolean updateContactMech ;

        String partyId = (String) context.get("PARTY_ID");
        String userTitle = (String) context.get("USER_TITLE");
        String lastname = (String) context.get("USER_LAST_NAME");
        String firstname = (String) context.get("USER_FIRST_NAME");
        String userBirthDate = (String) context.get("USER_BIRTHDATE");
        String address1 = (String) context.get("CUSTOMER_ADDRESS1");
        String address2 = (String) context.get("CUSTOMER_ADDRESS2");
        String postalCode = (String) context.get("CUSTOMER_POSTAL_CODE");
        String city = (String) context.get("CUSTOMER_CITY");
        String country = (String) context.get("CUSTOMER_COUNTRY");
        String state = (String) context.get("CUSTOMER_STATE");
        String customerHomeContact = (String) context.get("CUSTOMER_HOME_CONTACT");
        String customerMobileContact = (String) context.get("CUSTOMER_MOBILE_CONTACT");
//        String customerDefaultRoof = (String) context.get("CUSTOMER_DEFAULT_ROOF");
        if(UtilValidate.isEmpty(partyId)){
            GenericValue userLogin = (GenericValue) context.get("userLogin");
            partyId = (String) userLogin.get("partyId");
        }

        List<Map<String,Object>> contactMechList = ContactMechWorker.getPartyContactMechValueMaps(delegator, partyId, false);

        try {
            for (Map<String, Object> contactMech: contactMechList){
                GenericValue contactMechType = (GenericValue) contactMech.get("contactMechType");
                contactMechTypeId = (String) contactMechType.get("contactMechTypeId");
                GenericValue partyContactMech = (GenericValue) contactMech.get("partyContactMech");
                contactMechId = (String) partyContactMech.get("contactMechId");

                if("POSTAL_ADDRESS".equals(contactMechTypeId)){
                    List<GenericValue> partyContactMechPurposes = (List<GenericValue>) contactMech.get("partyContactMechPurposes");
                    updateContactMech = false;
                    for (GenericValue partyContactMechPurpose: partyContactMechPurposes){
                        if ("SHIPPING_LOCATION".equals(partyContactMechPurpose.get("contactMechPurposeTypeId"))) {
                            updateContactMech = true;
                        }
                    }
                    if(updateContactMech) {
                        Map<String, Object> postalAddress;
                        postalAddress = dctx.makeValidContext("updatePartyPostalAddress", "IN", context);
                        postalAddress.put("partyId", partyId);
                        postalAddress.put("address1", address1);
                        postalAddress.put("address2", address2);
                        postalAddress.put("postalCode", postalCode);
                        postalAddress.put("city", city);
                        postalAddress.put("stateProvinceGeoId", state);
                        postalAddress.put("countryGeoId", country);
                        postalAddress.put("contactMechId", contactMechId);

                        result = dctx.getDispatcher().runSync("updatePartyPostalAddress", postalAddress);
                        if (ServiceUtil.isError(result))
                            throw new GenericServiceException(ServiceUtil.getErrorMessage(result));
                    }
                }
                if("TELECOM_NUMBER".equals(contactMechTypeId)){
                    List<GenericValue> partyContactMechPurposes = (List<GenericValue>) contactMech.get("partyContactMechPurposes");
                    updateContactMech = false;
                    String contactMechPurposeTypeId ;
                    String updateContactMechTypeid="";
                    for (GenericValue partyContactMechPurpose: partyContactMechPurposes){
                        contactMechPurposeTypeId = (String) partyContactMechPurpose.get("contactMechPurposeTypeId");
                        if ("PHONE_HOME".equals(contactMechPurposeTypeId) || "PHONE_MOBILE".equals(contactMechPurposeTypeId)) {
                            updateContactMech = true;
                            updateContactMechTypeid = contactMechPurposeTypeId;
                        }
                    }
                    if(updateContactMech) {
                        Map<String, Object> telecomNumber;
                        telecomNumber = dctx.makeValidContext("createUpdatePartyTelecomNumber", "IN", context);
                        telecomNumber.put("partyId",partyId);
                        telecomNumber.put("contactMechId", contactMechId);
                        if ("PHONE_HOME".equals(updateContactMechTypeid)) {
                            telecomNumber.put("contactNumber", customerHomeContact);
                        } else if ("PHONE_MOBILE".equals(updateContactMechTypeid)) {
                            telecomNumber.put("contactNumber", customerMobileContact);
                        }

                        result = dctx.getDispatcher().runSync("createUpdatePartyTelecomNumber", telecomNumber);
                        if (ServiceUtil.isError(result))
                            throw new GenericServiceException(ServiceUtil.getErrorMessage(result));
                    }
                }
            }

//==================================================
//            Mise à jour des données personnelles
            Map<String, Object> personalData;
            personalData = dctx.makeValidContext("updatePerson", "IN", context);
            personalData.put("partyId",partyId);

            personalData.put("personalTitle", userTitle);
            personalData.put("lastName", lastname);
            personalData.put("firstName", firstname);

            SimpleDateFormat dateFormatter = new SimpleDateFormat("dd/MM/yyyy");
            Date birthDate = dateFormatter.parse(userBirthDate);
            personalData.put("birthDate", birthDate);

            result = dctx.getDispatcher().runSync("updatePerson", personalData);
            if (ServiceUtil.isError(result))
                throw new GenericServiceException(ServiceUtil.getErrorMessage(result));
        }
        catch (GenericServiceException e){
            e.printStackTrace();
        } catch (ParseException e) {
            e.printStackTrace();
        }
        result = ServiceUtil.returnSuccess();

        return result;
    }
    public static Map<String, Object> getUserDefaultRoof(DispatchContext dctx, Map<String, ? extends Object> context) {
        Map<String, Object> result = ServiceUtil.returnSuccess();
        String defaultRoof = "";

        String userLogin = (String) context.get("USER_LOGIN");

        try {
            Map<String, Object> getUserPreference;
            getUserPreference = dctx.makeValidContext("getUserPreference", "IN", context);

            if (UtilValidate.isNotEmpty(userLogin)) {
                getUserPreference.put("userPrefLoginId", userLogin);
            }
            getUserPreference.put("userPrefTypeId", "DEFAULT_ROOF");
            getUserPreference.put("userPrefGroupTypeId", "GLOBAL_PREFERENCES");

            result = dctx.getDispatcher().runSync("getUserPreference", getUserPreference);

            if(ServiceUtil.isError(result)) {
                throw new GenericServiceException(ServiceUtil.getErrorMessage(result));
            } else {
                Map<String, Object> userPrefMap = (Map<String, Object>) result.get("userPrefMap") ;
                defaultRoof = (String) userPrefMap.get("DEFAULT_ROOF") ;
            }
        } catch (GenericServiceException e) {
            e.printStackTrace();
        }

        result.clear();
        result.put("CUSTOMER_DEFAULT_ROOF", defaultRoof) ;

        return result;

    }

    public static Map<String, Object> selectMembership(DispatchContext dctx, Map<String, ? extends Object> context) {
        Map<String, Object> result = ServiceUtil.returnSuccess();

        String productId = "";
        String adhesion = (String) context.get("adhesionRadios");
        if ("simple".equals(adhesion)) {
            productId = "10000";
        } else if ("couple".equals(adhesion)) {
            productId = "10001";
        } else if ("jeune".equals(adhesion)) {
            productId = "10002";
        }

        result.put("add_product_id", productId);

        return result;
    }

    public static Map<String, Object> selectGift(DispatchContext dctx, Map<String, ? extends Object> context) {
        Map<String, Object> result = ServiceUtil.returnSuccess();

        String giftAmount = (String) context.get("donRadios");
        String productId = "10010";
        if (UtilValidate.isEmpty(giftAmount)) {
            return ServiceUtil.returnError("");
        } else if ("personalized".equals(giftAmount)) {
            giftAmount = (String) context.get("gift-amount");
        }

        result.put("add_product_id", productId);
        result.put("quantity", giftAmount);

        return result;
    }
}
