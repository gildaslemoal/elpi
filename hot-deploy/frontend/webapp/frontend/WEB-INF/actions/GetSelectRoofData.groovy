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


import javolution.util.FastList
import org.ofbiz.base.util.UtilMisc
import org.ofbiz.base.util.UtilValidate
import org.ofbiz.entity.GenericValue
import org.ofbiz.order.shoppingcart.ShoppingCart
import org.ofbiz.party.contact.ContactMechWorker

List<Map<String, Object>> roofs = FastList.newInstance();
List<GenericValue> facilities = delegator.findByAnd("Facility");
for (GenericValue facility in facilities) {
    facilityId = facility.get("facilityId");
    facilityName = facility.get("facilityName");
    List<Map<String, Object>> contactMeches = ContactMechWorker.getFacilityContactMechValueMaps(delegator, facilityId, false, null);
    for (Map<String, Object> contactMechMap in contactMeches) {
        GenericValue contactMech = contactMechMap.get("contactMech");
        if ("POSTAL_ADDRESS".equals(contactMech.contactMechTypeId)) {
            GenericValue postalAddress = contactMechMap.get("postalAddress");
            if (! UtilValidate.isEmpty(postalAddress)) {
                contactMechId = contactMech.get("contactMechId");
                address1 = postalAddress.get("address1");
                postalCode = postalAddress.get("postalCode");
                city = postalAddress.get("city");
                roofs.add(UtilMisc.toMap(
                        "facilityId", facilityId,
                        "facilityName", facilityName,
                        "contactMechId", contactMechId,
                        "address1", address1,
                        "postalCode", postalCode,
                        "city", city));
            }
        }
    }
}
context.roofs = roofs;

initialName = null;
initialId = null;
initialAddress = null;
initialPostalCode = null;
initialCity = null;
ShoppingCart cart = (ShoppingCart) session.getAttribute("shoppingCart");
if (UtilValidate.isNotEmpty(cart)) {
    initialId = cart.getShippingContactMechId();
    if (UtilValidate.isEmpty(initialId) && (roofs.size() > 0)) {
        initialId = roofs[0].get("contactMechId");
    }
    for (Map<String, Object> roof in roofs) {
        if (initialId.equals(roof.get("contactMechId"))) {
            initialName = roof.get("facilityName");
            initialAddress = roof.get("address1");
            initialPostalCode = roof.get("postalCode");
            initialCity = roof.get("city");
        }
    }
}

context.initialId = initialId;
context.initialName = initialName;
context.initialAddress = initialAddress;
context.initialPostalCode = initialPostalCode;
context.initialCity = initialCity;
