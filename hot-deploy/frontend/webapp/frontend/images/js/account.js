window.onload = function() {
    var myUri = document.URL.match('#.*').toString().substring(1) ;
    activeElement(myUri);
}
var accountMenu = document.getElementById('account-menu');
function activeElement(divId) {
    var menuList = accountMenu.getElementsByClassName('active');
    var informationBlock = document.getElementsByClassName(menuList[0].getAttribute('id'));
    informationBlock[0].style.display = 'none';
    informationBlock = document.getElementsByClassName('myInformation-modify');
    informationBlock[0].style.display = 'none';
    menuList[0].classList.remove('active');
    document.getElementById(divId).classList.add('active');
    informationBlock = document.getElementsByClassName(divId);
    informationBlock[0].style.display = 'block';
}

function modifyMyInformation() {
    document.getElementById("myInformation-readOnly").style.display = 'none';
    document.getElementById("myInformation-modify").style.display = 'inline';
}
function saveMyInformation() {
    document.getElementById("myInformation-modify").style.display = 'none';
    document.getElementById("myInformation-readOnly").style.display = 'inline';
}
