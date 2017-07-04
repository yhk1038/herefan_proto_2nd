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
    $('.note-editable.panel-body').keyup(function (e) {
        var html = $(this).html();

        var code = e.keyCode || e.which;
        if(code === 9){
            html = autoImage(html);
            console.log(html);
            $(this).html(html);
        }

        $('#wiki_post_content').text(html);
    });
    $('.note-editable.panel-body').mouseup(function () {
        $('#wiki_post_content').text($(this).html());
    });
    $(this).on('drop', function (e) {
        // console.log(e);
        return false;
    });

    // Only for Bug Fix on production server
    $('#wiki-ground[data-page="new"] #wiki_post_wiki_pointer_id').removeAttr('value');
});

function autoImage(html) {
    console.log('/// start');
    console.log('');
    var reg = /(.|\s)h(ttp:\/\/.|ttps:\/\/.)\S*?\.(png|gif|jpg|jpeg)/g;
    var urls = html.match(reg);
    var editor = $('.note-editable.panel-body');
    var content = editor.html();


    $.map(urls, function (url, i) {
        var u = '';

        if (url.indexOf('"') === 0){
            u = url
        } else {
            var ur = url.trim().slice(1);
            var f_ = url.trim().charAt(0);
            u = '<img style="max-width: 600px; height: auto;" src="'+ ur +'">';
            var str = f_ + u;
            console.log(i+'_str: ', str);
            console.log('');
            console.log('end //');
            content = content.replace(url, str);
        }
    });

    return content
}