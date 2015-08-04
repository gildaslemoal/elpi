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
<#escape x as x?xml>
        <fo:static-content flow-name="xsl-region-after" font-size="${(layoutSettings.footerFontSize)?default("8pt")}">

            <fo:block-container border-before-style="solid" border-before-color="black" border-before-width="1" height="1.2cm">

            <#--#Bam# 24243-report -->
                <fo:table table-layout="fixed" width="100%">
                    <fo:table-body>
                        <fo:table-row>
                           <fo:table-cell>
                              <fo:block font-size="7pt" text-align="left" margin-top="1.2mm">
                                  <fo:block space-before="-1mm">
                                      <fo:inline font-weight="bold">${companyName?if_exists}</fo:inline> <#if postalAddress?has_content>- ${postalAddress.address1?if_exists}<#if postalAddress.address2?has_content> - ${postalAddress.address2?if_exists}</#if> - ${postalAddress.postalCode?if_exists} ${postalAddress.city?if_exists} </#if>- ${countryName?if_exists}
                                      <#if phone?exists> - ${uiLabelMap.CommonTelephoneAbbr}: <#if phone.countryCode?exists>${phone.countryCode}-</#if><#if phone.areaCode?exists>${phone.areaCode}-</#if>${phone.contactNumber?if_exists}</#if>
                                      <#if fax?exists> - ${uiLabelMap.CommonFaxAbbr}: <#if fax.countryCode?exists>${fax.countryCode}-</#if><#if fax.areaCode?exists>${fax.areaCode}-</#if>${fax.contactNumber?if_exists}</#if>
                                      <#if email?exists> - ${uiLabelMap.CommonEmail}: <fo:inline text-decoration="underline">${email.infoString?if_exists}</fo:inline></#if>
                                      <#if website?exists> - ${uiLabelMap.CommonWebsite}: <fo:inline text-decoration="underline">${website.infoString?if_exists}</fo:inline></#if>
                                  </fo:block>
                              </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row>
                           <fo:table-cell>
                              <fo:block font-size="7pt" text-align="left" margin-top="1.2mm">
                                  <#if siretValue?exists>${uiLabelMap.SIRETnumber}: ${siretValue?if_exists}</#if>
                                  <#if rcsValue?exists> - ${uiLabelMap.CommonRcsNumber}: ${rcsValue?if_exists}</#if>
                                  <#if tvaValue?exists> - ${uiLabelMap.CommonTaxNumber}: ${tvaValue?if_exists}</#if>
                              </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            <#--#Eam# 24243-report -->

                <fo:block text-align="center" font-size="8pt">
                    <fo:page-number/> / <fo:page-number-citation ref-id="theEnd"/>
                </fo:block>
            </fo:block-container>

        </fo:static-content>
</#escape>
