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
function selectButton(field, value) {
    document.getElementById(field).innerHTML = value + ' <span class="caret"> </span>';
};
//]]>
</script>
    <div class="row">
        <div class="products-viewmode">
            <div class="viewmode-grid pull-left">
                <a id="productsGridBtn" href="javascript:visibilite('content-products');">
                    <i class="fa fa-th-large"></i>
                    Grille
                </a>
            </div>
            <div class="viewmode-grid pull-left">
                <a id="productsListBtn" href="javascript:visibilite('content-products-list');">
                    <i class="fa fa-th-list"></i>
                    Liste
                </a>
            </div>
        </div>
        <div class="products-sort col-lg-offset-6">
            <div class="products-per-page pull-right">
                <div class="btn-group">
                    <button id="number-by-page-button" type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
                        Tous <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu" role="menu">
                        <li><a href="javascript:selectButton('number-by-page-button', 'Tous')">Tous</a></li>
                        <li><a href="javascript:selectButton('number-by-page-button', '25')">25</a></li>
                        <li><a href="javascript:selectButton('number-by-page-button', '50')">50</a></li>
                        <li><a href="javascript:selectButton('number-by-page-button', '100')">100</a></li>
                    </ul>
                </div>
            </div>
            <div class="sort-type pull-right">
                <div class="btn-group">
                    <button id="sort-criteria-button" type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
                        Ordre alpha croissant <span class="caret"></span>
                    </button>
                    <ul id="select-sort-criteria" class="dropdown-menu" role="menu">
                        <li><a href="javascript:selectButton('sort-criteria-button', 'Ordre alpha croissant')">Ordre alpha croissant</a></li>
                        <li><a href="javascript:selectButton('sort-criteria-button', 'Ordre alpha décroissant')">Ordre alpha décroissant</a></li>
                        <li><a href="javascript:selectButton('sort-criteria-button', 'Du - cher au + cher')">Du - cher au + cher</a></li>
                        <li><a href="javascript:selectButton('sort-criteria-button', 'Du + cher au - cher')">Du + cher au - cher</a></li>
                        <li><a href="javascript:selectButton('sort-criteria-button', 'Les mieux notés')">Les mieux notés</a></li>
                        <li><a href="javascript:selectButton('sort-criteria-button', 'Meilleurs ventes')">Meilleurs ventes</a></li>
                        <li><a href="javascript:selectButton('sort-criteria-button', 'Les plus récents')">Les plus récents</a></li>
                        <li><a href="javascript:selectButton('sort-criteria-button', 'Les plus anciens')">Les plus anciens</a></li>
                    </ul>
                </div>
            </div>
            <label for="select-sort-criteria" class="pull-right">Trier par</label>
        </div>
    </div>
    <div class="row">
        <div class="ruler"></div>
    </div>
    <div class="row">
        <div id="products-list">
            <div class="product-item-qty">
                <#assign filteredOffersQty = productOfferList?size>
                <#assign totalOffersQty = productOfferList?size>
                <h4>${filteredOffersQty} offres sur ${totalOffersQty} au total</h4>
            </div>
        </div>
    </div>
    <div id="content-products" class="products-grid">
        <div class="row">
        <#assign gridCount = 0>
        <#list productOfferList as productOffer>
        <#if gridCount gt 3>
            <#assign gridCount = 0>
            <div class="row">
        </#if>
            <div class="col-lg-3">
                <div class="product">
                    <div class="crush-id">
                        <a href="crushes/2/edit" data-remote="true">
                            <img src="<@ofbizContentUrl>/frontend/images/coup-de-coeur.svg</@ofbizContentUrl>">
                        </a>
                        <div class="crush-details notcrushed">Identifiez-vous pour ajouter un coup de coeur</div>
                    </div>
                    <div class="product-new"></div>
                    <div class="product-preview">
                        <#assign largeImageUrl = Static["org.ofbiz.product.product.ProductContentWrapper"].getProductContentAsText(productOffer.get("product"), "LARGE_IMAGE_URL", locale, dispatcher)?if_exists />
                        <#assign defaultProductImage = ""/>
                        <#if !largeImageUrl?string?has_content>
                            <#assign largeImageUrl = "/images/defaultImage.jpg" />
                            <#assign defaultProductImage = "defaultProductImage"/>
                        </#if>
                        <#if largeImageUrl?string?has_content>
                            <img src="<@ofbizContentUrl>${largeImageUrl}</@ofbizContentUrl>" class="img-responsive <#if defaultProductImage?string?has_content>defaultProductImage</#if>">
                        </#if>
                    </div>
                    <div class="product-info">
                        <h5><a id="gridOfferName-${productOffer_index}" href="products/2">${productOffer.productName}</a></h5>
                        <p id="gridOfferPrice-${productOffer_index}"><@ofbizCurrency amount=productOffer.price?if_exists isoCode=productOffer.currencyUomId?if_exists/></p>
                        <form method="post" action="<@ofbizUrl>additem</@ofbizUrl>" name="the${productOffer.productOfferId}gridform" style="margin: 0;">
                            <input type="hidden" name="productOfferId" value="${productOffer.productOfferId}"/>
                            <input type="hidden" name="add_product_id" value="${productOffer.productId}"/>
                            <input type="hidden" size="5" name="quantity" value="1"/>
                            <input type="hidden" name="clearSearch" value="N"/>
                            <input type="hidden" name="mainSubmitted" value="Y"/>
                            <div class="button-box">
                                <a id="addToCartBtnGrid-${productOffer_index}" href="javascript:document.the${productOffer.productOfferId}gridform.submit()"><i class="fa fa-shopping-cart"></i> ${uiLabelMap.OrderAddToCart}</a>
                            </div>
                        </form>
                    </div>
                    <div class="product-rating">
                        <div class="stars">
                            <#list productOffer.stars as star>
                            <#if star == 0>
                                <i class="fa fa-star-o"></i>
                            <#elseif star == 1>
                                <i class="fa fa-star"></i>
                            <#else>
                                <i class="fa fa-star-half-o"></i>
                            </#if>
                            </#list>
                        </div>
                    </div>
                </div>
            </div>
        <#if gridCount == 3 && ! (productOffer == productOfferList?last)>
            </div>
        </#if>
        <#assign gridCount = gridCount + 1>
        </#list>
        </div>
    </div>
    <div id="content-products-list" class="products-list" style="display:none">
        <#list productOfferList as productOffer>
        <div class="row">
            <div class="product-in-list">
                <div class="col-lg-3">
                    <div class="product">
                        <div class="crush-id">
                            <a href="crushes/2/edit" data-remote="true">
                                <img src="<@ofbizContentUrl>/frontend/images/coup-de-coeur.svg</@ofbizContentUrl>">
                            </a>
                            <div class="crush-details notcrushed">Identifiez-vous pour ajouter un coup de coeur</div>
                        </div>
                        <div class="product-preview">
                            <#assign largeImageUrl = Static["org.ofbiz.product.product.ProductContentWrapper"].getProductContentAsText(productOffer.get("product"), "LARGE_IMAGE_URL", locale, dispatcher)?if_exists />
                            <#assign defaultProductImage = ""/>
                            <#if !largeImageUrl?string?has_content>
                                <#assign largeImageUrl = "/images/defaultImage.jpg" />
                                <#assign defaultProductImage = "defaultProductImage"/>
                            </#if>
                            <#if largeImageUrl?string?has_content>
                                <img src="<@ofbizContentUrl>${largeImageUrl}</@ofbizContentUrl>" <#if defaultProductImage?string?has_content>class="defaultProductImage"</#if>>
                            </#if>
                        </div>
                    </div>
                </div>
                <div class="col-lg-9">
                    <div class="product-list-info col-lg-offset-1">
                        <h5><a id="listProductName-${productOffer_index}" href="products/2">${productOffer.productName}</a></h5>
                        <div class="stars">
                            <#list productOffer.stars as star>
                            <#if star == 0>
                                <i class="fa fa-star-o"></i>
                            <#elseif star == 1>
                                <i class="fa fa-star"></i>
                            <#else>
                                <i class="fa fa-star-half-o"></i>
                            </#if>
                            </#list>
                        </div>
                        <div class="product-details">
                            <p>
                                <u>Description :</u>
                                ${productOffer.productName}
                            </p>
                            <p>
                                <u>Description longue :</u>
                                ${productOffer.productDescription}
                            </p>
                            <p>
                                <u>Argumentation commerciale :</u>
                                ${productOffer.commercialArguments}
                            </p>
                            <p>
                                <u>Conseils d'utilisation :</u>
                                ${productOffer.useAdvises}
                            </p>
                            <br>
                            <br>
                        </div>
                        <h4 id="listProductPrice-${productOffer_index}"><@ofbizCurrency amount=productOffer.price?if_exists isoCode=productOffer.currencyUomId?if_exists/></h4>
                        <form method="post" action="<@ofbizUrl>additem</@ofbizUrl>" name="the${productOffer.productOfferId}listform" style="margin: 0;">
                            <input type="hidden" name="productOfferId" value="${productOffer.productOfferId}"/>
                            <input type="hidden" name="add_product_id" value="${productOffer.productId}"/>
                            <input type="hidden" size="5" name="quantity" value="1"/>
                            <input type="hidden" name="clearSearch" value="N"/>
                            <input type="hidden" name="mainSubmitted" value="Y"/>
                            <div class="button-list-box">
                                <a id="addToCartBtnList-${productOffer_index}" href="javascript:document.the${productOffer.productOfferId}listform.submit()"><i class="fa fa-shopping-cart"></i> Ajouter au panier</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        </#list>
    </div>