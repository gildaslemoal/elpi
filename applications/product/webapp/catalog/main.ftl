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

<#if !sessionAttributes.userLogin?exists>
  <div class='label label-default'> ${uiLabelMap.ProductGeneralMessage}.</div>
</#if>
<#if security.hasEntityPermission("CATALOG", "_VIEW", session)>
  <div class="row">
      <div class="label label-default">${uiLabelMap.ProductEditCatalogWithCatalogId}:</div>
      <form class="form-horizontal" method="post" action="<@ofbizUrl>EditProdCatalog</@ofbizUrl>" name="EditProdCatalogForm">
        <input type="text" maxlength="20" name="prodCatalogId" value=""/>
        <input type="submit" value=" ${uiLabelMap.ProductEditCatalog}" class="btn btn-default"/>
      </form>
  </div>
  <div class="row">
      <div class="label label-default">${uiLabelMap.CommonOr}: <a href="<@ofbizUrl>EditProdCatalog</@ofbizUrl>" class="buttontext">${uiLabelMap.ProductCreateNewCatalog}</a></div>
      <div class="label">${uiLabelMap.ProductEditCategoryWithCategoryId}:</div>
      <form class="form-horizontal" method="post" action="<@ofbizUrl>EditCategory</@ofbizUrl>" name="EditCategoryForm">
        <@htmlTemplate.lookupField name="productCategoryId" id="productCategoryId" formName="EditCategoryForm" fieldFormName="LookupProductCategory"/>
        <input type="submit" value="${uiLabelMap.ProductEditCategory}" class="btn btn-default"/>
      </form>
  </div>
  <div class="row">
      <div class="label">${uiLabelMap.CommonOr}: <a href="<@ofbizUrl>EditCategory</@ofbizUrl>" class="buttontext">${uiLabelMap.ProductCreateNewCategory}</a></div>
      <div class="label">${uiLabelMap.ProductEditProductWithProductId}:</div>
      <form class="form-horizontal" method="post" action="<@ofbizUrl>EditProduct</@ofbizUrl>" name="EditProductForm">
        <@htmlTemplate.lookupField name="productId" id="productId" formName="EditProductForm" fieldFormName="LookupProduct"/>
        <input type="submit" value=" ${uiLabelMap.ProductEditProduct}"  class="btn btn-default""/>
      </form>
    </div>
  <div class="row">
      <div class="label">${uiLabelMap.CommonOr}: <a href="<@ofbizUrl>EditProduct</@ofbizUrl>" class="buttontext">${uiLabelMap.ProductCreateNewProduct}</a></div>
      <div class="label">${uiLabelMap.CommonOr}: <a href="<@ofbizUrl>CreateVirtualWithVariantsForm</@ofbizUrl>" class="buttontext">${uiLabelMap.ProductQuickCreateVirtualFromVariants}</a></div>
      <div class="label">${uiLabelMap.ProductFindProductWithIdValue}:</div>
      <form class="form-horizontal" method="post" action="<@ofbizUrl>FindProductById</@ofbizUrl>">
        <input type="text" maxlength="20" name="idValue" value=""/>
        <input type="submit" value=" ${uiLabelMap.ProductFindProduct}"  class="btn btn-default"/>
      </form>
    </div>
  <div class="row">
      <div><a href="<@ofbizUrl>UpdateAllKeywords</@ofbizUrl>" class="buttontext"> ${uiLabelMap.ProductAutoCreateKeywordsForAllProducts}</a></div>
      <div><a href="<@ofbizUrl>FastLoadCache</@ofbizUrl>" class="buttontext"> ${uiLabelMap.ProductFastLoadCatalogIntoCache}</a></div>
<!--   </div> -->
</#if>
