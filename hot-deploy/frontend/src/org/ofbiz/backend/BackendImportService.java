package org.ofbiz.backend;

import java.util.List;
import java.util.Map;

import org.ofbiz.base.util.UtilGenerics;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityComparisonOperator;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityJoinOperator;
import org.ofbiz.entity.util.EntityUtil;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.ServiceUtil;


public class BackendImportService {

    public static Map<String, Object> importProductCategory(DispatchContext dctx, Map<String, Object> context) {
        try {
            String serviceName = "createProductCategory";
            if (UtilValidate.isNotEmpty(dctx.getDelegator().findOne("ProductCategory", false, "productCategoryId", context.get("productCategoryId")))) {
                serviceName = "updateProductCategory";
            }
            Map<String, Object> results = dctx.getDispatcher().runSync(serviceName, context);
            if (ServiceUtil.isError(results)) {
                return results;
            }
            else {
                return ServiceUtil.returnSuccess();
            }
        }
        catch (Exception e ) {
            return ServiceUtil.returnError(e.getLocalizedMessage());
        }
    }

    public static Map<String, Object> importProductCategoryRemoval(DispatchContext dctx, Map<String, Object> context) {
        try {
            dctx.getDelegator().removeByPrimaryKey(dctx.getDelegator().makePK("ProductCategory", context));
            return ServiceUtil.returnSuccess();
        }
        catch (GenericEntityException gee ) {
            return ServiceUtil.returnError(gee.getLocalizedMessage());
        }
    }

    public static Map<String, Object> importProduct(DispatchContext dctx, Map<String, Object> context) {
        try {
            String serviceName = "createProduct";
            if (UtilValidate.isNotEmpty(dctx.getDelegator().findOne("Product", false, 
                    "productId", context.get("productId")))) {
                serviceName = "updateProduct";
            }
            Map<String, Object> results = dctx.getDispatcher().runSync(serviceName, dctx.makeValidContext(serviceName, "IN", context));
            if (ServiceUtil.isError(results)) {
                return results;
            }
            else {
                return ServiceUtil.returnSuccess();
            }
        }
        catch (Exception e ) {
            return ServiceUtil.returnError(e.getLocalizedMessage());
        }
    }

    public static Map<String, Object> importProductToProductCategory(DispatchContext dctx, Map<String, Object> context) {
        try {
            String serviceName = "addProductToCategory";
            if (UtilValidate.isNotEmpty(dctx.getDelegator().findOne("ProductCategoryMember", false, 
                    "productCategoryId", context.get("productCategoryId"), 
                    "productId", context.get("productId"), 
                    "fromDate", context.get("fromDate")))) {
                serviceName = "updateProductToCategory";
            }
            Map<String, Object> results = dctx.getDispatcher().runSync(serviceName, context);
            if (ServiceUtil.isError(results)) {
                return results;
            }
            else {
                return ServiceUtil.returnSuccess();
            }
        }
        catch (Exception e ) {
            return ServiceUtil.returnError(e.getLocalizedMessage());
        }
    }

    public static Map<String, Object> importFacility(DispatchContext dctx, Map<String, Object> context) {
        try {
            GenericValue facility = dctx.getDelegator().findOne("Facility", false, "facilityId", context.get("facilityId"));
            if (UtilValidate.isNotEmpty(facility)) {
                facility.setNonPKFields(context);
                facility.store();
            }
            else {
                facility = dctx.getDelegator().makeValidValue("Facility", context);
                facility.create();
            }
            return ServiceUtil.returnSuccess();
        }
        catch (Exception e ) {
            return ServiceUtil.returnError(e.getLocalizedMessage());
        }
    }

