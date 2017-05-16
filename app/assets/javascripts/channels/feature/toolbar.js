$(document).ready(function () {

    //
    // Location : '/fandoms/:id'
    // Sort By DropDown
    $('.sorting-method').click(function () {
        var method = $(this).text();

        $(this).addClass('active');
        $('#sort-method').text(method);
        fadeOutWholeCards();

        if (method === 'Latest') {
            fadeInBySelectedMethod('');
        }

        if (method === 'Popular') {
            fadeInBySelectedMethod('');
        }

        if (method === 'Unwatched') {
            fadeInBySelectedMethod(':not(.visited)');
        } else if (method === 'Watched') {
            fadeInBySelectedMethod('.visited');
        }

        if (method === 'Clipped') {
            fadeInBySelectedMethod('.clipped');
        } else if (method === 'UnClipped') {
            fadeInBySelectedMethod(':not(.clipped)');
        }
    });

    //
    // Location : '/fandoms/:id'
    // Filter By LeftLinks
    $('.filter-type').click(function () {
        var type = $(this).text();
        var typeNum = $(this).attr('value');
        var k = $(this).attr('class').indexOf('active');

        $('.filter-type').removeClass('active');

        if (k >= 0) {
            fadeOutWholeCards();
            fadeInByFilteringType('');
        }

        if (k < 0) {
            $(this).addClass('active');
            fadeOutWholeCards();
            fadeInByFilteringType(typeNum);
        }
    });
});

function fadeOutWholeCards() {
    $('.blog-post')
        .fadeOut()
        .parent('.task').toggle(false);
}

function fadeInBySelectedMethod(method) {
    $('.blog-post'+method)
        .fadeIn()
        .parent('.task').toggle(true);
}

function fadeInByFilteringType(type) {
    var typeTag = '';

    if (type !== '') {
        typeTag += '.type-'+type;
    }

    $('.blog-post'+typeTag)
        .fadeIn()
        .parent('.task').toggle(true);
}


//
// Sorting Functions

// function sortDefault() {
//
// }