// 위키 인덱싱 박스 스크롤 전환
$(window).on('scroll', function () {
    var scroll = $(this).scrollTop();

    if (scroll > 320) {
        $('#contents_widget-box').attr('style', 'position: fixed !important; top: 150px;');
    } else {
        $('#contents_widget-box').attr('style', 'position: initial !important');
    }
});