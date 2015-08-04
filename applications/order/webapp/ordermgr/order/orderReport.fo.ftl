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

        <#if orderHeader?has_content>
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
                            <fo:block>${uiLabelMap.AccountingTotalExclTax}</fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-header>
                <fo:table-body>
                    <#list orderItemList as orderItem>
                        <#assign orderItemType = orderItem.getRelatedOne("OrderItemType", false)?if_exists>
                        <#assign productId = orderItem.productId?if_exists>
                        <#assign remainingQuantity = (orderItem.quantity?default(0) - orderItem.cancelQuantity?default(0))>
                        <#assign itemAdjustment = Static["org.ofbiz.order.order.OrderReadHelper"].getOrderItemAdjustmentsTotal(orderItem, orderAdjustments, true, false, false)>
                        <#assign internalImageUrl = Static["org.ofbiz.product.imagemanagement.ImageManagementHelper"].getInternalImageUrl(request, productId?if_exists)?if_exists>
                        <#assign rowColor = "white">
                        <#if orderItem.productId?exists>
                            <#assign product = orderItem.getRelatedOne("Product", false)>
                        </#if>
                        
                        <fo:table-row>
                            <fo:table-cell padding="2pt" background-color="${rowColor}" border="0.5pt solid black">
                                <fo:block>${orderItem.orderItemSeqId}</fo:block>
                            </fo:table-cell>
                            <fo:table-cell padding="2pt" background-color="${rowColor}" border="0.5pt solid black">
                                <fo:block>${(product.internalName)?if_exists} [${product.productId?if_exists}]</fo:block>
                            </fo:table-cell>
                            <fo:table-cell padding="2pt" background-color="${rowColor}" border="0.5pt solid black">
                                <fo:block text-align="center">${remainingQuantity}</fo:block>
                            </fo:table-cell>
                            <fo:table-cell padding="2pt" background-color="${rowColor}" border="0.5pt solid black">
                                <fo:block text-align="right"><@ofbizCurrency amount=orderItem.unitPrice isoCode=currencyUomId/></fo:block>
                            </fo:table-cell>
                            <fo:table-cell padding="2pt" background-color="${rowColor}" border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
    <!--                             <fo:block text-align="right"><@ofbizCurrency amount=totalQuoteItemAmount isoCode=currencyUomId/></fo:block> -->
                            </fo:table-cell>
                            <fo:table-cell padding="2pt" background-color="${rowColor}" border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                <fo:block>
                                    <#if orderItem.statusId != "ITEM_CANCELLED">
                                        <@ofbizCurrency amount=Static["org.ofbiz.order.order.OrderReadHelper"].getOrderItemSubTotal(orderItem, orderAdjustments) isoCode=currencyUomId/>
                                    <#else>
                                        <@ofbizCurrency amount=0.00 isoCode=currencyUomId/>
                                    </#if>
                                </fo:block>
                            </fo:table-cell>
    
                        </fo:table-row>
                        <#if itemAdjustment != 0>
                            <fo:table-row>
                                <fo:table-cell number-columns-spanned="2" padding="2pt" background-color="${rowColor}" border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                    <fo:block text-indent="0.2in">
                                        <fo:inline font-style="italic">${uiLabelMap.OrderAdjustments}</fo:inline>
                                        : <@ofbizCurrency amount=itemAdjustment isoCode=currencyUomId/>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </#if>
                    </#list>
                </fo:table-body>
            </fo:table>
    
            <fo:block space-after="5mm"/>
    
            <fo:table font-size="10pt">
                <fo:table-column column-width="66%"/>
                <fo:table-column column-width="10%"/>
                <fo:table-column column-width="10%"/>
                <fo:table-column column-width="14%"/>
                <fo:table-body>
                    <#list orderHeaderAdjustments as orderHeaderAdjustment>
                        <#assign adjustmentType = orderHeaderAdjustment.getRelatedOne("OrderAdjustmentType", false)>
                        <#assign adjustmentAmount = Static["org.ofbiz.order.order.OrderReadHelper"].calcOrderAdjustment(orderHeaderAdjustment, orderSubTotal)>
                        <#if adjustmentAmount != 0>
                            <fo:table-row>
                                <fo:table-cell><fo:block></fo:block></fo:table-cell>
                                <fo:table-cell number-columns-spanned="2" padding="2pt" background-color="${rowColor}" border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                    <fo:block font-weight="bold">
                                        ${adjustmentType.get("description",locale)}
                                        <#if orderHeaderAdjustment.get("description")?has_content>
                                            (${orderHeaderAdjustment.get("description")?if_exists})
                                        </#if>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell text-align="right" padding="2pt" background-color="${rowColor}" border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                    <fo:block><@ofbizCurrency amount=adjustmentAmount isoCode=currencyUomId/></fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </#if>
                    </#list>
                    <#-- summary of order amounts -->
                    <fo:table-row>
                        <fo:table-cell><fo:block></fo:block></fo:table-cell>
                        <fo:table-cell number-columns-spanned="2" padding="2pt" background-color="${rowColor}" border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                            <fo:block font-weight="bold">${uiLabelMap.OrderItemsSubTotal}</fo:block>
                        </fo:table-cell>
                        <fo:table-cell text-align="right" padding="2pt" background-color="${rowColor}" border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                            <fo:block><@ofbizCurrency amount=orderSubTotal isoCode=currencyUomId/></fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <#if otherAdjAmount != 0>
                        <fo:table-row>
                            <fo:table-cell><fo:block></fo:block></fo:table-cell>
                            <fo:table-cell number-columns-spanned="2" padding="2pt" background-color="${rowColor}" border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                <fo:block font-weight="bold">${uiLabelMap.OrderTotalOtherOrderAdjustments}</fo:block>
                            </fo:table-cell>
                            <fo:table-cell text-align="right" padding="2pt" background-color="${rowColor}" border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                <fo:block><@ofbizCurrency amount=otherAdjAmount isoCode=currencyUomId/></fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </#if>
                    <#if shippingAmount != 0>
                        <fo:table-row>
                            <fo:table-cell><fo:block></fo:block></fo:table-cell>
                            <fo:table-cell number-columns-spanned="2" padding="2pt" background-color="${rowColor}" border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                <fo:block font-weight="bold">${uiLabelMap.OrderTotalShippingAndHandling}</fo:block>
                            </fo:table-cell>
                            <fo:table-cell text-align="right" padding="2pt" background-color="${rowColor}" border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                <fo:block><@ofbizCurrency amount=shippingAmount isoCode=currencyUomId/></fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </#if>
                    <#if taxAmount != 0>
                        <fo:table-row>
                            <fo:table-cell><fo:block></fo:block></fo:table-cell>
                            <fo:table-cell number-columns-spanned="2" padding="2pt" background-color="${rowColor}" border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                <fo:block font-weight="bold">${uiLabelMap.OrderTotalSalesTax}</fo:block>
                            </fo:table-cell>
                            <fo:table-cell text-align="right" padding="2pt" background-color="${rowColor}" border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                <fo:block><@ofbizCurrency amount=taxAmount isoCode=currencyUomId/></fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </#if>
                    <#if grandTotal != 0>
                        <fo:table-row>
                            <fo:table-cell><fo:block></fo:block></fo:table-cell>
                            <fo:table-cell number-columns-spanned="2" background-color="#EEEEEE" padding="2pt" border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                <fo:block font-size="12pt" font-weight="bold">${uiLabelMap.OrderGrandTotal?string?upper_case}</fo:block>
                            </fo:table-cell>
                            <fo:table-cell text-align="right" padding="2pt" background-color="${rowColor}" border="0.5pt solid black" border-right-color="grey" border-right-width="1mm">
                                <fo:block font-size="12pt" font-weight="bold"><@ofbizCurrency amount=grandTotal isoCode=currencyUomId/></fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </#if>
                    <#-- notes -->
                    <#if orderNotes?has_content>
                        <#if showNoteHeadingOnPDF>
                            <fo:table-row>
                                <fo:table-cell number-columns-spanned="3">
                                    <fo:block font-weight="bold">${uiLabelMap.OrderNotes}</fo:block>
                                    <fo:block>
                                        <fo:leader leader-length="19cm" leader-pattern="rule"/>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </#if>
                        <#list orderNotes as note>
                            <#if (note.internalNote?has_content) && (note.internalNote != "Y")>
                                <fo:table-row>
                                    <fo:table-cell number-columns-spanned="1">
                                        <fo:block>${note.noteInfo?if_exists}</fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell number-columns-spanned="2">
                                        <fo:block>
                                        <#if note.noteParty?has_content>
                                            <#assign notePartyNameResult = dispatcher.runSync("getPartyNameForDate", Static["org.ofbiz.base.util.UtilMisc"].toMap("partyId", note.noteParty, "compareDate", note.noteDateTime, "lastNameFirst", "Y", "userLogin", userLogin))/>
                                            ${uiLabelMap.CommonBy}: ${notePartyNameResult.fullName?default("${uiLabelMap.OrderPartyNameNotFound}")}
                                        </#if>
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell number-columns-spanned="1">
                                        <fo:block>${uiLabelMap.CommonAt}: ${note.noteDateTime?string?if_exists}</fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                            </#if>
                        </#list>
                    </#if>
                </fo:table-body>
            </fo:table>
        </#if>
        
</#escape>
