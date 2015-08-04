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
            form.action="/frontend/control/checkoutoptions";
            form.submit();
        } else if (mode == "CS") {
            // continue shopping
            form.action="/frontend/control/updateCheckoutOptions/showcart";
            form.submit();
        } else if (mode == "NC") {
            // new credit card
            form.action="/frontend/control/updateCheckoutOptions/editcreditcard?DONE_PAGE=checkoutpayment";
            form.submit();
        } else if (mode == "EC") {
            // edit credit card
            form.action="/frontend/control/updateCheckoutOptions/editcreditcard?DONE_PAGE=checkoutpayment&paymentMethodId="+value+"";
            form.submit();
        } else if (mode == "GC") {
            // edit gift card
            form.action="/frontend/control/updateCheckoutOptions/editgiftcard?paymentMethodId="+value+"";
            form.submit();
        } else if (mode == "NE") {
            // new eft account
            form.action="/frontend/control/updateCheckoutOptions/editeftaccount?DONE_PAGE=checkoutpayment";
            form.submit();
        } else if (mode == "EE") {
            // edit eft account
            form.action="/frontend/control/updateCheckoutOptions/editeftaccount?DONE_PAGE=checkoutpayment&paymentMethodId="+value+"";
            form.submit();
        }else if(mode = "EG")
        //edit gift card
            form.action="/frontend/control/updateCheckoutOptions/editgiftcard?DONE_PAGE=checkoutpayment&paymentMethodId="+value+"";
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

    <div class="row">
        <ul id="breadcrumbs-one" class="breadcrumbs-cart">
            <li><a class="validated" href="/frontend/control/newcustomer">
                INFORMATIONS
                <small class="carriage-return">Saisissez vos nom, prénom et coordonnées</small>
            </a></li>
            <li><a class="validated" href="/frontend/control/adhesion">
                ADHÉSION
                <small class="carriage-return">Indiquez votre choix d'adhésion et/ou votre don</small>
            </a></li>
            <li><a class="selected" href="#">
                PAIEMENT
                <small class="carriage-return">Choisissez votre mode de paiement</small>
            </a></li>
        </ul>
    </div>
        <div class="row">
            <h3 class="StepTitle">
                Récapitulatif avant paiement
            </h3>
        </div>

    <form method="post" id="checkoutInfoForm" action="">
        <input type="hidden" name="checkoutpage" value="payment" />
        <input type="hidden" name="BACK_PAGE" value="checkoutoptions" />
        <input type="hidden" name="issuerId" id="issuerId" value="" />

        <div class="row">
            <#list shoppingCart.items() as cartLine>
                <#assign productId = cartLine.getProductId() />
                <#if productId = "10000"> <!-- adhesion simple -->
                    <h4>Vous adhérer pour 1 an à : Adhésion simple (<@ofbizCurrency amount=cartLine.getDisplayItemSubTotal() isoCode=shoppingCart.getCurrency()/>)</h4>
                <#elseif productId = "10001"> <!-- adhesion couple -->
                    <h4>Vous adhérer pour 1 an à : Adhésion couple (<@ofbizCurrency amount=cartLine.getDisplayItemSubTotal() isoCode=shoppingCart.getCurrency()/>)</h4>
                <#elseif productId = "10002"> <!-- adhesion jeune -->
                    <h4>Vous adhérer pour 1 an à : Adhésion jeune (<@ofbizCurrency amount=cartLine.getDisplayItemSubTotal() isoCode=shoppingCart.getCurrency()/>)</h4>
                <#elseif productId = "10010"> <!-- don -->
                    <h4>Vous effectuez un don de : <@ofbizCurrency amount=cartLine.getDisplayItemSubTotal() isoCode=shoppingCart.getCurrency()/></h4>
                </#if>

            </#list>
        </div>

        <div class="row">
            <h3>Total : <@ofbizCurrency amount=shoppingCart.getDisplayGrandTotal() isoCode=shoppingCart.getCurrency()/></h3>
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
                <a href="" type="button" class="btn shopping-cart-nav selected" role="group">Pr&eacute;c&eacute;dent</a>
                <a type="button" class="btn shopping-cart-nav" role="group">Suivant</a>
                <a onclick="" href="javascript:submitForm(document.getElementById('checkoutInfoForm'), 'DN', '');" type="button" class="btn shopping-cart-nav selected" role="group">Terminer</a>
            </div>
        </div>
    </div>
