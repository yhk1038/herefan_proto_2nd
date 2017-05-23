$(document).ready(function () {
    $('.lightbox').hover(function () {
        var element_id = $(this).attr('value');
        var title = $('#'+element_id+'-title').text();
        $('#titleShadow').text(title);
    });

    $('.p-item').click(function () {
        $('#titleShadow').show();
    });

    $('body').click(function (event) {
        if ($(this).attr('class') === 'light-gallery' && event.target.id === 'lg-action')  {
            var duration = 0;
            $('img.object').attr('style', 'transform: rotate3d(1,1,1,0); opacity: 0;');
            event.setTimeout(hideViewer(), 1500);
        }
    });

    $('.lightbox').mouseenter(function () {
        $('#lg-outer').remove();
        $('body').removeClass('light-gallery');
    })
});

function hideViewer() {
    $('#lg-outer').hide(); //.fadeOut(duration);
    $('#titleShadow').hide(); //.fadeOut(duration);
}