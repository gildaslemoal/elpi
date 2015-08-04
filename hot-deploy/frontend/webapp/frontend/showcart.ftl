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
function removeCartLine(cartLine) {
    var obj = document.getElementById(cartLine);
    obj.checked = true;
    removeSelected();
}
function addQuantity(cartLine) {
    var obj = document.getElementById(cartLine);
    var oldQuantity = obj.value;
    oldQuantity ++;
    obj.value = oldQuantity;
    document.cartform.submit();
}
function subtractQuantity(cartLine) {
    var obj = document.getElementById(cartLine);
    var oldQuantity = obj.value;
    oldQuantity --;
    obj.value = oldQuantity;
    document.cartform.submit();
}
function removeSelected() {
    var cform = document.cartform;
    cform.removeSelected.value = true;
    cform.submit();
}

//]]>
</script>
    <div style="height:40px"></div>
    <div class="row">
        <ul id="breadcrumbs-one" class="breadcrumbs-cart">
            <li><a class="selected" href="<@ofbizUrl>showcart</@ofbizUrl>">
                ${uiLabelMap.FrontEndCartValidation}
                <small class="carriage-return">${uiLabelMap.FrontEndSelectedProductsValidation}</small>
            </a></li>
            <li><a href="#">
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
        <h3 class="StepTitle">
            ${uiLabelMap.OrderCartSummary}
        </h3>
        <a class="btn btn-info pull-right" href="/cart/merge">
            ${uiLabelMap.FrontEndRecoverFamilyCarts}
        </a>
        <p>
            ${uiLabelMap.FrontEndCartContent} <span id="cartOffersQuantity">${shoppingCartSize}</span>
            <#if shoppingCartSize gt 1> ${uiLabelMap.FrontEndProducts}
            <#else> ${uiLabelMap.FrontEndProduct}
            </#if>
        </p>
    </div>

    <div class="row">
    <#if (shoppingCartSize > 0)>
        <form method="post" action="<@ofbizUrl>modifycart</@ofbizUrl>" name="cartform">
        <input type="hidden" name="removeSelected" value="false" />
        <table  class="shopping-cart-summary">
            <thead>
                <tr>
                    <th class="text-center">${uiLabelMap.OrderProduct}</th>
                    <th>${uiLabelMap.CommonDescription}</th>
                    <th class="text-right">${uiLabelMap.EcommerceUnitPrice}</th>
                    <th class="text-center">${uiLabelMap.CommonQuantity}</th>
                    <th class="text-right">${uiLabelMap.CommonTotal}</th>
                    <th class="text-center">${uiLabelMap.CommonRemove}</th>
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
                                <img class="table-image-thumbler imageborder" src="<@ofbizContentUrl>${requestAttributes.contentPathPrefix?if_exists}${smallImageUrl}</@ofbizContentUrl>" alt="Product Image" />
                            </a>
                        </#if>
                    </td>
                    <#-- Nom du produit -->
                    <td id="cartSummaryOfferName-${cartLine_index}">
                        ${cartLine.getName()?if_exists}
                    </td>
                    <#-- Prix à l'unité -->
                    <td class="text-right"><@ofbizCurrency amount=cartLine.getDisplayPrice() isoCode=shoppingCart.getCurrency()/></td>
                    <#-- Quantité -->
                    <td class="text-center">
                        <a id="subtractQty-${cartLineIndex}" class="quantity-modif" href="javascript:subtractQuantity('quantity_${cartLineIndex}')"><i class="fa fa-minus"></i></a>
                        <span id="quantitySpan_${cartLineIndex}" class="cart-quantity" name="update_${cartLineIndex}">${cartLine.getQuantity()?string.number}</span>
                        <input id="quantity_${cartLineIndex}" size="6" class="inputBox hidden" type="text" name="update_${cartLineIndex}" value="${cartLine.getQuantity()?string.number}" />
                        <a id="addQty-${cartLineIndex}" class="quantity-modif" href="javascript:addQuantity('quantity_${cartLineIndex}')"><i class="fa fa-plus"></i></a>
                    </td>
                    <td class="text-right">
                        <@ofbizCurrency amount=cartLine.getDisplayItemSubTotal() isoCode=shoppingCart.getCurrency()/>
                    </td>
                    <td class="text-center">
                        <a id="removeBtn-${cartLineIndex}" href="javascript:removeCartLine('remove_${cartLineIndex}');" class="item-remove"><i class="fa fa-times"></i></a>
                        <input id="remove_${cartLineIndex}" type="checkbox" class="hidden" name="selectedItem" value="${cartLineIndex}" />
                    </td>
                </tr>
                </#list>
                <tr class="shopping-cart-summary-total">
                    <td></td>
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
                        <@ofbizCurrency amount=shoppingCart.getDisplayGrandTotal() isoCode=shoppingCart.getCurrency()/>
                    </td>
                </tr>
            </tbody>
        </table>
        </form>
    </div>
    <div class="row">
        <a id="emptyCartBtn" href="<@ofbizUrl>emptycart</@ofbizUrl>" class="btn btn-empty-cart">${uiLabelMap.EcommerceEmptyCart}</a>
        <div class="btn-group pull-right" role="group">
            <a type="button" class="btn shopping-cart-nav" role="group">${uiLabelMap.CommonPrevious}</a>
            <a href="<@ofbizUrl>checkoutoptions</@ofbizUrl>" type="button" class="btn shopping-cart-nav selected" role="group">${uiLabelMap.CommonNext}</a>
            <a type="button" class="btn shopping-cart-nav" role="group">${uiLabelMap.CommonDone}</a>
        </div>
    </div>
    <#else>
        <h2>${uiLabelMap.EcommerceYourShoppingCartEmpty}.</h2>
    </#if>
</div>
