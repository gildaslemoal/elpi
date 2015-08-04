package org.ofbiz.backend;

import java.sql.Timestamp;
import java.util.*;

import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.model.ModelEntity;
import org.ofbiz.entity.util.EntityUtil;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.ServiceUtil;


public class BackendExportService {
    public static final String module = BackendExportService.class.getName();
    public static Map<String, Object> exportCustomer(DispatchContext dctx, Map<String, ? extends Object> context) {
        Debug.log("exportCustomer Java", module);

        Delegator delegator = dctx.getDelegator();

        Map<String, Object> result = exportParty(dctx, context);
        if(ServiceUtil.isError(result)) {
            return result;
        }
        result = exportUserLogin(dctx, context);
        if(ServiceUtil.isError(result)) {
            return result;
        }

        String partyId = (String) context.get("partyId");
        Map<String, Object> results = null;
        Map<String, Object> callCtx = null;
        try {
            //export Email
            GenericValue pcmp = EntityUtil.getFirst(EntityUtil.filterByDate(delegator.findByAnd("PartyContactMechPurpose", UtilMisc.toMap("partyId", partyId, "contactMechPurposeTypeId", "PRIMARY_EMAIL"), null, false)));
            if (UtilValidate.isNotEmpty(pcmp)) {
                String emailContactMechId = (String) pcmp.get("contactMechId");
                GenericValue emailPartyContactMech = EntityUtil.getFirst(EntityUtil.filterByDate(delegator.findByAnd("PartyContactMech", UtilMisc.toMap("partyId", partyId, "contactMechId", emailContactMechId), null, false)));
                Timestamp emailContactMechFromDate = (Timestamp) emailPartyContactMech.get("fromDate");
                callCtx = dctx.makeValidContext("exportPartyEmailAddress", "IN", context);
    
                callCtx.put("partyId", partyId);
                callCtx.put("contactMechId", emailContactMechId);
                callCtx.put("fromDate", emailContactMechFromDate);
    
                results = exportPartyEmailAddress(dctx, callCtx);
                if (ServiceUtil.isError(results)) {
                    return results;
                }
            }
            List<GenericValue> contacts  = EntityUtil.filterByDate(delegator.findByAnd("PartyContactMech", UtilMisc.toMap("partyId", partyId), null, false));
            for (GenericValue contact : contacts) {
                GenericValue cm = dctx.getDelegator().findOne("ContactMech", UtilMisc.toMap("contactMechId", contact.get("contactMechId")), false);
                if ("POSTAL_ADDRESS".equals(cm.getString("contactMechTypeId"))) {
                    callCtx = dctx.makeValidContext("exportPartyPostalAddress", "IN", context);

                    callCtx.put("partyId", partyId);
                    callCtx.put("contactMechId", contact.get("contactMechId"));
                    callCtx.put("fromDate", contact.get("fromDate"));
                    results = exportPartyPostalAddress(dctx, callCtx);
                    if (ServiceUtil.isError(results)) {
                        return results;
                    }
                    List<GenericValue> cmps = EntityUtil.filterByDate(delegator.findByAnd("PartyContactMechPurpose", UtilMisc.toMap("partyId", partyId, "contactMechId", contact.get("contactMechId")), null, false));
                    for (GenericValue cmp : cmps) {
                        
                        callCtx = dctx.makeValidContext("exportPartyContactMechPurpose", "IN", context);
                        callCtx.put("partyId", partyId);
                        callCtx.put("contactMechId", cmp.get("contactMechId"));
                        callCtx.put("fromDate", cmp.get("fromDate"));
                        callCtx.put("contactMechPurposeTypeId", cmp.get("contactMechPurposeTypeId"));
                        results = exportPartyContactMechPurpose(dctx, callCtx);
                        if (ServiceUtil.isError(results)) {
                            return results;
                        }
                    }
                }
                else if ("TELECOM_NUMBER".equals(cm.getString("contactMechTypeId"))) {
                    callCtx = dctx.makeValidContext("exportPartyTelecomNumber", "IN", context);

                    callCtx.put("partyId", partyId);
                    callCtx.put("contactMechId", contact.get("contactMechId"));
                    callCtx.put("fromDate", contact.get("fromDate"));
                    results = exportPartyTelecomNumber(dctx, callCtx);
                    if (ServiceUtil.isError(results)) {
                        return results;
                    }
                    List<GenericValue> cmps = EntityUtil.filterByDate(delegator.findByAnd("PartyContactMechPurpose", UtilMisc.toMap("partyId", partyId, "contactMechId", contact.get("contactMechId")), null, false));
                    for (GenericValue cmp : cmps) {
                        
                        callCtx = dctx.makeValidContext("exportPartyContactMechPurpose", "IN", context);
                        callCtx.put("partyId", partyId);
                        callCtx.put("contactMechId", cmp.get("contactMechId"));
                        callCtx.put("fromDate", cmp.get("fromDate"));
                        callCtx.put("contactMechPurposeTypeId", cmp.get("contactMechPurposeTypeId"));
                        results = exportPartyContactMechPurpose(dctx, callCtx);
                        if (ServiceUtil.isError(results)) {
                            return results;
                        }
                    }
                }
            }
            return ServiceUtil.returnSuccess();
        } catch (Exception e) {
            e.printStackTrace();
            return ServiceUtil.returnError("exportCustomer : Unable to export user profile du to errors : " + e.getMessage());
        }
    }

