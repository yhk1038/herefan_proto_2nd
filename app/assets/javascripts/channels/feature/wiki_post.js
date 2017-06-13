$(document).ready(function () {
    if ($('#wiki-ground').data('page') === 'edit'){
        $('input[name="_method"]').val('post');
    }

    $('#wiki-ground[data-page="edit"] span.edge').click(function () {
        $('#wiki_post_title-edit_box').slideToggle();
    });


});