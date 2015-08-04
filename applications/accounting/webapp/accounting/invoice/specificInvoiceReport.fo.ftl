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
            <#--
             <fo:region-after extent="1.5cm"/>
            -->
            <#if invoice?has_content && invoice.invoiceTypeId == "SALES_INVOICE">
                <fo:region-after extent="3.5cm"/>
            <#else>
                <fo:region-after extent="1.5cm"/>
            </#if>
        </fo:simple-page-master>
    </fo:layout-master-set>

    <fo:page-sequence master-reference="main-page">

        <#-- Header -->
        <#assign issueDate = Static["org.ofbiz.base.util.UtilDateTime"].timeStampToString(invoice.get("invoiceDate"),'dd/MM/yyyy',timeZone,locale)>
        ${setContextField("reportTitle", uiLabelMap.AccountingInvoiceCapitals)}
        ${setContextField("reportId", invoice.invoiceId)}
        ${setContextField("reportDate", issueDate)}
        ${setContextField("headerLogoImageUrl", logoImageUrl!)}
        ${screens.render("component://common/widget/CommonScreens.xml#companyHeaderPDF")}

        <#-- Footer -->
        <#--
         ${screens.render("component://common/widget/CommonScreens.xml#companyFooterPDF")}
        -->
        <fo:static-content flow-name="xsl-region-after" font-size="${(layoutSettings.footerFontSize)?default("8pt")}">

            <#if invoice?has_content && invoice.invoiceTypeId == "SALES_INVOICE">
                <#assign totalInvoiceAmount = 0.0>
                <#list invoiceItems as invoiceItem>
                    <#assign invoiceItemAmount = invoiceItem.quantity?default(0) * invoiceItem.amount?default(0)>
                    <#assign invoiceItemAdjustments = delegator.findByAnd("OrderAdjustmentBilling", Static["org.ofbiz.base.util.UtilMisc"].toMap("invoiceId", invoice.invoiceId,"invoiceItemSeqId",invoice.invoiceItemSeqId))>
                    <#assign totalInvoiceItemAdjustmentsAmount = 0.0>
                    <#if invoiceItem.invoiceItemTypeId != "ITM_SALES_TAX">
                        <#list invoiceItemAdjustments as invoiceItemAdjustment>
                            <#assign totalInvoiceItemAdjustmentsAmount = invoiceItemAdjustment.amount?default(0) + totalInvoiceItemAdjustmentsAmount>
                        </#list>
                    </#if>
                    <#assign totalInvoiceItemAmount = invoiceItemAmount + totalInvoiceItemAdjustmentsAmount>
                    <#assign totalInvoiceAmount = totalInvoiceAmount + totalInvoiceItemAmount>
                </#list>
                <#assign totalInvoiceHeaderAdjustmentAmount = 0.0>
                <#assign orderAdjustmentBillings = delegator.findByAnd("OrderAdjustmentBilling", Static["org.ofbiz.base.util.UtilMisc"].toMap("invoiceId", invoice.invoiceId))>
                <#list orderAdjustmentBillings as orderAdjustmentBilling>
                   <#assign invoiceAdjustment = orderAdjustmentBilling.getRelatedOne("OrderAdjustment", false)>
                   <#assign adjustmentType = invoiceAdjustment.getRelatedOne("OrderAdjustmentType", false)>
                   <#if !orderAdjustmentBilling.invoiceItemSeqId?exists>
                       <#assign totalInvoiceHeaderAdjustmentAmount = invoiceAdjustment.amount?default(0) + totalInvoiceHeaderAdjustmentAmount>
                   </#if>
                </#list>
                <#assign grandTotalInvoiceAmount = totalInvoiceAmount + totalInvoiceHeaderAdjustmentAmount>
                <#assign grandTotalInvoiceAmount = grandTotalInvoiceAmount.setScale(2,2)>

                <fo:block font-size="8pt" text-align="center">
                    <fo:block space-before="-1mm">
                        <fo:inline font-weight="bold">${companyName?if_exists}</fo:inline> <#if postalAddress?has_content>- ${postalAddress.address1?if_exists}<#if postalAddress.address2?has_content> - ${postalAddress.address2?if_exists}</#if> - ${postalAddress.postalCode?if_exists} ${postalAddress.city?if_exists} </#if>- ${countryName?if_exists}
                    </fo:block>
                    <fo:block>
                        <#if phone?exists>${uiLabelMap.CommonTelephoneAbbr}: <#if phone.countryCode?exists>${phone.countryCode}-</#if><#if phone.areaCode?exists>${phone.areaCode}-</#if>${phone.contactNumber?if_exists}</#if>
                        <#if fax?exists>- ${uiLabelMap.CommonFaxAbbr}: <#if fax.countryCode?exists>${fax.countryCode}-</#if><#if fax.areaCode?exists>${fax.areaCode}-</#if>${fax.contactNumber?if_exists}</#if>
                        <#if email?exists>- ${uiLabelMap.CommonEmail}: <fo:inline text-decoration="underline">${email.infoString?if_exists}</fo:inline></#if>
                        <#if website?exists>- ${uiLabelMap.CommonWebsite}: <fo:inline text-decoration="underline">${website.infoString?if_exists}</fo:inline></#if>
                    </fo:block>
                    <fo:block>
                        <#if rcsValue?exists>${uiLabelMap.CommonRcsNumber}: ${rcsValue?if_exists}</#if>
                        <#if tvaValue?exists>- ${uiLabelMap.CommonTaxNumber}: ${tvaValue?if_exists}</#if>
                    </fo:block>
                </fo:block>
                <fo:block space-after="10mm"/>

                <fo:table>
                    <fo:table-column column-width="60%"/>
                    <fo:table-column column-width="20%"/>
                    <fo:table-column column-width="20%"/>
                    <fo:table-body>
                        <fo:table-row font-size="12pt">
                            <fo:table-cell>

                            <fo:block-container width="11cm" border-style="dashed" margin-left="-1.6cm" padding-top="0.5cm" padding-bottom="0.5cm" padding-right="0.5cm" keep-together.within-page="always" >
                                <fo:block font-size="8pt" margin-top="-0.9cm" space-after="5mm" margin-left="3cm">${uiLabelMap.InvoiceCoupon}</fo:block>
                                <fo:table font-size="9pt" margin-left="2.4cm">
                                    <fo:table-column column-width="50%"/>
                                    <fo:table-column column-width="50%"/>
                                    <fo:table-body>
                                        <fo:table-row font-size="12pt">
                                            <fo:table-cell>
                                                <fo:block>${uiLabelMap.OrderCustomer?string?upper_case}</fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell>
                                                <fo:block text-align="right">${invoice.partyId!}</fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>
                                        <fo:table-row font-size="12pt">
                                            <fo:table-cell>
                                                <fo:block>${uiLabelMap.AccountingInvoiceCapitals?string?upper_case}</fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell>
                                                <fo:block text-align="right">${invoice.invoiceId!}</fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>
                                        <fo:table-row font-size="12pt">
                                            <fo:table-cell>
                                                <fo:block>${uiLabelMap.AccountingInvoiceDate?string?upper_case}</fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell>
                                                <fo:block text-align="right">${issueDate?if_exists}</fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>
                                        <fo:table-row font-size="12pt">
                                            <fo:table-cell>
                                                <fo:block>${uiLabelMap.OrderTotal?string?upper_case}</fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell>
                                                <fo:block text-align="right"><@ofbizCurrency amount=grandTotalInvoiceAmount isoCode=invoice.currencyUomId/></fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>
                                    </fo:table-body>
                                </fo:table>
                            </fo:block-container>

                       </fo:table-cell>
                       <fo:table-cell>
                           <fo:block space-after="0.80mm"/>
                                <fo:block>
                                    <fo:external-graphic src="/images/report/Logo-Synafel-small.jpg" overflow="hidden" height="1.5cm" content-height="scale-to-fit"/>
                                </fo:block>
                       </fo:table-cell>
                       <fo:table-cell>
                            <fo:block>
                                <fo:external-graphic src="/images/report/Logo-ESF-small.jpg" overflow="hidden" height="1.5cm" content-height="scale-to-fit"/>
                            </fo:block>
                       </fo:table-cell>
                   </fo:table-row>
               </fo:table-body>
            </fo:table>

            <#else>
                <fo:block-container border-before-style="solid" border-before-color="black" border-before-width="1" height="1.2cm">

                <fo:table table-layout="fixed" width="100%">
                    <fo:table-column column-width="3.5cm"/>
                    <fo:table-column column-width="13cm"/>
                    <fo:table-column column-width="3.5cm"/>
                    <fo:table-body>
                        <fo:table-row>
                            <fo:table-cell>
                                <fo:block space-after="0.80mm"/>
                                <fo:block>
                                    <fo:external-graphic src="/images/report/Logo-Synafel-small.jpg" overflow="hidden" height="1.5cm" content-height="scale-to-fit"/>
                                </fo:block>
                            </fo:table-cell>
                           <fo:table-cell>
                                <fo:block font-size="10pt" text-align="center" margin-top="1.2mm">
                                    <fo:block font-size="9pt" space-before="-1mm">
                                        <fo:inline font-weight="bold">${companyName?if_exists}</fo:inline> <#if postalAddress?has_content>- ${postalAddress.address1?if_exists}<#if postalAddress.address2?has_content> - ${postalAddress.address2?if_exists}</#if> - ${postalAddress.postalCode?if_exists} ${postalAddress.city?if_exists} </#if>- ${countryName?if_exists}
                                    </fo:block>
                                    <fo:block font-size="9pt" >
                                        <#if phone?exists>${uiLabelMap.CommonTelephoneAbbr}: <#if phone.countryCode?exists>${phone.countryCode}-</#if><#if phone.areaCode?exists>${phone.areaCode}-</#if>${phone.contactNumber?if_exists}</#if>
                                        <#if fax?exists>- ${uiLabelMap.CommonFaxAbbr}: <#if fax.countryCode?exists>${fax.countryCode}-</#if><#if fax.areaCode?exists>${fax.areaCode}-</#if>${fax.contactNumber?if_exists}</#if>
                                        <#if email?exists>- ${uiLabelMap.CommonEmail}: <fo:inline text-decoration="underline">${email.infoString?if_exists}</fo:inline></#if>
                                        <#if website?exists>- ${uiLabelMap.CommonWebsite}: <fo:inline text-decoration="underline">${website.infoString?if_exists}</fo:inline></#if>
                                    </fo:block>
                                    <fo:block font-size="9pt" >
                                        <#if rcsValue?exists>${uiLabelMap.CommonRcsNumber}: ${rcsValue?if_exists}</#if>
                                        <#if tvaValue?exists>- ${uiLabelMap.CommonTaxNumber}: ${tvaValue?if_exists}</#if>
                                    </fo:block>
                                </fo:block>

                            </fo:table-cell>
                            <fo:table-cell>
                                 <fo:block >
                                      <fo:external-graphic src="/images/report/Logo-ESF-small.jpg" overflow="hidden" height="1.5cm" content-height="scale-to-fit"/>
                                 </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>

                <fo:block text-align="center" font-size="8pt">
                    <fo:page-number/> / <fo:page-number-citation ref-id="theEnd"/>
                </fo:block>
            </fo:block-container>
            </#if>

        </fo:static-content>

        <#-- Body -->
        <fo:flow flow-name="xsl-region-body">

                <#-- Invoice informations-->
                <fo:table table-layout="fixed" width="100%">
                    <fo:table-column column-number="1" column-width="proportional-column-width(50)"/>
                    <fo:table-column column-number="2" column-width="proportional-column-width(50)"/>
                    <fo:table-body>
                      <#--
                       <fo:table-row>
                      -->
                      <fo:table-row height="5.5cm">
                          <fo:table-cell margin-left="5mm"   margin-top="5mm">
                              <fo:block space-after="15mm"/>
                              <#-- Display invoice informations -->
                              <#if shipments?has_content>
                                  <#list shipments as shipmentId>
                                      <#assign shipment = delegator.findByPrimaryKey("Shipment",{"shipmentId":shipmentId})>
                                      <#if shipment?has_content && shipment.estimatedShipDate?has_content>
                                          <#assign shipmentDate = Static["org.ofbiz.base.util.UtilDateTime"].timeStampToString(shipment.estimatedShipDate,'dd/MM/yyyy',timeZone,locale)>
                                      </#if>
                                      <fo:block>${uiLabelMap.AccountingShipmentNrAbbr} ${shipmentId}</fo:block>
                                      <fo:block>${uiLabelMap.AccountingShipmentDate}: ${shipmentDate?if_exists}</fo:block>
                                  </#list>
                              </#if>
                              <#if orders?has_content>
                                  <#list orders as orderId>
                                      <#assign orderHeader = delegator.findByPrimaryKey("OrderHeader",{"orderId":orderId})>
                                      <#if orderHeader?has_content>
                                          <#assign orderDate = Static["org.ofbiz.base.util.UtilDateTime"].timeStampToString(orderHeader.orderDate,'dd/MM/yyyy',timeZone,locale)>
                                      </#if>
                                      <fo:block>${uiLabelMap.AccountingOrderNrAbbr} ${orderId}</fo:block>
                                      <fo:block>${uiLabelMap.AccountingOrderDate}: ${orderDate?if_exists}</fo:block>
                                      <fo:block>${orderHeader.orderName?if_exists}</fo:block>
                                  </#list>
                              </#if>
                              <fo:block>${uiLabelMap.OrderCustomer}: ${invoice.partyId!}</fo:block>
                          </fo:table-cell>
                          <fo:table-cell font-weight="bold" margin-left="5mm" font-size="0.4cm">
                              <fo:block space-after="10mm"/>
                              <#-- Display billing address informations -->
                              <#if billingAddress?has_content>
                                  ${setContextField("address", billingAddress)}
                              <#else>
                                  <fo:block>${uiLabelMap.CommonAddressNotFound}</fo:block>
                              </#if>
                              ${screens.render("component://common/widget/CommonScreens.xml#commonAddressPDF")}
                          </fo:table-cell>
                      </fo:table-row>

                      <fo:table-row>
                          <fo:table-cell>
                              <fo:block space-after="5mm"/>
                              <#if originAddress?has_content>
                              <fo:block text-align="left" border="0.5pt solid black" margin="0.5cm" font-size="0.4cm" background-color="#EEEEEE">${uiLabelMap.AccountingInvoicePartyFrom}</fo:block>
                              </#if>
                          </fo:table-cell>
                          <fo:table-cell>
                              <fo:block space-after="5mm"/>
                              <#if deliveryAddress?has_content>
                              <fo:block text-align="left" border="0.5pt solid black" margin="0.5cm" font-size="0.4cm" background-color="#EEEEEE">${uiLabelMap.AccountingInvoicePartyTo}</fo:block>
                              </#if>
                          </fo:table-cell>
                      </fo:table-row>
                      <fo:table-row>
                          <fo:table-cell margin-left="5mm">
                              <#-- Display from party address informations -->
                              <#if originAddress?has_content>
                                  ${setContextField("address", originAddress)}
                                  ${screens.render("component://common/widget/CommonScreens.xml#commonAddressPDF")}
                              <#else>
                                  <fo:block></fo:block>
                              </#if>
                          </fo:table-cell>
                          <fo:table-cell margin-left="5mm">
                              <#-- Display delivery address informations -->
                              <#if deliveryAddress?has_content>
                                  ${setContextField("address", deliveryAddress)}
                                  ${screens.render("component://common/widget/CommonScreens.xml#commonAddressPDF")}
                              <#else>
                                  <fo:block></fo:block>
                              </#if>
                          </fo:table-cell>
                      </fo:table-row>

                     </fo:table-body>
                  </fo:table>

                  <fo:block space-after="5mm"/>

                  <#-- Display invoice item informations -->
                  <#if invoiceItems?has_content>
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
                                      <#assign currencyUomId = invoice.currencyUomId?if_exists>
                                      <fo:block>${uiLabelMap.AccountingTotalExclTax}</fo:block>
                                  </fo:table-cell>
                              </fo:table-row>
                          </fo:table-header>
                          <fo:table-body>
                              <#assign rowColor = "white">
                              <#assign totalInvoiceAmount = 0.0>
                              <#list invoiceItems as invoiceItem>
                                  <#assign uom = invoice.currencyUomId>
                                  <#if invoiceItem.productId?has_content>
                                      <#assign product = delegator.findByPrimaryKey("Product", Static["org.ofbiz.base.util.UtilMisc"].toMap("productId", invoiceItem.productId))>
                                      <#assign productName = product.get("internalName",locale)?if_exists>
                                      <#assign quantityUomId = product.get("quantityUomId")?if_exists>
                                  </#if>
                                  <#if invoiceItem.description?has_content>
                                      <#assign description=invoiceItem.description>
                                  <#elseif invoiceItem.taxAuthorityRateSeqId?has_content>
                                      <#assign taxRate = delegator.findByPrimaryKey("TaxAuthorityRateProduct", Static["org.ofbiz.base.util.UtilMisc"].toMap("taxAuthorityRateSeqId", invoiceItem.taxAuthorityRateSeqId))>
                                      <#assign description=taxRate.get("description",locale)>
                                  <#elseif invoiceItem.invoiceItemTypeId?has_content>
                                      <#assign itemType = delegator.findByPrimaryKey("InvoiceItemType", Static["org.ofbiz.base.util.UtilMisc"].toMap("invoiceItemTypeId", invoiceItem.invoiceItemTypeId))>
                                      <#assign description=itemType.get("description",locale)>
                                  </#if>
                                  <#assign invoiceItemAmount = invoiceItem.quantity?default(0) * invoiceItem.amount?default(0)>
                                  <#assign invoiceItemAdjustments = delegator.findByAnd("OrderAdjustmentBilling", Static["org.ofbiz.base.util.UtilMisc"].toMap("invoiceId", invoice.invoiceId,"invoiceItemSeqId",invoice.invoiceItemSeqId))>
                                  <#assign totalInvoiceItemAdjustmentsAmount = 0.0>
                                  <#list invoiceItemAdjustments as invoiceItemAdjustment>
                                      <#assign totalInvoiceItemAdjustmentsAmount = invoiceItemAdjustment.amount?default(0) + totalInvoiceItemAdjustmentsAmount>
                                  </#list>
                                  <#assign totalInvoiceItemAmount = invoiceItemAmount + totalInvoiceItemAdjustmentsAmount>
                                  <#assign totalInvoiceAmount = totalInvoiceAmount + totalInvoiceItemAmount>

                                  <#if invoiceItem.invoiceItemTypeId != "ITM_SALES_TAX">
                                      <fo:table-row>
                                          <fo:table-cell padding="2pt" background-color="${rowColor}" border="0.5pt solid black">
                                              <fo:block>${invoiceItem.invoiceItemSeqId}</fo:block>
                                          </fo:table-cell>
                                          <fo:table-cell padding="2pt" background-color="${rowColor}" border="0.5pt solid black">
                                              <fo:block><#if invoiceItem.productId?has_content>${productName} [${invoiceItem.productId?if_exists}]</#if></fo:block>
                                              <fo:block><#if description?has_content>${description}</#if></fo:block>
                                          </fo:table-cell>
                                          <fo:table-cell padding="2pt" background-color="${rowColor}" border="0.5pt solid black">
                                              <fo:block text-align="center">${invoiceItem.quantity?if_exists}</fo:block>
                                          </fo:table-cell>
                                          <fo:table-cell padding="2pt" background-color="${rowColor}" border="0.5pt solid black">
                                              <fo:block text-align="right"><@ofbizCurrency amount=invoiceItem.amount isoCode=uom/></fo:block>
                                          </fo:table-cell>
                                          <fo:table-cell padding="2pt" background-color="${rowColor}" border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                          <fo:block text-align="right"><@ofbizCurrency amount=totalInvoiceItemAdjustmentsAmount isoCode=uom/></fo:block>
                                          </fo:table-cell>
                                          <fo:table-cell padding="2pt" background-color="${rowColor}" border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                          <fo:block text-align="right"><@ofbizCurrency amount=totalInvoiceItemAmount isoCode=uom/></fo:block>
                                          </fo:table-cell>
                                      </fo:table-row>
                                  </#if>

                                  <#list invoiceItemAdjustments as invoiceItemAdjustment>
                                      <#assign adjustmentType = invoiceItemAdjustment.getRelatedOne("OrderAdjustmentType", false)>
                                      <fo:table-row>
                                          <fo:table-cell padding="2pt" background-color="${rowColor}"></fo:table-cell>
                                          <fo:table-cell padding="2pt" background-color="${rowColor}"></fo:table-cell>
                                          <fo:table-cell padding="2pt" background-color="${rowColor}"></fo:table-cell>
                                          <fo:table-cell padding="2pt" background-color="${rowColor}"></fo:table-cell>
                                          <fo:table-cell padding="2pt" background-color="${rowColor}">
                                              <fo:block font-size="7pt" text-align="right">${adjustmentType.get("description",locale)?if_exists}</fo:block>
                                          </fo:table-cell>
                                          <fo:table-cell padding="2pt" background-color="${rowColor}">
                                              <fo:block font-size="7pt" text-align="right"><@ofbizCurrency amount=invoiceItemAdjustment.amount isoCode=uom/></fo:block>
                                          </fo:table-cell>
                                      </fo:table-row>
                                  </#list>

                                  <#if invoiceItem.invoiceItemTypeId != "ITM_SALES_TAX">
                                      <#if rowColor == "white">
                                          <#assign rowColor = "#D4D0C8">
                                      <#else>
                                          <#assign rowColor = "white">
                                      </#if>
                                  </#if>
                              </#list>
                          </fo:table-body>
                      </fo:table>
                  </#if>

                  <fo:block space-after="5mm"/>

                    <#-- Invoice Terms and Payments -->
                    <fo:table font-size="10pt">
                        <fo:table-column column-width="50%"/>
                        <fo:table-column column-width="50%"/>
                        <fo:table-body>
                            <fo:table-row>
                                <fo:table-cell>
                                    <#assign invoiceTerms = context.terms!>
                                    <#-- Display Invoice Terms -->
                                    <#if invoiceTerms?exists?has_content && invoiceTerms.size() gt 0>
                                        <fo:block text-align="left" border="0.5pt solid black"  font-size="0.4cm" background-color="#EEEEEE">${uiLabelMap.OrderOrderEntryOrderTerms}</fo:block>
                                        <fo:block font-size="0.3cm">
                                            <#list invoiceTerms as invoiceTerm>
                                                <#assign termType = invoiceTerm.getRelatedOne("TermType")/>
                                                <#assign termDescription = termType.get("description",locale)>
                                                <fo:block text-align="left" display-align="center">
                                                    ${termDescription?default("")} 
                                                    <#if invoiceTerm.termDays?has_content><#if invoiceTerm.termDays = 0 > 
                                                        au comptant 
                                                    <#else>
                                                        ${invoiceTerm.description?default("")} &#224; ${invoiceTerm.termDays?default("")} ${uiLabelMap.CommonDays} 
                                                    </#if></#if>
                                                    ${invoiceTerm.textValue?default("")}.
                                                </fo:block>
                                            </#list>
                                        </fo:block>
                                    </#if>
                                    <#if invoice.dueDate?has_content>
                                        <#assign invoiceDueDate = Static["org.ofbiz.base.util.UtilDateTime"].timeStampToString(invoice.dueDate,'dd/MM/yyyy',timeZone,locale)>
                                        <fo:block margin-top="0.5cm" display-align="center">${uiLabelMap.AccountingDueDate} : ${invoiceDueDate?if_exists}</fo:block>
                                    </#if>
                                    <#-- Display eft account informations -->
                                    <#if eftAccount?exists>
                                        <fo:block-container font-weight="bold">
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
                                                    <fo:block >${uiLabelMap.AccountingTotalExclTax?string?upper_case}</fo:block>
                                                </fo:table-cell>
                                                <fo:table-cell border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                                    <fo:block><@ofbizCurrency amount=invoiceNoTaxTotal isoCode=invoice.currencyUomId/></fo:block>
                                                </fo:table-cell>
                                                <fo:table-cell/>
                                            </fo:table-row>

                                            <#assign totalInvoiceHeaderAdjustmentAmount = 0.0>
                                            <#assign orderAdjustmentBillings = delegator.findByAnd("OrderAdjustmentBilling", Static["org.ofbiz.base.util.UtilMisc"].toMap("invoiceId", invoice.invoiceId))>
                                            <#list orderAdjustmentBillings as orderAdjustmentBilling>
                                               <#assign invoiceAdjustment = orderAdjustmentBilling.getRelatedOne("OrderAdjustment", false)>
                                               <#assign adjustmentType = invoiceAdjustment.getRelatedOne("OrderAdjustmentType", false)>
                                               <#if !orderAdjustmentBilling.invoiceItemSeqId?exists>
                                                   <#assign totalInvoiceHeaderAdjustmentAmount = invoiceAdjustment.amount?default(0) + totalInvoiceHeaderAdjustmentAmount>
                                                   <fo:table-row>
                                                       <fo:table-cell border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                                           <fo:block >${adjustmentType.get("description", locale)?if_exists?string?upper_case}</fo:block>
                                                       </fo:table-cell>
                                                       <fo:table-cell border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                                           <fo:block><@ofbizCurrency amount=invoiceAdjustment.amount isoCode=invoice.currencyUomId/></fo:block>
                                                       </fo:table-cell>
                                                       <fo:table-cell/>
                                                   </fo:table-row>
                                               </#if>
                                            </#list>
                                            <#if invoiceTaxAuths?has_content>
                                                <#assign count = 0>
                                                <#list invoiceTaxAuths as invoiceTaxAuth>
                                                  <#assign count = count + 1>
                                                    <fo:table-row>
                                                        <fo:table-cell border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                                            <fo:block>
                                                            ${uiLabelMap.AccountingReportAmountTax?string?upper_case} <#if invoiceTaxAuth.taxPercentage?has_content>${invoiceTaxAuth.taxPercentage?string("##0.00")} %</#if></fo:block>
                                                        </fo:table-cell>
                                                        <fo:table-cell border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                                            <fo:block><@ofbizCurrency amount=invoiceTaxAuth.taxAmount isoCode=invoice.currencyUomId/></fo:block>
                                                        </fo:table-cell>
                                                        <fo:table-cell/>
                                                    </fo:table-row>
                                                    <#--<fo:table-row>
                                                        <fo:table-cell border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                                            <fo:block>${uiLabelMap.AccountingSubTotal}</fo:block>
                                                        </fo:table-cell>
                                                        <fo:table-cell border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                                            <#assign invoiceNoTaxTotal = invoiceNoTaxTotal + invoiceTaxAuth.taxAmount?if_exists>
                                                            <fo:block><@ofbizCurrency amount=invoiceNoTaxTotal isoCode=invoice.currencyUomId/></fo:block>
                                                        </fo:table-cell>
                                                        <fo:table-cell/>
                                                    </fo:table-row>-->
                                                </#list>
                                            <#else>
                                                    <fo:table-row>
                                                        <fo:table-cell border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                                            <fo:block>${uiLabelMap.AccountingReportAmountTax?string?upper_case}</fo:block>
                                                        </fo:table-cell>
                                                        <fo:table-cell border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                                            <fo:block><@ofbizCurrency amount=invoiceTaxTotal isoCode=invoice.currencyUomId/></fo:block>
                                                        </fo:table-cell>
                                                        <fo:table-cell/>
                                                    </fo:table-row>
                                                    <fo:table-row>
                                                        <fo:table-cell border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                                            <fo:block>${uiLabelMap.AccountingSubTotal}</fo:block>
                                                        </fo:table-cell>
                                                        <fo:table-cell border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                                            <fo:block><@ofbizCurrency amount=invoiceTotal isoCode=invoice.currencyUomId/></fo:block>
                                                        </fo:table-cell>
                                                        <fo:table-cell/>
                                                    </fo:table-row>
                                            </#if>
                                            <#assign grandTotalInvoiceAmount = totalInvoiceAmount + totalInvoiceHeaderAdjustmentAmount>
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
                                                    <fo:block><@ofbizCurrency amount=grandTotalInvoiceAmount isoCode=invoice.currencyUomId/></fo:block>
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

                    <#-- Invoice conditions-->
                    <fo:block-container height="1cm" font-size="8.5pt" margin-top="1cm">
                        <fo:block>${uiLabelMap.InvoiceConditions1}</fo:block>
                        <fo:block>${uiLabelMap.InvoiceConditions2}</fo:block>
                        <fo:block>${uiLabelMap.InvoiceConditions3}</fo:block>
                        <fo:block>${uiLabelMap.InvoiceConditions4}</fo:block>
                        <fo:block>${uiLabelMap.InvoiceConditions5}</fo:block>
                    </fo:block-container>

                    <fo:block space-after="5mm"/>

                    <#-- Billing party notes -->
                    <#if billingPartyNotes?has_content>
                        <#list billingPartyNotes as note>
                            <#if (note.internalNote?has_content) && (note.internalNote != "Y")>
                                <fo:block margin-left="20mm" text-align="left">${note.noteInfo?if_exists}</fo:block>
                            </#if>
                        </#list>
                    </#if>

            <fo:block id="theEnd"/>

        </fo:flow>
    </fo:page-sequence>
</fo:root>

</#escape>
