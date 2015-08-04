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

<#assign username = requestParameters.USERNAME?default((sessionAttributes.autoUserLogin.userLoginId)?default(""))>
<#assign tenantId = requestParameters.tenantId!>

<div id="fullscreen_bg" class="fullscreen_bg"/>

<div class="container">
    <form class="form-signin" method="post" action="<@ofbizUrl>login</@ofbizUrl>" name="loginform">
        <input type="hidden" name="requirePasswordChange" value="Y"/>
        <input type="hidden" name="USERNAME" value="${username}"/>
        <input type="hidden" name="tenantId" value="${tenantId!}"/>
        <img src="/images/img/easyofbiz.svg" style="width:300px;-moz-border-radius:4px 4px;-webkit-border-radius:4px 4px;border-radius:4px 4px;"></img>
        <h1>${username}</h1>
        <input type="password" name="PASSWORD" class="form-control currentPassword" placeholder="${uiLabelMap.CommonCurrentPassword}" required="">
        <input type="password" name="newPassword" class="form-control newPassword" placeholder="${uiLabelMap.CommonNewPassword}" required="">
        <input type="password" name="newPasswordVerify" class="form-control" placeholder="${uiLabelMap.CommonNewPasswordVerify}" required="">
        <button class="btn btn-lg btn-primary btn-block" type="submit">${uiLabelMap.CommonSubmit}</button>
    </form>
</div>


<script language="JavaScript" type="text/javascript">
  document.loginform.PASSWORD.focus();
</script>
