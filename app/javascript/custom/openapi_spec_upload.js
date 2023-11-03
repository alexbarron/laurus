// Enforcing file extension requirements for OpenAPI spec uploads

document.addEventListener("turbo:load", function() {
    document.addEventListener("change", function(event) {
        var openapi_file = document.getElementById('openapi_spec').value.toUpperCase();
        console.log(openapi_file);
        var extension=".YML";
        var extension2=".YAML";
        if (openapi_file.indexOf(extension, openapi_file.length - extension.length) == -1||
        openapi_file.indexOf(extension2, openapi_file.length - extension2.length) == -1) {
            alert("File type not allowed,\nAllowed file types: *.yml,*.yaml");
            document.getElementById('openapi_spec').value='';
        }
    });
});


function check_file(){
    str=document.getElementById('fileToUpload').value.toUpperCase();
var extension=".YML";
var extension2=".YAML";
if(openapi_file.indexOf(extension, openapi_file.length - extension.length) == -1||
openapi_file.indexOf(extension2, openapi_file.length - extension2.length) == -1){
alert('File type not allowed,\nAllowed file: *.jpg,*.jpeg');
document.getElementById('fileToUpload').value='';
}
}