    public static Map<String, Object> importProductOffer(DispatchContext dctx, Map<String, Object> context) {
        try {
            GenericValue offer = dctx.getDelegator().findOne("ProductOffer", false, "productOfferId", context.get("productOfferId"));
            if (UtilValidate.isNotEmpty(offer)) {
                offer.setNonPKFields(context);
                offer.store();
            }
            else {
                offer = dctx.getDelegator().makeValidValue("ProductOffer", context);
                offer.create();
            }
            if (UtilValidate.isNotEmpty(context.get("adjustments"))) {
                List<Map<String, Object>> adjustments = UtilGenerics.checkList(context.get("adjustments"));
                offer.removeRelated("ProductOfferAdjustment");
                for (Map<String, Object> adjustment : adjustments) {
                    GenericValue adj = dctx.getDelegator().makeValidValue("ProductOfferAdjustment", adjustment);
                    adj.create();
                }
            }
            return ServiceUtil.returnSuccess();
        }
        catch (Exception e ) {
            return ServiceUtil.returnError(e.getLocalizedMessage());
        }
    }

    public static Map<String, Object> importProductOfferFacility(DispatchContext dctx, Map<String, Object> context) {
        try {
            GenericValue offer = dctx.getDelegator().findOne("ProductOfferFacility", false, 
                "productOfferId", context.get("productOfferId"),
                "facilityId", context.get("facilityId"),
                "fromDate", context.get("fromDate")
                );
            if (UtilValidate.isNotEmpty(offer)) {
                offer.setNonPKFields(context);
                offer.store();
            }
            else {
                offer = dctx.getDelegator().makeValidValue("ProductOfferFacility", context);
                offer.create();
            }
            return ServiceUtil.returnSuccess();
        }
        catch (Exception e ) {
            return ServiceUtil.returnError(e.getLocalizedMessage());
        }
    }

    public static Map<String, Object> importProductFeatureCategory(DispatchContext dctx, Map<String, Object> context) {
        try {
            GenericValue pfc = dctx.getDelegator().findOne("ProductFeatureCategory", false, 
                "productFeatureCategoryId", context.get("productFeatureCategoryId"));
            if (UtilValidate.isNotEmpty(pfc)) {
                pfc.setNonPKFields(context);
                pfc.store();
            }
            else {
                pfc = dctx.getDelegator().makeValidValue("ProductFeatureCategory", context);
                pfc.create();
            }
            return ServiceUtil.returnSuccess();
        }
        catch (Exception e ) {
            return ServiceUtil.returnError(e.getLocalizedMessage());
        }
    }

    public static Map<String, Object> importProductFeature(DispatchContext dctx, Map<String, Object> context) {
        try {
            GenericValue pf = dctx.getDelegator().findOne("ProductFeature", false, 
                "productFeatureId", context.get("productFeatureId"));
            if (UtilValidate.isNotEmpty(pf)) {
                pf.setNonPKFields(context);
                pf.store();
            }
            else {
                pf = dctx.getDelegator().makeValidValue("ProductFeature", context);
                pf.create();
            }
            return ServiceUtil.returnSuccess();
        }
        catch (Exception e ) {
            return ServiceUtil.returnError(e.getLocalizedMessage());
        }
    }

    public static Map<String, Object> importFeatureCategoryAppl(DispatchContext dctx, Map<String, Object> context) {
        try {
            GenericValue pfca = dctx.getDelegator().findOne("ProductFeatureCategoryAppl", false, 
                "productCategoryId", context.get("productCategoryId"),
                "productFeatureCategoryId", context.get("productFeatureCategoryId"),
                "fromDate", context.get("fromDate")
                );
            if (UtilValidate.isNotEmpty(pfca)) {
                pfca.setNonPKFields(context);
                pfca.store();
            }
            else {
                pfca = dctx.getDelegator().makeValidValue("ProductFeatureCategoryAppl", context);
                pfca.create();
            }
            return ServiceUtil.returnSuccess();
        }
        catch (Exception e ) {
            return ServiceUtil.returnError(e.getLocalizedMessage());
        }
    }

    public static Map<String, Object> importFeatureCategoryApplRemove(DispatchContext dctx, Map<String, Object> context) {
        try {
            GenericValue pfca = dctx.getDelegator().findOne("ProductFeatureCategoryAppl", false, 
                "productCategoryId", context.get("productCategoryId"),
                "productFeatureCategoryId", context.get("productFeatureCategoryId"),
                "fromDate", context.get("fromDate")
                );
            if (UtilValidate.isNotEmpty(pfca)) {
                pfca.remove();
            }
            else {
                return ServiceUtil.returnError("ProductFeatureCategoryAppl removal failed, no vaule for keys :" 
                        + "[" + context.get("productCategoryId") + "], "
                        + "[" + context.get("productFeatureCategoryId") + "], "
                        + "[" + context.get("fromDate") + "]");
            }
            return ServiceUtil.returnSuccess();
        }
        catch (Exception e ) {
            return ServiceUtil.returnError(e.getLocalizedMessage());
        }
    }

