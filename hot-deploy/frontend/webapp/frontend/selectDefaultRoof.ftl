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
    <dialog>
        <div><h1>Selection du toit par défaut</h1></div>
        <form method="post" action="<@ofbizUrl>setDefaultRoof</@ofbizUrl>" name="setDefaultRoof" class="horizontal">
            <div class="form-group">
                <label for="customerDefaultRoof" class="col-sm-3 control-label">${uiLabelMap.FrontEndSelectRoof} *</label>
                <div class="col-sm-9">
                    <#if roofs?has_content>
                        <select class="selectpicker" data-width="100%" id="customerDefaultRoof" name="customerDefaultRoof">
                            <#list roofs as roof>
                                <option value="${roof.facilityId}">${roof.postalCode} - ${roof.facilityName} (${roof.city})</option>
                            </#list>
                        </select>
                    </#if>
                </div>
            </div>
            </br></br></br></br>
            <button type="submit" class="btn btn-default btn-otoit" id="setDefaultRoofBtn">${uiLabelMap.CommonApply}</button>
        </form>

        </br></br>
        <div><h1>${uiLabelMap.FrontEndIdentification}</h1></div>
        <div class="ruler"></div>
        <form method="post" action="<@ofbizUrl>login</@ofbizUrl>" name="loginform" class="horizontal">
            <div class="form-group">
                <label for="userName">${uiLabelMap.CommonEmail}</label>
                <input type="text" class="form-control" id="userName" name="USERNAME" value="<#if requestParameters.USERNAME?has_content>${requestParameters.USERNAME}<#elseif autoUserLogin?has_content>${autoUserLogin.userLoginId}</#if>" placeholder="${uiLabelMap.FrontEndEmailAddress}"/>
            </div>
            <div class="form-group">
                <label for="password">${uiLabelMap.CommonPassword}</label>
                <input type="password" class="form-control" id="password" name="PASSWORD" placeholder="${uiLabelMap.CommonPassword}" value="">
            </div>
            <div class="checkbox">
                <label>
                    <input type="checkbox" id="rememberMeChkbx"> ${uiLabelMap.FrontEndRememberMe}
                </label>
            </div>
            <a href="<@ofbizUrl>forgotpassword</@ofbizUrl>" id="forgotPasswordBtn">${uiLabelMap.FrontEndForgotPassword}</a><br>
            <button type="submit" class="btn btn-default btn-otoit" id="loginBtn">${uiLabelMap.FrontEndConnection}</button>
        </form>
    </dialog>

    <script type="java/text"></script>