/**
 * Created by julien on 17/06/15.
 */
import org.ofbiz.entity.util.EntityUtil;
import org.ofbiz.base.util.UtilValidate;

if(UtilValidate.isEmpty(parameters.partyId)) {
    return
}
partyId = parameters.partyId ;
String contactMechTypeId ;
party = delegator.findOne("Party", ["partyId": partyId], true);
person = delegator.findOne("Person", ["partyId": partyId],true);
cotisation = "0" ;

userLogin = EntityUtil.getFirst(delegator.findByAnd("UserLogin",["partyId": partyId], null, false));
if(UtilValidate.isNotEmpty(userLogin)) {
    userLoginId = userLogin.get("userLoginId");
}

partyContactMechList = EntityUtil.filterByDate(delegator.findByAnd("PartyContactMech", ["partyId": partyId], null, false));
for (partyContactMech in partyContactMechList){
    contactMech = delegator.findOne("ContactMech", ["contactMechId": partyContactMech.contactMechId], true);
    contactMechTypeId = contactMech.get("contactMechTypeId");
    contactMechId = contactMech.get("contactMechId");
    if ("POSTAL_ADDRESS".equals(contactMechTypeId)) {
        postalAddress = delegator.findOne("PostalAddress", ["contactMechId": partyContactMech.contactMechId], true);
    }
    if ("ELECTRONIC_ADDRESS".equals(contactMechTypeId) || "EMAIL_ADDRESS".equals(contactMechTypeId)){
        emailAddress = contactMech.infoString;
    }
    if ("TELECOM_NUMBER".equals(contactMechTypeId)) {
        partyContactMechPurposeList = EntityUtil.filterByDate(delegator.findByAnd("PartyContactMechPurpose", ["partyId": partyId, "contactMechId": contactMechId]));
        for (partyContactMechPurpose in partyContactMechPurposeList) {
            telecomNumberType = partyContactMechPurpose.get("contactMechPurposeTypeId");
            if("PHONE_HOME".equals(telecomNumberType)){
                phoneHome = delegator.findOne("TelecomNumber", ["contactMechId": contactMechId], true);
            }
            if("PHONE_MOBILE".equals(telecomNumberType)){
                phoneMobile = delegator.findOne("TelecomNumber", ["contactMechId": contactMechId], true);
            }
        }
    }
}

partyAttributeList = delegator.findByAnd("PartyAttribute", ["partyId": partyId], null, false);
for (partyAttribute in partyAttributeList) {
    partyAttributeAttrName = partyAttribute.get("attrName");
    if ("COTISATION".equals(partyAttributeAttrName)) {
        cotisation = partyAttribute.get("attrValue");
    }
}

visitList = EntityUtil.filterByDate(delegator.findByAnd("Visit", ["partyId": partyId], null, false));
if(UtilValidate.isNotEmpty(visitList)){
    connected = true ;
} else {
    connected = false ;
}

if (UtilValidate.isEmpty(person.get("salutation"))) {
    genre = person.get("personalTitle");
} else {
    if ("Misses".equals(person.get("salutation"))) {
        genre = "Mme" ;
    } else {
        genre = "Mr" ;
    }
}

context.put("partyId",partyId);
context.put("userLoginId",userLoginId);
context.put("party",party);
context.put("person",person);
context.put("cotisation",cotisation);
context.put("postalAddress",postalAddress);
context.put("emailAddress",emailAddress);
context.put("phoneHome",phoneHome);
context.put("phoneMobile",phoneMobile);
context.put("genre",genre);
context.put("connected", connected)