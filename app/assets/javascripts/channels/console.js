
function consoleMove(seq) {
    $('.navtab').removeClass('active');
    $('li[data-navtab="'+seq+'"]').addClass('active');
    var offset = $('section#'+seq).offset();
    $('html, body').animate({scrollTop: offset.top - 100}, 400)
}