    public static Map<String, Object> exportPartyContactMechPurpose(DispatchContext dctx, 
            Map<String, ? extends Object> context) throws GenericEntityException, GenericServiceException{
        String partyId = (String) context.get("partyId");
        String contactMechId = (String) context.get("contactMechId");
        String contactMechPurposeTypeId = (String) context.get("contactMechPurposeTypeId");
        Timestamp fromDate = (Timestamp) context.get("fromDate");
        Delegator delegator = dctx.getDelegator();
        GenericValue pcmp = delegator.findOne("PartyContactMechPurpose", 
                UtilMisc.toMap("partyId", partyId, 
                               "contactMechId", contactMechId,
                               "fromDate", fromDate,
                               "contactMechPurposeTypeId", contactMechPurposeTypeId
                               ), false);
        if (UtilValidate.isEmpty(pcmp)) {
            return ServiceUtil.returnError("BackendExportService.exportPartyPostalAddressPurpose : Error exporting party contact mech purpose to backend. can find contact mech purpose using input parameters");
        }
        if (UtilValidate.isNotEmpty(pcmp)) {
            Map<String, Object> callCtx = dctx.makeValidContext("exportPartyContactMechPurposeToBack", "IN", context);

            callCtx.put("webService", "exportPartyContactMechPurposeToBack");
            return BackendUtils.exportService(dctx, callCtx);
        }
        return ServiceUtil.returnSuccess();
    }

    public static Map<String, Object> exportPartyAndLogin(DispatchContext dctx, Map<String, ? extends Object> context) {
        Map<String, Object> result = exportParty(dctx, context);
        if(ServiceUtil.isError(result)) {
            return result;
        }
        return exportUserLogin(dctx, context);
    }

    public static Map<String, Object> exportParty(DispatchContext dctx, Map<String, ? extends Object> context) {
        String partyId = (String) context.get("partyId");
        if (UtilValidate.isEmpty(partyId)) {
            return ServiceUtil.returnError("BackendExportService.exportParty : Error exporting party to backend. partyId was empty");
        }
        Map<String, Object> exportCtx = new HashMap<String, Object>();
        try {
            GenericValue value = dctx.getDelegator().findOne("Party", UtilMisc.toMap("partyId", partyId), false);
            if (UtilValidate.isEmpty(value)) {
                return ServiceUtil.returnError("BackendExportService.exportParty : Error exporting party to backend. partyId " + partyId + " was not valid");
            }
            exportCtx.putAll(value.getAllFields());
            value = dctx.getDelegator().findOne("Person", UtilMisc.toMap("partyId", partyId), false);
            if (UtilValidate.isEmpty(value)) {
                return ServiceUtil.returnError("BackendExportService.exportParty : Error exporting party to backend. partyId " + partyId + " was not valid");
            }
            exportCtx.putAll(value.getAllFields());
            exportCtx.put("roleTypeId", "CUSTOMER");
            exportCtx.put("webService", "exportPartyToBack");
            return BackendUtils.exportService(dctx, transformeOne(exportCtx));
        }
        catch(Exception e) {
            return ServiceUtil.returnError("BackendExportService.exportParty : Error exporting party to backend. " + e.getLocalizedMessage());
        }
    }

