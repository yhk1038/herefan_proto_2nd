$(document).ready(function () {
    if ($('#wiki-ground').data('page') === 'edit'){
        $('input[name="_method"]').val('post');
    }

    $('#wiki-ground[data-page="edit"] span.edge').click(function () {
        $('#wiki_post_title-edit_box').show();
    });
    $('#wiki-ground[data-page="new"] span.edge').click(function () {
        $('#wiki_post_title-edit_box').show();
    });


    $('.note-editable.panel-body').keyup(function () {
        $('#wiki_post_content').text($(this).html());
    });
    $('.note-editable.panel-body').mouseup(function () {
        $('#wiki_post_content').text($(this).html());
    });
});

