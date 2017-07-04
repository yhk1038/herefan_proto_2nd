$(document).ready(function () {


    ///////////////////////////////////////////////////
    //                 전환 네비게이션 바
    ///////////////////////////////////////////////////
    transNavBar_init(window_path());

    // 네비게이션 바 전환
    $(window).scroll(function () {
        var scroll = $(this).scrollTop();

        if (scroll > 190) {
            toggleNavigationBar('on');
        } else {
            toggleNavigationBar('off');
        }
    });

    ///////////////////////////////////////////////////
    //            네비게이션 우측 하단 플래닛 리모콘
    ///////////////////////////////////////////////////

    // 초기설정 + 새로고침 했을 때 상태 유지.
    // 페이지 이동 간에 플래닛 리모콘 상태를 유지 하도록.
    myPlanetGroup_init();

    // 주 행동
    // 플래닛 리모콘을 누르면 알맞게 제어하고, 그 상태를 브라우저에게 기억 시킴.
    $('#top-fandoms a').click(function () {
        if (myPlanetGroup() === 'show'){
            localStorage.setItem('remote_status','hide');
        } else {
            localStorage.setItem('remote_status','show');
        }
        togglePlanetRemoteControl(myPlanetGroup());
    });
});




// 전환 네비게이션 바
// =====================================================================================================

// 네비게이션바를 토글시킨다.
function toggleNavigationBar(status) {
    var header = $('#header');
    var myfandoms = $('#follow_list_box');

    if (status === 'on'){
        header.addClass('init_header');
        myfandoms.addClass('scrolled');
    }

    if (status === 'off'){
        header.removeClass('init_header');
        myfandoms.removeClass('scrolled');
    }
}

// 네비게이션바의 전환상테를 초기회.
function transNavBar_init(path) {
    // path (현재 페이지의 domain을 제외한 url)
    // console.log(path)
    var is_toggled          = false;
    // 처음부터 전환된 네비게이션바 상태로 출력되어야 하는 페이지의 path list
    var no_transparent_list = ['/home/new', '/home/index', '/fandoms', '/mypage/watched'];

    if (no_transparent_list.indexOf(path) !== -1){
        is_toggled = true;
    }

    if (is_toggled){
        toggleNavigationBar('on');
    } else {
        toggleNavigationBar('off');
    }
}


// 네비게이션 우측 하단 플래닛 리모콘
// =====================================================================================================

// 플래닛 리모콘을 토글시킨다.
function togglePlanetRemoteControl(status) {
    if (status === 'hide'){
        $('#top-fandoms a').removeClass('active');
        $('#follow_list_box').addClass('hi_de');
    }

    if (status === 'show'){
        $('#top-fandoms a').addClass('active');
        $('#follow_list_box').removeClass('hi_de');
    }
}

// 브라우저가 이전 상태를 기억하는지 물어보고,
// 기억시킨 적이 없어서 null을 반환하면 새롭게 상태를 기억시킴. (상태의 기본 값: 'show')
function myPlanetGroup_init() {
    if (!myPlanetGroup()){
        localStorage.setItem('remote_status','show');
    }

    togglePlanetRemoteControl(myPlanetGroup());
}

// 브라우저로부터 이전에 기억시킨 플래닛 리모콘의 제어 상태를 호출.
// 기억시킨 적이 없다면 반환 값은 'null'.
function myPlanetGroup() {
    return localStorage.getItem('remote_status');
}