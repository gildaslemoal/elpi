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
            <h3>${uiLabelMap.FrontEndResetPassword}</h3>
            <div class="ruler"></div>
            <form method="post" action="<@ofbizUrl>requestPasswordResetLink</@ofbizUrl>" name="forgotpasswordform" class="horizontal">
                <div class="form-group">
                    <label for="emailAddress">${uiLabelMap.CommonEmail}</label>
                    <input type="email" class="form-control" id="emailAddress" name="emailAddress" placeholder="${uiLabelMap.FrontEndYourEmail}">
                </div>
                <button type="submit" class="btn btn-default" id="resetPasswordBtn" name="EMAIL_PASSWORD" value="${uiLabelMap.CommonEmailPassword}">${uiLabelMap.ProductSubmit}</button>
            </form>
        </div>
    </div>
<script language="JavaScript" type="text/javascript">
  <#if autoUserLogin?has_content>document.loginform.PASSWORD.focus();</#if>
  <#if !autoUserLogin?has_content>document.loginform.USERNAME.focus();</#if>
</script>
