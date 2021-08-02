$(document).ready(function () {
    $('.removeOnClick').click(function () {
        $(this).parent().parent().remove()
    })
});