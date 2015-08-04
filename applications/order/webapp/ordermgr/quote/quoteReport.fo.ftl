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

<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">

    <fo:layout-master-set>
        <fo:simple-page-master master-name="main-page"
              page-width="21.59cm" page-height="29.7cm"
              margin-top="1cm" margin-bottom="1.5cm"
              margin-left="1.5cm" margin-right="1cm">
            <#-- main body -->
            <fo:region-body margin-top="2.4cm" margin-bottom="1.6cm"/>
            <#-- the header -->
            <fo:region-before extent="1.5cm"/>
            <#-- the footer -->
            <fo:region-after extent="1.5cm"/>
        </fo:simple-page-master>
    </fo:layout-master-set>

    <fo:page-sequence master-reference="main-page">

        <#-- Header -->
        <#assign issueDate = Static["org.ofbiz.base.util.UtilDateTime"].timeStampToString(quote.get("issueDate"),'dd/MM/yyyy',timeZone,locale)>
        ${setContextField("reportTitle", uiLabelMap.OrderOrderQuote)}
        ${setContextField("reportId", quote.quoteId)}
        ${setContextField("reportDate", issueDate)}
        ${setContextField("headerLogoImageUrl", logoImageUrl!)}
        ${screens.render("component://common/widget/CommonScreens.xml#companyHeaderPDF")}

        <#-- Footer -->
        ${screens.render("component://common/widget/CommonScreens.xml#companyFooterPDF")}

        <#-- Body -->
        <fo:flow flow-name="xsl-region-body">

            <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-number="1" column-width="proportional-column-width(50)"/>
                <fo:table-column column-number="2" column-width="proportional-column-width(50)"/>
                <fo:table-body>
                    <fo:table-row height="4cm">
                          <fo:table-cell margin-left="5mm"  margin-top="5mm">
                              <fo:block space-after="15mm"/>
                              <#-- Display customer information -->
                              <fo:block>${uiLabelMap.PartyClient}: ${(quote.partyId.toString())?if_exists}</fo:block>
                              <#if quote.validThruDate?has_content>
                                  <#assign validThruDate = Static["org.ofbiz.base.util.UtilDateTime"].timeStampToString(quote.get("validThruDate"),'dd/MM/yyyy',timeZone,locale)>
                                  <fo:block>${uiLabelMap.CommonValidUntil}: ${validThruDate?if_exists}</fo:block>
                              </#if>
                          </fo:table-cell>
                          <fo:table-cell font-weight="bold" margin-left="5mm" font-size="0.4cm">
                              <fo:block space-after="10mm"/>
                              <#-- Display general address informations -->
                              <#if toPostalAddress?exists>
                                ${setContextField("address", toPostalAddress)}
                                ${screens.render("component://common/widget/CommonScreens.xml#commonAddressPDF")}
                              </#if>
                          </fo:table-cell>
                      </fo:table-row>

<#--
                      <fo:table-row>
                          <fo:table-cell>
                              <fo:block space-after="5mm"/>
                              <fo:block text-align="left" border="0.5pt solid black" margin="0.5cm" font-size="0.4cm" background-color="#EEEEEE">${uiLabelMap.OrderShippingAddress}</fo:block>
                          </fo:table-cell>
                          <fo:table-cell>
                              <fo:block space-after="5mm"/>
                              <fo:block text-align="left" border="0.5pt solid black" margin="0.5cm" font-size="0.4cm" background-color="#EEEEEE">${uiLabelMap.OrderBillingAddress}</fo:block>
                          </fo:table-cell>
                      </fo:table-row>
                      <fo:table-row>
                          <fo:table-cell margin-left="5mm" font-size="0.4cm">
                              <#if toPostalAddress?exists>
                                ${setContextField("address", toPostalAddress)}
                                ${screens.render("component://common/widget/CommonScreens.xml#commonAddressPDF")}
                              </#if>
                          </fo:table-cell>
                          <fo:table-cell margin-left="5mm" font-size="0.4cm">
                              <#if toPostalAddress?exists>
                                ${setContextField("address", toPostalAddress)}
                                ${screens.render("component://common/widget/CommonScreens.xml#commonAddressPDF")}
                              </#if>
                          </fo:table-cell>
                      </fo:table-row>
