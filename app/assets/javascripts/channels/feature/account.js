/*
 * 회원 정보 수정 페이지 글자수 트래킹
 * ===========================
 */

// 1. 닉네임 필드
var nickname_input          = $('#checkNickNameLength_from');
nickname_input.on({
    blur: function () {
        account_append_length($('#checkNickNameLength_from'), $('#checkNickNameLength_to'))
    },
    keyup: function () {
        account_append_length($('#checkNickNameLength_from'), $('#checkNickNameLength_to'))
    }
});

// 2. 네임 필드
var name_input          = $('#checkNameLength_from');
name_input.on({
    blur: function () {
        account_append_length($('#checkNameLength_from'), $('#checkNameLength_to'))
    },
    keyup: function () {
        account_append_length($('#checkNameLength_from'), $('#checkNameLength_to'))
    }
});



/*
 *  Validation
 *  ===========================
 */
function account_validation() {
    var updatable = true;
    var message = '';

    var current_date = new Date;
    var year    = $('input[name="user[birthday]"]').val().split('-')[0];
    var month   = $('input[name="user[birthday]"]').val().split('-')[1];
    var day     = $('input[name="user[birthday]"]').val().split('-')[2];
    year    = parseInt(year);
    month   = parseInt(month);
    day     = parseInt(day);

    // 닉네임 20자 넘으면 안됨.
    if (!$('#checkNickNameLength_from').val() || $('#checkNickNameLength_from').val().length > 20 || $('#checkNickNameLength_from').val().length <= 0){
        updatable = false;
        message = 'nick name length error';
        swal(message, $('#checkNickNameLength_from').val(), 'error');
        $('#checkNickNameLength_from').focus();
    }

    // 이름 20자 넘으면 안됨.
    if ($('#checkNameLength_from').val().length > 20){
        updatable = false;
        message = 'name length error';
        swal(message, $('#checkNameLength_from').val(), 'error');
        $('#checkNameLength_from').focus();
    }

    // 생일 연도 체크
    if (year && (year >= current_date.getFullYear() || year < 1900)){
        updatable = false;
        message = 'Birth Year Range Error';
        swal(message, year, 'error');
    }

    // 생일 월 체크
    if (month && (month > 12 || month < 1)){
        updatable = false;
        message = 'Birth Month Range Error';
        swal(message, month, 'error');
    }

    // 생일 일 체크
    var dayLimit = 30;
    if ($.inArray(month, [1, 3, 5, 7, 8, 10, 12]) !== -1){
        dayLimit = 31;
    } else if ($.inArray(month, [2]) !== -1){
        dayLimit = 29;
    }
    if (day && (day > dayLimit || day < 1)){
        updatable = false;
        message = 'Birth Day Range Error';
        swal(message, day, 'error');
    }

    // 이메일 형식 체크
    if (!isEmail($('input[name="user[email]"]').val())){
        updatable = false;
        message = 'Email Format error';
        swal(message, $('input[name="user[email]"]').val(), 'error');
        $('input[name="user[email]"]').focus();
    }

    return updatable;
}

/*
 * 부수기재
 * ===========================
 */

function account_append_length(checkFrom, appendTo) {
    appendTo.text(checkFrom.val().length);
}

function isEmail(email) {
    var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
    return regex.test(email);
}