<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->
<#if party?exists>

    <div class="col-lg-3">
        <ul id="account-menu" class="account-menu">
            <li id="myInformation" class="active"><a href="javascript:activeElement('myInformation');">
                <h3><i class="fa fa-book"></i> ${uiLabelMap.FrontEndMes} <strong>${uiLabelMap.FrontEndInformationsLower}</strong></h3>
            </a>
            </li>
            <li id="myFamily"><a href="javascript:activeElement('myFamily');">
                <h3><i class="fa fa-users"></i> ${uiLabelMap.FrontEndMa} <strong>${uiLabelMap.FrontEndFamilyLower}</strong></h3>
            </a>
            </li>
            <li id="myFavorites"><a href="javascript:activeElement('myFavorites');">
                <h3><i class="fa fa-heart"></i> ${uiLabelMap.FrontEndMes} <strong>${uiLabelMap.FrontEndFavoritesLower}</strong></h3>
            </a>
            </li>
            <li id="myHistory"><a href="javascript:activeElement('myHistory');">
                <h3><i class="fa fa-history"></i> ${uiLabelMap.FrontEndMon} <strong>${uiLabelMap.FrontEndHistoricalLower}</strong></h3>
            </a>
            </li>
        </ul>
    </div>
    <div class="col-lg-9">
        <div id="myInformation-readOnly" class="myInformation-readOnly myInformation">
            <button id="btnModifyAccount" class="btn btn-standard btn-otoit pull-right" onclick="modifyMyInformation()"><i class="fa fa-pencil"></i> ${uiLabelMap.FormFieldTitle_edit}</button>
            <p>
                <strong>${uiLabelMap.FormFieldTitle_lastName} : </strong><span id="DISP_LASTNAME">${person.lastName?if_exists}</span><br/>
                <strong>${uiLabelMap.FormFieldTitle_firstName} : </strong><span id="DISP_FIRSTNAME">${person.firstName?if_exists}</span><br/><br/>
                <strong>${uiLabelMap.OrderAddress} :</strong>
                <address>
                    <span id="DISP_ADDRESS1">${postalAddress.address1}</span>
                    <br/>
                    <#if postalAddress.address2?has_content><span id="DISP_ADDRESS2">${postalAddress.address2}</span></#if>
                    <br/>
                    <span id="DISP_POSTAL_CODE">${postalAddress.postalCode?if_exists}</span><span id="DISP_CITY"> ${postalAddress.city}</span>
                </address>
                <strong>${uiLabelMap.FrontEndHomePhone} : </strong><span id="DISP_HOME_NUMBER">${homeTelecomNumber.contactNumber?if_exists}</span><br/>
                <strong>${uiLabelMap.PartyMobilePhone} : </strong><span id="DISP_MOBILE_NUMBER">${mobileTelecomNumber.contactNumber?if_exists}</span><br/><br/>

                <strong>${uiLabelMap.CommonEmail} : </strong><span id="DISP_EMAIL">${primaryEmail.infoString}</span><br/><br/>
                <strong>${uiLabelMap.FormFieldTitle_birthDate} :</strong> <span id="DISP_BIRTH_DATE">${birthDate}</span><br/><br/>
                <!--<strong>${uiLabelMap.FrontEndDefaultRoof} :</strong>-->
                <!--<#list roofs as roof>-->
                    <!--<#if roof.facilityId == defaultRoof>-->
                        <!--<span id="DEFAULT_ROOF_TEXT">${roof.postalCode} - ${roof.facilityName} (${roof.city})</span>-->
                        <!--<label id="DEFAULT_ROOF" class="hidden">${defaultRoof}</label>-->
                    <!--</#if>-->
                <!--</#list>-->
            </p>
        </div>
        <form id="myInformation-modify" method="post" action="<@ofbizUrl>updateProfil</@ofbizUrl>" name="profilUpdateForm" class="myInformation-modify form-horizontal" style="display:none">
            <div class="form-group">
                <label class="col-sm-3 control-label">${uiLabelMap.FormFieldTitle_salutation} *</label>
                <div class="col-sm-9">
                    <label class="radio-inline"><input type="radio" name="USER_TITLE" id="misterRadioBtn" <#if person.personalTitle?has_content && person.personalTitle=="Mme">checked</#if> value="${uiLabelMap.CommonTitleMrs}">${uiLabelMap.FrontEndMisses}</label>
                    <label class="radio-inline"><input type="radio" name="USER_TITLE" id="missesRadioBtn" <#if person.personalTitle?has_content && person.personalTitle=="Mr">checked</#if> value="${uiLabelMap.CommonTitleMr}">${uiLabelMap.FrontEndMister}</label>
                </div>
            </div>
            <div class="form-group">
                <label for="lastname" class="col-sm-3 control-label">${uiLabelMap.FormFieldTitle_lastName} *</label>
                <div class="col-sm-9">
                    <input type="text" class="form-control" id="lastname" name="USER_LAST_NAME" value="${person.lastName?if_exists}" placeholder="${uiLabelMap.FormFieldTitle_lastName}">
                </div>
            </div>
            <div class="form-group">
                <label for="firstname" class="col-sm-3 control-label">${uiLabelMap.FormFieldTitle_firstName} *</label>
                <div class="col-sm-9">
                    <input type="text" class="form-control" id="firstname" name="USER_FIRST_NAME" value="${person.firstName?if_exists}" placeholder="${uiLabelMap.FormFieldTitle_firstName}">
                </div>
            </div>
            <div class="form-group">
                <label for="userBirthdate" class="col-sm-3 control-label">${uiLabelMap.FormFieldTitle_birthDate} *</label>
                <div class="col-sm-9">
                    <input type="date" class="form-control" id="userBirthdate" name="USER_BIRTHDATE" value="<#if birthDate?exists>${birthDate}</#if>" placeholder="${uiLabelMap.FormFieldTitle_birthDate} JJ-MM-AAAA (16-03-1953)">
                </div>
            </div>
            <div class="form-group">
                <label for="customerHomeContact" class="col-sm-3 control-label">${uiLabelMap.FrontEndHomePhone} **</label>
                <div class="col-sm-9">
                    <input type="phone" required class="form-control" id="customerHomeContact" name="CUSTOMER_HOME_CONTACT" value="${homeTelecomNumber.contactNumber?if_exists}" placeholder="${uiLabelMap.FrontEndHomePhone}">
                </div>
            </div>
            <div class="form-group">
                <label for="customerMobileContact" class="col-sm-3 control-label">${uiLabelMap.PartyMobilePhone} **</label>
                <div class="col-sm-9">
                    <input type="phone" class="form-control" id="customerMobileContact" name="CUSTOMER_MOBILE_CONTACT" value="${mobileTelecomNumber.contactNumber?if_exists}" placeholder="${uiLabelMap.PartyMobilePhone}">
                </div>
            </div>
            <div class="form-group">
                <label for="customerAddress1" class="col-sm-3 control-label">${uiLabelMap.OrderAddress} *</label>
                <div class="col-sm-9">
                    <input type="text" class="form-control" id="customerAddress1" name="CUSTOMER_ADDRESS1" value="${postalAddress.address1}" placeholder="${uiLabelMap.OrderAddress}">
                </div>
            </div>
            <div class="form-group">
                <label for="customerAddress2" class="col-sm-3 control-label">${uiLabelMap.FormFieldTitle_paAddress2}</label>
                <div class="col-sm-9">
                    <input type="text" class="form-control" id="customerAddress2" name="CUSTOMER_ADDRESS2" value="<#if postalAddress.address2?exists>${postalAddress.address2}</#if>" placeholder="${uiLabelMap.FormFieldTitle_paAddress2}">
                </div>
            </div>
            <div class="form-group">
                <label for="customerPostalCode" class="col-sm-3 control-label">${uiLabelMap.FormFieldTitle_postalCode} *</label>
                <div class="col-sm-9">
                    <input type="text" class="form-control" id="customerPostalCode" name="CUSTOMER_POSTAL_CODE" value="${postalAddress.postalCode}" placeholder="${uiLabelMap.FormFieldTitle_postalCode}">
                </div>
            </div>
            <div class="form-group">
                <label for="customerCity" class="col-sm-3 control-label">${uiLabelMap.FormFieldTitle_city} *</label>
                <div class="col-sm-9">
                    <input type="text" class="form-control" id="customerCity" name="CUSTOMER_CITY" value="${postalAddress.city}" placeholder="${uiLabelMap.FormFieldTitle_city}">
                    <input type="hidden" class="form-control" id="customerCountry" name="CUSTOMER_COUNTRY" value="${postalAddress.countryGeoId}">
                    <input type="hidden" class="form-control" id="customerState" name="CUSTOMER_STATE" value="${postalAddress.stateProvinceGeoId}">
                </div>
            </div>
            <!--<div class="form-group">-->
                <!--<label for="customerCity" class="col-sm-3 control-label">${uiLabelMap.FrontEndSelectRoof} *</label>-->
                <!--<div class="col-sm-9">-->
                    <!--<#if roofs?has_content>-->
                        <!--<select class="selectpicker" data-width="100%" name="CUSTOMER_DEFAULT_ROOF" id="roofSelectPicker">-->
                            <!--<#list roofs as roof>-->
                                <!--<option value="${roof.facilityId}">${roof.postalCode} - ${roof.facilityName} (${roof.city})</option>-->
                            <!--</#list>-->
                        <!--</select>-->
                    <!--</#if>-->
                <!--</div>-->
            <!--</div>-->
            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-9">
                    <button type="submit" class="btn btn-success" id="registerBtn">Valider</button>
                    <!--<button type="submit" class="btn btn-success" id="registerBtn" onclick="saveMyInformation()">Valider</button>-->
                </div>
            </div>
        </form>
        <div class="myFamily" style="display:none;">
            <label class="label label-success">Veuilliez nous excuser, cette fonctionnalité n'est pas encore disponible</label>
        </div>
        <div class="myFavorites" style="display:none;">
            <label class="label label-success">Veuilliez nous excuser, cette fonctionnalité n'est pas encore disponible</label>
        </div>
        <div class="myOrders" style="display:none;">
            <table class="table table-hover order-list-table" data-toggle="table" data-cache="false" data-height="299">
                <thead>
                <tr>
                    <th>${uiLabelMap.FormFieldTitle_referenceId}</th>
                    <th>${uiLabelMap.FormFieldTitle_orderDate}</th>
                    <th>${uiLabelMap.FormFieldTitle_statusItemDescription}</th>
                    <th class="text-right">${uiLabelMap.FrontEndAmountIncludingTax}</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
        <#list orderHeaderList as orderHeader>
            <#assign orderStatus = "FrontEnd"+orderHeader.statusId/>
                    <tr>
                        <td>${orderHeader.orderId}</td>
                        <td>${Static["org.ofbiz.base.util.UtilFormatOut"].formatDateTime(orderHeader.orderDate, "", locale, timeZone)!}</td>
                        <td>${uiLabelMap[orderStatus]}</td>
                        <td class="text-right"><@ofbizCurrency amount=orderHeader.totalGrandAmount isoCode=orderHeader.currencyUom/></td>
                        <td>
                            <form class="pull-right" method="post" action="<@ofbizUrl>accountOrder</@ofbizUrl>" name="detailOrder">
                                <input type="hidden" name="orderId" value="${orderHeader.orderId}" />
                                <button title="${uiLabelMap.FrontEndOrderDetails}" type="submit"><i class="fa fa-file-text-o"></i></button>
                            </form>
                            <#if "ORDER_CREATED" = orderHeader.statusId>
                            <form class="pull-right"  method="post" action="<@ofbizUrl>changeOrderStatus</@ofbizUrl>" name="cancelOrder">
                                <input type="hidden" name="statusId" value="ORDER_CANCELLED"/>
                                <input type="hidden" name="setItemStatus" value="Y"/>
                                <input type="hidden" name="workEffortId" value="${workEffortId?if_exists}"/>
                                <input type="hidden" name="orderId" value="${orderHeader.orderId?if_exists}"/>
                                <input type="hidden" name="partyId" value="${partyId?if_exists}"/>
                                <input type="hidden" name="roleTypeId" value="${assignRoleTypeId?if_exists}"/>
                                <input type="hidden" name="fromDate" value="${fromDate?if_exists}"/>
                                <button title="${uiLabelMap.OrderCancelOrder}" type="submit"><i class="fa fa-times"></i></button>
                            </form>
                            </#if>
                        </td>
                    </tr>
        </#list>
                </tbody>
            </table>
        </div>
        <div class="myOrderLists" style="display:none;">
            <label class="label label-success">Veuilliez nous excuser, cette fonctionnalité n'est pas encore disponible</label>
        </div>
        <div class="myHistory" style="display:none;">
            <label class="label label-success">Veuilliez nous excuser, cette fonctionnalité n'est pas encore disponible</label>
        </div>
    </div>
</#if>
    <script type="text/javascript">
        document.getElementById('roofSelectPicker').value='${defaultRoof}';
    </script>
