<div class="row">
    <div class="col-lg-12">
        <a class="btn btn-otoit" href="<@ofbizUrl>account</@ofbizUrl>#myOrders">Retour à la liste des commandes</a>
        <table  class="shopping-cart-summary">
            <thead>
            <tr>
                <th class="text-center">${uiLabelMap.OrderProduct}</th>
                <th>${uiLabelMap.CommonDescription}</th>
                <th class="text-right">${uiLabelMap.EcommerceUnitPrice}</th>
                <th class="text-center">${uiLabelMap.CommonQuantity}</th>
                <th class="text-right">${uiLabelMap.CommonTotal}</th>
            </tr>
            </thead>
            <tbody>
            <#if orderItemList?exists>
                <#list orderItemList as orderItem>
                <tr>
                    <td class="text-center">
                    <#assign product = orderItem.getRelatedOne("Product")/>
                    <#assign smallImageUrl = Static["org.ofbiz.product.product.ProductContentWrapper"].getProductContentAsText(product, "SMALL_IMAGE_URL", locale, dispatcher)?if_exists>
                    <#if smallImageUrl?string?has_content>
                        <a href="<@ofbizCatalogAltUrl productId=product.productId/>">
                            <img class="table-image-thumbler" src="<@ofbizContentUrl>${smallImageUrl}</@ofbizContentUrl>" alt="Product Image" class="imageborder" />
                        </a>
                    </#if>
                    </td>
                    <td>
                        ${orderItem.itemDescription}
                    </td>
                    <td class="text-right">
                        <#assign unitPriceTotal = orderItem.unitPrice + orderReadHelper.getOrderItemTax(orderItem)/>
                        <@ofbizCurrency amount=unitPriceTotal isoCode=currencyUomId/>
                    </td>
                    <td class="text-center">
                        ${orderItem.quantity?string.number}
                    </td>
                    <td class="text-right">
                        <@ofbizCurrency amount=orderReadHelper.getOrderItemTotal(orderItem) isoCode=currencyUomId/>
                    </td>
                </tr>
                </#list>
            </#if>
            </tbody>
        </table>
    </div>
</div>
<div class="row">
    <div class="col-lg-3 pull-right">
        <table  class="shopping-cart-summary">
            <tbody>
            <#list orderHeaderAdjustments as orderHeaderAdjustment>
                <#assign adjustmentType = orderHeaderAdjustment.getRelatedOne("OrderAdjustmentType", false)>
                    <#assign adjustmentAmount = Static["org.ofbiz.order.order.OrderReadHelper"].calcOrderAdjustment(orderHeaderAdjustment, orderSubTotal)>
                        <#if adjustmentAmount != 0>
                <tr>
                    <td class="text-right">
                        <#if orderHeaderAdjustment.comments?has_content>${orderHeaderAdjustment.comments} - </#if>
                        <#if orderHeaderAdjustment.description?has_content>${orderHeaderAdjustment.description} - </#if>
                        ${adjustmentType.get("description", locale)}
                    </td>
                    <td class="text-right">
                        <@ofbizCurrency amount=adjustmentAmount isoCode=currencyUomId/>
                    </td>
                </tr>
                        </#if>
            </#list>
            <#-- grand total -->
                <tr class="shopping-cart-summary-total">
                    <td></td>
                    <td></td>
                    <td></td>
                    <td class="text-right">
                        ${uiLabelMap.OrderTotalDue}
                    </td>
                    <td class="text-right">
                        <@ofbizCurrency amount=grandTotal isoCode=currencyUomId/>
                    </td>
                </tr>
                <#-- tax adjustments -->
                <tr class="shopping-cart-tax-total">
                    <td></td>
                    <td></td>
                    <td></td>
                    <td class="text-right">
                            ${uiLabelMap.OrderSalesTaxIncluded}
                    </td>
                    <td class="text-right">
                            <@ofbizCurrency amount=taxAmount isoCode=currencyUomId/>
                    </td>
                </tr>
            </tbody>
        </table>
    <!--</div>-->
</div>
