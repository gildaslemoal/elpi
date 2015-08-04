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
     function changeEmail() {
         document.getElementById('userName').value = jQuery('#customerEmail').val();
     }
    </script>
    <div class="row">
        <ul id="breadcrumbs-one" class="breadcrumbs-cart">
            <li><a class="selected" href="/frontend/control/newcustomer">
                INFORMATIONS
                <small class="carriage-return">Saisissez vos nom, prénom et coordonnées</small>
            </a></li>
            <li><a class="" href="#">
                ADHÉSION
                <small class="carriage-return">Indiquez votre choix d'adhésion et/ou votre don</small>
            </a></li>
            <li><a class="" href="#">
                PAIEMENT
                <small class="carriage-return">Choisissez votre mode de paiement</small>
            </a></li>
        </ul>
    </div>
    <div class="row">
        <h2>${uiLabelMap.FrontEndInformations}</h2>
        <div class="ruler"></div>
        <form method="post" action="<@ofbizUrl>createProfil</@ofbizUrl>" name="registerform" class="form-horizontal">
            <input type="hidden" name="emailProductStoreId" value="${productStoreId}"/>
            <span class="col-sm-offset-3">* ${uiLabelMap.FrontEndMandatoryField}, ** ${uiLabelMap.FrontEndAtLeastOneMandatoryField}</span>
            <div class="form-group">
                <label class="col-sm-3 control-label">${uiLabelMap.FormFieldTitle_salutation} *</label>
                <div class="col-sm-9">
                    <label class="radio-inline"><input type="radio" name="USER_TITLE" id="misterRadioBtn" value="${uiLabelMap.CommonTitleMrs}">${uiLabelMap.FrontEndMisses}</label>
                    <label class="radio-inline"><input type="radio" name="USER_TITLE" id="missesRadioBtn" value="${uiLabelMap.CommonTitleMr}">${uiLabelMap.FrontEndMister}</label>
                    <!--<label class="radio-inline"><input type="radio" name="USER_TITLE" id="misterRadioBtn" <#if userTitle?has_content && userTitle=="Mme">checked</#if> value="${uiLabelMap.CommonTitleMrs}">${uiLabelMap.FrontEndMisses}</label>-->
                    <!--<label class="radio-inline"><input type="radio" name="USER_TITLE" id="missesRadioBtn" <#if userTitle?has_content && userTitle=="Mr">checked</#if> value="${uiLabelMap.CommonTitleMr}">${uiLabelMap.FrontEndMister}</label>-->
                </div>
            </div>
            <div class="form-group">
                <label for="lastname" class="col-sm-3 control-label">${uiLabelMap.FormFieldTitle_lastName} *</label>
                <div class="col-sm-9">
                    <input type="text" class="form-control" id="lastname" name="USER_LAST_NAME" <#if userLastName?has_content>value="${userLastName}"</#if> placeholder="${uiLabelMap.FormFieldTitle_lastName}">
                </div>
            </div>
            <div class="form-group">
                <label for="firstname" class="col-sm-3 control-label">${uiLabelMap.FormFieldTitle_firstName} *</label>
                <div class="col-sm-9">
                    <input type="text" class="form-control" id="firstname" name="USER_FIRST_NAME" <#if userFirstName?has_content>value="${userFirstName}"</#if> placeholder="${uiLabelMap.FormFieldTitle_firstName}">
                </div>
            </div>
            <div class="form-group">
                <label for="customerEmail" class="col-sm-3 control-label">${uiLabelMap.CommonEmail} *</label>
                <div class="col-sm-9">
                    <input type="email" class="form-control" id="customerEmail" name="CUSTOMER_EMAIL" placeholder="${uiLabelMap.CommonEmail}" <#if customerEmail?has_content>value="${customerEmail}"</#if> onchange="changeEmail()" onkeyup="changeEmail()">
                    <input type="hidden" class="form-control" id="userName" name="USERNAME" <#if customerEmail?has_content>value="${customerEmail}"</#if>>
                </div>
            </div>
            <div class="form-group">
                <label for="password" class="col-sm-3 control-label">${uiLabelMap.WorkEffortPassword} *</label>
                <div class="col-sm-9">
                    <input type="password" class="form-control" id="password" name="PASSWORD" placeholder="${uiLabelMap.WorkEffortPassword}">
                </div>
            </div>
            <div class="form-group">
                <label for="confirmPassword" class="col-sm-3 control-label">${uiLabelMap.FrontEndConfirmation} *</label>
                <div class="col-sm-9">
                    <input type="password" class="form-control" id="confirmPassword" name="CONFIRM_PASSWORD" placeholder="${uiLabelMap.FrontEndConfirmation}">
                </div>
            </div>
            <div class="form-group">
                <label for="userBirthdate" class="col-sm-3 control-label">${uiLabelMap.FormFieldTitle_birthDate} *</label>
                <div class="col-sm-9">
                    <input type="date" class="form-control" id="userBirthdate" name="USER_BIRTHDATE" <#if userBirthDate?has_content>value="${userBirthDate}"</#if> placeholder="${uiLabelMap.FormFieldTitle_birthDate} JJ-MM-AAAA (16-03-1953)">
                </div>
            </div>
            <div class="form-group">
                <label for="customerHomeContact" class="col-sm-3 control-label">${uiLabelMap.FrontEndHomePhone} **</label>
                <div class="col-sm-9">
                    <input type="phone" required class="form-control" id="customerHomeContact" name="CUSTOMER_HOME_CONTACT" <#if customerHomeContact?has_content>value="${customerHomeContact}"</#if> placeholder="${uiLabelMap.FrontEndHomePhone}">
                </div>
            </div>
            <div class="form-group">
                <label for="customerMobileContact" class="col-sm-3 control-label">${uiLabelMap.PartyMobilePhone} **</label>
                <div class="col-sm-9">
                    <input type="phone" class="form-control" id="customerMobileContact" name="CUSTOMER_MOBILE_CONTACT" <#if customerMobileContact?has_content>value="${customerMobileContact}"</#if> placeholder="${uiLabelMap.PartyMobilePhone}">
                </div>
            </div>
            <div class="form-group">
                <label for="customerAddress1" class="col-sm-3 control-label">${uiLabelMap.OrderAddress} *</label>
                <div class="col-sm-9">
                    <input type="text" class="form-control" id="customerAddress1" name="CUSTOMER_ADDRESS1" <#if customerAddress1?has_content>value="${customerAddress1}"</#if> placeholder="${uiLabelMap.OrderAddress}">
                </div>
            </div>
            <div class="form-group">
                <label for="customerAddress2" class="col-sm-3 control-label">${uiLabelMap.FormFieldTitle_paAddress2}</label>
                <div class="col-sm-9">
                    <input type="text" class="form-control" id="customerAddress2" name="CUSTOMER_ADDRESS2" <#if customerAddress2?has_content>value="${customerAddress2}"</#if> placeholder="${uiLabelMap.FormFieldTitle_paAddress2}">
                </div>
            </div>
            <div class="form-group">
                <label for="customerPostalCode" class="col-sm-3 control-label">${uiLabelMap.FormFieldTitle_postalCode} *</label>
                <div class="col-sm-9">
                    <input type="text" class="form-control" id="customerPostalCode" name="CUSTOMER_POSTAL_CODE" <#if customerPostalCode?has_content>value="${customerPostalCode}"</#if> placeholder="${uiLabelMap.FormFieldTitle_postalCode}">
                </div>
            </div>
            <div class="form-group">
                <label for="customerCity" class="col-sm-3 control-label">${uiLabelMap.FormFieldTitle_city} *</label>
                <div class="col-sm-9">
                    <input type="text" class="form-control" id="customerCity" name="CUSTOMER_CITY" <#if customerCity?has_content>value="${customerCity}"</#if> placeholder="${uiLabelMap.FormFieldTitle_city}">
                    <input type="hidden" class="form-control" id="customerCountry" name="CUSTOMER_COUNTRY" value="FRA">
                    <input type="hidden" class="form-control" id="customerState" name="CUSTOMER_STATE" value="_NA_">
                </div>
            </div>
            <div class="form-group">
                <!--<input class="" type="checkbox" id="CUSTOMER_EMAIL_ALLOW_SOL" name="CUSTOMER_EMAIL_ALLOW_SOL">-->
                <!--<label class="control-label">Je souhaite m'abonner à la news letter</label>-->
                <label class="col-sm-3 control-label"></label>
                <div class="col-sm-9">
                    <!--<label class="radio-inline"><input type="checkbox" name="CUSTOMER_EMAIL_ALLOW_SOL" id="CUSTOMER_EMAIL_ALLOW_SOL" value=""> Je souhaite m'abonner à la news letter</label>-->
                    <label><input type="checkbox" name="CUSTOMER_EMAIL_ALLOW_SOL" id="CUSTOMER_EMAIL_ALLOW_SOL" <#if CUSTOMER_EMAIL_ALLOW_SOL?has_content && CUSTOMER_EMAIL_ALLOW_SOL=="Y">checked</#if> value="Y"> Je souhaite m'abonner à la news letter</label>
                    <!--<label class="radio-inline"><input type="radio" name="CUSTOMER_EMAIL_ALLOW_SOL" id="missesRadioBtn" <#if CUSTOMER_EMAIL_ALLOW_SOL?has_content && CUSTOMER_EMAIL_ALLOW_SOL=="N">checked</#if> value="N">Non</label>-->
                </div>
            </div>
            <div class="row">
                <div class="btn-group pull-right" role="group">
                    <a type="button" class="btn shopping-cart-nav" role="group">Pr&eacute;c&eacute;dent</a>
                    <button type="submit" class="btn shopping-cart-nav selected" role="group">Suivant</button>
                    <a type="button" class="btn shopping-cart-nav" role="group">Terminer</a>
                </div>
            </div>
        </form>

    </div>
    </div>
