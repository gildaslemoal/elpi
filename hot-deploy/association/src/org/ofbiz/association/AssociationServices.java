package org.ofbiz.association;

import org.ofbiz.base.util.Debug;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.party.contact.ContactMechWorker;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;
import org.ofbiz.service.ServiceUtil;
import java.util.*;

public class AssociationServices {
    public static final String module = AssociationServices.class.getName();
    public static final String resource = "AssociationUiLabels";
    public static final String errors = "AssociationUiLabels";

    public static Map<String, Object> sendEmail(DispatchContext dctx, Map<String, ? extends Object> context) throws GenericServiceException, GenericEntityException {
        Delegator delegator = dctx.getDelegator();
        LocalDispatcher dispatcher = dctx.getDispatcher();
        List<String> partyList = (List<String>) context.get("partyList");
        GenericValue userLogin = (GenericValue) context.get("userLogin");
        String sendFrom = "sioux.ofbiz@nomaka.fr";
        String emailContent = (String) context.get("emailContent");

        String partyIdFrom = userLogin.getString("partyId");
        List<Map<String, Object>> valuesFrom = ContactMechWorker.getPartyContactMechValueMaps(delegator, partyIdFrom, false, "EMAIL_ADDRESS");
        for (Map<String, Object> value : valuesFrom) {
            GenericValue contactMech = (GenericValue) value.get("contactMech");
            sendFrom = contactMech.getString("infoString");
        }

        for (String partyId: partyList) {
            List<Map<String, Object>> values = ContactMechWorker.getPartyContactMechValueMaps(delegator, partyId, false, "EMAIL_ADDRESS");
            for (Map<String, Object> value : values) {
                GenericValue contactMech = (GenericValue) value.get("contactMech");
                String eMail = contactMech.getString("infoString");
                GenericValue partyNameView = delegator.findOne("PartyNameView", false, "partyId", partyId);
                String lastName = partyNameView.getString("lastName");
                String firstName = partyNameView.getString("firstName");

                Map<String, Object> sendMailCtx = dctx.makeValidContext("sendMailFromTemplateSetting", "IN", context);
                sendMailCtx.put("emailTemplateSettingId", "EMAIL_GENERIQUE");
                sendMailCtx.put("sendTo", eMail);
                sendMailCtx.put("partyIdTo", partyId);

                //get sendFrom email adress
                sendMailCtx.put("sendFrom", sendFrom);

                //get bodyParameters from custom method
                Map<String, Object> bodyParameters = new HashMap<String, Object>();
                bodyParameters.put("firstName", firstName);
                bodyParameters.put("lastName", lastName);
                bodyParameters.put("emailContent", emailContent);

                sendMailCtx.put("bodyParameters", bodyParameters);

                //call service to send mail
                dispatcher.runAsync("sendMailFromTemplateSetting", sendMailCtx);
            }
        }

        Map<String, Object> result = ServiceUtil.returnSuccess();
        return result;
    }
}
