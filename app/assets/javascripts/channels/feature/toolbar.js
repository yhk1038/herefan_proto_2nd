$(document).ready(function () {

    //
    // Location : '/fandoms/:id'
    // Sort By DropDown
    $('.sorting-method').click(function () {
        var method = $(this).text();

        $(this).addClass('active');
        $('#sort-method').text(method);
        fadeOutWholeCards();

        if (method === 'Latest') {
            fadeInBySelectedMethod('');
        }

        if (method === 'Popular') {
            fadeInBySelectedMethod('');
        }

        if (method === 'Unwatched') {
            fadeInBySelectedMethod(':not(.visited)');
        } else if (method === 'Watched') {
            fadeInBySelectedMethod('.visited');
        }

        if (method === 'Clipped') {
            fadeInBySelectedMethod('.clipped');
        } else if (method === 'UnClipped') {
            fadeInBySelectedMethod(':not(.clipped)');
        }
    });

    //
    // Location : '/fandoms/:id'
    // Filter By LeftLinks
    $('.filter-type').click(function () {
        var type = $(this).text();
        var typeNum = $(this).attr('value');
        var k = $(this).attr('class').indexOf('active');

        $('.filter-type').removeClass('active');

        if (k >= 0) {
            fadeOutWholeCards();
            fadeInByFilteringType('');
        }

        if (k < 0) {
            $(this).addClass('active');
            fadeOutWholeCards();
            fadeInByFilteringType(typeNum);
        }
    });
});

function fadeOutWholeCards() {
    $('.blog-post')
        .fadeOut()
        .parent('.task').toggle(false);
}

function fadeInBySelectedMethod(method) {
    $('.blog-post'+method)
        .fadeIn()
        .parent('.task').toggle(true);
}

function fadeInByFilteringType(type) {
    var typeTag = '';

    if (type !== '') {
        typeTag += '.type-'+type;
    }

    $('.blog-post'+typeTag)
        .fadeIn()
        .parent('.task').toggle(true);
}


//
// Sorting Functions

// function sortDefault() {
//
// }
function getMyCards(_req) {
    $('.sortList').removeClass('active');
    $('#sortList-'+_req).addClass('active');
    $('#library').attr('style', 'min-height: 1000px');

    var query = $.ajax({
        url: '/sort_by/'+_req
    });

    query.done(function(){
        console.log('done!');
        $('#libraries_wrapper').gridalicious({
            selector: '.task',
            width: 250
        });
        $('#library').attr('style', '');
        bindingActions();
    });
}


function bindingActions() {
    // 링크 카드 Like 기능
    $('.actions_box .maum').unbind('click').click(function (event) {
        var btn     = $(this);
        var user_id = $(this).attr('action_noiser');
        var target_id = $(this).attr('action_target');
        var method  = $(this).attr('action_status');
        var url     = '';

        if (user_id !== '0'){
            if (method === 'post'){
                url += '/action/likes.json'
            } else if (method === 'delete'){
                url += '/action/likes/'+target_id+'.json'
            }

            var req = $.ajax({
                url: url,
                method: method,
                data: {
                    like: {
                        user_id: user_id,
                        link_id: target_id
                    },
                    authenticity_token: _hf_
                }
            });

            req.done(function (result) {
                console.log(result);
                var icon = $('#actions_'+result.data.link_id+' .maum span.zmdi');
                var counter = $('#actions_'+result.data.link_id+' .maum span.counter');

                if (result.status === 'created'){
                    icon.removeClass('zmdi-favorite-outline').addClass('zmdi-favorite');
                    counter.text(result.count);
                    btn
                        .attr('action_status', 'delete')
                        .attr('action_target', result.data.id);

                } else if (result.status === 'deleted'){
                    icon.removeClass('zmdi-favorite').addClass('zmdi-favorite-outline');
                    counter.text(result.count);
                    btn
                        .attr('action_status', 'post')
                        .attr('action_target', result.data.link_id);
                }
            });

            req.fail(function (result) { console.log('failed'); alert(result.responseText) })

        } else {
            alert('you should login to use like button')
        }

        event.stopPropagation();
    });
    // 링크 카드 Clip 기능
    $('.clip_btn').unbind('click').click(function (event) {
        var btn = $(this);
        var user_id = $(this).attr('action_noiser');
        var target_id = $(this).attr('action_target');
        var method  = $(this).attr('action_status');
        var url     = '';

        if (user_id !== '0'){
            if (method === 'post'){
                url += '/action/clips.json'
            } else if (method === 'delete'){
                url += '/action/clips/'+target_id+'.json'
            }

            var req = $.ajax({
                url: url,
                method: method,
                data: {
                    clip: {
                        user_id: user_id,
                        link_id: target_id
                    },
                    authenticity_token: _hf_
                }
            });

            req.done(function (result) {
                console.log(result);
                var grand = $('#link_'+result.data.link_id);

                if (result.status === 'created'){
                    grand.addClass('clipped');
                    btn
                        .attr('action_status', 'delete')
                        .attr('action_target', result.data.id);

                } else if (result.status === 'deleted'){
                    grand.removeClass('clipped');
                    btn
                        .attr('action_status', 'post')
                        .attr('action_target', result.data.link_id);
                }
            });

            req.fail(function (result) { console.log('failed'); hey_login() })

        }

        event.stopPropagation()
    });
}