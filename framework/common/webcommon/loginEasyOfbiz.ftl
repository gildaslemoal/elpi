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

<#if requestAttributes.uiLabelMap?exists><#assign uiLabelMap = requestAttributes.uiLabelMap></#if>
<#assign useMultitenant = Static["org.ofbiz.base.util.UtilProperties"].getPropertyValue("general.properties", "multitenant")>

<#assign username = requestParameters.USERNAME?default((sessionAttributes.autoUserLogin.userLoginId)?default(""))>
<#if username != "">
  <#assign focusName = false>
<#else>
  <#assign focusName = true>
</#if>

<div id="fullscreen_bg" class="fullscreen_bg"/>

<div class="container">
    <form class="form-signin" method="post" action="<@ofbizUrl>login</@ofbizUrl>" name="loginform">
        <img src="/images/img/easyofbiz.svg" style="width:300px;-moz-border-radius:4px 4px;-webkit-border-radius:4px 4px;border-radius:4px 4px;"></img>
        <input type="text" name="USERNAME" class="form-control" placeholder="Utilisateur" required="" autofocus="">
        <input type="password" name="PASSWORD" class="form-control" placeholder="Mot de passe" required="">
        <button class="btn btn-lg btn-primary btn-block" type="submit">Connexion</button>
        <a href="<@ofbizUrl>forgotPassword</@ofbizUrl>">Mot de passe oublié ?</a>
    </form>
</div>

<script language="JavaScript" type="text/javascript">
  document.loginform.JavaScriptEnabled.value = "Y";
  <#if focusName>
    document.loginform.USERNAME.focus();
  <#else>
    document.loginform.PASSWORD.focus();
  </#if>
</script>
