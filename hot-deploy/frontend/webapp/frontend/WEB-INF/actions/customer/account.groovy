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


import org.ofbiz.common.preferences.PreferenceWorker

import java.lang.*
import java.text.DateFormat;
import java.util.*;
import org.ofbiz.base.util.*;
import org.ofbiz.entity.*;
import org.ofbiz.entity.util.*;
import org.ofbiz.entity.condition.*;
import org.ofbiz.party.contact.ContactMechWorker;
import org.ofbiz.product.store.ProductStoreWorker;
import org.ofbiz.accounting.payment.PaymentWorker;

productStoreId = ProductStoreWorker.getProductStoreId(request);
context.productStoreId = productStoreId;

if (userLogin) {
    partyId = userLogin.partyId
    context.partyId = partyId
    context.party = userLogin.getRelatedOne("Party", false);
    context.person = userLogin.getRelatedOne("Person",false);

    showOld = "true".equals(parameters.SHOW_OLD);

    partyContactMechValueMaps = ContactMechWorker.getPartyContactMechValueMaps(delegator, userLogin.partyId, showOld);
    for(partyContactMechValueMap in partyContactMechValueMaps) {
        for(partyContactMechPurpose in partyContactMechValueMap.partyContactMechPurposes){
            contactMechPurposeType = partyContactMechPurpose.getRelatedOne("ContactMechPurposeType", true);
            if(contactMechPurposeType.contactMechPurposeTypeId == "SHIPPING_LOCATION") {
                postalAddress = partyContactMechValueMap.postalAddress;
            }
            if(contactMechPurposeType.contactMechPurposeTypeId == "PHONE_MOBILE") {
                mobileTelecomNumber = partyContactMechValueMap.telecomNumber;
            }
            if(contactMechPurposeType.contactMechPurposeTypeId == "PHONE_HOME") {
                homeTelecomNumber = partyContactMechValueMap.telecomNumber;
            }
            if(contactMechPurposeType.contactMechPurposeTypeId == "PRIMARY_EMAIL") {
                primaryEmail = partyContactMechValueMap.contactMech;
            }
        }
    }
//    String birthDate = DateFormat.getDateInstance().format(context.person.birthDate) ;
    birthDate = UtilDateTime.toDateString(context.person.birthDate,"dd/MM/yyyy") ;
    String creatingAccountDate = DateFormat.getDateInstance().format(userLogin.createdStamp) ;

//    Map<String, Object> userPreferenceResult = dispatcher.runSync("getUserPreference", [userPrefTypeId: "DEFAULT_ROOF", userPrefLoginId: userLogin.userLoginId]);
//    if(userPreferenceResult.responseMessage.equals("success")) {
//        userPrefMap = userPreferenceResult.userPrefMap ;
//        defaultRoof = userPrefMap.get("DEFAULT_ROOF") ;
//    }
    context.postalAddress = postalAddress ;
    context.homeTelecomNumber = homeTelecomNumber ;
    context.mobileTelecomNumber = mobileTelecomNumber ;
    context.primaryEmail = primaryEmail ;
    context.birthDate = birthDate ;
    context.creatingAccountDate = creatingAccountDate ;
//    context.defaultRoof = defaultRoof ;

    // Order List management
    orderHeaderList = delegator.findByAnd("OrderHeaderAndRoleSummary", [partyId: partyId, roleTypeId: "END_USER_CUSTOMER"], ["orderId"], false);
    context.orderHeaderList = orderHeaderList;
}
