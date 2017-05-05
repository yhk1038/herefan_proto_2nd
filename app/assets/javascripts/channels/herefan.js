$(document).ready(function () {

    //
    // 상단 네비게이션 전환
    var header = $('#header');
    $(window).scroll(function () {
        var scroll = $(this).scrollTop();

        if (scroll > 190) {
            header.addClass('init_header')
        } else {
            header.removeClass('init_header')
        }

    });


    //
    // 링크 카드 미리보기 상태에서 메세지 입력
    $('#msg-content').keydown(function () {
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
    // 회원 정보 수정 페이지 글자수 트래커
    // 닉네임 필드
    var nickname_input          = $('#checkNickNameLength_from');
    var nickname_lenght_counter = $('#checkNickNameLength_to');
    // 마지막 편집 없이 인풋 창을 이탈했을 때.
    nickname_input.blur(function () {
        var str = $('#checkNickNameLength_from').val();
        nickname_lenght_counter.text(str.length);
    });
    // 특정 키를 클릭 하는 경우의 이벤트를 잡아서 처리.
    nickname_input.keydown(function (e) {
        if (e.keyCode == 9) {
            // Clicked 'Tab'
            var str = $('#checkNickNameLength_from').val();
            nickname_lenght_counter.text(str.length);
        }
    });

    // 네임 필드
    var name_input          = $('#checkNameLength_from');
    var name_lenght_counter = $('#checkNameLength_to');
    // 마지막 편집 없이 인풋 창을 이탈했을 때.
    name_input.blur(function () {
        var str = $('#checkNameLength_from').val();
        name_lenght_counter.text(str.length);
    });
    // 특정 키를 클릭 하는 경우의 이벤트를 잡아서 처리.
    name_input.keydown(function (e) {
        if (e.keyCode == 9) {
            // Clicked 'Tab'
            var str = $('#checkNameLength_from').val();
            name_lenght_counter.text(str.length);
        }
    });

});

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
        console.log(result);
        preloader.hide();
        $("#saveBtn").hide();
        $('#msg-wrap').hide();
    });
}

function followBtn(command, id, channel_id, user_id) {
    if (command === 'follow') {
        ajax_follow_add(channel_id, user_id)
    } else if (command === 'cancel') {
        ajax_follow_cancel(channel_id, user_id, id)
    }
}

function ajax_follow_add(channel_id, user_id) {
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
            target
                .addClass('bgm-red')
                .attr('onclick', 'followBtn("cancel", ' + result.id + ', ' + channel_id + ', ' + user_id + ')')
                .text('FOLLOWED');

            var counter = $('#follower_count_' + channel_id);
            var count = parseInt(counter.text()) + 1;
            counter.text(count);
        }
    });
}

function ajax_follow_cancel(channel_id, user_id, id) {
    $.ajax({
        url: '/myfandoms/'+ id + '.json',
        method: 'delete',
        data: { authenticity_token: _hf_ }
    }).done(function (result) {
        var target = $('#channel_' + channel_id);

        target
            .removeClass('bgm-red')
            .attr('onclick', 'followBtn("follow", 0, '+ channel_id +', '+ user_id +')')
            .text('FOLLOW');

        var counter = $('#follower_count_' + channel_id);
        var count = parseInt(counter.text()) - 1;
        counter.text(count);
    })
}