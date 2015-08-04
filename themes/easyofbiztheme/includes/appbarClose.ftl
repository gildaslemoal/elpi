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

<#if (requestAttributes.externalLoginKey)?exists><#assign externalKeyParam = "?externalLoginKey=" + requestAttributes.externalLoginKey?if_exists></#if>
<#if (externalLoginKey)?exists><#assign externalKeyParam = "?externalLoginKey=" + requestAttributes.externalLoginKey?if_exists></#if>
<#assign ofbizServerName = application.getAttribute("_serverId")?default("default-server")>
<#assign contextPath = request.getContextPath()>
<#assign displayApps = Static["org.ofbiz.base.component.ComponentConfig"].getAppBarWebInfos(ofbizServerName, "main")>
<#assign displaySecondaryApps = Static["org.ofbiz.base.component.ComponentConfig"].getAppBarWebInfos(ofbizServerName, "secondary")>

<#if userLogin?has_content>
    <!-- Navigation -->
            </ul>
        </li>
      <#assign beforeSelected = true>
      <#list displayApps as display>
        <#assign thisApp = display.getContextRoot()>
        <#assign permission = true>
        <#assign selected = false>
        <#assign permissions = display.getBasePermission()>
        <#assign menuStyle = display.getMenuStyle()>
        <#list permissions as perm>
          <#if (perm != "NONE" && !security.hasEntityPermission(perm, "_VIEW", session))>
            <#-- User must have ALL permissions in the base-permission list -->
            <#assign permission = false>
          </#if>
        </#list>
        <#if permission == true>
          <#if thisApp == contextPath || contextPath + "/" == thisApp>
            <#assign selected = true>
            <#assign beforeSelected = false>
          </#if>
          <#if beforeSelected == false && selected == false>
              <#assign thisApp = StringUtil.wrapString(thisApp)>
              <#assign thisURL = thisApp>
              <#if thisApp != "/">
                  <#assign thisURL = thisURL + "/control/main">
              </#if>
              <#if layoutSettings.suppressTab?exists && display.name == layoutSettings.suppressTab>
                  <#-- do not display this component-->
              <#else>
            <li<#if selected> class="active"</#if>>
                <a href="${thisURL}${StringUtil.wrapString(externalKeyParam)}"<#if uiLabelMap?exists> title="${uiLabelMap[display.description]}"><i class="${menuStyle}"></i> ${uiLabelMap[display.title]}<#else> title="${display.description}"><i class="${menuStyle}"></i> ${display.title}</#if><span class="fa arrow"></span></a>
            </li>
              </#if>
          </#if>
        </#if>
      </#list>
      <#list displaySecondaryApps as display>
      <#assign thisApp = display.getContextRoot()>
      <#assign permission = true>
      <#assign selected = false>
      <#assign permissions = display.getBasePermission()>
      <#list permissions as perm>
        <#if (perm != "NONE" && !security.hasEntityPermission(perm, "_VIEW", session))>
          <#-- User must have ALL permissions in the base-permission list -->
          <#assign permission = false>
        </#if>
      </#list>
        <#if permission == true>
          <#if thisApp == contextPath || contextPath + "/" == thisApp>
            <#assign selected = true>
            <#assign beforeSelected = false>
          </#if>
          <#if beforeSelected == false && selected == false>
            <#assign thisApp = StringUtil.wrapString(thisApp)>
            <#assign thisURL = thisApp>
            <#if thisApp != "/">
              <#assign thisURL = thisURL + "/control/main">
            </#if>
        <li<#if selected> class="active"</#if>>
            <a href="${thisURL}${StringUtil.wrapString(externalKeyParam)}"<#if uiLabelMap?exists> title="${uiLabelMap[display.description]}"><i class="${menuStyle}"></i> ${uiLabelMap[display.title]}<#else> title="${display.description}"><i class="${menuStyle}"></i> ${display.title}</#if><span class="fa arrow"></span></a>
        </li>
          </#if>
      </#if>
    </#list>
                </ul>
            </div>
            <!-- /.sidebar-collapse -->
        </div>
        <!-- /.navbar-static-side -->
    </nav>
</#if>
    <div id="page-wrapper">
