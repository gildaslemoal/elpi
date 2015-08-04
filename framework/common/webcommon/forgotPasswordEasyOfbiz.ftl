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
<div id="fullscreen_bg" class="fullscreen_bg"/>

<div class="container">
    <form class="form-signin" method="post" action="<@ofbizUrl>forgotPassword${previousParams?if_exists}</@ofbizUrl>" name="forgotpassword">
        <img src="/images/img/easyofbiz.svg" style="width:300px;-moz-border-radius:4px 4px;-webkit-border-radius:4px 4px;border-radius:4px 4px;"></img>
        <h2>${uiLabelMap.CommonForgotYourPassword}?</h2>
        <input type="text" name="USERNAME" class="form-control single-field" placeholder="${uiLabelMap.CommonUsername}" required="">
        <button class="btn btn-lg btn-primary btn-block" type="submit" name="GET_PASSWORD_HINT">${uiLabelMap.CommonGetPasswordHint}</button>
        <button class="btn btn-lg btn-primary btn-block" type="submit" name="EMAIL_PASSWORD">${uiLabelMap.CommonEmailPassword}</button>
        <h2><a href='<@ofbizUrl>authview</@ofbizUrl>' class="button">${uiLabelMap.CommonGoBack}</a></h2>
        <input type="hidden" name="JavaScriptEnabled" value="N"/>
    </form>
</div>
