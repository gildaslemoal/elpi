<!DOCTYPE html>
<html>
<head>
    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type'/>
</head>
<body style="width:725px;margin:auto;">
<p>
    <img src="${baseSecureUrl?if_exists}/assets/include/header.png">

<h3 style="BORDER-LEFT:#e8e6e0 1px solid;PADDING-BOTTOM:0px;BACKGROUND-COLOR:#d9171f;MARGIN:0px;PADDING-LEFT:20px;PADDING-RIGHT:10px;FONT-FAMILY:Arial,Helvetica,sans-serif;COLOR:white;FONT-SIZE:14px;BORDER-RIGHT:#e8e6e0 1px solid;PADDING-TOP:0px">Bienvenue
    chez O'Toit </h3></td></tr>
<tr>
    <td style="PADDING-BOTTOM:2px;PADDING-LEFT:10px;PADDING-RIGHT:10px;PADDING-TOP:2px" bgcolor="white"><p align="left">Bonjour, </p>

        <p align="left">Toute l'équipe d'O'Toit Perigueux vous remercie de votre inscription sur notre site&nbsp;
            <a style="COLOR:#d9171f" href="#" target="_blank">http://www.O-toit.fr</a>&nbsp; et pour tout l'intérêt que vous nous portez.
        </p>
        <img src="${baseSecureUrl?if_exists}/assets/include/background_email.jpg">


        <table style="PADDING-BOTTOM:0px;PADDING-LEFT:20px;PADDING-RIGHT:10px;FONT-FAMILY:Arial,Helvetica,sans-serif;FONT-SIZE:11px;PADDING-TOP:20px" summary="" align="center" cellpadding="0" cellspacing="0" width="500">
            <tbody>
            <tr>
                <th style="TEXT-ALIGN:left;PADDING-BOTTOM:2px;BACKGROUND-COLOR:#e2e6e7;PADDING-LEFT:10px;PADDING-RIGHT:10px;FONT-FAMILY:Arial,Helvetica,sans-serif;FONT-SIZE:11px;FONT-WEIGHT:bold;PADDING-TOP:2px" colspan="2">
                    Pour Réinitialiser votre mot de passe
                </th>
            </tr>
            <tr>
                <th style="PADDING-BOTTOM:2px;BACKGROUND-COLOR:#f6f4ee;PADDING-LEFT:10px;PADDING-RIGHT:10px;FONT-WEIGHT:normal;PADDING-TOP:2px" width="41%">
                    <div align="left">Veuillez suivre ce lien : </div>
                </th>
            </tr>
            <td style="PADDING-BOTTOM:2px;BACKGROUND-COLOR:#f6f4ee;PADDING-LEFT:10px;PADDING-RIGHT:10px;PADDING-TOP:2px" width="59%">
                <a href="${baseSecureUrl?if_exists}/frontend/control/requestPasswordReset?verifyHash=${parameters.verifyHash}">${baseSecureUrl?if_exists}/frontend/control/requestPasswordReset?verifyHash=${parameters.verifyHash}</a>
            </td>
            <tr>
                <th style="PADDING-BOTTOM:2px;BACKGROUND-COLOR:#f6f4ee;PADDING-LEFT:10px;PADDING-RIGHT:10px;FONT-WEIGHT:normal;PADDING-TOP:2px">
                    <div align="left">Valable jusqu'au :<#if parameters.expireDate?has_content>${parameters.expireDate?string("dd/MM/yyyy à HH:mm")}</#if></div>
                </th>
            </tr>
            </tbody>
        </table>
        <p>
            Pour toute question, remarque ou suggestion, n'hésitez pas à contacter notre service support au fournisseurs par mail à
            <a style="COLOR:#d9171f" href="mailto:supplier-support@unionsmarket.com" target="_blank">supplier-support@unionsmarket.com</a>
            ou par téléphone au 05 77 77 77 du  lundi au samedi de 08h30 à 20h30 <span>(prix d'un appel local).</span>
        </p>
        <p>A bientôt chez O TOit Perigueux<br></p>
        <p align="left">
            <strong>O'toit vous remercie de votre confiance.</strong> <br>Pour plus d'informations,
            rendez-vous dans la rubrique <a style="COLOR:#d9171f" href="#" target="_blank">Vos questions</a>
        </p>
        <p>&nbsp;</p>
        <img src="${baseSecureUrl?if_exists}/assets/include/footer.png">
        </p></br>
</body>
</html>
