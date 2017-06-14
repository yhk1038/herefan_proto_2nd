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
    // 링크 카드 Like 기능
    $('.actions_box .maum').click(function (event) {
        var btn     = $(this);
        var user_id = $(this).attr('action_noiser');
        var target_id = $(this).attr('action_target');
        var method  = $(this).attr('action_status');
        var url     = '';

        if (user_id !== '0'){
            if (method === 'post'){
                url += '/action/likes.json'
            } else if (method === 'delete'){
                url += '/action/likes/'+target_id+'.json'
            }

            var req = $.ajax({
                url: url,
                method: method,
                data: {
                    like: {
                        user_id: user_id,
                        link_id: target_id
                    },
                    authenticity_token: _hf_
                }
            });

            req.done(function (result) {
                console.log(result);
                var icon = $('#actions_'+result.data.link_id+' .maum span.zmdi');
                var counter = $('#actions_'+result.data.link_id+' .maum span.counter');

                if (result.status === 'created'){
                    icon.removeClass('zmdi-favorite-outline').addClass('zmdi-favorite');
                    counter.text(result.count);
                    btn
                        .attr('action_status', 'delete')
                        .attr('action_target', result.data.id);

                } else if (result.status === 'deleted'){
                    icon.removeClass('zmdi-favorite').addClass('zmdi-favorite-outline');
                    counter.text(result.count);
                    btn
                        .attr('action_status', 'post')
                        .attr('action_target', result.data.link_id);
                }
            });

            req.fail(function (result) { console.log('failed'); alert(result.responseText) })

        } else {
            alert('you should login to use like button')
        }

        event.stopPropagation();
    });


    //
    // 링크 카드 Clip 기능
    $('.clip_btn').click(function (event) {
        var btn = $(this);
        var user_id = $(this).attr('action_noiser');
        var target_id = $(this).attr('action_target');
        var method  = $(this).attr('action_status');
        var url     = '';

        if (user_id !== '0'){
            if (method === 'post'){
                url += '/action/clips.json'
            } else if (method === 'delete'){
                url += '/action/clips/'+target_id+'.json'
            }

            var req = $.ajax({
                url: url,
                method: method,
                data: {
                    clip: {
                        user_id: user_id,
                        link_id: target_id
                    },
                    authenticity_token: _hf_
                }
            });

            req.done(function (result) {
                console.log(result);
                var grand = $('#link_'+result.data.link_id);

                if (result.status === 'created'){
                    grand.addClass('clipped');
                    btn
                        .attr('action_status', 'delete')
                        .attr('action_target', result.data.id);

                } else if (result.status === 'deleted'){
                    grand.removeClass('clipped');
                    btn
                        .attr('action_status', 'post')
                        .attr('action_target', result.data.link_id);
                }
            });

            req.fail(function (result) { console.log('failed'); alert(result.responseText) })

        }

        event.stopPropagation()
    });

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
});

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
        console.log(result);
        preloader.hide();
        $("#saveBtn").show();
        $('#msg-wrap').show();
    });

    ajax.fail(function (result) {
        console.log('fail');
        console.log(result.responseText);
        var txt = result.responseText;
        eval(txt);
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
            target;

            if (option === 'no-text') {
                target
                    .attr('onclick', 'followBtn("cancel", ' + result.id + ', ' + channel_id + ', ' + user_id + ', "no-text")');
                target.children('span')
                    .removeClass('zmdi-favorite-outline')
                    .addClass('zmdi-favorite')
                    .addClass('c-pink');
            } else {
                target
                    .attr('onclick', 'followBtn("cancel", ' + result.id + ', ' + channel_id + ', ' + user_id + ', "")')
                    .addClass('bgm-red')
                    .text('FOLLOWED');
            }

            var counter = $('#follower_count_' + channel_id);
            var count = parseInt(counter.text()) + 1;
            counter.text(count);
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
                .attr('onclick', 'followBtn("follow", 0, '+ channel_id +', '+ user_id +', "no-text")');
            target.children('span')
                .removeClass('zmdi-favorite')
                .addClass('zmdi-favorite-outline')
                .removeClass('c-pink');
        } else {
            target
                .attr('onclick', 'followBtn("follow", 0, '+ channel_id +', '+ user_id +', "")')
                .removeClass('bgm-red')
                .text('FOLLOW');
        }

        var counter = $('#follower_count_' + channel_id);
        var count = parseInt(counter.text()) - 1;
        counter.text(count);
    })
}


// UTILITY Group
// goTopScroll
function goTopScroll() {
    $('html, body').animate({scrollTop: 0 }, 'slow');
}