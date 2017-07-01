// 무한 스크롤

// 트리거
$(window).on('scroll', function () {
    if ($(window).scrollTop() === ($(document).height() - $(window).height())) {

        var wrapper = $('#libraries_wrapper');
        var load_count  = $load_count;
        var req         = wrapper.data('req');
        var method      = '&method=' + $method;
        // console.log('load count: ', load_count);
        // console.log('method: ', method);

        if (wrapper !== undefined && req !== undefined && load_count !== 'end'){
            var url = '/load_card/'+load_count+'?req='+req + method;
            call_card_append(url);
        }

        if (load_count === 'end'){
            // swal('End', load_count, 'info');
        }
    }
});

// 추가적인 링크 카드를 요청.
// 요청이 끝나고 반환된 카드들은 각 랜더링된 .js.erb 파일 에서 제어.
function call_card_append(url) {
    var preloader = $('#call_card_preloader');
    preloader.show();

    var req = $.ajax({
        url: url,
        method: 'get'
    });

    req.success(function (data) {
        preloader.hide();
    });

    req.fail(function (data) {
        preloader.hide();
        swal('Request fail :(', 'something went wrong! check your internet', 'error');
    });
}
