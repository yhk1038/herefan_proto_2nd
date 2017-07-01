/*
 *  카드 필터
 */

// 1. 라이브러리에서의 카드 필터
function getLibCards(fandom_id, method) {
    $('#toolbar .left_group li').removeClass('active');
    $('#toolbar li[data-filter="'+ method +'"]').addClass('active');


    var query = $.ajax({
        url: '/filter_by',
        data: {
            fandom_id: fandom_id,
            method: method
        }
    });

    query.done(function () {
        after_getCards();
    });
}

// 2. 마이페이지에서의 카드 필터
function getMyCards(_req) {
    $('.sortList').removeClass('active');
    $('#sortList-'+_req).addClass('active');
    $('#library').attr('style', 'min-height: 1000px');

    var query = $.ajax({
        url: '/sort_by/'+_req
    });

    query.done(function(){
        after_getCards();
    });
}



/*
 * 아직 쓰이지 않음(쓰다가 쓰이지 않음)
 */
$(document).ready(function () {

    //
    // Location : '/fandoms/:id'
    // Sort By DropDown
    $('.sorting-method').click(function () {
        var method = $(this).text();
        $method = $method + '-' + method;

        $(this).addClass('active');
        $('#sort-method').text(method);
        // fadeOutWholeCards();
        //
        // if (method === 'Latest') {
        //     fadeInBySelectedMethod('');
        // }
        //
        // if (method === 'Popular') {
        //     fadeInBySelectedMethod('');
        // }
        //
        // if (method === 'Unwatched') {
        //     fadeInBySelectedMethod(':not(.visited)');
        // } else if (method === 'Watched') {
        //     fadeInBySelectedMethod('.visited');
        // }
        //
        // if (method === 'Clipped') {
        //     fadeInBySelectedMethod('.clipped');
        // } else if (method === 'UnClipped') {
        //     fadeInBySelectedMethod(':not(.clipped)');
        // }
    });

    //
    // Location : '/fandoms/:id'
    // Filter By LeftLinks
    // $('.filter-type').click(function () {
    //     var type = $(this).text();
    //     var typeNum = $(this).attr('value');
    //     var k = $(this).attr('class').indexOf('active');
    //
    //     $('.filter-type').removeClass('active');
    //
    //     if (k >= 0) {
    //         // fadeOutWholeCards();
    //         // fadeInByFilteringType('');
    //     }
    //
    //     if (k < 0) {
    //         $(this).addClass('active');
    //         // fadeOutWholeCards();
    //         // fadeInByFilteringType(typeNum);
    //     }
    // });
});

// function fadeOutWholeCards() {
//     $('.blog-post')
//         .fadeOut()
//         .parent('.task').toggle(false);
// }
//
// function fadeInBySelectedMethod(method) {
//     $('.blog-post'+method)
//         .fadeIn()
//         .parent('.task').toggle(true);
// }

// function fadeInByFilteringType(type) {
//     var typeTag = '';
//
//     if (type !== '') {
//         typeTag += '.type-'+type;
//     }
//
//     $('.blog-post'+typeTag)
//         .fadeIn()
//         .parent('.task').toggle(true);
// }


//
// Sorting Functions

// function sortDefault() {
//
// }