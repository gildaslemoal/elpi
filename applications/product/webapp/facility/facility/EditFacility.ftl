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

<div class="panel panel-primary">
  <div class="panel-heading">
    <h3 class="panel-title">${uiLabelMap.ProductFacilityId}</h3>
  </div>
  <div class="panel-body">
<#if facility?exists && facilityId?has_content>
  <form action="<@ofbizUrl>UpdateFacility</@ofbizUrl>" name="EditFacilityForm" method="post" class="form-horizontal">
  <input type="hidden" name="facilityId" value="${facilityId?if_exists}" />
  <span>${uiLabelMap.ProductFacilityId}</span>
  <span class="tooltip">${uiLabelMap.ProductNotModificationRecrationFacility}</span>
<#else>
  <form action="<@ofbizUrl>CreateFacility</@ofbizUrl>" name="EditFacilityForm" method="post" class="basic-form">
  <#if facilityId?exists>
    <h3>${uiLabelMap.ProductCouldNotFindFacilityWithId} "${facilityId?if_exists}".</h3>
  </#if>
</#if>
      <div class="input-group">
         <span class="input-group-addon">${uiLabelMap.ProductFacilityTypeId}</span>
      <select name="facilityTypeId" class="selectpicker">
        <option selected="selected" value='${facilityType.facilityTypeId?if_exists}'>${facilityType.get("description",locale)?if_exists}</option>
        <option value='${facilityType.facilityTypeId?if_exists}'>----</option>
        <#list facilityTypes as nextFacilityType>
          <option value='${nextFacilityType.facilityTypeId?if_exists}'>${nextFacilityType.get("description",locale)?if_exists}</option>
        </#list>
      </select>
     </div>
      <div class="input-group">
         <span class="input-group-addon">${uiLabelMap.FormFieldTitle_parentFacilityId}</span>
      <@htmlTemplate.lookupField value="${facility.parentFacilityId?if_exists}" formName="EditFacilityForm" name="parentFacilityId" id="parentFacilityId" fieldFormName="LookupFacility"/>
    </div>
      <div class="input-group">
         <span class="input-group-addon">${uiLabelMap.ProductFacilityOwner}</span>
      <@htmlTemplate.lookupField value="${facility.ownerPartyId?if_exists}" formName="EditFacilityForm" name="ownerPartyId" id="ownerPartyId" fieldFormName="LookupPartyName"/>
      <span class="tooltip">${uiLabelMap.CommonRequired}</span>
     </div>
      <div class="input-group">
         <span class="input-group-addon">${uiLabelMap.ProductFacilityDefaultWeightUnit}</span>
      <select name="defaultWeightUomId" class="selectpicker">
          <option value=''>${uiLabelMap.CommonNone}</option>
          <#list weightUomList as uom>
            <option value='${uom.uomId}'
               <#if (facility.defaultWeightUomId?has_content) && (uom.uomId == facility.defaultWeightUomId)>
               selected="selected"
               </#if>
             >${uom.get("description",locale)?default(uom.uomId)}</option>
          </#list>
      </select>
     </div>
      <div class="input-group">
         <span class="input-group-addon">${uiLabelMap.ProductFacilityDefaultInventoryItemType}</span>
      <select name="defaultInventoryItemTypeId" class="selectpicker">
          <#list inventoryItemTypes as nextInventoryItemType>
            <option value='${nextInventoryItemType.inventoryItemTypeId}'
               <#if (facility.defaultInventoryItemTypeId?has_content) && (nextInventoryItemType.inventoryItemTypeId == facility.defaultInventoryItemTypeId)>
               selected="selected"
               </#if>
             >${nextInventoryItemType.get("description",locale)?default(nextInventoryItemType.inventoryItemTypeId)}</option>
          </#list>
      </select>
      </div>
      <div class="input-group">
         <span class="input-group-addon">${uiLabelMap.ProductName}</span>
         <input type="text" name="facilityName" value="${facility.facilityName?if_exists}" maxlength="60" class="form-control"/>
         <span class="tooltip">${uiLabelMap.CommonRequired}</span>
      </div>
      <div class="input-group">
         <span class="input-group-addon">${uiLabelMap.ProductFacilitySize}</span>
         <input type="text" name="facilitySize" value="${facility.facilitySize?if_exists}" maxlength="20" class="form-control"/>
      </div>
      <div class="input-group">
         <span class="input-group-addon">${uiLabelMap.ProductFacilityDefaultAreaUnit}</span>
      <select name="facilitySizeUomId" class="selectpicker">
          <option value=''>${uiLabelMap.CommonNone}</option>
          <#list areaUomList as uom>
            <option value='${uom.uomId}'
               <#if (facility.facilitySizeUomId?has_content) && (uom.uomId == facility.facilitySizeUomId)>
               selected="selected"
               </#if>
             >${uom.get("description",locale)?default(uom.uomId)}</option>
          </#list>
      </select>
      </div>
      <div class="input-group">
         <span class="input-group-addon">${uiLabelMap.ProductProductDescription}</span>
         <input type="text" name="description" value="${facility.description?if_exists}" maxlength="250" class="form-control"/>
      </div>
      <div class="input-group">
         <span class="input-group-addon">${uiLabelMap.ProductDefaultDaysToShip}</span>
         <input type="text" name="defaultDaysToShip" value="${facility.defaultDaysToShip?if_exists}" maxlength="20" class="form-control"/>
      </div>
    <#if facilityId?has_content>
      <input class="btn btn-default pull-right" type="submit" name="Update" value="${uiLabelMap.CommonUpdate}" />
    <#else>
      <input class="btn btn-default pull-right" type="submit" name="Update" value="${uiLabelMap.CommonSave}" />
    </#if>
</form>
     </div> <!-- Panel-body -->
</div>
</div>