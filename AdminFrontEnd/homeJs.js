$(document).ready(function () {
    $('.completedTask').click(function () {
        if($(this).text() == 'Yes') {
            $(this).text('No');
        }
        else {
            $(this).text('Yes');
        }
    })
});