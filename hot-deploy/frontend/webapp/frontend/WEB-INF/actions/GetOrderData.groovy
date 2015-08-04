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


import org.ofbiz.base.util.Debug
import org.ofbiz.base.util.UtilValidate
import org.ofbiz.entity.GenericValue
import org.ofbiz.entity.util.EntityUtil
import org.ofbiz.order.order.OrderReadHelper

orderId = parameters.orderId;
orderHeader = null;
partyId = context.partyId;
if (userLogin) {
    if (!partyId) {
        partyId = userLogin.partyId;
    }
}

if (orderId) {
    orderHeader = delegator.findOne("OrderHeader", [orderId : orderId], false);
    //customer
    roleTypeId = "PLACING_CUSTOMER";
    context.roleTypeId = roleTypeId;
    // check OrderRole to make sure the user can view this order.  This check must be done for any order which is not anonymously placed and
    // any anonymous order when the allowAnonymousView security flag (see above) is not set to Y, to prevent peeking
    if (orderHeader && (!"anonymous".equals(orderHeader.createdBy) || ("anonymous".equals(orderHeader.createdBy) && !"Y".equals(allowAnonymousView)))) {
        orderRole = EntityUtil.getFirst(delegator.findByAnd("OrderRole", [orderId : orderId, partyId : partyId, roleTypeId : roleTypeId], null, false));

        if (!userLogin || !orderRole) {
            context.remove("orderHeader");
            orderHeader = null;
            Debug.logWarning("Warning: in OrderStatus.groovy before getting order detail info: role not found or user not logged in; partyId=[" + partyId + "], userLoginId=[" + (userLogin == null ? "null" : userLogin.get("userLoginId")) + "]", "orderstatus");
        }
    }
}

if (orderHeader) {
    orderReadHelper = new OrderReadHelper(orderHeader);
    orderItemShipGroups = orderReadHelper.getOrderItemShipGroups();
    if (UtilValidate.isNotEmpty(orderItemShipGroups)) {
        GenericValue shippingAddress = orderItemShipGroups[0].getRelatedOne("PostalAddress", false);
        contactMechId = shippingAddress.get("contactMechId");
        GenericValue facilityContactMech = EntityUtil.getFirst(delegator.findByAnd("FacilityContactMech", [contactMechId : contactMechId], null, false));
        if (UtilValidate.isNotEmpty(facilityContactMech)) {
            GenericValue facility = delegator.findOne("Facility", [facilityId : facilityContactMech.get("facilityId")], false);
            if (UtilValidate.isNotEmpty(facility)) {
                roofName = facility.get("facilityName");
                context.roofName = roofName;
            }
        }
        address = shippingAddress.get("address1");
        postalCode = shippingAddress.get("postalCode");
        city = shippingAddress.get("city");
        context.shippingAddress = address;
        context.shippingPostalCode = postalCode;
        context.shippingCity = city;
    }
}