    public static Map<String, Object> exportUserLogin(DispatchContext dctx, Map<String, ? extends Object> context) {
        
        String userLoginId = (String) context.get("userLoginId");
        Map<String, Object> exportCtx = new HashMap<String, Object>();
        try {
            GenericValue value = null;
            if (UtilValidate.isEmpty(userLoginId)) {
                String partyId = (String) context.get("partyId");
                if (UtilValidate.isEmpty(partyId)) {
                    return ServiceUtil.returnError("BackendExportService.exportUserLogin : Error exporting userLogin to backend. partyId ans userLoginId were both empty");
                }
                value = EntityUtil.getFirst(dctx.getDelegator().findByAnd("UserLogin", UtilMisc.toMap("partyId", partyId), null, false));
            }
            else {
                value = dctx.getDelegator().findOne("UserLogin", UtilMisc.toMap("userLoginId", userLoginId), false);
                if (UtilValidate.isEmpty(value)) {
                    return ServiceUtil.returnError("BackendExportService.exportUserLogin : Error exporting userLogin to backend. userLoginId " + userLoginId + " was not valid");
                }
            }

            if (UtilValidate.isEmpty(value)) {
                return ServiceUtil.returnError("BackendExportService.exportUserLogin : Error exporting userLogin to backend. Can not find userLogin to export using. userLoginId='" + userLoginId + "' and partyId='" + context.get("partyId") + " was not valid");
            }
            exportCtx.put("partyId", value.getString("partyId"));
            exportCtx.put("userLoginId", value.getString("userLoginId"));
            exportCtx.put("webService", "exportUserLoginToBack");
            return BackendUtils.exportService(dctx, transformeOne(exportCtx));
        }
        catch(Exception e) {
            return ServiceUtil.returnError("BackendExportService.exportUserLogin : Error exporting party to backend. " + e.getLocalizedMessage());
        }
    }

    public static Map<String, Object> exportConsumerOrder(DispatchContext dctx, Map<String, ? extends Object> context) {
        String orderId = (String) context.get("orderId");
        if (UtilValidate.isEmpty(orderId)) {
            return ServiceUtil.returnError("BackendExportService.exportConsumerOrder : Error exporting order to backend. orderId was empty");
        }
        Map<String, Object> exportCtx = new HashMap<String, Object>();
        try {
            GenericValue oh = dctx.getDelegator().findOne("OrderHeader", UtilMisc.toMap("orderId", orderId), false);
            if (UtilValidate.isEmpty(oh)) {
                return ServiceUtil.returnError("BackendExportService.exportConsumerOrder : Error exporting order to backend. orderId " +orderId + " was not valid");
            }

            exportCtx.put("orderHeader", transformeOne(oh.getAllFields()));

            exportCtx.put("orderItems", transformeList(oh.getRelated("OrderItem", null, null, false)));

            exportCtx.put("orderAdjustments", transformeList(oh.getRelated("OrderAdjustment", null, null, false)));

            exportCtx.put("paymentInfos", transformeList(oh.getRelated("OrderPaymentPreference", null, null, false)));

            exportCtx.put("orderRoles", transformeList(oh.getRelated("OrderRole", null, null, false)));

            exportCtx.put("orderContactMechs", transformeList(oh.getRelated("OrderContactMech", null, null, false)));
            exportCtx.put("webService", "exportConsumerOrderToBack");
            return BackendUtils.exportService(dctx, exportCtx);
        }
        catch(Exception e) {
            return ServiceUtil.returnError("BackendExportService.exportConsumerOrder : Error exporting order to backend. " + e.getLocalizedMessage());
        }
    }

