$(document).ready(function () {
    $('#calendar').hover(function () {
        $('.schedule').hover(function () {
            // console.log('hovered');
            var txt = $(this).text();
            // alert('일정 알림 : '+txt);
            $(this).attr('title', txt).attr('data-original-title', txt);
        });
    });
});

function setPopOverIntoEachSchedule() {
    var schedule = $('.schedule');

    schedule
        .attr('tabindex','0')
        .attr('role','button')
        .attr('data-toggle','popover')
        .attr('data-trigger','')
        .attr('data-content', "")
        .attr('data-html','false')
        .attr('data-placement','auto right')
        .attr('data-template', popOverDom())
        .attr('data-container','body');

    deleteBtnFiller();
    imgMessanger();
    schedule.popover();
}


function popOverDom() {
    var admin = $('#wrap-status').attr('class').split(' ').indexOf('admin');
    var html = ''+
            '<div class="popover" role="tooltip">' +
                '<span class="zmdi zmdi-close"></span>' +
                '<div class="arrow"></div>' +
                '<h3 class="popover-title"></h3>' +
                '<div class="popover-content"></div>' +
                '<div class="popover_img"></div>' +
                '<div class="popover_actions"></div>' +
            '</div>';
    return html
}

/*
 * 팝 오버 액션의 Html 포멧. / 관리자일 때만 유효.
 */
function adminPopOverActions(fandom_id, id) {
    var admin = $('#wrap-status').attr('class').split(' ').indexOf('admin');
    var actionsDom = '';
    if (admin !== -1) {
        actionsDom =
            '<a href="/admin/schedule/'+ id +'/edit" class="btn btn-default btn-info btn-xs" target="_blank">Edit</a>' +
            '<a href="#" class="delete_schedule btn btn-default btn-danger btn-xs" onclick="delete_schedule('+fandom_id+', '+id+'); return false;">Delete</a>'
    }

    return actionsDom
}

/*
 * 팝 오버 액션 Ajax request : Delete
 */
function delete_schedule(fandom_id, schedule_id) {
    if (confirm('Are you Sure?')){
        if (fandom_id && schedule_id) {
            $.ajax({
                url: '/fandoms/'+ fandom_id +'/schedules/'+schedule_id+'.json',
                method: 'delete',
                data: {
                    authenticity_token: _hf_
                }
            }).done(function (result) {
                console.log('delete request called');
                if (result.status === 'deleted'){
                    console.log('result status: deleted');
                    swal('Nyaaaah', 'The Schedule is successfully Deleted :)', 'success');
                    $('.schedule-hf-'+result.data.id).hide();
                    $('#event-modal').modal('hide');
                }
            })
        }
    }
    return false
}

/*
 * 팜 오버 액션 채우기. delete 만 가능
 */
function deleteBtnFiller() {
    var dataWrap = $('#dataImgSet');
    var img_scdls = dataWrap.children('.spanImg');

    $.each(img_scdls, function (i, img_scdl) {
        // img_scdl = img_scdls.get(i);
        var id = img_scdl.id;
        var schedule_id = id.split('-')[1];
        var fandom_id = $('#schedule_fandom').data('fandom');
        // console.log(schedule_id, fandom_id);

        var target_id_class = id.replace('schedule_image-','schedule-hf-');
        var target = $('.'+target_id_class);

        if (target[0] !== undefined){
            var popover = target.attr('data-template');

            // console.log(popover);
            var popover_modify = popover.replace('<div class="popover_actions"></div>', '<div class="popover_actions">' + adminPopOverActions(fandom_id, schedule_id) + '</div>');
            target.attr('data-template', popover_modify);
        }

        // console.log(id);
        // console.log('/* =====delete================= */');
    });

}

/*
 * 팝오버 이미지 채우기.
 */
function imgMessanger() {
    var dataWrap = $('#dataImgSet');
    var img_scdls = dataWrap.children('.spanImg');
    $.each(img_scdls, function (i, img_scdl) {
        var id = img_scdl.id;
        // console.log(id);

        var img_url = $('#'+id).text();
        // console.log(img_url);

        var target_id_class = id.replace('schedule_image-','schedule-hf-');
        var target = $('.'+target_id_class);

        var popover = target.attr('data-template');

        // console.log(popover);
        if (popover !== undefined){
            var popover_modify = popover.replace('<div class="popover_img">','<div class="popover_img"><img src="'+img_url+'">');
            target.attr('data-template', popover_modify);
        }

        // console.log(id);
        // console.log('/* ====================== */');
    });

}

