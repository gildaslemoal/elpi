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

// This script gets shipment items grouped by package for use in the packing slip PDF or any screens that require by-package layout

import org.ofbiz.base.util.*;
import org.ofbiz.entity.condition.*;
import org.ofbiz.entity.util.EntityTypeUtil

// Since this script is run after ViewShipment, we will re-use the shipment in the context
shipment = context.shipment;
if (!shipment) {
    return;
}

// get the packages related to this shipment in order of packages
shipmentPackages = shipment.getRelated("ShipmentPackage", null, ['shipmentPackageSeqId'], false);

// first we scan the shipment items and count the quantity of each product that is being shipped
quantityShippedByProduct = [:];
quantityInShipmentByProduct = [:];
shipmentItems = shipment.getRelated("ShipmentItem", null, null, false);
shipmentItems.each { shipmentItem ->
    productId = shipmentItem.productId;
    shipped = quantityShippedByProduct.get(productId);
    if (!shipped) {
        shipped = 0 as Double;
    }
    shipped += shipmentItem.getDouble("quantity").doubleValue();
    quantityShippedByProduct.put(productId, shipped);
    quantityInShipmentByProduct.put(productId, shipped);
}

// Add in the total of all previously shipped items
previousShipmentIter = delegator.find("Shipment",
        EntityCondition.makeCondition(
            UtilMisc.toList(
                EntityCondition.makeCondition("primaryOrderId", EntityOperator.EQUALS, shipment.getString("primaryOrderId")),
                EntityCondition.makeCondition("shipmentTypeId", EntityOperator.EQUALS, "SALES_SHIPMENT"),
                EntityCondition.makeCondition("createdDate", EntityOperator.LESS_THAN_EQUAL_TO,
                        ObjectType.simpleTypeConvert(shipment.getString("createdDate"), "Timestamp", null, null))
            ),
        EntityOperator.AND), null, null, null, null);

while (previousShipmentItem = previousShipmentIter.next()) {
    if (!previousShipmentItem.shipmentId.equals(shipment.shipmentId)) {
        previousShipmentItems = previousShipmentItem.getRelated("ShipmentItem", null, null, false);
        previousShipmentItems.each { shipmentItem ->
            productId = shipmentItem.productId;
            shipped = quantityShippedByProduct.get(productId);
            if (!shipped) {
                shipped = new Double(0);
            }
            shipped += shipmentItem.getDouble("quantity").doubleValue();
            quantityShippedByProduct.put(productId, shipped);
        }
    }
}
previousShipmentIter.close();

// next scan the order items (via issuances) to count the quantity of each product requested
quantityRequestedByProduct = [:];
countedOrderItems = [:]; // this map is only used to keep track of the order items already counted
order = shipment.getRelatedOne("PrimaryOrderHeader", false);
if (UtilValidate.isNotEmpty(order)) {
    //get primary order info
    context.order = order;
    context.primaryOrderHeaderId = order.orderId;
}
Timestamp estimatedShipDate = shipment.getTimestamp("estimatedShipDate");
Timestamp estimatedDeliveryDate = shipment.getTimestamp("estimatedArrivalDate");
context.put("handlingInstructions", shipment.getString("handlingInstructions"));

