function openCartDetail(btn, typeId) {
    var panel = document.getElementById('detail-' + typeId);
    if (panel.style.display === 'none' || panel.style.display === '') {
        panel.style.display = 'block';
        btn.textContent = 'Ẩn chi tiết ▴';
    } else {
        panel.style.display = 'none';
        btn.textContent = 'Xem chi tiết ▾';
    }
}

function updateProv(selectEl, hiddenId) {
    var opt = selectEl.options[selectEl.selectedIndex];
    var hidden = document.getElementById(hiddenId);
    if (hidden) {
        hidden.value = opt && opt.value !== "" ? opt.text : '';
    }
}