<#if partyList?has_content>
    <h1>Envoi d'emails groupés</h1>
<#else>
    <h1>Envoi d'emails groupés</h1>
</#if>

<div class="screenlet">
    <div class="screenlet-body">
        <div class="row">
        <div id="findPartyParameters" class="col-md-4"  >
            <form method="post" name="lookupparty" action="<@ofbizUrl>selectMailing</@ofbizUrl>" class="basic-form">
                <#if parameters.mailingType??>
                    <#assign mailingType = parameters.mailingType/>
                <#else>
                    <#assign mailingType = "none"/>
                </#if>
                <input type="hidden" name="lookupFlag" value="Y">
                <input type="hidden" name="hideFields" value="Y">
                <input type="hidden" name="roleTypeId" value="CUSTOMER">
                <dl class="dl-horizontal">
                    <dt>Type de mailing</dt>
                    <dd>
                        <select id="mailingType" name="mailingType" class="selectpicker" data-width="100%" >
                            <option value="newsletter" <#if mailingType?has_content && mailingType = "newsletter">selected</#if> >Newsletter</option>
                            <option value="cotisation" <#if mailingType?has_content && mailingType = "cotisation">selected</#if> >Rappel de cotisation</option>
                            <option value="codepostal" <#if mailingType?has_content && mailingType = "codepostal">selected</#if> >Message par code postal</option>
                        </select>
                    </dd>
                    <div style="height:5px"></div>
                    <dt>code postal</dt>
                    <dd>
                        <input type="text" name="postalCode" class="form-control" placeholder="code postal">
                    </dd>
                    <div style="height:10px"></div>
                    <dt></dt>
                    <dd>
                        <button type="submit" class="btn btn-classic">Éditer</button>
                    </dd>
                </dl>

            </form>
        </div>
        </div>
        <#if partyList?has_content>
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

        <form method="post" name="formmailcontent" action="<@ofbizUrl>sendEmail</@ofbizUrl>" class="basic-form">
            <input type="hidden" name="partyList" value="${partyIdList}">
            <textarea name="emailContent" class="inputBox" rows="10" id="EditArticle_articleData"></textarea>
            <script language="javascript" src="/images/jquery/plugins/elrte-1.3/js/elrte.min.js" type="text/javascript"></script>
            <script language="javascript" src="/images/jquery/plugins/elrte-1.3/js/i18n/elrte.fr.js" type="text/javascript"></script>
            <link href="/images/jquery/plugins/elrte-1.3/css/elrte.min.css" rel="stylesheet" type="text/css">
            <script language="javascript" type="text/javascript">
                var opts = {
                    cssClass : 'el-rte',
                    lang     : 'fr',
                    toolbar  : 'maxi',
                    doctype  : '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">', //'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">',
                    cssfiles : ['/images/jquery/plugins/elrte-1.3/css/elrte-inner.css']
                }
                jQuery('#EditArticle_articleData').elrte(opts);
            </script>

            <div style="height:10px"></div>
            <button type="submit" class="btn btn-success">Envoyer</button>
            <div style="height:30px"></div>
        </form>
    </#if>
