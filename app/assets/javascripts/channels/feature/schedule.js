$(document).ready(function () {
    $('.schedule').hover(function () {
        var txt = $(this).text();
        // alert('일정 알림 : '+txt);
        $(this).attr('title', txt).attr('data-original-title', txt);
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
                $('.schedule-hf-'+result.data.id).hide();
            }
        })
    }
}

/*
 * 팜 오버 액션 채우기. delete 만 가능
 */
function deleteBtnFiller() {
    var dataWrap = $('#dataImgSet');
    var img_scdls = dataWrap.children('span');
    $.each(img_scdls, function (i, img_scdl) {
        img_scdl = img_scdls.get(i);
        var id = img_scdl.id;
        var schedule_id = id.split('-')[1];
        var fandom_id = $('#'+id).attr('fandom_id');
        // console.log(schedule_id, fandom_id);

        var target_id_class = id.replace('schedule_image-','schedule-hf-');
        var target = $('.'+target_id_class);

        var popover = target.attr('data-template');

        // console.log(popover);
        var popover_modify = popover.replace('<div class="popover_actions"></div>', '<div class="popover_actions">'+ adminPopOverActions(fandom_id, schedule_id) +'</div>');
        target.attr('data-template', popover_modify);

        // console.log(id);
        // console.log('/* =====delete================= */');
    });

}

/*
 * 팝오버 이미지 채우기.
 */
function imgMessanger() {
    var dataWrap = $('#dataImgSet');
    var img_scdls = dataWrap.children('span');
    $.each(img_scdls, function (i, img_scdl) {
        img_scdl = img_scdls.get(i);
        var id = img_scdl.id;
        // console.log(id);

        var img_url = img_scdl.innerHTML;
        // console.log(img_url);

        var target_id_class = id.replace('schedule_image-','schedule-hf-');
        var target = $('.'+target_id_class);

        var popover = target.attr('data-template');

        // console.log(popover);
        var popover_modify = popover.replace('<div class="popover_img"></div>','<div class="popover_img"><img src="'+img_url+'"></div>');
        target.attr('data-template', popover_modify);

        // console.log(id);
        // console.log('/* ====================== */');
    });

}

/*
 * Ajax Function Add new Event into Server
 */

function addEventRecord(fandom_id, e_title, e_start, e_end, e_allDay, e_className, e_content) {
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
                content: e_content
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