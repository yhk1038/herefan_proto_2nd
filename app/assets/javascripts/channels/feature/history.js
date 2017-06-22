$(document).ready(function () {

    /*
     * ========================================
     *      툴바 인덱스
     * ========================================
     */
    $(window).scroll(function () {
        if ($(this).scrollTop() >= 330) {
            $('#history-index-wrap').addClass('fixed');
            var topScroll = $(this).scrollTop() - 254;
            $('#history-index-wrap').attr('style', 'top: '+topScroll+'px;');
        } else {
            $('#history-index-wrap').removeClass('fixed')
        }
    });

    $('.index_list').click(function () {
        $('#history-index-wrap .active').removeClass('active');
        $(this).addClass('active');
    });


    /*
     * ========================================
     *      이미지 뷰어
     * ========================================
     */

    /*
     * 이미지 뷰어를 위한 타이틀을 준비하는 함수.
     *///=========================
    // 1. 준비하고.
    $('.lightbox').hover(function () {
        var element_id = $(this).data('history');
        var date = new Date($(this).data('edate'));
        var h2 = $('#'+element_id+'-title');
        var title = h2.text();
        var garbage = h2.children().text();

        if (title.indexOf(garbage) !== -1) {
            title = title.replace(garbage, '').trim();
        }

        var y = date.getFullYear();
        var m = date.getMonth()+1;
        var d = date.getDate();
        var time = y + '.' + m + '.' + d;
        var html = '<span>'+time+'</span> '+ title;

        $('#titleShadow').html(html);
    });

    // 2. 보여준다.
    $('.p-item').click(function () {
        $('#titleShadow').show();
    });
    //============================

    /*
     * 이미지 뷰어를 종료하기 위한 함수들.
     *///=========================
    // 1. ESC 버튼을 누르면, 뷰어가 열려있는 상태인지 확인하고, 열려있는 상태라면 종료한다.
    $('body').click(function (event) {
        if ($(this).attr('class') === 'light-gallery' && event.target.id === 'lg-action')  {
            // var duration = 0;
            $('img.object').attr('style', 'transform: rotate3d(1,1,1,0); opacity: 0;');
            hideViewer()
        }
    });

    // 2. 그런다음 다음 뷰어 오픈 시에 가려둔 이전 뷰어를 없애버린다.
    $('.lightbox').mouseenter(function () {
        $('#lg-outer').remove();
        $('body').removeClass('light-gallery');
    });
    //============================

    /*
     * ESC 버튼으로 이미지 뷰어를 닫을 때.
     */
    $(document).keyup(function (e) {
        var classes = $('body').attr('class');

        if (classes) {
            if (classes.indexOf('light-gallery') !== -1){
                if (e.keyCode === 27) { // escape key maps to keycode `27`
                    $('#titleShadow').hide();
                }
            }
        }
    });

    /*
     * ========================================
     *      히스토리 CRUD
     * ========================================
     */

    /*
     * 히스토리 추가하는 함수
     */
    $('#history_add_line-edit').click(function () {
        // $('#timeline-add-title').hide();
        // $('#timeline-add-title-edit').show();
        // $('.lightbox-item2').hide();
        $('#eventUploadModal').modal();
    });
    $('#history_add_line-save').click(function () {
        $(this).attr('style', 'opacity: 0.25;').text('save ...');

        var fandom_id   = $(this).data('fandom');
        var user_id     = $(this).data('author');
        var context     = $('#new-history-title').val();
        var event_date  = $('#history-event_date').val();
        add_history_line(fandom_id, user_id, context, event_date);
    });

    /*
     * 히스토리 편집하는 함수
     */
    $('.history-edit').click(function () {
        var title       = $(this).data('title');
        var date        = $(this).data('date');
        var fandom_id   = $(this).data('fandom');
        var id          = $(this).data('history');
        var delete_history_path = '/fandoms/'+fandom_id+'/histories/'+id;

        $('#removeHistoryBtn-form').attr('action','').attr('action', delete_history_path);
        $('#editHistoryEvent-event_date').empty().val(date);
        $('#editHistoryEvent-title').empty().val(title);

        $('#editEventModal').modal();
        // var history_id = $(this).data('history');
        //
        // $('#timeline-'+history_id+'-title').hide();
        // $('#timeline-'+history_id+'-title-edit').show();
        // $('.lightbox-item2').hide();
    });
    $('.history-save').click(function () {
        $(this).attr('style', 'opacity: 0.25;').text('save ...');

        var history_id  = $(this).data('history');
        var fandom_id   = $(this).data('fandom');
        var user_id     = $(this).data('author');
        var context     = $('#history-'+history_id+'-title').val();
        var event_date  = $('#history-'+history_id+'-event_date').val();
        edit_history_line(history_id, fandom_id, user_id, context, event_date);
    });

    /*
     * 이미지 추가 모달 띄울 때, 타이틀에 히스토리 타이틀 입히기.
     *
     * 이미지 추가 모달 띄울 때, 히든필드에 히스토리 아이디 값 넣기.
     */
    $('.item-plus').click(function () {
        var title = $(this).data('title');
        var history_id = $(this).data('history');
        console.log(history_id);

        $('#imgUploadModalLabel').text(title);
        $('#inputHistory-history_id').val(history_id);
    });
});

