                              <#if address?has_content>
                                  <#if address.toName?exists>
                                    <fo:block>${address.toName}</fo:block>
                                  </#if>
                                  <#if address.attnName?exists>
                                      <fo:block>${address.attnName}</fo:block>
                                  </#if>
                                  <#if !address.toName?exists && !address.attnName?exists>
                                      <#assign partyContactMech =  Static["org.ofbiz.entity.util.EntityUtil"].getFirst(address.getRelated("PartyContactMech"))>
                                      <#assign party = partyContactMech.getRelatedOne("Party")>
                                      <#if party.get("partyTypeId") == "PARTY_GROUP">
                                      		<#assign partyGroup = party.getRelatedOne("PartyGroup")>
                                      		<fo:block>${partyGroup.groupName?if_exists}</fo:block>
                                      <#elseif party.get("partyTypeId") == "PERSON">
                                      		<#assign personn = party.getRelatedOne("PERSON")>
                                      		<fo:block>${person.salutation?if_exists} ${person.firstName?if_exists} ${person.lastName?if_exists}</fo:block>
                                      </#if>
                                  </#if>
                                      <fo:block>${address.address1?if_exists}</fo:block>
                                  <#if address.address2?exists>
                                      <fo:block>${address.address2}</fo:block>
                                  </#if>
                                  <fo:block>${address.postalCode?if_exists} ${address.city?if_exists}</fo:block>
                                  <#if address.countryGeoId?exists>
                                      <#assign country = address.getRelatedOne("CountryGeo")>
                                      <fo:block>${country?if_exists.get("geoCode")} ${country?if_exists.get("geoName",locale)}</fo:block>
                                  </#if>
                              </#if>
