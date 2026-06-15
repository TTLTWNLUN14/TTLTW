(function () {
    if (window._navDropdownInit) return;
    window._navDropdownInit = true;

    window.navToggleDropdown = function (e) {
        e.stopPropagation();
        document.getElementById('navDropdownMenu').classList.toggle('open');
    };
    document.addEventListener('click', function () {
        var m = document.getElementById('navDropdownMenu');
        if (m) m.classList.remove('open');
    });
})();