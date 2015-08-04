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
<#assign shoppingCart = sessionAttributes.shoppingCart?if_exists/>
<#if shoppingCart?has_content>
    <#assign shoppingCartSize = shoppingCart.size()/>
<#else>
    <#assign shoppingCartSize = 0/>
</#if>
    <div class="header-bar navbar navbar-fixed-top">
        <div class="container">
            <div class="pull-left">
                <a class="logo" href="<@ofbizUrl>main</@ofbizUrl>">
                    <img id="logo-header" src="<@ofbizContentUrl>/frontend/images/Logo-nouscitoyens-HD.jpg</@ofbizContentUrl>" alt="Logo otoit">
                </a>
                <!--<img id="logo-header" src="<@ofbizContentUrl>/frontend/images/Logo-nouscitoyens-HD.jpg</@ofbizContentUrl>" alt="logo nous citoyens">-->
            </div>
        <#if userLogin?has_content && userLogin.userLoginId != "anonymous">
            <div>
                <ul>
                    <li><a id="disconnectBtn" href="<@ofbizUrl>logout</@ofbizUrl>"><i class="fa fa-unlock"></i> ${uiLabelMap.FrontEndLogout}</a></li>
                    <#if person?has_content>
                        <!--<li><a href="#"><i class="fa fa-heart"></i> ${uiLabelMap.FrontEndMyFavorite} |</a></li>-->
                        <!--<li><a href="#"><i class="fa fa-users"></i> ${uiLabelMap.FrontEndFamily} |</a></li>-->
                        <li><a id="btnMyAccount" href="<@ofbizUrl>account</@ofbizUrl>">| <i class="fa fa-user"></i> ${uiLabelMap.EcommerceMyAccount} |</a></li>
                        <li id="navUserFirstname" class="welcome-message">${uiLabelMap.WorkEffortWelcome}, <#if person?exists> ${person.get("firstName")}<#else> ${userLogin.userLoginId}</#if></li>
                    </#if>
                </ul>
            </div>
        <#else/>
            <a id="connectionBtn" style="position: relative;float: right;" href="<@ofbizUrl>${checkLoginUrl}</@ofbizUrl>"><i class="fa fa-lock"></i> ${uiLabelMap.FrontEndLoginRegister}</a>
        </#if>
        </div>
    </div>
    <div style="height:50px"></div>
