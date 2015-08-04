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
    <#assign partyId = userLogin.get("partyId")?if_exists/>
    <input type="hidden" value="${partyId}">
    <div class="row">
        <ul id="breadcrumbs-one" class="breadcrumbs-cart">
            <li><a class="validated" href="/frontend/control/newcustomer">
                INFORMATIONS
                <small class="carriage-return">Saisissez vos nom, prénom et coordonnées</small>
            </a></li>
            <li><a class="selected" href="#">
                ADHÉSION
                <small class="carriage-return">Indiquez votre choix d'adhésion et/ou votre don</small>
            </a></li>
            <li><a class="" href="#">
                PAIEMENT
                <small class="carriage-return">Choisissez votre mode de paiement</small>
            </a></li>
        </ul>
    </div>

    <form method="post" action="<@ofbizUrl>selectMembership</@ofbizUrl>" name="membershipChoice" class="form-horizontal">

    <div class="row">
            <h3>Votre adhésion</h3>
        </div>
        <div class="row">
            <div class="radio">
                <label>
                    <input type="radio" name="adhesionRadios" id="adhesionRadios1" value="simple">
                    Adhésion Simple : 20 €
                </label>
                <label>
                    <input type="radio" name="adhesionRadios" id="adhesionRadios2" value="couple">
                    Adhésion Couple : 35 €
                </label>
                <label>
                    <input type="radio" name="adhesionRadios" id="adhesionRadios3" value="jeune">
                    Adhésion Jeune : 6,80 €
                </label>
            </div>
        </div>
    
        <div class="row">
            <h3>Vous souhaitez faire un don</h3>
        </div>
        <div class="row">
            <div id="gift-choices" class="radio">
                <label>
                    <input type="radio" name="donRadios" id="donRadios1" value="20">
                    20 €
                </label>
                <label>
                    <input type="radio" name="donRadios" id="donRadios2" value="60">
                    60 €
                </label>
                <label>
                    <input type="radio" name="donRadios" id="donRadios3" value="100">
                    100 €
                </label>
                <label>
                    <input type="radio" name="donRadios" id="donRadios4" value="300">
                    300 €
                </label>
                <label>
                    <input type="radio" name="donRadios" id="donRadios5" value="1000">
                    1000 €
                </label>
                <label>
                    <input type="radio" name="donRadios" id="donRadios6" value="3000">
                    3000 €
                </label>
                <div>
                    <input type="radio" name="donRadios" id="donRadios7" value="personalized">
                    <input type="text" id="gift-amount" name="gift-amount" placeholder="Autre montant" class="form-control">
                </div>
            </div>
        </div>

        <div class="row">
            <div class="btn-group pull-right" role="group">
                <a href="/frontend/control/newcustomer" class="btn shopping-cart-nav selected" role="group">Pr&eacute;c&eacute;dent</a>
                <button type="submit" class="btn shopping-cart-nav selected" role="group">Suivant</button>
                <a type="button" class="btn shopping-cart-nav" role="group">Terminer</a>
            </div>
        </div>
    </div>
    </form>

