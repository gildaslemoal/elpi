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


<!-- TODO : Need formatting -->
<script type="text/javascript">
//<![CDATA[
function submitForm(form, mode, value) {
    if (mode == "DN") {
        // done action; checkout
        form.action="<@ofbizUrl>checkoutoptions</@ofbizUrl>";
        form.submit();
    } else if (mode == "CS") {
        // continue shopping
        form.action="<@ofbizUrl>updateCheckoutOptions/showcart</@ofbizUrl>";
        form.submit();
    } else if (mode == "NC") {
        // new credit card
        form.action="<@ofbizUrl>updateCheckoutOptions/editcreditcard?DONE_PAGE=checkoutpayment</@ofbizUrl>";
        form.submit();
    } else if (mode == "EC") {
        // edit credit card
        form.action="<@ofbizUrl>updateCheckoutOptions/editcreditcard?DONE_PAGE=checkoutpayment&paymentMethodId="+value+"</@ofbizUrl>";
        form.submit();
    } else if (mode == "GC") {
        // edit gift card
        form.action="<@ofbizUrl>updateCheckoutOptions/editgiftcard?paymentMethodId="+value+"</@ofbizUrl>";
        form.submit();
    } else if (mode == "NE") {
        // new eft account
        form.action="<@ofbizUrl>updateCheckoutOptions/editeftaccount?DONE_PAGE=checkoutpayment</@ofbizUrl>";
        form.submit();
    } else if (mode == "EE") {
        // edit eft account
        form.action="<@ofbizUrl>updateCheckoutOptions/editeftaccount?DONE_PAGE=checkoutpayment&paymentMethodId="+value+"</@ofbizUrl>";
        form.submit();
    }else if(mode = "EG")
    //edit gift card
        form.action="<@ofbizUrl>updateCheckoutOptions/editgiftcard?DONE_PAGE=checkoutpayment&paymentMethodId="+value+"</@ofbizUrl>";
        form.submit();
}
//]]>
$(document).ready(function(){
var issuerId = "";
    if ($('#checkOutPaymentId_IDEAL').attr('checked') == true) {
        $('#issuers').show();
        issuerId = $('#issuer').val();
        $('#issuerId').val(issuerId);
    } else {
        $('#issuers').hide();
        $('#issuerId').val('');
    }
    $('input:radio').click(function(){
        if ($(this).val() == "EXT_IDEAL") {
            $('#issuers').show();
            issuerId = $('#issuer').val();
            $('#issuerId').val(issuerId);
        } else {
            $('#issuers').hide();
            $('#issuerId').val('');
        }
    });
    $('#issuer').change(function(){
        issuerId = $(this).val();
        $('#issuerId').val(issuerId);
    });
});
</script>


    <#assign cart = shoppingCart?if_exists />

    <div style="height:40px"></div>

    <div class="row">
        <ul id="breadcrumbs-one" class="breadcrumbs-cart">
            <li><a class="validated" href="<@ofbizUrl>showcart</@ofbizUrl>">
                ${uiLabelMap.FrontEndCartValidation}
                <small class="carriage-return">${uiLabelMap.FrontEndSelectedProductsValidation}</small>
            </a></li>
            <li><a class="validated" href="">
                ${uiLabelMap.FrontEndChooseShippingPlace}
                <small class="carriage-return">${uiLabelMap.FrontEndChooseRoof}</small>
            </a></li>
            <li><a class="selected disabled" href="#">
                ${uiLabelMap.FrontEndChoosePaymentMethod}
                <small class="carriage-return">${uiLabelMap.FrontEndFavoritePaymentMethod}</small>
            </a></li>
        </ul>
    </div>
    <div class="row">
        <h3 class="StepTitle">
            ${uiLabelMap.FrontEndOrderSummary}
        </h3>
        <p>
            <#assign shoppingCartSize = shoppingCart.size()/>
            ${uiLabelMap.FrontEndCartContent} <span id="cartProductsQuantity">${shoppingCartSize}</span>
            <#if shoppingCartSize gt 1> ${uiLabelMap.FrontEndProducts}
                <#else> ${uiLabelMap.FrontEndProduct}
            </#if>
        </p>
    </div>

    <form method="post" id="checkoutInfoForm" action="">
        <input type="hidden" name="checkoutpage" value="payment" />
        <input type="hidden" name="BACK_PAGE" value="checkoutoptions" />
        <input type="hidden" name="issuerId" id="issuerId" value="" />

        <div class="row">
            <table  class="shopping-cart-summary">
                <thead>
                <tr>
                    <th class="text-center">${uiLabelMap.OrderProduct}</th>
                    <th>${uiLabelMap.CommonDescription}</th>
                    <th class="text-right">${uiLabelMap.EcommerceUnitPrice}</th>
                    <th class="text-center">${uiLabelMap.CommonQuantity}</th>
                    <th class="text-right">${uiLabelMap.CommonTotal}</th>
                </tr>
                </thead>
                <tbody>
                <#assign itemsFromList = false />
                <#assign promoItems = false />
                <#list shoppingCart.items() as cartLine>
                    <tr>
                        <#assign cartLineIndex = shoppingCart.getItemIndex(cartLine) />
                        <#assign lineOptionalFeatures = cartLine.getOptionalProductFeatures() />
                        <#-- Image du produit -->
                        <td class="text-center">
                            <#if cartLine.getParentProductId()?exists>
                                <#assign parentProductId = cartLine.getParentProductId() />
                            <#else>
                                <#assign parentProductId = cartLine.getProductId() />
                            </#if>
                            <#assign smallImageUrl = Static["org.ofbiz.product.product.ProductContentWrapper"].getProductContentAsText(cartLine.getProduct(), "SMALL_IMAGE_URL", locale, dispatcher)?if_exists />
                            <#if !smallImageUrl?string?has_content>
                                <#assign smallImageUrl = "/images/defaultImage.jpg" />
                            </#if>
                            <#if smallImageUrl?string?has_content>
                                <a href="<@ofbizCatalogAltUrl productId=parentProductId/>">
                                    <img class="table-image-thumbler" src="<@ofbizContentUrl>${requestAttributes.contentPathPrefix?if_exists}${smallImageUrl}</@ofbizContentUrl>" alt="Product Image" class="imageborder" />
                                </a>
                            </#if>
                        </td>
                        <#-- Nom du produit -->
                        <td id="cartSummaryProductName-${cartLine_index}">
                            ${cartLine.getName()?if_exists}
                        </td>
                        <#-- Prix à l'unité -->
                        <td class="text-right"><@ofbizCurrency amount=cartLine.getDisplayPrice() isoCode=shoppingCart.getCurrency()/></td>
                        <#-- Quantité -->
                        <td class="text-center">
                            <span id="quantitySpan_${cartLineIndex}" name="update_${cartLineIndex}">${cartLine.getQuantity()?string.number}</span>
                        </td>
                        <#-- Total de la ligne -->
                        <td class="text-right">
                            <@ofbizCurrency amount=cartLine.getDisplayItemSubTotal() isoCode=shoppingCart.getCurrency()/>
                        </td>
                    </tr>
                </#list>
                <tr class="shopping-cart-summary-total">
                    <td></td>
                    <td></td>
                    <td></td>
                    <td class="text-right">
                        <#if shoppingCart.getAdjustments()?has_content>
                            ${uiLabelMap.CommonSubTotal}:
                            <#if (shoppingCart.getDisplayTaxIncluded() > 0.0)>
                                <br>
                                ${uiLabelMap.OrderSalesTaxIncluded}:
                            </#if>
                            <#list shoppingCart.getAdjustments() as cartAdjustment>
                                <#assign adjustmentType = cartAdjustment.getRelatedOne("OrderAdjustmentType", true) />
                                <br>
                                ${uiLabelMap.EcommerceAdjustment} - ${adjustmentType.get("description",locale)?if_exists}
                                <#if cartAdjustment.productPromoId?has_content><a href="<@ofbizUrl>showPromotionDetails?productPromoId=${cartAdjustment.productPromoId}</@ofbizUrl>" class="button">${uiLabelMap.CommonDetails}</a></#if>:
                            </#list>
                        </#if>
                        <br>
                        <br>
                        ${uiLabelMap.EcommerceCartTotal}:
                    </td>
                    <td class="text-right">
                        <#if shoppingCart.getAdjustments()?has_content>
                            <@ofbizCurrency amount=shoppingCart.getDisplaySubTotal() isoCode=shoppingCart.getCurrency()/>
                            <#if (shoppingCart.getDisplayTaxIncluded() > 0.0)>
                                <br>
                                <@ofbizCurrency amount=shoppingCart.getDisplayTaxIncluded() isoCode=shoppingCart.getCurrency()/>
                            </#if>
                            <#list shoppingCart.getAdjustments() as cartAdjustment>
                                <#assign adjustmentType = cartAdjustment.getRelatedOne("OrderAdjustmentType", true) />
                                <br>
                                <@ofbizCurrency amount=Static["org.ofbiz.order.order.OrderReadHelper"].calcOrderAdjustment(cartAdjustment, shoppingCart.getSubTotal()) isoCode=shoppingCart.getCurrency()/>
                            </#list>
                        </#if>
                        <br>
                        <br>
                        <@ofbizCurrency amount=shoppingCart.getDisplayGrandTotal() isoCode=shoppingCart.getCurrency()/>
                    </td>
                </tr>

                </tbody>
            </table>
        </div>

        <div class="row">
            <div class="btn-group payment-modes" role="group">
                <div class="payment-type">
                    <input type="radio" id="checkOutPaymentId_CREDIT_CARD" name="checkOutPaymentId" value="CREDIT_CARD" <#if "CREDIT_CARD" == checkOutPaymentId>checked="checked"</#if> />
                    <img src="<@ofbizContentUrl>/frontend/images/payment/pay_mastercard.png</@ofbizContentUrl>">
                    <label>Mastercard</label>
                </div>
                <div class="payment-type">
                    <input type="radio" id="checkOutPaymentId_CREDIT_CARD" name="checkOutPaymentId" value="CREDIT_CARD" <#if "CREDIT_CARD" == checkOutPaymentId>checked="checked"</#if> />
                    <img src="<@ofbizContentUrl>/frontend/images/payment/pay_visa.png</@ofbizContentUrl>">
                    <label>Visa</label>
                </div>
                <div class="payment-type">
                    <input type="radio" id="checkOutPaymentId_PAYPAL" name="checkOutPaymentId" value="EXT_PAYPAL" <#if "EXT_PAYPAL" == checkOutPaymentId>checked="checked"</#if> />
                    <img src="<@ofbizContentUrl>/frontend/images/payment/pay_paypal.jpg</@ofbizContentUrl>">
                    <label>Paypal</label>
                </div>
            </div>
        </div>
    </form>

    <div class="row">
        <div class="btn-group pull-right" role="group">
            <a href="" type="button" class="btn shopping-cart-nav selected" role="group">${uiLabelMap.CommonPrevious}</a>
            <a type="button" class="btn shopping-cart-nav" role="group">${uiLabelMap.CommonNext}</a>
            <a onclick="" href="javascript:submitForm(document.getElementById('checkoutInfoForm'), 'DN', '');" type="button" class="btn shopping-cart-nav selected" role="group">${uiLabelMap.CommonDone}</a>
        </div>
    </div>

