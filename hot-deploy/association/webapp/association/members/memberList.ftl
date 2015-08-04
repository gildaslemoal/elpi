<#assign extInfo = parameters.extInfo?default("N")>
<#assign inventoryItemId = parameters.inventoryItemId?default("")>
<#assign serialNumber = parameters.serialNumber?default("")>
<#assign softIdentifier = parameters.softIdentifier?default("")>
<#assign sortField = parameters.sortField?if_exists/>
<#-- Only allow the search fields to be hidden when we have some results -->
<#if partyList?has_content>
    <#assign hideFields = parameters.hideFields?default("N")>
<#else>
    <#assign hideFields = "N">
</#if>
<#assign actionFindParty="memberList">
<#assign showByPartyType = showByPartyType?if_exists/>
<#assign showCustomer = showCustomer?if_exists/>
<#assign showSupplier = showSupplier?if_exists/>
<#if partyList?has_content>
<h1>${uiLabelMap.PageTitleMembersList}</h1>
<#else>
<h1>${uiLabelMap.PageTitleFindMember}</h1>
</#if>

<#if (parameters.firstName?has_content || parameters.lastName?has_content)>
    <#assign createUrl = "editperson?create_new=Y&amp;lastName=${parameters.lastName?if_exists}&amp;firstName=${parameters.firstName?if_exists}"/>
<#elseif (parameters.groupName?has_content)>
    <#assign createUrl = "editpartygroup?create_new=Y&amp;groupName=${parameters.groupName?if_exists}"/>
<#else>
    <#assign createUrl = "createnew"/>
</#if>

