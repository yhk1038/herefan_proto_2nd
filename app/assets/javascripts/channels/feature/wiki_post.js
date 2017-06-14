$(document).ready(function () {
    if ($('#wiki-ground').data('page') === 'edit'){
        $('input[name="_method"]').val('post');
    }

    $('#wiki-ground[data-page="edit"] span.edge').click(function () {
        $('#wiki_post_title-edit_box').show();
        $('#wiki_post_title').focus();
        $('#wiki_post_row_count-edit_box').show();
    });
    $('#wiki-ground[data-page="new"] span.edge').click(function () {
        $('#wiki_post_title-edit_box').show();
        $('#wiki_post_title').attr('autofocus','true');
        $('#wiki_post_row_count-edit_box').show();
    });

    $('#hidden_closer .zmdi').click(function () {
        var txt = $('#wiki_post_title').val();
        var number = $('#wiki-ground span.edge').text().split('. ')[0];
        var order_num = $('#wiki_post_row_count').val();
        $('#wiki-ground span.edge').text(order_num + '. ' + txt);

        $('#wiki-ground .hidden_toggle').hide();
    });

    // Editor
    // ready for saving textarea by taking Editor's value
    $('.note-editable.panel-body').keyup(function () {
        $('#wiki_post_content').text($(this).html());
    });
    $('.note-editable.panel-body').mouseup(function () {
        $('#wiki_post_content').text($(this).html());
    });
});