    public static  Map<String, Object> exportPartyPostalAddress(DispatchContext dctx, Map<String, ? extends Object> context) {
        String partyId = (String) context.get("partyId");
        String contactMechId = (String) context.get("contactMechId");
        Timestamp fromDate = (Timestamp) context.get("fromDate");
        if (UtilValidate.isEmpty(partyId)) {
            return ServiceUtil.returnError("BackendExportService.exportPartyPostalAddress : Error exporting postalAddress to backend. partyId was empty");
        }
        if (UtilValidate.isEmpty(fromDate)) {
            return ServiceUtil.returnError("BackendExportService.exportPartyPostalAddress : Error exporting postalAddress to backend. fromDate was empty");
        }
        if (UtilValidate.isEmpty(contactMechId)) {
            return ServiceUtil.returnError("BackendExportService.exportPartyPostalAddress : Error exporting postalAddress to backend. contactMechId was empty");
        }
        Map<String, Object> exportCtx = new HashMap<String, Object>();
        try {
            GenericValue value = dctx.getDelegator().findOne("ContactMech", UtilMisc.toMap("contactMechId", contactMechId), false);
            if (UtilValidate.isEmpty(value)) {
                return ServiceUtil.returnError("BackendExportService.exportPartyPostalAddress : Error exporting postal address to backend. contactMechId " + contactMechId + " was not valid");
            }
            exportCtx.putAll(value.getAllFields());
            value = dctx.getDelegator().findOne("PostalAddress", UtilMisc.toMap("contactMechId", contactMechId), false);
            if (UtilValidate.isEmpty(value)) {
                return ServiceUtil.returnError("BackendExportService.exportPartyPostalAddress : Error exporting postal address to backend. contactMechId " + contactMechId + " was not valid");
            }
            exportCtx.putAll(value.getAllFields());
            value = dctx.getDelegator().findOne("PartyContactMech", UtilMisc.toMap("contactMechId", contactMechId, "partyId", partyId, "fromDate", fromDate), false);
            if (UtilValidate.isEmpty(value)) {
                return ServiceUtil.returnError("BackendExportService.exportPartyPostalAddress : Error exporting postal address to backend. fromDate " + fromDate + " was not valid");
            }
            exportCtx.putAll(value.getAllFields());
            exportCtx.put("webService", "exportPartyPostalAddressToBack");
            return BackendUtils.exportService(dctx, transformeOne(exportCtx));
        }
        catch(Exception e) {
            return ServiceUtil.returnError("BackendExportService.exportParty : Error exporting party to backend. " + e.getLocalizedMessage());
        }
    }
    public static  Map<String, Object> exportPartyEmailAddress(DispatchContext dctx, Map<String, ? extends Object> context) {
        String partyId = (String) context.get("partyId");
        String contactMechId = (String) context.get("contactMechId");
        Timestamp fromDate = (Timestamp) context.get("fromDate");
        if (UtilValidate.isEmpty(partyId)) {
            return ServiceUtil.returnError("BackendExportService.exportPartyEmailAddress : Error exporting emailAddress to backend. partyId was empty");
        }
        if (UtilValidate.isEmpty(fromDate)) {
            return ServiceUtil.returnError("BackendExportService.exportPartyEmailAddress : Error exporting emailAddress to backend. fromDate was empty");
        }
        if (UtilValidate.isEmpty(contactMechId)) {
            return ServiceUtil.returnError("BackendExportService.exportPartyEmailAddress : Error exporting emailAddress to backend. contactMechId was empty");
        }
        Map<String, Object> exportCtx = new HashMap<String, Object>();
        try {
            GenericValue value = dctx.getDelegator().findOne("ContactMech", UtilMisc.toMap("contactMechId", contactMechId), false);
            if (UtilValidate.isEmpty(value)) {
                return ServiceUtil.returnError("BackendExportService.exportPartyEmailAddress : Error exporting email address to backend. contactMechId " + contactMechId + " was not valid");
            }
            exportCtx.putAll(value.getAllFields());
            exportCtx.put("emailAddress", value.get("infoString"));

            value = dctx.getDelegator().findOne("PartyContactMech", UtilMisc.toMap("contactMechId", contactMechId, "partyId", partyId, "fromDate", fromDate), false);
            if (UtilValidate.isEmpty(value)) {
                return ServiceUtil.returnError("BackendExportService.exportPartyEmailAddress : Error exporting postal address to backend. fromDate " + fromDate + " was not valid");
            }
            exportCtx.putAll(value.getAllFields());
            exportCtx.put("fromDate", fromDate);
            exportCtx.put("contactMechPurposeTypeId", "PRIMARY_EMAIL");
            exportCtx.put("contactMechId", contactMechId);

            exportCtx.put("webService", "exportPartyEmailAddressToBack");
            return BackendUtils.exportService(dctx, transformeOne(exportCtx));
        }
        catch(Exception e) {
            return ServiceUtil.returnError("BackendExportService.exportPartyEmailAddress : Error exporting party email address to backend. " + e.getLocalizedMessage());
        }
    }

