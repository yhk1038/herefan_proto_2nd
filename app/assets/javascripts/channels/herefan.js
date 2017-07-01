//= require ./lib/smoothwheel.js
//= require_tree ./feature/.



/*
 * 페이지 로딩 시
 * 초기 설정 그룹
 * ===========================
 */

$(document).ready(function () {

    // 카드 & 그리드 셋업
    myGridALicious(cardGridCalculator());
    bindingActions();
    $('#grid_waiting').fadeOut(1500);

    // 웨이브 효과 없애기
    $('.no-waves').removeClass('waves-effect');

    // 부드러운 스크롤
    // $('body:not(.modal-open)').smoothWheel();

});