//get carring info
oisg = shipment.getRelatedOne("PrimaryOrderItemShipGroup");
if(oisg != null){
    //set shipping Dates
    if (UtilValidate.isEmpty(estimatedShipDate)) {
        estimatedShipDate = oisg.getTimestamp("estimatedShipDate");
        if(UtilValidate.isEmpty(estimatedShipDate)){
            estimatedShipDate = oisg.getTimestamp("shipAfterDate");
        } else {
            estimatedDeliveryDate = shipment.get("estimatedShipDate");
        }
    }
    if (UtilValidate.isEmpty(estimatedDeliveryDate)) {
        estimatedDeliveryDate = oisg.getTimestamp("estimatedDeliveryDate");
        if(UtilValidate.isEmpty(estimatedDeliveryDate)){
            estimatedDeliveryDate = oisg.getTimestamp("shipByDate");
        }
    }
    //Add shipping instructions
    context.put("shippingInstructions", oisg.getString("shippingInstructions"));
    context.put("shipGroupSeqId", oisg.getString("shipGroupSeqId"));
}
if(UtilValidate.isNotEmpty(estimatedShipDate)){
    context.put("estimatedShipDate", UtilDateTime.timeStampToString(estimatedShipDate,'dd/MM/yyyy',timeZone,locale));
}
if(UtilValidate.isNotEmpty(estimatedDeliveryDate)){
    context.put("estimatedDeliveryDate", UtilDateTime.timeStampToString(estimatedDeliveryDate,'dd/MM/yyyy',timeZone,locale));
}
issuances = order.getRelated("ItemIssuance", null, null, false);
issuances.each { issuance ->
    orderItem = issuance.getRelatedOne("OrderItem", false);
    productId = orderItem.productId;
    if (!countedOrderItems.containsKey(orderItem.orderId + orderItem.orderItemSeqId)) {
        countedOrderItems.put(orderItem.orderId + orderItem.orderItemSeqId, null);
        requested = quantityRequestedByProduct.get(productId);
        if (!requested) {
            requested = new Double(0);
        }
        cancelQuantity = orderItem.getDouble("cancelQuantity");
        quantity = orderItem.getDouble("quantity");
        requested += quantity.doubleValue() - (cancelQuantity ? cancelQuantity.doubleValue() : 0);
        quantityRequestedByProduct.put(productId, requested);
    }
}

// for each package, we want to list the quantities and details of each product
packages = []; // note we assume that the package number is simply the index + 1 of this list
packageDetails = [];
shipmentPackages.each { shipmentPackage ->
    contents = shipmentPackage.getRelated("ShipmentPackageContent", null, ['shipmentItemSeqId'], false);

    // each line is one logical Product and the quantities associated with it
    lines = [];
    contents.each { content ->
        shipmentItem = content.getRelatedOne("ShipmentItem", false);
        product = shipmentItem.getRelatedOne("Product", false);
        productTypeId = product.get("productTypeId");

        line = [:];
        line.product = product;
        line.shipmentItemSeqId = shipmentItem.shipmentItemSeqId
        line.quantityRequested = quantityRequestedByProduct.get(product.productId);
        line.quantityInPackage = content.quantity;
        if (EntityTypeUtil.hasParentType(delegator, "ProductType", "productTypeId", productTypeId, "parentTypeId", "MARKETING_PKG_PICK") && line.quantityInPackage > line.quantityRequested) {
            line.quantityInPackage = line.quantityRequested;
        }
        line.quantityInShipment = quantityInShipmentByProduct.get(product.productId);
        if (EntityTypeUtil.hasParentType(delegator, "ProductType", "productTypeId", productTypeId, "parentTypeId", "MARKETING_PKG_PICK") && line.quantityInShipment > line.quantityRequested) {
            line.quantityInShipment = line.quantityRequested;
        }
        line.quantityShipped = quantityShippedByProduct.get(product.productId);
        if (EntityTypeUtil.hasParentType(delegator, "ProductType", "productTypeId", productTypeId, "parentTypeId", "MARKETING_PKG_PICK") && line.quantityShipped > line.quantityRequested) {
            line.quantityShipped = line.quantityRequested;
        }
        lines.add(line);
    }
    packages.add(lines);
    String trackingCode = null;
    shipmentPackageRouteSegments = shipmentPackage.getRelated("ShipmentPackageRouteSeg");
    shipmentPackageRouteSegments.each { shipmentPackageRouteSegment ->
        if (UtilValidate.isNotEmpty(shipmentPackageRouteSegment.trackingCode)) {
            trackingCode = shipmentPackageRouteSegment.trackingCode;
        }
    }
    packageDetail = [:];
    packageDetail.put("lines",lines);
    packageDetail.put("weight",shipmentPackage.weight);
    packageDetail.put("weightUomId",shipmentPackage.weightUomId);
    packageDetail.put("trackingCode",trackingCode);
    packageDetails.add(packageDetail);
}
context.packageDetails = packageDetails;
context.packages = packages;