    public static Map<String, Object> importProductFeatureAppl(DispatchContext dctx, Map<String, Object> context) {
        try {
            GenericValue pfa = dctx.getDelegator().findOne("ProductFeatureAppl", false, 
                "productId", context.get("productId"),
                "productFeatureId", context.get("productFeatureId"),
                "fromDate", context.get("fromDate")
                );
            if (UtilValidate.isNotEmpty(pfa)) {
                pfa.setNonPKFields(context);
                pfa.store();
            }
            else {
                pfa = dctx.getDelegator().makeValidValue("ProductFeatureAppl", context);
                pfa.create();
            }
            return ServiceUtil.returnSuccess();
        }
        catch (Exception e ) {
            return ServiceUtil.returnError(e.getLocalizedMessage());
        }
    }

    public static Map<String, Object> importProductFeatureApplRemoval(DispatchContext dctx, Map<String, Object> context) {
        try {
            GenericValue pfca = dctx.getDelegator().findOne("ProductFeatureAppl", false, 
                "productId", context.get("productId"),
                "productFeatureId", context.get("productFeatureId"),
                "fromDate", context.get("fromDate")
                );
            if (UtilValidate.isNotEmpty(pfca)) {
                pfca.remove();
            }
            else {
                return ServiceUtil.returnError("ProductFeatureAppl removal failed, no vaule for keys :" 
                        + "[" + context.get("productId") + "], "
                        + "[" + context.get("productFeatureId") + "], "
                        + "[" + context.get("fromDate") + "]");
            }
            return ServiceUtil.returnSuccess();
        }
        catch (Exception e ) {
            return ServiceUtil.returnError(e.getLocalizedMessage());
        }
    }

    public static Map<String, Object> importGoodIdentification(DispatchContext dctx, Map<String, Object> context) {
        try {
            GenericValue gi = dctx.getDelegator().findOne("GoodIdentification", false, 
                "productId", context.get("productId"),
                "goodIdentificationTypeId", context.get("goodIdentificationTypeId")
                );
            if (UtilValidate.isNotEmpty(gi)) {
                gi.setNonPKFields(context);
                gi.store();
            }
            else {
                gi = dctx.getDelegator().makeValidValue("GoodIdentification", context);
                gi.create();
            }
            return ServiceUtil.returnSuccess();
        }
        catch (Exception e ) {
            return ServiceUtil.returnError(e.getLocalizedMessage());
        }
    }

    public static Map<String, Object> importGoodIdentificationType(DispatchContext dctx, Map<String, Object> context) {
        try {
            GenericValue git = dctx.getDelegator().findOne("GoodIdentificationType", false, 
                "goodIdentificationTypeId", context.get("goodIdentificationTypeId")
                );
            if (UtilValidate.isNotEmpty(git)) {
                git.setNonPKFields(context);
                git.store();
            }
            else {
                git = dctx.getDelegator().makeValidValue("GoodIdentificationType", context);
                git.create();
            }
            return ServiceUtil.returnSuccess();
        }
        catch (Exception e ) {
            return ServiceUtil.returnError(e.getLocalizedMessage());
        }
    }

    public static Map<String, Object> importProductImage(DispatchContext dctx, Map<String, Object> context) {
        return ServiceUtil.returnSuccess();
    }

    public static Map<String, Object> importProductImageRemoval(DispatchContext dctx, Map<String, Object> context) {
        return ServiceUtil.returnSuccess();
    }

    public static Map<String, Object> importProductText(DispatchContext dctx, Map<String, Object> context) {
        return ServiceUtil.returnSuccess();
    }

    public static Map<String, Object> importProductTextRemoval(DispatchContext dctx, Map<String, Object> context) {
        return ServiceUtil.returnSuccess();
    }

