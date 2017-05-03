function gogo_crawler() {
    var value = $('#link_url').val();
    console.log(value);

    var preloader = $('#linkModalPreLoader');
    preloader.show();

    var ajax =  $.ajax({
        url: '/crawler/uri_spy',
        method: 'post',
        data: {url: value}
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

$(document).ready(function () {

    var header = $('#header');
    $(window).scroll(function () {
        var scroll = $(this).scrollTop();

        if (scroll > 220) {
            header.addClass('init_header')
        } else {
            header.removeClass('init_header')
        }

    });


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

});

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