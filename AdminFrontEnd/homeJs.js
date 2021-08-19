$(document).ready(function () {
    $('.removeOnClick').click(function () {
        $(this).parent().parent().remove()
    })
});

//
// $.post("demo_test.asp", function(data, status){
//     alert("Data: " + data + "\nStatus: " + status);
// });