    public static Map<String, Object> importProductDocument(DispatchContext dctx, Map<String, Object> context) {
        return ServiceUtil.returnSuccess();
    }

    public static Map<String, Object> importProductDocumentRemoval(DispatchContext dctx, Map<String, Object> context) {
        return ServiceUtil.returnSuccess();
    }

    public static Map<String, Object> importProductCategoryMemberRemoval(DispatchContext dctx, Map<String, Object> context) {
        return ServiceUtil.returnSuccess();
    }

    public static Map<String, Object> importProductDataRemoval(DispatchContext dctx, Map<String, Object> context) {
        String productId = (String) context.get("productId");
        try {
            GenericValue product= dctx.getDelegator().findOne("Product", true, "productId", productId);
            if ("Y".equals(context.get("category"))) {
                product.removeRelated("ProductCategoryMember");
            }
            if ("Y".equals(context.get("identification"))) {
                product.removeRelated("GoodIdentification");
            }
            if ("Y".equals(context.get("feature"))) {
                product.removeRelated("ProductFeatureApplAttr");
                product.removeRelated("ProductFeatureAppl");
            }
            if ("Y".equals(context.get("image"))) {
                removeProductContentByParentType(dctx.getDelegator(), productId, "FRONT_IMAGES");
            }
            if ("Y".equals(context.get("text"))) {
                removeProductContentByParentType(dctx.getDelegator(), productId, "PRODUCT_TEXT");
            }
            if ("Y".equals(context.get("document"))) {
                removeProductContentByParentType(dctx.getDelegator(), productId, "DOCUMENT_COMMERCIAL");
            }
            
        }
        catch(GenericEntityException gee) {
            return ServiceUtil.returnError(gee.getLocalizedMessage());
        }
        return ServiceUtil.returnSuccess();
    }
    public static void removeProductContentByParentType(Delegator delegator, String productId, String parentTypeId) throws GenericEntityException{
        List<String> types = EntityUtil.getFieldListFromEntityList(
                delegator.findByAnd("ProductContentType", UtilMisc.toMap("parentTypeId",  parentTypeId), null, true), 
                "productContentTypeId", 
                true);
        EntityCondition cond = EntityCondition.makeCondition(
                UtilMisc.toList(
                    EntityCondition.makeCondition("productContentTypeId", EntityComparisonOperator.IN, types),
                    EntityCondition.makeCondition("productId", EntityComparisonOperator.EQUALS, productId)
                    ),
                    EntityJoinOperator.AND
                );
        delegator.removeByCondition("ProductContent", cond);
    }
    public static Map<String, Object> importGoodIdentificationRemoval(DispatchContext dctx, Map<String, Object> context) {
        try {
            GenericValue gi = dctx.getDelegator().findOne("GoodIdentification", false, 
                "productId", context.get("productId"),
                "goodIdentificationTypeId", context.get("goodIdentificationTypeId")
                );
            if (UtilValidate.isNotEmpty(gi)) {
                gi.remove();
            }
            else {
                return ServiceUtil.returnError("GoodIdentification removal failed, no vaule for keys :" 
                        + "[" + context.get("productId") + "], "
                        + "[" + context.get("goodIdentificationTypeId") + "]");
            }
            return ServiceUtil.returnSuccess();
        }
        catch (Exception e ) {
            return ServiceUtil.returnError(e.getLocalizedMessage());
        }
    }

    public static Map<String, Object> importSupplier(DispatchContext dctx, Map<String, Object> context) {
        try {
            GenericValue party = dctx.getDelegator().findOne("PartyGroup", false, 
                "partyId", context.get("partyId"));
            if (UtilValidate.isNotEmpty(party)) {
                party.setNonPKFields(context);
                party.store();
            }
            else {
                party = dctx.getDelegator().makeValidValue("Party", context);
                party.create();
                party = dctx.getDelegator().makeValidValue("PartyGroup", context);
                party.create();
            }
            return ServiceUtil.returnSuccess();
        }
        catch (Exception e ) {
            return ServiceUtil.returnError(e.getLocalizedMessage());
        }
    }

