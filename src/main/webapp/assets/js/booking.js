document.querySelectorAll('.rt-card').forEach(card => {
    card.addEventListener('click', function() {
        document.querySelectorAll('.rt-card').forEach(el => el.classList.remove('active'));
        this.classList.add('active');
    });
});

document.querySelectorAll('.cc-card').forEach(card => {
    card.addEventListener('click', function() {
        document.querySelectorAll('.cc-card').forEach(c => c.classList.remove('active'));
        this.classList.add('active');
    });
});

function syncProvinceName(selectId, hiddenId) {
    const select = document.getElementById(selectId);
    const hidden = document.getElementById(hiddenId);
    if (!select || !hidden) return;
    const opt = select.options[select.selectedIndex];
    hidden.value = opt ? (opt.getAttribute('data-name') || '') : '';
}

['fromProvinceSelect', 'toProvinceSelect'].forEach(id => {
    const hiddenId = id === 'fromProvinceSelect' ? 'fromProvinceName' : 'toProvinceName';
    const select = document.getElementById(id);
    if (select) {
        select.addEventListener('change', () => syncProvinceName(id, hiddenId));
        syncProvinceName(id, hiddenId);
    }
});