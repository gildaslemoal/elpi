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


<script type="text/javascript">
//<![CDATA[
function selectRoofButton(field, roofName, contactMechId, address, postalCode, city) {
    selectButton(field, roofName);

    document.getElementById("selectedRoof").value = contactMechId;
    document.getElementById("shipping-address").innerHTML = address;
    document.getElementById("shipping-postal-code").innerHTML = postalCode;
    document.getElementById("shipping-city").innerHTML = city;
}
function selectButton(field, value) {
    document.getElementById(field).innerHTML = value + ' <span class="caret"> </span>';
}

function submitForm(form, mode, value) {
    if (mode == "DN") {
        // done action; checkout
        form.action="<@ofbizUrl>checkoutoptions</@ofbizUrl>";
        form.submit();
    } else if (mode == "CS") {
        // continue shopping
        form.action="<@ofbizUrl>updateCheckoutOptions/showcart</@ofbizUrl>";
        form.submit();
    } else if (mode == "NA") {
        // new address
        form.action="<@ofbizUrl>updateCheckoutOptions/editcontactmech?preContactMechTypeId=POSTAL_ADDRESS&contactMechPurposeTypeId=SHIPPING_LOCATION&DONE_PAGE=checkoutshippingaddress</@ofbizUrl>";
        form.submit();
    } else if (mode == "EA") {
        // edit address
        form.action="<@ofbizUrl>updateCheckoutOptions/editcontactmech?DONE_PAGE=checkoutshippingaddress&contactMechId="+value+"</@ofbizUrl>";
        form.submit();
    }
}

