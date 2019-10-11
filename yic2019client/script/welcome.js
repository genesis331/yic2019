const urlParams = new URLSearchParams(window.location.search);
const myParam = urlParams.get('myParam');

function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, '\\$&');
    var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, ' '));
}

JsBarcode("#barcode-content", getParameterByName('visitid'), {
    format: "pharmacode",
    lineColor: "#000000",
    displayValue: false
  });

  window.onload = function() {
      document.getElementById('id-content').innerHTML = getParameterByName('visitid');
  }