function hideViewer() {
    $('#lg-outer').hide(); //.fadeOut(duration);
    $('#titleShadow').hide(); //.fadeOut(duration);
    $('body').removeClass('light-gallery')
}

/*
 * Ajax Request => Edit a New history line.
 * ==========================================================
 */
function edit_history_line(history_id, fandom_id, user_id, context, event_date) {
    if (parseInt(user_id) !== 0 && fandom_id && context.length !== 0 && event_date) {
        var req = $.ajax({
            url: '/fandoms/'+fandom_id+'/histories/'+history_id+'.json',
            method: 'put',
            data: {
                history: {
                    fandom_id: fandom_id,
                    user_id: user_id,
                    title: context,
                    event_date: event_date
                },
                authenticity_token: _hf_
            }
        });

        req.done(function (result) {
            console.log(result);
            if (result.status === 'ok') {
                console.log('ok');
                var date = new Date(result.data.event_date);
                var year = date.getFullYear();
                var month = date.getMonth() + 1;
                var day = date.getDate();
                var html = '<span class="d-block">'+year+'</span> ' + day + '/' + month;
                console.log(date, year, month, day, html);

                $('#timeline-'+result.data.id+'-title').val(result.data.title);
                $('#timeline-'+result.data.id+'-date').html(html);

                close_edit_mode(result.data.id);
            }

            if (result.status === 'unprocessable_entity') {
                sweetAlert("Oops...", result.message, "error");
            }
        })
    } else {
        console.log('request skipped');
        close_edit_mode(history_id);
    }
}

/*
 * Ajax Request => Add a New history line.
 * ==========================================================
 */
function add_history_line(fandom_id, user_id, context, event_date) {
    if (parseInt(user_id) !== 0 && fandom_id && context.length !== 0 && event_date) {
        var req = $.ajax({
            url: '/fandoms/'+fandom_id+'/histories',
            method: 'post',
            data: {
                history: {
                    fandom_id: fandom_id,
                    user_id: user_id,
                    title: context,
                    event_date: event_date
                },
                authenticity_token: _hf_
            }
        });

        req.done(function (result) {
            if (result.status === 'unprocessable_entity') {
                sweetAlert("Oops...", result.message, "error");
            }
        })
    } else {
        console.log('request skipped');
        close_add_mode();
    }
}

/*
 * 히스토리 추가모드 또는 수정모드를 종료할 때
 * 요소의 상태를 원래대로 복구하는 함수들.
 *///===================
function close_add_mode() {
    $('#new-history-title').val('');
    $('#history-event_date').val('');
    $('#timeline-add-title-edit').hide();
    $('#timeline-add-title').show();
    $('#history_add_line-save').attr('style', 'opacity: 1;').text('save');
    $('.lightbox-item2').show();
}

function close_edit_mode(history_id) {
    $('#history-'+history_id+'-title').val('');
    $('#history-'+history_id+'-event_date').val('');
    $('#timeline-'+history_id+'-title-edit').hide();
    $('#timeline-'+history_id+'-title').show();
    $('#history_'+history_id+'_line-save').attr('style', 'opacity: 1;').text('save');
    $('.lightbox-item2').show();
}
//======================


/*
 * 툴바 인덱스 클릭 시, 해당 인덱스 위치로 이동.
 */
function fnMove(seq) {
    var offset = $('#history-'+seq+'-line').offset();
    $('html, body').animate(
        {
            scrollTop : offset.top - 90
        },
        400
    )
}
function fnMove_wiki(seq) {
    var offset = $('#main-section-'+seq).offset();
    $('html, body').animate(
        {
            scrollTop : offset.top - 50
        },
        400
    )
}
