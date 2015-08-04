
<#if parameters.partyId??>
    <#--<#assign visit = delegator.findByAnd("Visit", {"partyId": partyId, "thruDate": ""}, null, false)>-->
    <#--<#assign connected = false>-->
    <#--<#list partyAttributeList as partyAttribute>-->
        <#--<#assign connected = true>-->
    <#--</#list>-->
    <script>
        function modifyMyInformation() {
            document.getElementById("contact-information").style.display = 'none';
            document.getElementById("contact-information-form").style.display = 'inline';
        }
        function cancelMyInformation() {
            document.getElementById("contact-information").style.display = 'inline';
            document.getElementById("contact-information-form").style.display = 'none';
        }
    </script>
    <div style="height: 30px"></div>
    <div class="row">
        <div class="col-md-12">
            <div class="row panel panel-profile">
                <div class="panel-heading col-md-3 col-lg-2">
                    <img class="img-circle img-responsive profile-image center-block" src="/easyofbiztheme/images/<#if genre="Mr">default-men.svg<#else>default-women.svg</#if>" alt="${person.lastName} ${person.firstName}"></td>
                    <h3 class="profile-name text-center">${person.lastName} ${person.firstName}</h3>
                    <p class="profile-type text-center">(Membre)</p>
                </div>
                <div class="panel-body col-md-9 col-lg-10">
                    <div class="row">
                        <div id="contact-information" class="col-md-6">
                            <h3>Informations du contact <button type="button" class="btn btn-default" onclick="modifyMyInformation()"><i class="fa fa-pencil"></i> Modifier</button></h3>
                            <dl class="dl-horizontal">
                                <dt>Adresse email : </dt>
                                <dd><a href="mailto:${emailAddress}">${emailAddress}</a></dd>
                                <dt>Domicile : </dt>
                                <dd>${phoneHome.contactNumber?if_exists}</dd>
                                <dt>Mobile : </dt>
                                <dd>${phoneMobile.contactNumber?if_exists}</dd>
                                <dt>Adresse postale : </dt>
                                <dd>${postalAddress.address1} ${postalAddress.address2?if_exists} ${postalAddress.postalCode} ${postalAddress.city}</dd>
                                <dt>Date de naissance : </dt>
                                <dd>${person.birthDate?string.long}</dd>
                            </dl>
                        </div>
                        <div id="contact-information-form" class="col-md-6" style="display:none">
                            <form id="myInformation-modify" method="post" action="<@ofbizUrl>updateProfile</@ofbizUrl>" name="profileUpdateForm">
                            <h3>Informations du contact
                                <button type="submit" class="btn btn-success" onclick=""><i class="fa fa-pencil"></i> valider</button>
                                <button type="button" class="btn btn-default" onclick="cancelMyInformation()"><i class="fa fa-arrow-left"></i> annuler</button>
                                <input type="hidden" id="partyId" name="PARTY_ID" value="${partyId}">
                                <input type="hidden" name="partyId" value="${partyId}">
                            </h3>
                                <dl class="dl-horizontal">
                                    <dt>${uiLabelMap.FormFieldTitle_salutation}</dt>
                                    <dd>
                                        <label class="radio-inline"><input type="radio" name="USER_TITLE" id="misterRadioBtn" <#if genre?has_content && genre=="Mme">checked</#if> value="${uiLabelMap.CommonTitleMrs}">${uiLabelMap.FrontEndMisses}</label>
                                        <label class="radio-inline"><input type="radio" name="USER_TITLE" id="missesRadioBtn" <#if genre?has_content && genre=="Mr">checked</#if> value="${uiLabelMap.CommonTitleMr}">${uiLabelMap.FrontEndMister}</label>
                                    </dd>
                                    <dt>Nom : </dt>
                                    <dd><input type="text" class="form-control" id="lastName" name="USER_LAST_NAME" value="${person.lastName?if_exists}" placeholder="${uiLabelMap.FormFieldTitle_lastName}"></dd>
                                    <dt>Prénom : </dt>
                                    <dd><input type="text" class="form-control" id="firstName" name="USER_FIRST_NAME" value="${person.firstName?if_exists}" placeholder="${uiLabelMap.FormFieldTitle_firstName}"></dd>
                                    <dt>Domicile : </dt>
                                    <dd><input type="text" class="form-control" id="phoneNumber" name="CUSTOMER_HOME_CONTACT" value="${phoneHome.contactNumber?if_exists}" placeholder="Téléphone domicile"></dd>
                                    <dt>Mobile : </dt>
                                    <dd><input type="text" class="form-control" id="phoneNumber" name="CUSTOMER_MOBILE_CONTACT" value="${phoneMobile.contactNumber?if_exists}" placeholder="Téléphone mobile"></dd>
                                    <dt>Addresse : </dt>
                                    <dd>
                                        <input type="text" class="form-control" id="customerAddress1" name="CUSTOMER_ADDRESS1" value="${postalAddress.address1}" placeholder="${uiLabelMap.OrderAddress}">
                                    </dd>
                                    <dt>Complément : </dt>
                                    <dd>
                                        <input type="text" class="form-control" id="customerAddress2" name="CUSTOMER_ADDRESS2" value="<#if postalAddress.address2?exists>${postalAddress.address2}</#if>" placeholder="${uiLabelMap.FormFieldTitle_paAddress2}">
                                    </dd>
                                    <dt>Code postal : </dt>
                                    <dd>
                                        <input type="text" class="form-control" id="customerPostalCode" name="CUSTOMER_POSTAL_CODE" value="${postalAddress.postalCode}" placeholder="${uiLabelMap.FormFieldTitle_postalCode}">
                                    </dd>
                                    <dt>Ville : </dt>
                                    <dd>
                                        <input type="text" class="form-control" id="customerCity" name="CUSTOMER_CITY" value="${postalAddress.city}" placeholder="${uiLabelMap.FormFieldTitle_city}">
                                        <input type="hidden" class="form-control" id="customerCountry" name="CUSTOMER_COUNTRY" value="${postalAddress.countryGeoId}">
                                        <input type="hidden" class="form-control" id="customerState" name="CUSTOMER_STATE" value="${postalAddress.stateProvinceGeoId}">
                                    </dd>
                                    <dt>Date de naissance : </dt>
                                    <dd>
                                        <input type="date" class="form-control" id="userBirthdate" name="USER_BIRTHDATE" value="${person.birthDate?string["yyyy/mm/dd"]}" placeholder="${uiLabelMap.FormFieldTitle_birthDate} AAAA-MM-JJ (1953-03-16)">
                                    </dd>
                                </dl>
                            </form>
                        </div>
                        <div id="account-information" class="col-md-6">
                            <h3>Informations du compte</h3>
                            <dl class="dl-horizontal">
                                <dt>Identifiant : </dt>
                                <dd>${partyId?if_exists}</dd>
                                <dt>Login : </dt>
                                <dd>${userLoginId?if_exists}</dd>
                                <dt>Situation : </dt>
                            <#if cotisation="1">
                                <dd><span class="label table-label label-success">Cotisation à jour</span></dd>
                            <#else>
                                <dd><span class="label table-label label-danger">En attente de paiement</span></dd>
                            </#if>
                                <dt>Membre depuis : </dt>
                                <dd>${party.createdDate?date}</dd>
                                <dt>Statut : </dt>
                                <dd>
                                <#if connected = true>
                                    <span class="label table-label label-success">Connecté</span>
                                <#else>
                                    <span class="label table-label label-default">Non connecté</span>
                                </#if>
                                </dd>
                            </dl>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <ul class="nav nav-tabs">
            <li role="presentation" class="active"><a href="#">Coordonnées</a></li>
            <li role="presentation"><a href="#">Connexions</a></li>
            <li role="presentation"><a href="#">Messages</a></li>
        </ul>
    </div>
<#else>
    <div>Aucun membre ne correspond à cet identifiant</div>
    <a href="<@ofbizUrl>memberList</@ofbizUrl>" class="btn btn-success">retour à la liste des membres</a>
</#if>