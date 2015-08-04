/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */


import org.ofbiz.entity.util.EntityUtil

import java.util.*;
import org.ofbiz.base.util.*;
import org.ofbiz.entity.*;
import org.ofbiz.product.catalog.CatalogWorker;
import org.ofbiz.product.store.ProductStoreWorker;
import org.ofbiz.common.CommonWorkers;
import org.ofbiz.order.shoppingcart.*;
import org.ofbiz.webapp.control.*;

List<Map<String, Object>> productOfferList = new ArrayList<Map<String, Object>>();

facilityId = session.getAttribute("defaultRoof");

//List<GenericValue> productsList = delegator.findList("Product", null, null, null, null, false);
List<GenericValue> offersList = delegator.findByAnd("ProductOfferFacility", [facilityId : facilityId], null, false);
for (AvailableOffer in offersList) {
    productOfferId = AvailableOffer.get("productOfferId");
    GenericValue productOffer = delegator.findOne("ProductOffer", [productOfferId : productOfferId], false);
    if (UtilValidate.isEmpty(productOffer)) {
        return;
    }
    productId = productOffer.get("productId");
    GenericValue product = delegator.findOne("Product", [productId : productId], false);
    if (UtilValidate.isEmpty(product)) {
        return;
    }
    productName = product.get("productName");
    productDescription = product.get("description");
    if (UtilValidate.isEmpty(productDescription)) {
        productDescription = "";
    }
    List<GenericValue> productContentAndInfos = delegator.findByAnd("ProductContentAndInfo", [productId : productId], null, false);
    commercialArguments = "";
    useAdvises = "";
    picturePath = "";
    for (productContentAndInfo in productContentAndInfos) {
        if ("ARG_COM".equals(productContentAndInfo.get("productContentTypeId"))) {
            dataResourceId = productContentAndInfo.get("dataResourceId");
            GenericValue electronicText = delegator.findOne("ElectronicText", [dataResourceId : dataResourceId], false);
            if (!UtilValidate.isEmpty(electronicText)) {
                commercialArguments = electronicText.get("textData");
            }
        }
        if ("CONSEIL_UTIL".equals(productContentAndInfo.get("productContentTypeId"))) {
            dataResourceId = productContentAndInfo.get("dataResourceId");
            GenericValue electronicText = delegator.findOne("ElectronicText", [dataResourceId : dataResourceId], false);
            if (! UtilValidate.isEmpty(electronicText)) {
                useAdvises = electronicText.get("textData");
            }
        }
        if ("MAIN_IMAGE".equals(productContentAndInfo.get("productContentTypeId"))) {
            picturePath = productContentAndInfo.get("drObjectInfo");
        }
    }

    List<Float> stars = new ArrayList<Float>();
    stars.add(new Float(0));
    stars.add(new Float(0));
    stars.add(new Float(0));
    stars.add(new Float(0));
    stars.add(new Float(0));

    List<GenericValue> productPricesList = delegator.findByAnd("ProductAndPriceView", [productId : productId, productPriceTypeId : "DEFAULT_PRICE", productPricePurposeId : "PURCHASE"], null, false);
    GenericValue productPrice = EntityUtil.getFirst(productPricesList);
    price = productOffer.get("consumerSalePrice");
    currencyUomId = "EUR";

    productOfferList.add(UtilMisc.toMap(
            "productOfferId", productOfferId,
            "product", product,
            "productId", productId,
            "productName", productName,
            "productDescription", productDescription,
            "commercialArguments", commercialArguments,
            "useAdvises", useAdvises,
            "stars", stars,
            "price", price,
            "currencyUomId", currencyUomId,
            "picturePath", picturePath));
}

context.productOfferList = productOfferList;
