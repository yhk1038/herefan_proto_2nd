$(document).ready(function (event) {
    console.log('loaded');

    var header = $('#header');
    // $('#libraries_wrapper .task').wookmark(option);

    $(window).scroll(function () {
        var scroll = $(this).scrollTop();

        if (scroll > 220) {
            header.addClass('init_header')
        } else {
            header.removeClass('init_header')
        }

    });
});

option = {
    align: 'center',
    autoResize: true,
    comparator: null,
    // container: $('#libraries_wrapper'),
    ignoreInactiveItems: true,
    fillEmptySpace: true,
    possibleFilters: [],
    resizeDelay: 50
};