<#if showByPartyType != 'Y'>
<div class="button-bar"><a href="<@ofbizUrl>${createUrl}</@ofbizUrl>" class="buttontext create">${uiLabelMap.CommonCreateNew}</a></div>
</#if>
<div class="screenlet">
    <div class="screenlet-title-bar">
    <#if partyList?has_content>
        <ul>
            <#if hideFields == "Y">
                <li class="collapsed"><a href="<@ofbizUrl>${actionFindParty}?hideFields=N&sortField=${sortField?if_exists}${paramList}</@ofbizUrl>" title="${uiLabelMap.CommonShowLookupFields}">&nbsp;</a></li>
            <#else>
                <li class="expanded"><a href="<@ofbizUrl>${actionFindParty}?hideFields=Y&sortField=${sortField?if_exists}${paramList}</@ofbizUrl>" title="${uiLabelMap.CommonHideFields}">&nbsp;</a></li>
            </#if>
        </ul>
        <br class="clear"/>
    </#if>
    </div>
    <div class="screenlet-body">
        <div id="findPartyParameters" <#if hideFields != "N"> style="display:none" </#if> >
        <#-- NOTE: this form is setup to allow a search by partial partyId or userLoginId; to change it to go directly to
            the viewprofile page when these are entered add the follow attribute to the form element:

             onsubmit="javascript:lookupParty('<@ofbizUrl>viewprofile</@ofbizUrl>');"
         -->
            <div class="row">
            <form method="post" name="lookupparty" action="<@ofbizUrl>memberList</@ofbizUrl>" class="basic-form">
                <input type="hidden" name="lookupFlag" value="Y"/>
                <input type="hidden" name="hideFields" value="Y"/>
                <div class="col-lg-4">
                    <dl id="find-member-table" class="dl-horizontal">
                            <dt class="hidden label">${uiLabelMap.PartyContactInformation}</dt>
                            <dd class="hidden">
                                <input class="hidden" type="radio" name="extInfo" value="N" onclick="javascript:refreshInfo();" <#if extInfo == "N">checked="checked"</#if>/>${uiLabelMap.CommonNone}&nbsp;
                                <input type="radio" name="extInfo" value="P" onclick="javascript:refreshInfo();" <#if extInfo == "P">checked="checked"</#if>/>${uiLabelMap.PartyPostal}&nbsp;
                                <input type="radio" name="extInfo" value="T" onclick="javascript:refreshInfo();" <#if extInfo == "T">checked="checked"</#if>/>${uiLabelMap.PartyTelecom}&nbsp;
                                <input type="radio" name="extInfo" value="O" onclick="javascript:refreshInfo();" <#if extInfo == "O">checked="checked"</#if>/>${uiLabelMap.CommonOther}&nbsp;
                            </dd>
                        </dd>
                        <dt>${uiLabelMap.PartyPartyId}</dt>
                        <dd><input class="form-control" type="text" name="partyId" value="${parameters.partyId?if_exists}"/></dd>
                        <div style="height:5px"></div>
                        <dt>Identifiant</dt>
                        <dd><input class="form-control" type="text" name="userLoginId" value="${parameters.userLoginId?if_exists}"/></dd>
                        <div style="height:5px"></div>
                        <dt>${uiLabelMap.PartyLastName}</dt>
                        <dd><input class="form-control" type="text" name="lastName" value="${parameters.lastName?if_exists}"/></dd>
                        <div style="height:5px"></div>
                        <dt>${uiLabelMap.PartyFirstName}</dt>
                        <dd><input class="form-control" type="text" name="firstName" value="${parameters.firstName?if_exists}"/></dd>
                        <div style="height:5px"></div>
                        <dt>Nom du groupe</dt>
                        <dd><input class="form-control" type="text" name="groupName" value="${parameters.groupName?if_exists}"/></dd>
                        <div style="height:5px"></div>
                    <#if showByPartyType == "Y">
                        <dt>
                            <select name="roleTypeId" hidden="false">
                                <#if showCustomer == "Y">
                                    <option value="CUSTOMER"></option>
                                </#if>
                                <#if showSupplier == "Y">
                                    <option value="SUPPLIER"></option>
                                </#if>
                            </select>
                        </dt>
                    <#else>
                        <dt>${uiLabelMap.PartyRoleType}</dt>
                        <dd>
                            <select name="roleTypeId">
                                <#if currentRole?has_content>
                                    <option value="${currentRole.roleTypeId}">${currentRole.get("description",locale)}</option>
                                    <option value="${currentRole.roleTypeId}">---</option>
                                </#if>
                                <option value="ANY">${uiLabelMap.CommonAnyRoleType}</option>
                                <#list roleTypes as roleType>
                                    <option value="${roleType.roleTypeId}">${roleType.get("description",locale)}</option>
                                </#list>
                            </select>
                        </dd>
                    </#if>
                        <dt>${uiLabelMap.PartyType}</dt>
                        <dd>
                            <select name="partyTypeId" class="selectpicker" data-width="100%">
                            <#if currentPartyType?has_content>
                                <option value="${currentPartyType.partyTypeId}">${currentPartyType.get("description",locale)}</option>
                                <option value="${currentPartyType.partyTypeId}">---</option>
                            </#if>
                                <option value="ANY">${uiLabelMap.CommonAny}</option>
                            <#list partyTypes as partyType>
                                <option value="${partyType.partyTypeId}">${partyType.get("description",locale)}</option>
                            </#list>
                            </select>
                        </dd>
                        <div style="height:5px"></div>
                        <dt>${uiLabelMap.ProductInventoryItemId}</dt>
                        <dd><input class="form-control" type="text" name="inventoryItemId" value="${parameters.inventoryItemId?if_exists}"/></dd>
                        <div style="height:5px"></div>
                        <dt>${uiLabelMap.ProductSerialNumber}</dt>
                        <dd><input class="form-control" type="text" name="serialNumber" value="${parameters.serialNumber?if_exists}"/></dd>
                        <div style="height:5px"></div>
                        <dt>${uiLabelMap.ProductSoftIdentifier}</dt>
                        <dd><input class="form-control" type="text" name="softIdentifier" value="${parameters.softIdentifier?if_exists}"/></dd>
                        <div style="height:10px"></div>
                        <dt>&nbsp;</dt>
                        <dd>
                            <input class="btn btn-classic" type="submit" value="${uiLabelMap.CommonFind}" onclick="javascript:document.lookupparty.submit();"/>
                        </dd>
                    </dl>
                </div>
            </form>
            </div>
        </div>
        <script language="JavaScript" type="text/javascript">
            document.lookupparty.partyId.focus();
        </script>


        <table class="table table-hover">
    <thead>
        <tr>
            <th>
                Identifiant
            </th>
            <th>
                Photo
            </th>
            <th>
                Nom
            </th>
            <th>
                Prénom
            </th>
            <th>
                Date de naissance
            </th>
            <th>
                Code Postal
            </th>
            <th>
                Ville
            </th>
            <th>
                Courriel
            </th>
            <th>
                Cotisation
            </th>
        </tr>
    </thead>
    <tbody>
    <#assign alt_row = false>
        <#assign rowCount = 0>
        <#list partyList as partyRow>
            <#assign partyType = partyRow.getRelatedOne("PartyType", false)?if_exists>
            <#assign person = delegator.findOne("Person", {"partyId": partyRow.partyId},true)?if_exists>
            <#assign partyContactMechList = delegator.findByAnd("PartyContactMech", {"partyId": partyRow.partyId}, null, false)>
            <#assign cotisation = "0">
            <#list partyContactMechList as partyContactMech>
                <#assign contactMech = delegator.findOne("ContactMech", {"contactMechId": partyContactMech.contactMechId}, true)?if_exists>
                <#if contactMech.contactMechTypeId="POSTAL_ADDRESS">
                    <#assign postalAddress = delegator.findOne("PostalAddress", {"contactMechId": partyContactMech.contactMechId}, true)?if_exists>
                </#if>
                <#if contactMech.contactMechTypeId="ELECTRONIC_ADDRESS">
                    <#assign emailAddress = contactMech.infoString>
                </#if>
                <#if contactMech.contactMechTypeId="EMAIL_ADDRESS">
                    <#assign emailAddress = contactMech.infoString>
                </#if>
            </#list>
            <#assign partyAttributeList = delegator.findByAnd("PartyAttribute", {"partyId": partyRow.partyId}, null, false)>
            <#list partyAttributeList as partyAttribute>
                <#if partyAttribute.attrName="COTISATION">
                    <#assign cotisation = partyAttribute.attrValue>
                </#if>
            </#list>
            <#if person.salutation??>
                <#assign genre = person.salutation>
            <#else>
                <#if person.personalTitle = "Mme">
                    <#assign genre = "Misses">
                <#else>
                    <#assign genre = "Mister">
                </#if>

            </#if>
        <tr valign="middle"<#if alt_row> class="alternate-row"</#if>>
            <td><a href="<@ofbizUrl>profileMember?partyId=${partyRow.partyId}</@ofbizUrl>">${partyRow.partyId}</a></td>
            <td>
                <img class="img-responsive table-image" src="/easyofbiztheme/images/<#if genre="Mister">default-men.svg<#else>default-women.svg</#if>" alt="<#if partyRow.getModelEntity().isField("lastName") && lastName?has_content>${partyRow.lastName}<#if partyRow.firstName?has_content>, ${partyRow.firstName}</#if></#if>"></td>
            <td>${person.lastName}</td>
            <td>${person.firstName}</td>
            <td>${person.birthDate?string.long}</td>
            <td>${postalAddress.postalCode}</td>
            <td>${postalAddress.city}</td>
            <td><a href="mailto:${emailAddress}">${emailAddress}</a></td>
            <td>
                <#if cotisation="1">
                    <span class="label table-label label-success">Cotisation à jour</span>
                <#else>
                    <span class="label table-label label-danger">En attente de paiement</span>
                </#if>
            </td>
        </tr>
            <#assign rowCount = rowCount + 1>
        <#-- toggle the row color -->
            <#assign alt_row = !alt_row>
        </#list>

    </tbody>
</table>
