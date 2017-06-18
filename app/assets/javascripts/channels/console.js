
function consoleMove(seq) {
    $('.navtab').removeClass('active');
    $('li[data-navtab="'+seq+'"]').addClass('active');
    var offset = $('section#'+seq).offset();
    $('html, body').animate({scrollTop: offset.top - 100}, 400)
}

function leftNevToggle() {
    $('#leftNav').toggleClass('active');
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
        $('#info-'+data.id).fadeOut();
    }).fail(function (data) {
        swal(data, '', 'error')
    })
}