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

    <fo:static-content flow-name="xsl-region-before">

        <fo:table table-layout="fixed" width="100%">
            <fo:table-column column-number="1" column-width="proportional-column-width(50)"/>
            <fo:table-column column-number="2" column-width="proportional-column-width(50)"/>
            <fo:table-body>
                <fo:table-row>
                        <#-- Header Left section -->
                        <fo:table-cell>
                            <fo:table>
                                  <fo:table-column column-width="50%"/>
                                  <fo:table-column column-width="50%"/>
                                  <fo:table-body>
                                      <fo:table-row>
                                          <fo:table-cell column-spanned="2">
                                              <fo:block text-align="left" margin-top="0mm">
                                                  <#if headerLogoImageUrl?has_content><fo:external-graphic src="<@ofbizContentUrl>${headerLogoImageUrl}</@ofbizContentUrl>" overflow="hidden" width="7.0cm" content-height="scale-to-fit"/></#if>
                                              </fo:block>
                                          </fo:table-cell>
                                      </fo:table-row>
                                </fo:table-body>
                            </fo:table>
                        </fo:table-cell>
                        <#-- Header right section -->
                        <fo:table-cell>
                            <fo:table>
                                <fo:table-column column-width="100%"/>
                                <fo:table-body>
                                    <fo:table-row>
                                        <fo:table-cell>
                                        <fo:block space-after="3mm"/>
                                           <fo:block font-size="0.75cm" font-weight="bold" margin-right="10mm" text-align="center">${reportTitle?string?upper_case}</fo:block>
                                        </fo:table-cell>
                                    </fo:table-row>

                                    <fo:table-row>
                                        <fo:table-cell>
                                            <fo:block font-size="0.4cm" font-weight="bold" margin-left="5mm" margin-right="10mm" text-align="left" margin-top="5mm">${uiLabelMap.CommonNbr} ${reportId?if_exists} ${uiLabelMap.CommonFromTheDate} ${reportDate?if_exists}</fo:block>
                                        </fo:table-cell>
                                    </fo:table-row>
                                </fo:table-body>
                              </fo:table>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>

    </fo:static-content>
</#escape>
