$(document).ready(function () {
    $('.completedTask').click(function () {
        $(this).parent().parent().remove()
    })
});