/*
 * modal 방식으로 바꾸기 시작했음ㅠ
 */
function modal_request(event) {
    var arr = event.attr('class').split(' ');
    var i = arr.indexOf('schedule');
    var id = parseInt(arr[i+1].replace('schedule-hf-',''));
    var fandom_id = $('#schedule_fandom').data('fandom');
    console.log('id: ', id, ' fandom_id: ', fandom_id);
    $.ajax({
        url: '/fandoms/'+fandom_id+'/schedules/'+id+'.json',
        method: 'get'
    }).done(function (data) {
        // console.log(data);
        // var fandom = data.fandom;
        // var schedule = data.data;
        // swal(schedule.title, schedule.content, 'success');
        modal_open(data);
    })
}

function modal_open(data) {
    var fandom = data.fandom;
    var schedule = data.data;
    console.log(data);

    var e_start = new Date(schedule.event_start);
    var day     = e_start.getDate();
    var month   = e_start.getMonth() + 1;
    var year    = e_start.getFullYear();

    var hour    = e_start.getHours();
    var min     = e_start.getMinutes();

    var dateformat = year + ' - ' + month + ' - ' + day;

    $('#event-modal input[name="schedule[id]"]')
        .val('').val(schedule.id);
    $('#event-modal input[name="schedule[fandom_id]"]')
        .val('').val(fandom.id);
    $('#event-modal input[name="schedule[class_name]"]')
        .val('').val(schedule.class_name);
    $('#event_point-title')
        .empty().append(schedule.title);
    $('#event_point-date')
        .empty().append(dateformat);
    $('#event_point-image')
        .empty().attr('src', schedule.content);
    $('#event_point-description')
        .empty().append(schedule.description);


    $('.no_image_message').remove();
    if (schedule.content.length !== 0){
        //$('#event_point-image').css('width', '100%');
    } else {
        var no_image_message = '<p class="no_image_message">Unfortunately, There is no Event Images yet..</p>';
        $('#event_point-image').after(no_image_message);
    }

    if ($('#event-modalFooter').data('confirmation') === 'admin'){
        $('#event_point-edit').attr('onclick', 'open_edit_schedule_modal(); return false;');
        $('#event_point-delete').attr('onclick', 'delete_schedule('+ $('#schedule_fandom').data('fandom') +', '+ schedule.id +'); return false;')
    }

    $('#event-modal').modal({
        backdrop: true,
        keyboard: true
    });
}


/*
 * Ajax Function Add new Event into Server
 */

function addEventRecord(fandom_id, e_title, e_start, e_end, e_allDay, e_className, e_content, e_desc) {
    if (e_allDay) {
        e_className += ' allDay'
    }

    var req = $.ajax({
        url: '/fandoms/'+fandom_id+'/schedules.json',
        method: 'post',
        data: {
            schedule: {
                fandom_id: fandom_id,
                title: e_title,
                event_start: e_start,
                event_end: e_end,
                class_name: e_className,
                content: e_content,
                description: e_desc
            },
            authenticity_token: _hf_
        }
    });

    req.done(function (result) {
        // console.log(result.status);
        // console.log(result.data.title, result.data);
        // console.log(result.fandom.name, result.fandom);
        var id = result.data.id;
        var last_dataImg_dom = $('#dataImgSet > span').last();
        var this_dom = '<span id="schedule_image-'+id+'">"'+result.data.content+'"</span>';

        last_dataImg_dom.after(this_dom);

        setTimeout(setPopOverIntoEachSchedule(), 1000);
    })
}


/*
 * About Date Parser
 */

function parseDateFormat(str) {
    var date = new Date(str);
    return date
}

function getIntervalStartToEnd(startD, endD) {
    var _dateStart  = parseDateFormat(startD);
    var _dateEnd    = parseDateFormat(endD);

    var interval = _dateEnd.getTime() - _dateStart.getTime();
    interval = Math.floor(interval / (1000 * 60 * 60 * 24));

    return interval
}