function submitForm() {
    var value = document.getElementById('inputid').value;
    location.replace('./welcome/index.html?visitid=' + value);
}