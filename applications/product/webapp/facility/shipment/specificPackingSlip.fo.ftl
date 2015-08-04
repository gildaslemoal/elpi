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
        <#assign createdDate = Static["org.ofbiz.base.util.UtilDateTime"].timeStampToString(shipment.get("createdDate"),'dd/MM/yyyy',timeZone,locale)>
        ${setContextField("reportTitle", uiLabelMap.ProductPackingSlip)}
        ${setContextField("reportId", shipmentId!)}
        ${setContextField("reportDate", createdDate!)}
        ${setContextField("headerLogoImageUrl", logoImageUrl!)}
        ${screens.render("component://common/widget/CommonScreens.xml#companyHeaderPDF")}

        <#-- Footer -->
        ${screens.render("component://common/widget/CommonScreens.xml#companyFooterPDF")}

        <#-- Body -->
        <fo:flow flow-name="xsl-region-body">

            <#if packageDetails?has_content>
                <#list packageDetails as packageDetail>
                    <#assign package = packageDetail.lines!>
                    <fo:table table-layout="fixed" width="100%">
                        <fo:table-column column-number="1" column-width="proportional-column-width(50)"/>
                        <fo:table-column column-number="2" column-width="proportional-column-width(50)"/>
                        <fo:table-body>
                            <#--#Bam# 24243-report -->
                            <#--
                            <fo:table-row>
                            -->
                            <fo:table-row height="5.5cm">
                            <#--#Eam# 24243-report -->
                                <fo:table-cell margin-left="5mm" margin-top="5mm">
                                      <fo:block space-after="15mm"/>
                                      <#-- Display order informations -->
                                      <#if order?has_content>
                                          <#assign orderDate = Static["org.ofbiz.base.util.UtilDateTime"].timeStampToString(order.orderDate,'dd/MM/yyyy',timeZone,locale)>
                                          <fo:block>${uiLabelMap.AccountingOrderNrAbbr}: ${order.orderId!}</fo:block>
                                          <fo:block>${uiLabelMap.AccountingOrderDate}: ${orderDate!}</fo:block>
                                          <fo:block>${order.orderName?if_exists}</fo:block>
                                      </#if>
                                      <#if shipGroupSeqId?has_content>
                                          <fo:block>${uiLabelMap.ProductOrderShipGroupId}: ${shipGroupSeqId?if_exists}</fo:block>
                                      </#if>
                                      <fo:block>${uiLabelMap.ProductPackage}:  ${packageDetail_index + 1}</fo:block>
                                  </fo:table-cell>
                                  <fo:table-cell font-weight="bold" margin-left="5mm" font-size="0.4cm">
                                      <fo:block space-after="10mm"/>
                                      <#-- Display destination address informations -->
                                      <#if destinationPostalAddress?has_content>
                                          ${setContextField("address", destinationPostalAddress)}
                                          ${screens.render("component://common/widget/CommonScreens.xml#commonAddressPDF")}
                                      <#else>
                                          <fo:block>${uiLabelMap.CommonAddressNotFound}</fo:block>
                                      </#if>
                                  </fo:table-cell>
                              </fo:table-row>

                              <#--#Bam# 24243-report -->
                              <#--
                              <fo:table-row>
                                  <fo:table-cell>
                                      <fo:block space-after="5mm"/>
                                      <#if originPostalAddress?has_content>
                                      <fo:block text-align="left" border="0.5pt solid black" margin="0.5cm" font-size="0.4cm" background-color="#EEEEEE">${uiLabelMap.AccountingInvoicePartyFrom}</fo:block>
                                      </#if>
                                  </fo:table-cell>
                                  <fo:table-cell>
                                      <fo:block space-after="5mm"/>
                                      <#if destinationPostalAddress?has_content>
                                      <fo:block text-align="left" border="0.5pt solid black" margin="0.5cm" font-size="0.4cm" background-color="#EEEEEE">${uiLabelMap.AccountingInvoicePartyTo}</fo:block>
                                      </#if>
                                  </fo:table-cell>
                              </fo:table-row>
                              <fo:table-row>
                                  <fo:table-cell margin-left="5mm">
                              -->
                                      <#-- Display from party address informations -->
                              <#--
                                      <#if originPostalAddress?has_content>
                                          ${setContextField("address", originPostalAddress)}
                                          ${screens.render("component://common/widget/CommonScreens.xml#commonAddressPDF")}
                                      <#else>
                                          <fo:block></fo:block>
                                      </#if>
                                  </fo:table-cell>
                                  <fo:table-cell margin-left="5mm">
                              -->
                                      <#-- Display delivery address informations -->
                              <#--
                                      <#if destinationPostalAddress?has_content>
                                          ${setContextField("address", destinationPostalAddress)}
                                          ${screens.render("component://common/widget/CommonScreens.xml#commonAddressPDF")}
                                      <#else>
                                          <fo:block></fo:block>
                                      </#if>
                                  </fo:table-cell>
                              </fo:table-row>
                              -->
                              <#--#Eam# 24243-report -->

                         </fo:table-body>
                     </fo:table>

                     <fo:block space-after="5mm"/>

                     <#-- Display shipment line informations -->
                     <#assign shipGroup = shipment.getRelatedOne("PrimaryOrderItemShipGroup", false)?if_exists>
                     <#assign carrier = (shipGroup.carrierPartyId)?default("N/A")>
                     <fo:block space-after.optimum="15pt" >
                     <fo:table border="0.5pt solid black" font-size="10pt" border-right-color="grey" border-right-width="1mm" border-bottom-color="grey" border-bottom-width="1mm">
                          <fo:table-column column-width="6%"/>
                          <fo:table-column column-width="50%"/>
                         <#if (packages?size > 1)>
                             <fo:table-column column-width="11%"/>
                             <fo:table-column column-width="11%"/>
                             <fo:table-column column-width="11%"/>
                             <fo:table-column column-width="11%"/>
                         <#else>
                             <fo:table-column column-width="14.6%"/>
                             <fo:table-column column-width="14.6%"/>
                             <fo:table-column column-width="14.6%"/>
                         </#if>
                         <fo:table-header>
                             <fo:table-row display-align="center" text-align="center" font-weight="bold" font-size="0.3cm" background-color="#EEEEEE">
                                 <fo:table-cell border="0.5pt solid black">
                                     <fo:block></fo:block>
                                 </fo:table-cell>
                                 <fo:table-cell border="0.5pt solid black">
                                     <fo:block>${uiLabelMap.ProductProductDescription}</fo:block>
                                 </fo:table-cell>
                                 <fo:table-cell border="0.5pt solid black">
                                     <fo:block>${uiLabelMap.ProductQuantityRequested}</fo:block>
                                 </fo:table-cell>
                                 <fo:table-cell border="0.5pt solid black">
                                     <fo:block>${uiLabelMap.ProductQuantityOfPackage}</fo:block>
                                 </fo:table-cell>
                                 <#if (packages?size > 1)>
                                     <fo:table-cell border="0.5pt solid black">
                                         <fo:block>${uiLabelMap.ProductQuantityShippedOfPackage}</fo:block>
                                     </fo:table-cell>
                                 </#if>
                                 <fo:table-cell border="0.5pt solid black">
                                     <fo:block>${uiLabelMap.ProductQuantityShipped}</fo:block>
                                 </fo:table-cell>
                             </fo:table-row>
                         </fo:table-header>
                         <fo:table-body>
                         <#assign rowColor = "white">
                         <#list package as line>
                              <fo:table-row>
                                 <fo:table-cell padding="2pt" background-color="${rowColor}" border="0.5pt solid black">
                                     <fo:block>${line.shipmentItemSeqId!}</fo:block>
                                 </fo:table-cell>
                                 <fo:table-cell padding="2pt" background-color="${rowColor}" border="0.5pt solid black">
                                     <#if line.product?has_content>
                                         <fo:block>${line.product.internalName?default("Internal Name Not Set!")} [${line.product.productId}]</fo:block>
                                     <#else/>
                                         <fo:block>${line.getClass().getName()}</fo:block>
                                     </#if>
                                 </fo:table-cell>
                                 <fo:table-cell padding="2pt" background-color="${rowColor}" border="0.5pt solid black">
                                     <fo:block>${line.quantityRequested?default(0)} <#if line.productUom?has_content>${line.productUom.abbreviation}</#if></fo:block>
                                 </fo:table-cell>
                                 <fo:table-cell padding="2pt" background-color="${rowColor}" border="0.5pt solid black">
                                     <fo:block>${line.quantityInPackage?default(0)} <#if line.productUom?has_content>${line.productUom.abbreviation}</#if></fo:block>
                                 </fo:table-cell>
                                 <#if (packages?size > 1)>
                                     <fo:table-cell padding="2pt" background-color="${rowColor}" border="0.5pt solid black">
                                     <fo:block>${line.quantityInShipment?default(0)} <#if line.productUom?has_content>${line.productUom.abbreviation}</#if></fo:block>
                                     </fo:table-cell>
                                 </#if>
                                 <fo:table-cell padding="2pt" background-color="${rowColor}" border="0.5pt solid black">
                                     <fo:block>${line.quantityShipped?default(0)} <#if line.productUom?has_content>${line.productUom.abbreviation}</#if></fo:block>
                                 </fo:table-cell>
                             </fo:table-row>
                         </#list>
                         <#if rowColor == "white">
                             <#assign rowColor = "#D4D0C8">
                         <#else>
                             <#assign rowColor = "white">
                         </#if>
                         </fo:table-body>
                     </fo:table>
                     </fo:block>

                     <#-- Shipping informations -->
                     <fo:block space-after.optimum="10pt">
                         <fo:table>
                             <fo:table-column column-width="25%"/>
                             <fo:table-column column-width="25%"/>
                             <fo:table-column column-width="25%"/>
                             <fo:table-column column-width="25%"/>
                             <fo:table-header>
                                 <fo:table-row display-align="center" text-align="center" font-weight="bold" background-color="#EEEEEE" font-size="0.35cm">
                                     <fo:table-cell border="0.5pt solid black"><fo:block>${uiLabelMap.ProductCarrier} </fo:block></fo:table-cell>
                                     <fo:table-cell border="0.5pt solid black"><fo:block>${uiLabelMap.ProductShipmentMethod}</fo:block></fo:table-cell>
                                     <fo:table-cell border="0.5pt solid black"><fo:block>${uiLabelMap.OrderEstimatedShipDate}</fo:block></fo:table-cell>
                                     <fo:table-cell border="0.5pt solid black"><fo:block>${uiLabelMap.ProductEstimatedArrivalDate}</fo:block></fo:table-cell>
                                 </fo:table-row>
                             </fo:table-header>
                             <fo:table-body>
                                     <fo:table-row border="0.5pt solid black" font-size="0.3cm" margin="1mm" text-align="center">
                                         <fo:table-cell  border="0.5pt solid black" >
                                             <fo:block>${carrier?if_exists}</fo:block>
                                         </fo:table-cell>
                                         <fo:table-cell  border="0.5pt solid black" >
                                             <fo:block>${(shipGroup.getRelatedOne("ShipmentMethodType", false).get("description", locale))?default(shipGroup.shipmentMethodTypeId)}</fo:block>
                                         </fo:table-cell>
                                         <fo:table-cell  border="0.5pt solid black" >
                                             <fo:block>${estimatedShipDate?if_exists}</fo:block>
                                         </fo:table-cell>
                                         <fo:table-cell  border="0.5pt solid black" >
                                             <fo:block>${estimatedDeliveryDate?if_exists}</fo:block>
                                         </fo:table-cell>
                                     </fo:table-row>
                             </fo:table-body>
                         </fo:table>
                     </fo:block>

                     <fo:block space-after="5mm"/>

                     <#-- Package informations -->
                     <fo:block space-after.optimum="10pt" id="last-page">
                         <fo:table>
                             <fo:table-column column-width="20%"/>
                             <fo:table-column column-width="20%"/>
                             <fo:table-body>
                                 <#if packageDetail.trackingCode?has_content>
                                     <fo:table-row border="0.5pt solid black" font-size="0.35cm" margin="1mm"  height="0.5cm">
                                         <fo:table-cell border="0.5pt solid black" background-color="#EEEEEE" font-weight="bold"><fo:block margin-top="0.1cm">${uiLabelMap.ProductTracking}</fo:block></fo:table-cell>
                                         <fo:table-cell border="0.5pt solid black" ><fo:block margin-top="0.1cm">${packageDetail.trackingCode?if_exists}</fo:block></fo:table-cell>
                                     </fo:table-row>
                                 </#if>
                                 <#if packageDetail.weight?has_content>
                                     <fo:table-row border="0.5pt solid black" font-size="0.35cm" margin="1mm"  height="0.5cm">
                                         <#assign weightUom = delegator.findOne("Uom", Static["org.ofbiz.base.util.UtilMisc"].toMap("uomId", packageDetail.weightUomId?if_exists), true)?if_exists />
                                         <fo:table-cell border="0.5pt solid black" background-color="#EEEEEE" font-weight="bold"><fo:block margin-top="0.1cm">${uiLabelMap.CommonWeight}</fo:block></fo:table-cell>
                                         <fo:table-cell border="0.5pt solid black" ><fo:block margin-top="0.1cm">${packageDetail.weight?if_exists}<#if weightUom?has_content> ${weightUom.abbreviation}</#if></fo:block></fo:table-cell>
                                     </fo:table-row>
                                 </#if>
                                 <fo:table-row border="0.5pt solid black" font-size="0.35cm" margin="1mm"  height="0.5cm">
                                     <fo:table-cell border="0.5pt solid black" background-color="#EEEEEE" font-weight="bold"><fo:block margin-top="0.1cm">${uiLabelMap.ProductPackageQty}</fo:block></fo:table-cell>
                                     <fo:table-cell border="0.5pt solid black" ><fo:block margin-top="0.1cm"><#if packages?has_content>${packages?size}</#if></fo:block></fo:table-cell>
                                 </fo:table-row>
                             </fo:table-body>
                         </fo:table>
                     </fo:block>

                     <fo:block space-after="5mm"/>

                     <#-- Shipping instructions -->
                     <#if shippingInstructions?has_content>
                         <fo:block font-size="0.35cm" text-align="center" font-weight="bold">${uiLabelMap.OrderInstructions}</fo:block>
                         <fo:block font-size="0.3cm"  text-align="center" >${shippingInstructions}</fo:block>
                     </#if>

                     <#-- Handling instructions -->
                     <#if handlingInstructions?has_content>
                         <fo:block font-size="0.35cm" text-align="center" font-weight="bold">${uiLabelMap.ProductHandlingInstructions}</fo:block>
                         <fo:block font-size="0.3cm"  text-align="center" >${handlingInstructions}</fo:block>
                     </#if>

                    <#if packageDetail_has_next><fo:block break-before="page"/></#if>
                </#list> <#-- packages -->
             <#else>
                 <fo:block font-size="14pt">
                     ${uiLabelMap.ProductErrorNoPackagesFoundForShipment}
                 </fo:block>
             </#if>
             <fo:block id="theEnd"/>
        </fo:flow>
    </fo:page-sequence>
</fo:root>

</#escape>
