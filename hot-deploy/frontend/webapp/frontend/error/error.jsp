<%@ page import="org.ofbiz.base.util.*" %>
<html>
<head>
    <title>Nous Citoyens | Erreur 404</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="stylesheet" href="/images/bootstrap/css/bootstrap.min.css" type="text/css"/>
    <link rel="stylesheet" href="/images/font-awesome-4.1.0/css/font-awesome.min.css" type="text/css"/>
    <link rel="stylesheet" href="/frontend/images/css/otoit.css" type="text/css"/>
</head>
<% String errorMsg = (String) request.getAttribute("_ERROR_MESSAGE_"); %>

<body>
<div class="container">
    <div style="height:200px"></div>
    <div class="panel panel-danger">
      <div class="panel-heading">
        <button class="btn btn-danger pull-right" onclick="showError()">D&eacute;tails...</button>
        <h3>Oups !!! Erreur 404</h3>
      </div>
      <div class="panel-body">
        <h2>Votre page n'a pas &eacute;t&eacute; trouv&eacute;e...</h2><a class="btn btn-success" href="main">retour &agrave; l'accueil</a>
      </div>
      <div id="error-detail" class="panel-footer" style="display:none">
        <p><%=UtilFormatOut.replaceString(errorMsg, "\n", "<br/>")%></p>
      </div>
    </div>
</div>
<script type="text/javascript">
function showError() {
    errorBlock = document.getElementById('error-detail');
    errorBlock.style.display = 'block';
}
</script>
</body>
</html>