    public static List<Map<String, Object>> transformeList(List<GenericValue> values) {
        List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
        for(GenericValue value : values) {
            result.add(transformeOne(value));
        }
        return result;
    }
    public static Map<String, Object> transformeOne(GenericValue value) {
        return transformeOne(value.getAllFields());
    }
    public static Map<String, Object> transformeOne(Map<String, Object> value) {
        Map<String, Object> result = new HashMap<String, Object>();
        if (UtilValidate.isNotEmpty(value)) {
            for (String key : value.keySet()) {
                if (UtilValidate.isNotEmpty(value.get(key))
                        && ! isAutoField(key)) {
                    result.put(key, value.get(key));
                }
            }
        }
        return result;
    }
    public static boolean isAutoField(String name) {
        return (name.equals(ModelEntity.STAMP_FIELD)
                || name.equals(ModelEntity.STAMP_TX_FIELD)
                || name.equals(ModelEntity.CREATE_STAMP_FIELD)
                || name.equals(ModelEntity.CREATE_STAMP_TX_FIELD)
                || name.equals("createdBy")
                || name.equals("createdByUserLogin")
                || name.equals("lastModifiedByUserLogin")
                || name.equals("changeByUserLoginId")
                );
    }

    public static Map<String, Object> exportPartyTelecomNumber(DispatchContext dctx, Map<String, ? extends Object> context) {
        String partyId = (String) context.get("partyId");
        String contactMechId = (String) context.get("contactMechId");
        Timestamp fromDate = (Timestamp) context.get("fromDate");
        if (UtilValidate.isEmpty(partyId)) {
            return ServiceUtil.returnError("BackendExportService.exportPartyTelecomNumber : Error exporting telephone number to backend. partyId was empty");
        }
        if (UtilValidate.isEmpty(fromDate)) {
            return ServiceUtil.returnError("BackendExportService.exportPartyTelecomNumber : Error exporting telephone number to backend. fromDate was empty");
        }
        if (UtilValidate.isEmpty(contactMechId)) {
            return ServiceUtil.returnError("BackendExportService.exportPartyTelecomNumber : Error exporting telephone number to backend. contactMechId was empty");
        }
        Map<String, Object> exportCtx = new HashMap<String, Object>();
        try {
            GenericValue value = dctx.getDelegator().findOne("ContactMech", UtilMisc.toMap("contactMechId", contactMechId), false);
            if (UtilValidate.isEmpty(value)) {
                return ServiceUtil.returnError("BackendExportService.exportPartyTelecomNumber : Error exporting telephone number to backend. contactMechId " + contactMechId + " was not valid");
            }
            value = dctx.getDelegator().findOne("TelecomNumber", UtilMisc.toMap("contactMechId", contactMechId), false);
            if (UtilValidate.isEmpty(value)) {
                return ServiceUtil.returnError("BackendExportService.exportPartyTelecomNumber : Error exporting telephone number to backend. contactMechId " + contactMechId + " was not valid");
            }
            exportCtx.putAll(value.getAllFields());

            value = dctx.getDelegator().findOne("PartyContactMech", UtilMisc.toMap("contactMechId", contactMechId, "partyId", partyId, "fromDate", fromDate), false);
            if (UtilValidate.isEmpty(value)) {
                return ServiceUtil.returnError("BackendExportService.exportPartyTelecomNumber : Error exporting telephone number to backend. fromDate " + fromDate + " was not valid");
            }
            exportCtx.putAll(value.getAllFields());
            exportCtx.put("fromDate", fromDate);
            exportCtx.put("contactMechId", contactMechId);

            exportCtx.put("webService", "exportPartyTelecomNumberToBack");
            return BackendUtils.exportService(dctx, transformeOne(exportCtx));
        }
        catch(Exception e) {
            return ServiceUtil.returnError("BackendExportService.exportPartyTelecomNumber : Error exporting party telephone number to backend. " + e.getLocalizedMessage());
        }
    }
}
