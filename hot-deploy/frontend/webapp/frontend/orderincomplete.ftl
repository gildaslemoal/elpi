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

    <div style="height:40px"></div>
    <div class="row">
        <div class="order-incomplete-title text-center">
            <span class="smiley-sad">:(</span><span> ${uiLabelMap.FrontEndOups}</span>
        </div>
    </div>
    <div class="row">
        <div class="panel panel-default">
            <div class="panel-heading text-center">
                <h2>${uiLabelMap.FrontEndPaiementError}</h2>
            </div>
            <div class="panel-body">
                <div class="order-incomplete text-center">
                    <div>
                        <i class="fa fa-shopping-cart fa-4x"></i>
                        <i class="fa fa-circle point"></i>
                        <i class="fa fa-circle point"></i>
                        <i class="fa fa-circle point"></i>
                        <i class="fa fa-clock-o fa-4x"></i>
                    </div>
                    <div>
                        <h2> ${uiLabelMap.FrontEndErrorApologizes}</h2>
                        <h2> ${uiLabelMap.FrontEndOrderValidatedWhenProblemSolved}</h2>
                    </div>
                </div>
            </div>
            <div class="panel-footer">
                <h4>${uiLabelMap.FrontEndEmailSendWhenProblemSolved}</h4>
                <h4>${uiLabelMap.FrontEndNoteYourOrderNumber} : <#if orderHeader?has_content>${orderHeader.orderId}</#if></h4>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-offset-2 ">
            <img src="<@ofbizContentUrl>/frontend/images/background_email.jpg</@ofbizContentUrl>">
        </div>
    </div>

