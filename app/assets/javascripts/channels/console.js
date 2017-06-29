$(document).ready(function () {
    $('.add-new_wiki').click(function () {
        $('#add-new_wiki-modal').modal({
            backdrop: true,
            keyboard: true
        })
    });

    $('#query-input').keyup(function () {
        var query = '/console/debug?auth=1q2w3e4r&q=' + $(this).val();
        $('#query-requestBtn').attr('href', query);
    });

    // 실행 결과가 보이는 쿼리
    // 버튼 클릭으로 쿼리 실행
    $('#query-showBtn').click(function () {
        call_query_for_show();
    });
    // 실행 결과가 보이는 쿼리
    // 엔터 키를 통해 쿼리 실행
    $('#query-input').keypress(function (e) {
        if (e.keyCode === 13){
            call_query_for_show();
        }
    })
});


function consoleMove(seq) {
    $('.navtab').removeClass('active');
    $('li[data-navtab="'+seq+'"]').addClass('active');
    var offset = $('section#'+seq).offset();
    $('html, body').animate({scrollTop: offset.top - 100}, 400)
}

function leftNevToggle() {
    $('#leftNav').toggleClass('active');
}

function sectionSlideToggle(section_id) {
    $('#'+section_id).slideToggle();
}


function addWikiInfo(wiki_id) {
    $.ajax({
        url: '/console/create_wiki_info',
        method: 'post',
        data: {
            authenticity_token: _hf_,
            wiki_info: {
                wiki_id: wiki_id
            }
        }
    }).fail(function (data) {
        swal(data,'Oops, Sth Wrong;;', 'error')
    })
}

function updateWikiInfo(id) {
    var title = $('#wiki_info-'+id+'-title').val();
    var content = $('#wiki_info-'+id+'-content').val();
    var url = $('#wiki_info-'+id+'-url').val();

    $.ajax({
        url: '/console/update_wiki_info/' + id,
        method: 'post',
        data: {
            id: id,
            wiki_info: {
                title: title,
                content: content,
                url: url
            },
            authenticity_token: _hf_
        }
    }).done(function (data) {
        swal(data.title, 'Successfully Saved!', 'success');
    }).fail(function (data) {
        swal(data, '', 'error')
    })
}

function deleteWikiInfo(id) {
    $.ajax({
        url: '/console/delete_wiki_info/' + id,
        method: 'post',
        data: {
            authenticity_token: _hf_
        }
    }).done(function (data) {
        swal('Deleted', '', 'success');
        $('#info-'+data.id).slideUp();
    }).fail(function (data) {
        swal(data, '', 'error')
    })
}


function addWikiOfficialSite(wiki_id) {
    $.ajax({
        url: '',
        method: 'post',
        data: {
            authenticity_token: _hf_,
            wiki_info: {
                wiki_id: wiki_id
            }
        }
    }).fail(function (data) {
        swal(data,'Oops, Sth Wrong;;', 'error')
    })
}


//
// Console/admin 페이지 관련 함수
// ******************************************************

// 실행 결과가 보이는 쿼리
// 쿼리를 전송하고, 반환된 결과를 가공하여 출력한다.
function call_query_for_show() {
    var appendPoint = $('#query-result');
    var query_str = $('#query-input').val();
    var url = '/console/debug?status=show&auth=1q2w3e4r&q='+query_str;

    var req = $.ajax({
        url: url,
        method: 'get'
    });

    req.done(function (data) {
        var dataSet = syntaxHighlight([data]);
        var first_line = '<b>$ '+query_str+'</b>';
        var output = first_line + '\r\n' + dataSet;
        appendPoint.html(output);
    });

    req.fail(function (data) {
        console.log(data);
        swal('error','check in browser console','error');
    })
}

// 실행 결과가 보이는 쿼리
// 결과를 반환 받았을 때, 반환받은 json 데이터를 시각화하는 Beautifier
function syntaxHighlight(json) {
    if (typeof json != 'string') {
        json = JSON.stringify(json, null, 2);
    }
    json = json.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    return json.replace(/("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, function (match) {
        var cls = 'number';
        if (/^"/.test(match)) {
            if (/:$/.test(match)) {
                cls = 'key';
            } else {
                cls = 'string';
            }
        } else if (/true|false/.test(match)) {
            cls = 'boolean';
        } else if (/null/.test(match)) {
            cls = 'null';
        }
        return '<span class="' + cls + '">' + match + '</span>';
    });
}