//= require ./lib/smoothwheel.js
//= require_tree ./feature/.

$(document).ready(function () {

    //
    // 초기 설정 그룹
    // 1. 웨이브 효과 없애기
    $('.no-waves').removeClass('waves-effect');

    // 2. 부드러운 스크롤
    // $('body:not(.modal-open)').smoothWheel();

    //
    // 상단 네비게이션 전환
    var header = $('#header');
    var myfandoms = $('#follow_list_box');
    $(window).scroll(function () {
        var scroll = $(this).scrollTop();

        if (scroll > 190) {
            header.addClass('init_header');
            myfandoms.addClass('scrolled');
        } else {
            header.removeClass('init_header');
            myfandoms.removeClass('scrolled');
        }

    });

    $(window).scroll(function () {
        var scroll = $(this).scrollTop();

        if (scroll > 320) {
            $('#contents_widget-box').attr('style', 'position: fixed !important; top: 150px;');
        } else {
            $('#contents_widget-box').attr('style', 'position: initial !important');
        }
    });

    // (무한 스크롤) 화면이 최하단에 닿았을 때
    $(window).scroll(function () {
        if ($(window).scrollTop() === ($(document).height() - $(window).height())) {

            var wrapper = $('#libraries_wrapper');
            var load_count  = $load_count;
            var req         = wrapper.data('req');
            var method      = '&method=' + $method;
            // console.log('load count: ', load_count);
            // console.log('method: ', method);

            if (wrapper !== undefined && load_count !== 'end'){
                var url = '/load_card/'+load_count+'?req='+req + method;
                call_card_append(url);
            }

            if (load_count === 'end'){
                // swal('End', load_count, 'info');
            }
        }
    });

    //
    // 링크 카드 미리보기 상태에서 메세지 입력
    $('#msg-content').keyup(function () {
        var value = $(this).val();
        $('#link_message').attr('value', value);
        $('#editable_msg').text(value);
    });
    $('#msg-content').blur(function () {
        var value = $(this).val();
        $('#link_message').attr('value', value);
        $('#editable_msg').text(value);
    });


    //
    // 링크 방문시 나의 방문 링크 기록으로 카운팅
    $('.link_wrapping_anchor.no-mute').click(function () {
        console.log('.link_wrapping_anchor clicked!!');
        // alert('.link_wrapping_anchor clicked!!');
        var id = $(this).attr('id');
        var user_id = $(this).attr('noiser');
        id = id.replace('link_','');

        $.ajax({
            url: '/utils/user_watched_this_link',
            method: 'post',
            data: {
                user_id: user_id,
                link_id: id,
                authenticity_token: _hf_
            }
        }).done(function (result) {
            console.log(result);
        });
    });


    //
    // 링크 업로드 시 typee 필드를
    // form tag 안쪽의 hidden field로 옮겨주는 함수
    $('.radio-link_typee').click(function () {
        var value = $(this).attr('vc');
        console.log(value);
        $('#link_typee').attr('value',value);
    });


    //
    // 회원 정보 수정 페이지 글자수 트래커
    // 닉네임 필드
    var nickname_input          = $('#checkNickNameLength_from');
    var nickname_lenght_counter = $('#checkNickNameLength_to');
    // 마지막 편집 없이 인풋 창을 이탈했을 때.
    nickname_input.blur(function () {
        var str = $('#checkNickNameLength_from').val();
        nickname_lenght_counter.text(str.length);
    });
    nickname_input.keyup(function (e) {
        var str = $('#checkNickNameLength_from').val();
        nickname_lenght_counter.text(str.length);
    });

    // 네임 필드
    var name_input          = $('#checkNameLength_from');
    var name_lenght_counter = $('#checkNameLength_to');
    // 마지막 편집 없이 인풋 창을 이탈했을 때.
    name_input.blur(function () {
        var str = $('#checkNameLength_from').val();
        name_lenght_counter.text(str.length);
    });
    name_input.keyup(function (e) {
        var str = $('#checkNameLength_from').val();
        name_lenght_counter.text(str.length);
    });

    //
    // 링크 카드의 마음/클립 액션 바인딩
    bindingActions();

    //
    // 공유 주소 복사 했을 때, 툴팁 띄우기.
    $('.url_copy').click(function () {
        $(this).addClass('hf-tooltip');
        $(this).hover(function () {
            $(this).removeClass('hf-tooltip');
        });
    });

    //
    // 의도치 않은 방문기록 방지
    $('.no-vl').hover(function () {
        $('.link_wrapping_anchor').removeClass('no-mute');
    }, function () {
        $('.link_wrapping_anchor').addClass('no-mute');
    });
    $('.share_box').click(function (e) {
        var btn = $(this).find('.no-vl:not(.dropdown-menu)');
        var status = btn.attr('aria-expanded');
        if (status === 'true'){
            btn.attr('aria-expanded', 'false');
            $(this).removeClass('open');

        } else if (status === 'false'){
            btn.attr('aria-expanded', 'true');
            $(this).addClass('open');
        }

        e.stopPropagation();
    });
});

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


