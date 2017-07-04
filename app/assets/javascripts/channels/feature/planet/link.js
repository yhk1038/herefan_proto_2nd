//




/*
 * (1) 카드 요소 (드랍다운 등)
 * ===========================
 */

// 1. more 버튼 드롭다운
$('.moreBtn li.dropdown').on('click', function (e) {
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

// 2. 공유 버튼 드롭다운
$('.share_box').on('click', function (e) {
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




/*
 * (2) 카드 기능
 * ===========================
 */

// 1. 링크 방문 카운트 기능
// 링크 방문시 나의 방문 링크 기록으로 카운팅
$('.link_wrapping_anchor.no-mute').on('click', function () {
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

// 2. 신고기능
// 요청 & 완료 알림
function report_alert(link_id, user_id) {
    var title = $('#link_'+link_id).find('.linkcard-title').text();
    var req = $.ajax({
        url: '/reports.json',
        method: 'post',
        data: {
            authenticity_token: _hf_,
            report: {
                user_id: user_id,
                link_id: link_id
            }
        }
    });

    req.done(function (data) {
        swal('Report','Your report is completed. ([#'+data.id+'] '+ title +')','success');
    });

    return false
}

// 3. Edit 기능
// Edit modal 준비 & 열림.
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




/*
 * (3) 기타
 * ===========================
 */

// 의도치 않은 방문기록 방지
$(document).ready(function () {
    $('.no-vl').hover(function () {
        $('.link_wrapping_anchor').removeClass('no-mute');
    }, function () {
        $('.link_wrapping_anchor').addClass('no-mute');
    });
});

// 드롭다운 박스 클릭시 드롭다운 활성제거 방지
$(document).ready(function () {
    $('.no-vl.dropdown-menu').hover(function () {
        $(this).attr('data-prevent', 'true');
        $(this).click(function (e) {
            e.stopPropagation();
        })
    }, function () {
        $(this).attr('data-prevent', 'false');
    });
});




/*
 * 부수기재
 * ===========================
 */

// 라이브러리에서 새로운 링크를 올릴 때,
// 크롤러를 실행.
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

// 라이브러리에서 기존의 카드를 수정하고자 할 때,
// 기존 리소스를 활용하기 위해 다음 함수를 통하여 크롤러를 실행.
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

// 새롭게 Append 된 마음/클림 버튼에 기능을 바인딩.
function bindingActions() {
    // 링크 카드 Like 기능
    $('.actions_box .maum').unbind('click').click(function (event) {
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
                //console.log(result);
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

            //req.fail(function (result) { console.log('failed'); alert(result.responseText) })

        } else {
            //alert('you should login to use like button')
        }

        event.stopPropagation();
    });

    // 링크 카드 Clip 기능
    $('.clip_btn').unbind('click').click(function (event) {
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
                //console.log(result);
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

            //req.fail(function (result) { console.log('failed'); hey_login() })

        }

        event.stopPropagation();
    });
}