//]]>
</script>
    <div style="height:40px"></div>

    <div class="row">
        <ul id="breadcrumbs-one" class="breadcrumbs-cart">
            <li><a class="validated" href="<@ofbizUrl>showcart</@ofbizUrl>">
                ${uiLabelMap.FrontEndCartValidation}
                <small class="carriage-return">${uiLabelMap.FrontEndSelectedProductsValidation}</small>
            </a></li>
            <li><a class="selected" href="#">
                ${uiLabelMap.FrontEndChooseShippingPlace}
                <small class="carriage-return">${uiLabelMap.FrontEndChooseRoof}</small>
            </a></li>
            <li><a href="#">
                ${uiLabelMap.FrontEndChoosePaymentMethod}
                <small class="carriage-return">${uiLabelMap.FrontEndFavoritePaymentMethod}</small>
            </a></li>
        </ul>
    </div>

    <div class="row">
        <h3>${uiLabelMap.OrderShippingAddress}</h3>
    </div>

    <div class="row">
        <#assign cart = shoppingCart?if_exists/>
        <form method="post" name="checkoutInfoForm" style="margin:0;">
            <input type="hidden" name="checkoutpage" value="shippingaddress"/>
            <div class="aligned-field">
                <p class="col-lg-4">
                    ${uiLabelMap.FrontEndSelectRoof}
                </p>
                <div class="btn-group col-lg-8">
                    <#assign initialId = initialId/>
                    <#if initialId?has_content>
                        <#assign initialRoofId = initialId/>
                        <#assign initialRoofName = initialName/>
                    <#else>
                        <#if roofs.size() gt 0>
                            <#assign initialRoofName = roofs[0].get("facilityName")>
                            <#assign initialRoofId = roofs[0].get("contactMechId")>
                        <#else>
                            <#assign initialRoofName = ''>
                        </#if>
                    </#if>
                    <button id="roofSelector" type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
                        ${initialRoofName} <span class="caret"></span>
                    </button>
                    <ul id="select-roof" class="dropdown-menu" role="menu">
                        <#list roofs as roof>
                            <#assign checkThisAddress = (roof_index == 0 && !cart.getShippingContactMechId()?has_content) || (cart.getShippingContactMechId()?default("") == roof.contactMechId)/>
                            <li id="roof-${roof_index}"><a href="javascript:selectRoofButton('roofSelector', '${roof.facilityName}', '${roof.contactMechId}', '${roof.address1}', '${roof.postalCode}', '${roof.city}')">${roof.facilityName}</a></li>
                        </#list>
                    </ul>
                    <input id="selectedRoof" type="radio" class="hidden" name="shipping_contact_mech_id" value="${initialRoofId}" checked="checked"/>
                </div>
            </div>
        </form>
    </div>

    <div class="row">
        <div class="aligned-field">
            <p class="col-lg-4">
                ${uiLabelMap.FrontEndRetrieveHour}
            </p>
            <div class="btn-group col-lg-8">
                <button id="cartRetrievePeriod" type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
                    8h00 - 10h00 <span class="caret"></span>
                </button>
                <ul id="select-cart-retrieve-period" class="dropdown-menu" role="menu">
                    <li id="period-0"><a href="javascript:selectButton('cartRetrievePeriod', '8h00 - 10h00')">8h00 - 10h00</a></li>
                    <li id="period-1"><a href="javascript:selectButton('cartRetrievePeriod', '10h00 - 14h00')">10h00 - 14h00</a></li>
                    <li id="period-2"><a href="javascript:selectButton('cartRetrievePeriod', '14h00 - 17h00')">14h00 - 17h00</a></li>
                    <li id="period-3"><a href="javascript:selectButton('cartRetrievePeriod', '17h00 - 19h00')">17h00 - 19h00</a></li>
                </ul>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="checkbox">
            <label>
                <input type="checkbox"> ${uiLabelMap.FrontEndSelectionArea}
            </label>
        </div>
    </div>

    <div class="row">
        <div class=" col-lg-6 no-left-padding">
            <#if roofs.size() gt 0>
                <#assign initialAddress = initialAddress>
                <#assign initialPostalCode = initialPostalCode>
                <#assign initialCity = initialCity>
            <#else>
                <#assign initialAddress = ''>
                <#assign initialPostalCode = ''>
                <#assign initialCity = ''>
            </#if>
            <table  class="shopping-cart-summary">
                <thead>
                    <th colspan="0">${uiLabelMap.FrontEndRoofAddress}</th>
                </thead>
                <tbody>
                    <tr>
                        <td id="shipping-address">
                            ${initialAddress}
                        </td>
                        <td id="shipping-postal-code">
                            ${initialPostalCode}
                        </td>
                        <td id="shipping-city">
                            ${initialCity}
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class=" col-lg-6 no-right-padding">
        <table  class="shopping-cart-summary">
            <thead>
                <th colspan="0">${uiLabelMap.AccountingBillingAddress}</th>
            </thead>
            <tbody>
                <#if shippingContactMechList?has_content>
                    <#list shippingContactMechList as shippingContactMech>
                    <#assign shippingAddress = shippingContactMech.getRelatedOne("PostalAddress", false)>
                    <tr>
                        <td id="billing-to-name">
                            <#if shippingAddress.toName?has_content>${shippingAddress.toName}</#if>
                        </td>
                        <td id="billing-address">
                            <#if shippingAddress.address1?has_content>${shippingAddress.address1}</#if>
                        </td>
                        <td id="billing-postal-code">
                            <#if shippingAddress.postalCode?has_content>${shippingAddress.postalCode}</#if>
                        </td>
                        <td id="billing-city">
                            <#if shippingAddress.city?has_content>${shippingAddress.city}</#if>
                        </td>
                    </tr>
                    </#list>
                <#else>
                    <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                </#if>
            </tbody>
        </table>
        </div>
    </div>
    <div class="row">
        <div class="btn-group pull-right" role="group">
            <a href="<@ofbizUrl>showcart</@ofbizUrl>" class="btn shopping-cart-nav selected" role="group">${uiLabelMap.CommonPrevious}</a>
            <a href="javascript:submitForm(document.checkoutInfoForm, 'DN', '');" type="button" class="btn shopping-cart-nav selected" role="group">${uiLabelMap.CommonNext}</a>
            <a type="button" class="btn shopping-cart-nav" role="group">${uiLabelMap.CommonDone}</a>
        </div>
    </div>

