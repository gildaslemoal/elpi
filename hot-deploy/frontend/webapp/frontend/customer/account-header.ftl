<#if party?exists>

    <div style="height:20px"></div>
    <div class="account-header">
        <div class="actor pull-right"><strong>Membre</strong><br/>
            <div class="actor-subtitle pull-right">${uiLabelMap.FrontEndSince} ${creatingAccountDate}</div>
        </div>
        <i class="fa fa-user account-picture text-center"></i>
        <h1>${person.firstName?if_exists} ${person.lastName?if_exists}</h1>
    </div>
</#if>