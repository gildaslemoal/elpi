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

import javolution.util.FastList;
import org.ofbiz.base.util.UtilProperties;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.party.contact.ContactMechWorker;
import org.ofbiz.product.store.ProductStoreWorker;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityOperator;

productStore = ProductStoreWorker.getProductStore(request);
context.productStoreId = productStore.productStoreId;
context.productStore = productStore;
context.userTitle = request.getParameter("USER_TITLE");
context.userLastName = request.getParameter("USER_LAST_NAME");
context.userFirstName = request.getParameter("USER_FIRST_NAME");
context.customerEmail = request.getParameter("CUSTOMER_EMAIL");
context.userBirthDate = request.getParameter("USER_BIRTHDATE");
context.customerHomeContact = request.getParameter("CUSTOMER_HOME_CONTACT");
context.customerMobileContact = request.getParameter("CUSTOMER_MOBILE_CONTACT");
context.customerAddress1 = request.getParameter("CUSTOMER_ADDRESS1");
context.customerAddress2 = request.getParameter("CUSTOMER_ADDRESS2");
context.customerPostalCode = request.getParameter("CUSTOMER_POSTAL_CODE");
context.customerCity = request.getParameter("CUSTOMER_CITY");

context.createAllowPassword = "Y".equals(productStore.allowPassword);
context.getUsername = !"Y".equals(productStore.usePrimaryEmailUsername);

previousParams = parameters._PREVIOUS_PARAMS_;
if (previousParams) {
    previousParams = "?" + previousParams;
} else {
    previousParams = "";
}
context.previousParams = previousParams;

//the parameters from janrain
userInfoMap = request.getAttribute("userInfoMap");
if (!userInfoMap) {
    userInfoMap = request.getSession().getAttribute("userInfoMap");
}
if (userInfoMap) {
    if (userInfoMap.givenName && userInfoMap.familyName) {
        requestParameters.USER_FIRST_NAME = userInfoMap.givenName;
        requestParameters.USER_LAST_NAME = userInfoMap.familyName;
    } else if (userInfoMap.formatted) {
        requestParameters.USER_FIRST_NAME = userInfoMap.formatted;
    }
    requestParameters.CUSTOMER_EMAIL = userInfoMap.email;
    requestParameters.preferredUsername = userInfoMap.preferredUsername;
    requestParameters.USERNAME = userInfoMap.preferredUsername;
    request.getSession().setAttribute("userInfoMap", userInfoMap);
}

donePage = "main;" + parameters.visit.sessionId
context.donePage = donePage;
