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
import org.ofbiz.entity.condition.EntityCondition
import org.ofbiz.entity.condition.EntityOperator
import org.ofbiz.party.contact.ContactMechWorker

typeRoofConditions = EntityCondition.makeCondition([EntityCondition.makeCondition("facilityTypeId", EntityOperator.EQUALS, "PRIMARY_ROOF"),
                                                    EntityCondition.makeCondition("facilityTypeId", EntityOperator.EQUALS, "SECONDARY_ROOF")], EntityOperator.OR);


listFacility = delegator.findList("Facility",typeRoofConditions, null, null, null, false);
List<Map<String, Object>> roofs = FastList.newInstance();

for (GenericValue facility in listFacility) {
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