    public static Map<String, Object> importSupplierPostalAddress(DispatchContext dctx, Map<String, Object> context) {
        try {
            String serviceName = "createPartyPostalAddress";
            GenericValue cm = dctx.getDelegator().findOne("ContactMech", false, 
                    "contactMechId", context.get("contactMechId"));
            if (UtilValidate.isNotEmpty(cm)) {
                serviceName = "updatePartyPostalAddress";
            }
            Map<String, Object> results = dctx.getDispatcher().runSync(serviceName, context);
            if (ServiceUtil.isError(results)) {
                return results;
            }
            else {
                return ServiceUtil.returnSuccess();
            }
        }
        catch (Exception e ) {
            return ServiceUtil.returnError(e.getLocalizedMessage());
        }
    }

    public static Map<String, Object> importSupplierTelecomNumber(DispatchContext dctx, Map<String, Object> context) {
        try {
            String serviceName = "createPartyTelecomNumber";
            GenericValue cm = dctx.getDelegator().findOne("ContactMech", false, 
                    "contactMechId", context.get("contactMechId"));
            if (UtilValidate.isNotEmpty(cm)) {
                serviceName = "updateatePartyTelecomNumber";
            }
            Map<String, Object> results = dctx.getDispatcher().runSync(serviceName, context);
            if (ServiceUtil.isError(results)) {
                return results;
            }
            else {
                return ServiceUtil.returnSuccess();
            }
        }
        catch (Exception e ) {
            return ServiceUtil.returnError(e.getLocalizedMessage());
        }
    }

    public static Map<String, Object> importSupplierEmailAddress(DispatchContext dctx, Map<String, Object> context) {
        try {
            String serviceName = "createPartyEmailAddress";
            GenericValue cm = dctx.getDelegator().findOne("ContactMech", false, 
                    "contactMechId", context.get("contactMechId"));
            if (UtilValidate.isNotEmpty(cm)) {
                serviceName = "updateatePartyEmailAddress";
            }
            context.put("emailAddress", context.get("infoString"));
            Map<String, Object> results = dctx.getDispatcher().runSync(serviceName, context);
            if (ServiceUtil.isError(results)) {
                return results;
            }
            else {
                return ServiceUtil.returnSuccess();
            }
        }
        catch (Exception e ) {
            return ServiceUtil.returnError(e.getLocalizedMessage());
        }
    }

    public static Map<String, Object> importSupplierContactMechRemoval(DispatchContext dctx, Map<String, Object> context) {
        return ServiceUtil.returnSuccess();
    }

    public static Map<String, Object> importFacilityPostalAddress(DispatchContext dctx, Map<String, Object> context) {
        try {
            String serviceName = "createFacilityPostalAddress";
            GenericValue pa = dctx.getDelegator().findOne("PostalAddress", false, "contactMechId", context.get("contactMechId"));
            if (UtilValidate.isEmpty(pa)) {
                Map<String, Object> results = dctx.getDispatcher().runSync(serviceName, dctx.makeValidContext(serviceName, "IN", context));
                if (ServiceUtil.isError(results)) {
                    return results;
                }
                else {
                    return ServiceUtil.returnSuccess();
                }
            }
            else {
                pa.setNonPKFields(context);
                pa.store();
                return ServiceUtil.returnSuccess();
            }
        }
        catch (Exception e ) {
            return ServiceUtil.returnError(e.getLocalizedMessage());
        }
    }

    public static Map<String, Object> importFacilityTelecomNumber(DispatchContext dctx, Map<String, Object> context) {
        return ServiceUtil.returnSuccess();
    }

    public static Map<String, Object> importFacilityEmailAddress(DispatchContext dctx, Map<String, Object> context) {
        return ServiceUtil.returnSuccess();
    }

    public static Map<String, Object> importFacilityContactMechRemoval(DispatchContext dctx, Map<String, Object> context) {
        return ServiceUtil.returnSuccess();
    }

    public static Map<String, Object> requestOrderPaymentCapturing(DispatchContext dctx, Map<String, Object> context) {
        return ServiceUtil.returnSuccess();
    }

}
