

// 도메인을 제외한 path 를 반환.
// 용처 : ;
function window_path() {
    var baseUri = document.baseURI;
    var domain = document.domain;
    if ( domain === 'localhost'){
        domain = 'localhost:3000'
    }
    var path = baseUri.replace(domain, '*split*').split('*split*')[1];
    if (path.charAt(path.length-1) === '#'){
        path = path.slice(0, -1)
    }
    // console.log('window_path: ', path);
    return path
}

// 페이지 최상단으로 스크롤 이동
// 용처 : '라이브러리', (페이지가 길어질 수 있는 잠재적인 페이지들: 팔로우페이지, 위키, 히스토리, 마이페이지-마이링크페이지 등)
function goTopScroll() {
    $( 'html, body' ).animate( { scrollTop : 0 }, 600 );
    return false;
}

// 클립보드에 공유 주소 복사
// 복사 되었음을 툴팁으로 알림.
function copyToClipboard(element) {
    // 클립보드 복사
    var $temp = $("<input>");
    $("body").append($temp);
    $temp.val($(element).text()).select();
    document.execCommand("copy");
    $temp.remove();

    // 툴팁 출현
    var copyBtn = $('.url_copy[onclick="copyToClipboard(\''+element+'\')"]');
    copyBtn.addClass('hf-tooltip');
    copyBtn.hover(function () {
        copyBtn.removeClass('hf-tooltip');
    });
}
