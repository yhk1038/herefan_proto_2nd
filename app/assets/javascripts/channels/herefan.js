//= require ./lib/smoothwheel.js
//= require_tree ./feature/.

function window_path() {
    var baseUri = document.baseURI;
    var domain = document.domain;
    if ( domain === 'localhost'){
        domain = 'localhost:3000'
    }
    var path = baseUri.replace(domain, '*split*').split('*split*')[1];
    if (path.charAt(path.length-1) === '#'){
        path = path.slice(0, -1)
    }
    return path
}

$(document).ready(function () {

    //
    // 초기 설정 그룹
    // 1. 웨이브 효과 없애기
    $('.no-waves').removeClass('waves-effect');

    // 2. 부드러운 스크롤
    // $('body:not(.modal-open)').smoothWheel();

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

            if (wrapper !== undefined && req !== undefined && load_count !== 'end'){
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
    $('#msg-content-edit').keyup(function () {
        var value = $(this).val();
        $('#link_message-edit').attr('value', value);
        $('#editable_msg').text(value);
    });
    $('#msg-content-edit').blur(function () {
        var value = $(this).val();
        $('#link_message-edit').attr('value', value);
        $('#editable_msg').text(value);
    });


    //
    // 링크 방문시 나의 방문 링크 기록으로 카운팅
    $('.link_wrapping_anchor.no-mute').click(function () {
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
            if (result !== 'no_user'){
                $('#link_'+id).addClass('visited');
                var counter = $('#link_'+id).find('.viewcount .counter');
                var count = parseInt(counter.text()) + 1;
                counter.text(count);
            }
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
    $('.radio-link_typee-edit').click(function () {
        var value = $(this).attr('vc');
        console.log(value);
        $('#link_typee-edit').val(value);
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
    // $('.url_copy').click(function () {
    //     $(this).addClass('hf-tooltip');
    //     $(this).hover(function () {
    //         $(this).removeClass('hf-tooltip');
    //     });
    // });

    //
    // 의도치 않은 방문기록 방지
    $('.no-vl').hover(function () {
        $('.link_wrapping_anchor').removeClass('no-mute');
    }, function () {
        $('.link_wrapping_anchor').addClass('no-mute');
    });
    // 드롭다운 박스 클릭시 드롭다운 활성제거 방지
    $('.no-vl.dropdown-menu').hover(function () {
        $(this).attr('data-prevent','true');
        $(this).click(function (e) {
            e.stopPropagation();
        })
    }, function () {
        $(this).attr('data-prevent','false');
    });
    // 공유박스 드롭다운
    $('.share_box').click(function (e) {
        var btn = $(this).find('.no-vl:not(.dropdown-menu)');
        var dropdown_menu = $(this).find('.no-vl.dropdown-menu');
        var hovered_dropdown = dropdown_menu.data('prevent');
        var status = btn.attr('aria-expanded');

        $('.no-vl:not(.dropdown-menu)').attr('aria-expanded', 'false');
        $('.dropdown').removeClass('open');

        if (status === 'true' && hovered_dropdown !== true){
            console.log(hovered_dropdown);
            btn.attr('aria-expanded', 'false');
            $(this).removeClass('open');

        } else if (status === 'false'){
            btn.attr('aria-expanded', 'true');
            $(this).addClass('open');
        }

        e.stopPropagation();
    });
    // more 버튼 드롭다운
    $('.moreBtn li.dropdown').click(function (e) {
        var btn = $(this).find('.no-vl:not(.dropdown-menu)');
        var status = btn.attr('aria-expanded');

        $('.no-vl:not(.dropdown-menu)').attr('aria-expanded', 'false');
        $('.dropdown').removeClass('open');

        if (status === 'true'){
            btn.attr('aria-expanded', 'false');
            $(this).removeClass('open');
        } else if (status === 'false'){
            btn.attr('aria-expanded', 'true');
            $(this).addClass('open');
        }

        e.stopPropagation();
        return false;
    });
});

// 클립보드에 공유 주소 복사
// 복사 되었음을 툴팁으로 알림.
function copyToClipboard(element) {
    // 클립보드 복사
    var $temp = $("<input>");
    $("body").append($temp);
    $temp.val($(element).text()).select();
    document.execCommand("copy");
    $temp.remove();

    // 툴팁 출현
    var copyBtn = $('.url_copy[onclick="copyToClipboard(\''+element+'\')"]');
    copyBtn.addClass('hf-tooltip');
    copyBtn.hover(function () {
        copyBtn.removeClass('hf-tooltip');
    });
}

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
    //console.log(value);

    var preloader = $('#linkModalPreLoader');
    $('#card_preview_point .super').remove();
    preloader.show();
    $('#reload_url_btn.after').addClass('running');

    var ajax =  $.ajax({
        url: '/crawler/uri_spy',
        method: 'post',
        data: {
            url: value,
            authenticity_token: _hf_
        }
    });
    ajax.done(function (result) {
        // console.log('success');
        // console.log(result);
        preloader.hide();
        $('#reload_url_btn.after').removeClass('running');
        $("#saveBtn").show();
        $('#msg-wrap').show();
    });

    ajax.fail(function (result) {
        console.log('fail');
        //console.log(result);
        swal({
            title: 'Oops...!',
            text: 'I\'m still young, but studying hard! Plz expect the next update :)!',
            imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTxkPS1qLw-tFrTIJA7b_rsmOi0q5QrzdJkfGfNCY5jTx-bVKEb_A',
            imageWidth: 400,
            imageHeight: 400,
            animation: false
        });
        // console.log(result.responseText);
        // var txt = result.responseText;
        // eval(txt);
        preloader.hide();
        $('#reload_url_btn.after').removeClass('running');
        $("#saveBtn").hide();
        $('#msg-wrap').hide();
    });
}

function gogo_crawler_edit() {
    var value = $('#link_url-edit').val();
    console.log(value);

    var preloader = $('#linkModalPreLoader-edit');
    $('#card_preview_point-edit .super').remove();
    preloader.show();
    $('#reload_url_btn-edit.after').addClass('running');

    var ajax =  $.ajax({
        url: '/crawler/uri_spy?edit=true',
        method: 'post',
        data: {
            url: value,
            authenticity_token: _hf_
        }
    });
    ajax.done(function (result) {
        // console.log('success');
        // console.log(result);
        preloader.hide();
        $('#reload_url_btn-edit.after').removeClass('running');
        $("#saveBtn-edit").show();
        $('#msg-wrap-edit').show();
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
        // console.log(result.responseText);
        // var txt = result.responseText;
        // eval(txt);
        preloader.hide();
        $('#reload_url_btn-edit.after').removeClass('running');
        $("#saveBtn-edit").hide();
        $('#msg-wrap-edit').hide();
    });
}

function open_edit_modal(link_id) {
    var link_url = $('#link_'+link_id).find('.link-url').text();
    $('#link_url-edit').val(link_url);
    gogo_crawler_edit();

    var form_path = '/links/'+link_id;
    $('#edit_link_form').attr('action',form_path);

    var typee = $('#link_'+link_id).data('typee');
    $('.radio-link_typee-edit').find('input[checked="checked"]').removeAttr('checked');
    $('.radio-link_typee-edit[vc="'+typee+'"]').find('input').attr('checked','checked');

    var description = $('#link_'+link_id).find('.msg').text();
    $('#msg-content-edit').val(description);
    $('#editable_msg').text(description);
    $('#link_message-edit').val(description);
    //console.log(description);


    $('#edit_link_modal').modal({
        backdrop: true,
        keyboard: true
    });
    return false
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