/*
 * 팔로우
 * ============================
 * 참고 사항:
 *      1. 사용자(테이블: User) 와 Planet(테이블: Fandom) 사이에 팔로우 했는지를 기록/매개 하는 테이블은 Myfandom 이다.
 *      2. 요청될 url 의 Routing 은 Restful Guide 를 따른다.
 */

// 팔로우 버튼을 눌렀을 때.
function followBtn(command, myfandom_id, channel_id, user_id, option) {
    if (command === 'follow') { // 팔로우를 요청한 경우
        ajax_follow_add(channel_id, user_id, option)
    } else if (command === 'cancel') { // 팔로우 취소를 요청한 경우
        ajax_follow_cancel(channel_id, user_id, myfandom_id, option)
    }
}

// 팔로우를 요청한 경우
// 팔로우(Myfandom) 추가.
function ajax_follow_add(channel_id, user_id, option) {
    var req = $.ajax({
        url: '/myfandoms.json',
        method: 'post',
        data: {
            authenticity_token: _hf_,
            myfandom: {
                user_id: user_id,
                fandom_id: channel_id
            }
        }
    });

    req.done(function (result) {
        if (result.id) {
            if (option === 'no-text') {     // 플래닛 개별 페이지에서..
                var target = $('#channel_' + channel_id);
                target
                    .attr('onclick', 'followBtn("cancel", ' + result.id + ', ' + channel_id + ', ' + user_id + ', "no-text")')
                    .addClass('active');
                target.find('span.zmdi').addClass('zmdi-star');
                target.find('span:not(.zmdi)').addClass('active').text('following');
            } else {                        // 플래닛 팔로우 페이지에서..
                after_ajax_followBtnControl(channel_id, 'add', 'selectPage', user_id, result);
            }
            change_follower_count(channel_id, 'plus');
        }
    });
}

// 팔로우 취소를 요청한 경우
// 팔로우(Myfandom) 삭제.
function ajax_follow_cancel(channel_id, user_id, myfandom_id, option) {
    var req = $.ajax({
        url: '/myfandoms/'+ myfandom_id + '.json',
        method: 'delete',
        data: { authenticity_token: _hf_ }
    });

    req.done(function (result) {
        if (option === 'no-text') {     // 플래닛 개별 페이지에서..
            var target = $('#channel_' + channel_id);
            target
                .attr('onclick', 'followBtn("follow", 0, '+ channel_id +', '+ user_id +', "no-text")')
                .removeClass('active');
            target.find('span.zmdi').removeClass('zmdi-star');
            target.find('span:not(.zmdi)').removeClass('active').text('follow');
        } else {                        // 플래닛 팔로우 페이지에서..
            after_ajax_followBtnControl(channel_id, 'cancel', 'selectPage', user_id, result);
        }
        change_follower_count(channel_id, 'minus');
    })
}

// 요청에 따른 팔로우 버튼 컨트롤.
function after_ajax_followBtnControl(channel_id, status, loc, user_id, data) {
    // select page 에서
    if (loc === 'selectPage'){
        var card = $('.follow_card-'+channel_id);
        var cancelBtn = $('#channel_' + channel_id + '.followed');
        var followBtn = $('#channel_' + channel_id + ':not(.followed)');

        // 팔로우 신청시
        if (status === 'add'){
            card.addClass('followed');
            cancelBtn.show();
            followBtn.hide();
            cancelBtn
                .attr('onclick', 'followBtn("cancel", ' + data.id + ', ' + channel_id + ', ' + user_id + ', ""); return false;')
                .html('<span class=\'zmdi zmdi-star\' style=\'font-size: 20px; position: relative; top: 2px;\'></span> following');
        }

        // 팔로우 취소시
        if (status === 'cancel'){
            card.removeClass('followed');
            cancelBtn.hide();
            followBtn.show();
        }
    }

    // 플래닛 페이지 에서
    if (loc === 'planetPage'){
        // user_id, result.id 등 추가 인자가 많아서 네이티브로 처리.
    }
}

// 팔로워 숫자 변경.
function change_follower_count(channel_id, status) {
    var counter = $('#follower_count_' + channel_id);
    var count = parseInt(counter.text());

    if (status === 'plus'){
        count = count + 1;
    }

    if (status === 'minus'){
        count = count - 1;
    }

    counter.text(count);
}