-->

                </fo:table-body>
            </fo:table>

            <fo:block space-after="5mm"/>

            <fo:block-container height="1cm" >
                <fo:block font-size="8pt">${uiLabelMap.QuotePresentation}</fo:block>
            </fo:block-container>

            <fo:block space-after="5mm"/>

            <#-- Display quote items informations -->
            <fo:table border="0.5pt solid black" font-size="10pt" border-right-color="grey" border-right-width="1mm" border-bottom-color="grey" border-bottom-width="1mm">
                <fo:table-column column-width="6%"/>
                <fo:table-column column-width="50%"/>
                <fo:table-column column-width="10%"/>
                <fo:table-column column-width="10%"/>
                <fo:table-column column-width="10%"/>
                <fo:table-column column-width="14%"/>
                <fo:table-header>
                    <fo:table-row display-align="center" text-align="center" font-weight="bold" font-size="0.3cm" background-color="#EEEEEE">
                        <fo:table-cell border="0.5pt solid black">
                            <fo:block></fo:block>
                        </fo:table-cell>
                        <fo:table-cell border="0.5pt solid black">
                            <fo:block>${uiLabelMap.ProductProductDescription}</fo:block>
                        </fo:table-cell>
                        <fo:table-cell border="0.5pt solid black">
                            <fo:block>${uiLabelMap.OrderQuantity}</fo:block>
                        </fo:table-cell>
                        <fo:table-cell border="0.5pt solid black">
                           <fo:block>${uiLabelMap.AccountingUnitPrice}</fo:block>
                        </fo:table-cell>
                        <fo:table-cell border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                            <fo:block>${uiLabelMap.OrderAdjustments}</fo:block>
                        </fo:table-cell>
                        <fo:table-cell border="0.5pt solid black">
                            <#assign currencyUomId = quote.currencyUomId?if_exists>
                            <fo:block>${uiLabelMap.AccountingTotalExclTax}</fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-header>
                <fo:table-body>
                    <#assign rowColor = "white">
                    <#assign totalQuoteAmount = 0.0>
                    <#list quoteItems as quoteItem>
                        <#if quoteItem.productId?exists>
                            <#assign product = quoteItem.getRelatedOne("Product", false)>
                        </#if>
                        <#assign quoteItemAmount = quoteItem.quoteUnitPrice?default(0) * quoteItem.quantity?default(0)>
                        <#assign quoteItemAdjustments = quoteItem.getRelated("QuoteAdjustment", null, null, false)>
                        <#assign totalQuoteItemAdjustmentAmount = 0.0>
                        <#list quoteItemAdjustments as quoteItemAdjustment>
                            <#assign totalQuoteItemAdjustmentAmount = quoteItemAdjustment.amount?default(0) + totalQuoteItemAdjustmentAmount>
                        </#list>
                        <#assign totalQuoteItemAmount = quoteItemAmount + totalQuoteItemAdjustmentAmount>
                        <#assign totalQuoteAmount = totalQuoteAmount + totalQuoteItemAmount>

                        <fo:table-row>
                            <fo:table-cell padding="2pt" background-color="${rowColor}" border="0.5pt solid black">
                                <fo:block>${quoteItem.quoteItemSeqId}</fo:block>
                            </fo:table-cell>
                            <fo:table-cell padding="2pt" background-color="${rowColor}" border="0.5pt solid black">
                                <fo:block>${(product.internalName)?if_exists} [${quoteItem.productId?if_exists}]</fo:block>
                            </fo:table-cell>
                            <fo:table-cell padding="2pt" background-color="${rowColor}" border="0.5pt solid black">
                                <fo:block text-align="center">${quoteItem.quantity?if_exists}</fo:block>
                            </fo:table-cell>
                            <fo:table-cell padding="2pt" background-color="${rowColor}" border="0.5pt solid black">
                                <fo:block text-align="right"><@ofbizCurrency amount=quoteItem.quoteUnitPrice isoCode=quote.currencyUomId/></fo:block>
                            </fo:table-cell>
                            <fo:table-cell padding="2pt" background-color="${rowColor}" border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                <fo:block text-align="right"><@ofbizCurrency amount=totalQuoteItemAdjustmentAmount isoCode=quote.currencyUomId/></fo:block>
                            </fo:table-cell>
                            <fo:table-cell padding="2pt" background-color="${rowColor}" border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                <fo:block text-align="right"><@ofbizCurrency amount=totalQuoteItemAmount isoCode=quote.currencyUomId/></fo:block>
                            </fo:table-cell>

                        </fo:table-row>

                        <#list quoteItemAdjustments as quoteItemAdjustment>
                            <#assign adjustmentType = quoteItemAdjustment.getRelatedOne("OrderAdjustmentType", false)>
                            <fo:table-row>
                                <fo:table-cell padding="2pt" background-color="${rowColor}">
                                </fo:table-cell>
                                <fo:table-cell padding="2pt" background-color="${rowColor}">
                                </fo:table-cell>
                                <fo:table-cell padding="2pt" background-color="${rowColor}">
                                </fo:table-cell>
                                <fo:table-cell padding="2pt" background-color="${rowColor}">
                                </fo:table-cell>
                                <fo:table-cell padding="2pt" background-color="${rowColor}">
                                    <fo:block font-size="7pt" text-align="right">${adjustmentType.get("description",locale)?if_exists}</fo:block>
                                </fo:table-cell>
                                <fo:table-cell padding="2pt" background-color="${rowColor}">
                                    <fo:block font-size="7pt" text-align="right"><@ofbizCurrency amount=quoteItemAdjustment.amount isoCode=quote.currencyUomId/></fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </#list>

                        <#if rowColor == "white">
                            <#assign rowColor = "#D4D0C8">
                        <#else>
                            <#assign rowColor = "white">
                        </#if>
                    </#list>
                </fo:table-body>
            </fo:table>

            <fo:block space-after="5mm"/>

            <fo:table font-size="10pt">
                <fo:table-column column-width="50%"/>
                <fo:table-column column-width="50%"/>
                <fo:table-body>
                    <fo:table-row>
                        <fo:table-cell>
                            <#-- Quote Terms -->
                            <#--
                            <#if quoteTerms?exists?has_content && quoteTerms.size() gt 0>
                                <fo:block text-align="left" border="0.5pt solid black"  font-size="0.4cm" background-color="#EEEEEE">${uiLabelMap.OrderOrderEntryOrderTerms}</fo:block>
                                <fo:block font-size="0.3cm">
                                <#list quoteTerms as quoteTerm>
                                    <#assign termDescription = quoteTerm.description!>
                                    ${termDescription?default("")} 
                                    <#if quoteTerm.termDays?has_content><#if quoteTerm.termDays = 0 > au comptant <#else>${quoteTerm.description?default("")} &#224; ${quoteTerm.termDays?default("")} ${uiLabelMap.CommonDays} </#if></#if> ${quoteTerm.textValue?default("")}.
                                </#list>
                                </fo:block>
                            </#if>
                            -->
                            <fo:block text-align="left" border="0.5pt solid black"  font-size="0.4cm" background-color="#EEEEEE">${uiLabelMap.OrderOrderEntryOrderTerms}</fo:block>
                            <fo:block font-size="0.3cm">
                            ${uiLabelMap.QuoteTerm1}
                            <#list quoteTerms as quoteTerm>
                                <#assign termDescription = quoteTerm.description!>
                                ${termDescription?default("")} 
                                <#if quoteTerm.termDays?has_content><#if quoteTerm.termDays = 0 > au comptant <#else>${quoteTerm.description?default("")} &#224; ${quoteTerm.termDays?default("")} ${uiLabelMap.CommonDays} </#if></#if> ${quoteTerm.textValue?default("")}.
                            </#list>
                            </fo:block>

                            <#if eftAccount?exists>
                                <fo:block-container font-weight="bold">
                                  <#-- Display eft account informations -->
                                  <fo:block space-after="5mm"/>
                                  <fo:block font-size="9pt">${uiLabelMap.AccountingBankName}: ${(eftAccount.bankName.toString())?if_exists}</fo:block>
                                  <fo:block font-size="9pt">${uiLabelMap.AccountingBIC}: ${(eftAccount.routingNumber.toString())?if_exists}</fo:block>
                                  <fo:block font-size="9pt">${uiLabelMap.AccountingIBAN}: ${(eftAccount.accountNumber.toString())?if_exists}</fo:block>
                                </fo:block-container>
                            </#if>
                        </fo:table-cell>

                        <fo:table-cell margin-left="5mm">
                            <#-- Display total informations -->
                            <fo:table font-size="10pt" font-weight="bold" text-align="right" display-align="center" border-bottom-color="grey" border-bottom-width="1mm">
                                  <fo:table-column column-width="70%"/>
                                  <fo:table-column column-width="30%"/>
                                  <fo:table-column column-width="0%"/>
                                <fo:table-body>
                                    <fo:table-row>
                                        <fo:table-cell border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                            <fo:block >${uiLabelMap.CommonSubtotal?string?upper_case}</fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                            <fo:block><@ofbizCurrency amount=totalQuoteAmount isoCode=quote.currencyUomId/></fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell/>
                                    </fo:table-row>

                                    <#assign totalQuoteHeaderAdjustmentAmount = 0.0>
                                    <#list quoteAdjustments as quoteAdjustment>
                                       <#assign adjustmentType = quoteAdjustment.getRelatedOne("OrderAdjustmentType", false)>
                                       <#if !quoteAdjustment.quoteItemSeqId?exists>
                                           <#assign totalQuoteHeaderAdjustmentAmount = quoteAdjustment.amount?default(0) + totalQuoteHeaderAdjustmentAmount>
                                       <fo:table-row>
                                           <fo:table-cell border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                               <fo:block >${adjustmentType.get("description", locale)?if_exists?string?upper_case}</fo:block>
                                           </fo:table-cell>
                                           <fo:table-cell border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                               <fo:block><@ofbizCurrency amount=quoteAdjustment.amount isoCode=quote.currencyUomId/></fo:block>
                                           </fo:table-cell>
                                           <fo:table-cell/>
                                       </fo:table-row>
                                       </#if>
                                    </#list>

                                    <#assign grandTotalQuoteAmount = totalQuoteAmount + totalQuoteHeaderAdjustmentAmount>
                                    <fo:table-row>
                                        <fo:table-cell border="0.5pt solid black" border-right-color="grey" border-right-width="1mm"><fo:block/></fo:table-cell>
                                        <fo:table-cell border="0.5pt solid black" border-right-color="grey" border-right-width="1mm"><fo:block/></fo:table-cell>
                                        <fo:table-cell/>
                                    </fo:table-row>

                                    <fo:table-row font-size="12pt">
                                        <fo:table-cell border="0.5pt solid black" border-right-color="grey" border-right-width="1mm" background-color="#EEEEEE">
                                            <fo:block>${uiLabelMap.OrderGrandTotal?string?upper_case}</fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                            <fo:block><@ofbizCurrency amount=grandTotalQuoteAmount isoCode=quote.currencyUomId/></fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell/>
                                    </fo:table-row>
                                </fo:table-body>
                            </fo:table>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>

            <fo:block space-after="5mm"/>

            <#-- Quote conditions-->
            <fo:block-container height="4cm" text-align="center">
                <fo:block font-size="8pt" font-weight="bold" space-after="2mm">${uiLabelMap.QuoteConditions1}</fo:block>
                <fo:block font-size="8pt" font-weight="bold" color="red" space-after="2mm">${uiLabelMap.QuoteConditions2}</fo:block>
                <fo:block font-size="8pt" font-weight="bold">${uiLabelMap.QuoteConditions3}</fo:block>
            </fo:block-container>

            <fo:block space-after="5mm"/>

            <#-- Quote notes -->
            <#if quoteNotes?has_content>
                <#list quoteNotes as note>
                    <fo:block margin-left="20mm" font-size="0.3cm" text-align="left" >${note.noteInfo?if_exists}</fo:block>
                </#list>
            </#if>

            <fo:block space-after="5mm"/>

            <fo:block-container height="1cm" font-size="7pt">
                <fo:block>${uiLabelMap.QuoteWarranty1}</fo:block>
                <fo:block>${uiLabelMap.QuoteWarranty2}</fo:block>
                <fo:block>${uiLabelMap.QuoteWarranty3}</fo:block>
                <fo:block font-size="7pt" space-before="3mm"><fo:inline text-decoration="underline"  font-weight="bold" color="red">${uiLabelMap.QuoteWarrantyWarning}</fo:inline> <fo:inline font-weight="bold">${uiLabelMap.QuoteWarranty4}</fo:inline></fo:block>
            </fo:block-container>

            <fo:block id="theEnd"/>

        </fo:flow>
    </fo:page-sequence>
</fo:root>

</#escape>
