// Enforcing file extension requirements for OpenAPI spec uploads

document.addEventListener("turbo:load", function() {
    document.addEventListener("change", function(event) {
        if (!hasExtension('openapi_spec',['.yml','.yaml'])) {
            alert("File type not allowed,\nAllowed file types: *.yml,*.yaml");
            document.getElementById('openapi_spec').value='';
        }
    });
});

function hasExtension(inputID, exts) {
    var fileName = document.getElementById(inputID).value;
    return (new RegExp('(' + exts.join('|').replace(/\./g, '\\.') + ')$', "i")).test(fileName);
}