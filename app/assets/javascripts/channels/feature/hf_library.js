// 라이브러리



/*
 * 링크 카드 추가/편집 모달
 * ===========================
 */

//
// type 을 설정하면, 그 값을 typee input(hidden field) 에 반영.

// // Add modal
$('.radio-link_typee').on('click', function () {
    var value = $(this).attr('vc');
    console.log(value);
    $('#link_typee').attr('value',value);
});

// // Edit modal
$('.radio-link_typee-edit').on('click', function () {
    var value = $(this).attr('vc');
    console.log(value);
    $('#link_typee-edit').val(value);
});


//
// 링크 카드 미리보기 상태에서 메세지 입력

// // Add modal
$('#msg-content').on({
    blur: function () {
        text_append_with_anotherInput($(this), $('#add_link_modal #editable_msg'), $('#link_message'));
    },
    keyup: function () {
        text_append_with_anotherInput($(this), $('#add_link_modal #editable_msg'), $('#link_message'));
    }
});

// // Edit modal
$('#msg-content-edit').on({
    blur: function () {
        text_append_with_anotherInput($(this), $('#card_preview_point-edit #editable_msg'), $('#link_message-edit'));
    },
    keyup: function () {
        text_append_with_anotherInput($(this), $('#card_preview_point-edit #editable_msg'), $('#link_message-edit'));
    }
});





/*
 * 부수기재
 * ===========================
 */

function text_append_with_anotherInput(appendFrom, appendTo, anotherInput) {
    var value = appendFrom.val();
    anotherInput.attr('value', value);
    appendTo.text(value);
}

function after_getCards() {
    myGridALicious(250);
    $('#library').attr('style', '');
    bindingActions();
}

function cardGridCalculator() {
    var grid_size = 250;
    var section_row = $('#libraries_wrapper');
    var section_row_page = section_row.data('page');

    if (section_row_page){
        var narrow_grid_pages_list = ['home-new_content', 'home-index'];

        if (narrow_grid_pages_list.indexOf(section_row_page) !== -1){
            section_row.attr('data-grid','5');
            grid_size = 200;
        } else {
            section_row.attr('data-grid', '4');
            grid_size = 250;
        }
    } else {
        grid_size = 0;
    }

    return grid_size
}

function myGridALicious(width) {
    $('#libraries_wrapper').gridalicious({
        selector: '.task',
        width: width,
        animate: true,
        animationOptions: {
            speed: 100,
            duration: 200
        }
    })
}