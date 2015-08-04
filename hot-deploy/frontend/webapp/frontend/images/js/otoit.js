var divPrecedent = document.getElementById('content-products');
function visibilite(divId) {
    divPrecedent.style.display = 'none';
    divPrecedent = document.getElementById(divId);
    divPrecedent.style.display = 'inline';
}
