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

<#-- Note Glm (16072015 : modification des groupes autour des lignes : 37, 70 et 56 pour les résultats suivants : modification du logo en haut à gauceh et des barre de recherches en haut d el'ihm) -->

<#if userLogin?has_content>
    <!-- Navigation -->
    <nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="<@ofbizUrl>dashboardDons</@ofbizUrl>">ELPI</a>
        </div>
        <ul class="nav navbar-top-links navbar-right">
            <li class="dropdown">
                <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                    <i class="fa fa-user fa-fw"></i> ${userLogin.userLoginId} <i class="fa fa-caret-down"></i>
                </a>
                <ul class="dropdown-menu dropdown-user">
                    <li><a href="/webtools/control/main"><i class="fa fa-wrench fa-fw"></i> ${uiLabelMap.Tools}</a></li>
                    <li class="divider"></li>
                    <li><a href="<@ofbizUrl>ListLocales</@ofbizUrl>"><i class="fa fa-flag fa-fw"></i> ${locale.getDisplayName(locale)}</a></li>
                    <li><a href="<@ofbizUrl>ListVisualThemes</@ofbizUrl>"><i class="fa fa-desktop fa-fw"></i> ${uiLabelMap.CommonVisualThemes}</a></li>
                    <li class="divider"></li>
                    <li><a href="/easyofbiz/control/logout"><i class="fa fa-sign-out fa-fw"></i> ${uiLabelMap.CommonLogout}</a></li>
                </ul>
                <!-- /.dropdown-user -->
            </li>
            <!-- /.dropdown -->
        </ul>
        <#--<ul class="nav navbar-top-links navbar-right">-->
            <#--<li class="sidebar-search">-->
                <#--<div class="input-group custom-search-form">-->
                    <#--<span class="input-group-addon"><i class="fa fa-users"></i></span>-->
                    <#--<input type="text" class="form-control" placeholder="Type Username...">-->
                    <#--<span class="input-group-btn">-->
                        <#--<button class="btn btn-default" type="button">-->
                            <#--<i class="fa fa-user"></i>-->
                        <#--</button>-->
                    <#--</span>-->
                <#--</div>-->
            <#--</li>-->
            <#--<li style="width:10px"/>-->
            <#--<li class="sidebar-search">-->
                <#--<div class="input-group custom-search-form">-->
                    <#--<span class="input-group-addon"><i class="glyphicon glyphicon-tags"></i></span>-->
                    <#--<input type="text" class="form-control" placeholder="Type a keyword...">-->
                    <#--<span class="input-group-btn">-->
                        <#--<button class="btn btn-default" type="button">-->
                            <#--<i class="fa fa-key"></i>-->
                        <#--</button>-->
                    <#--</span>-->
                <#--</div>-->
            <#--</li>-->
        <#--</ul>-->
        <!-- /.navbar-top-links -->
    
        <div class="navbar-default sidebar" role="navigation">
            <div class="sidebar-nav navbar-collapse">
                <ul class="nav" id="side-menu">
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
          <#if beforeSelected == true>
              <#if thisApp == contextPath || contextPath + "/" == thisApp>
                <#assign selected = true>
                <#assign beforeSelected = false>
              </#if>
              <#assign thisApp = StringUtil.wrapString(thisApp)>
              <#assign thisURL = thisApp>
              <#if thisApp != "/">
                  <#assign thisURL = thisURL + "/control/main">
              </#if>
              <#if layoutSettings.suppressTab?exists && display.name == layoutSettings.suppressTab>
                  <#-- do not display this component-->
              <#else>
            <li>
                <a href="${thisURL}${StringUtil.wrapString(externalKeyParam)}"<#if selected> class="active"</#if><#if uiLabelMap?exists> title="${uiLabelMap[display.description]}"><i class="${menuStyle}"></i> ${uiLabelMap[display.title]}<#else> title="${display.description}"><i class="${menuStyle}"></i> ${display.title}</#if><span class="fa arrow"></span></a>
              <#if selected>
                <ul class="nav nav-second-level collapse in">
              <#else>
        </li>
                </#if>
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
          <#if beforeSelected == true>
            <#if thisApp == contextPath || contextPath + "/" == thisApp>
              <#assign selected = true>
              <#assign beforeSelected = false>
            </#if>
            <#assign thisApp = StringUtil.wrapString(thisApp)>
            <#assign thisURL = thisApp>
            <#if thisApp != "/">
              <#assign thisURL = thisURL + "/control/main">
            </#if>
        <li>
            <a href="${thisURL}${StringUtil.wrapString(externalKeyParam)}"<#if selected> class="active"</#if><#if uiLabelMap?exists> title="${uiLabelMap[display.description]}"><i class="${menuStyle}"></i> ${uiLabelMap[display.title]}<#else> title="${display.description}"><i class="${menuStyle}"></i> ${display.title}</#if><span class="fa arrow"></span></a>
              <#if selected>
            <ul>
              <#else>
            </li>
              </#if>
          </#if>
      </#if>
    </#list>
</#if>