function hey_login() {
    swal({
        title: 'Oops! Please Login First!',
        type: 'info',
        showCloseButton: true,
        showCancelButton: false,
        confirmButtonText: 'Ok HereFan :D'
    });
}

function gogo_crawler() {
    var value = $('#link_url').val();
    console.log(value);

    var preloader = $('#linkModalPreLoader');
    $('#card_preview_point .super').remove();
    preloader.show();

    var ajax =  $.ajax({
        url: '/crawler/uri_spy',
        method: 'post',
        data: {
            url: value,
            authenticity_token: _hf_
        }
    });
    ajax.done(function (result) {
        console.log('success');
        // console.log(result);
        preloader.hide();
        $("#saveBtn").show();
        $('#msg-wrap').show();
    });

    ajax.fail(function (result) {
        console.log('fail');
        console.log(result);
        swal({
            title: 'Oops...!',
            text: 'I\'m still young, but studying hard! Plz expect the next update :)!',
            imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTxkPS1qLw-tFrTIJA7b_rsmOi0q5QrzdJkfGfNCY5jTx-bVKEb_A',
            imageWidth: 400,
            imageHeight: 400,
            animation: false
        });
        console.log(result.responseText);
        // var txt = result.responseText;
        // eval(txt);
        preloader.hide();
        $("#saveBtn").hide();
        $('#msg-wrap').hide();
    });
}

function followBtn(command, myfandom_id, channel_id, user_id, option) {
    if (command === 'follow') {
        ajax_follow_add(channel_id, user_id, option)
    } else if (command === 'cancel') {
        ajax_follow_cancel(channel_id, user_id, myfandom_id, option)
    }
}

function ajax_follow_add(channel_id, user_id, option) {
    $.ajax({
        url: '/myfandoms.json',
        method: 'post',
        data: {
            authenticity_token: _hf_,
            myfandom: {
                user_id: user_id,
                fandom_id: channel_id
            }
        }
    }).done(function (result) {
        var target = $('#channel_' + channel_id);

        if (result.id) {

            if (option === 'no-text') {
                // 플래닛 개별 페이지에서..
                target
                    .attr('onclick', 'followBtn("cancel", ' + result.id + ', ' + channel_id + ', ' + user_id + ', "no-text")')
                    .addClass('active');
                target.find('span.zmdi').addClass('zmdi-star');
                target.find('span:not(.zmdi)').addClass('active').text('following');
            } else {
                // 플래닛 팔로우 페이지에서..
                var card = $('.follow_card-'+channel_id);
                var cancelBtn = $('#channel_' + channel_id + '.followed');
                var followBtn = $('#channel_' + channel_id + ':not(.followed)');

                card.addClass('followed');
                cancelBtn.show();
                followBtn.hide();
                cancelBtn
                    .attr('onclick', 'followBtn("cancel", ' + result.id + ', ' + channel_id + ', ' + user_id + ', ""); return false;')
                    .html('<span class=\'zmdi zmdi-star\' style=\'font-size: 20px; position: relative; top: 2px;\'></span> following');
            }

            var counter = $('#follower_count_' + channel_id);
            var count = parseInt(counter.text()) + 1;
            counter.text(count);

            if(option === 'unfandom'){

                var how_many_counter = '';

            }
        }
    });
}

function ajax_follow_cancel(channel_id, user_id, myfandom_id, option) {
    $.ajax({
        url: '/myfandoms/'+ myfandom_id + '.json',
        method: 'delete',
        data: { authenticity_token: _hf_ }
    }).done(function (result) {
        var target = $('#channel_' + channel_id);

        if (option === 'no-text') {
            target
                .attr('onclick', 'followBtn("follow", 0, '+ channel_id +', '+ user_id +', "no-text")')
                .removeClass('active');
            target.find('span.zmdi').removeClass('zmdi-star');
            target.find('span:not(.zmdi)').removeClass('active').text('follow');
        } else {
            var card = $('.follow_card-'+channel_id);
            var cancelBtn = $('#channel_' + channel_id + '.followed');
            var followBtn = $('#channel_' + channel_id + ':not(.followed)');

            card.removeClass('followed');
            cancelBtn.hide();
            followBtn.show();
        }

        var counter = $('#follower_count_' + channel_id);
        var count = parseInt(counter.text()) - 1;
        counter.text(count);

        if(option === 'unfandom'){

            var how_many_counter = '';

        }
    })
}


// UTILITY Group
// goTopScroll
function goTopScroll() {
    $('html, body').animate({scrollTop: 0 }, 'slow');
}

// display
// hey_follow
function hey_follow() {
    swal('Plz follow this Planet first!','','info');
}