function submitForm() {
    var value = document.getElementById('inputid').value;
    location.replace('./welcome?visitid=' + value);
}