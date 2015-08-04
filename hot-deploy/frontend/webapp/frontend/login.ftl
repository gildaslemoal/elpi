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
    <div class="row">
        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
            <h3>${uiLabelMap.FrontEndIdentification}</h3>
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
        </div>
        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
            <h3>${uiLabelMap.FrontEndRegister}</h3>
            <div class="ruler"></div>
            <form method="post" action="<@ofbizUrl>newcustomer</@ofbizUrl>" name="registerform" class="horizontal" >
                <div class="form-group">
                    <label for="customerEmail">${uiLabelMap.CommonEmail}</label>
                    <input type="email" class="form-control" id="customerEmail" name="CUSTOMER_EMAIL" placeholder="${uiLabelMap.FrontEndEmailAddress}">
                </div>
                <button type="submit" class="btn btn-default btn-otoit" id="registerBtn">${uiLabelMap.FrontEndRegister}</button>
            </form>
        </div>
        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
            <h3>Connexion Facebook</h3>
            <div class="ruler"></div>
            <a class="facebook-btn" href="#"><i class="fa fa-facebook"></i> Connectez-vous avec Facebook</a>
            <p style="padding-top: 20px">Nous ne publierons rien sans votre permission.</p>
        </div>
    </div>

<script language="JavaScript" type="text/javascript">
  <#if autoUserLogin?has_content>document.loginform.PASSWORD.focus();</#if>
  <#if !autoUserLogin?has_content>document.loginform.USERNAME.focus();</#if>
</script>
