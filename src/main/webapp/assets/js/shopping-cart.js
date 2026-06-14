var cancelModal = document.getElementById('cancelModal');

function toggleDetail(btn, typeId) {
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

if (cancelModal) {
    cancelModal.addEventListener('click', function(e) {
        if (e.target === cancelModal) {
            closeCancelModal();
        }
    });
}

var cancelModalClose = document.getElementById('cancelModalClose');
if (cancelModalClose) {
    cancelModalClose.addEventListener('click', closeCancelModal);
}

function openCancelModal(bookingId) {
    document.getElementById('cancelBookingIdInput').value = bookingId;
    document.getElementById('cancelModalLabel').textContent = '#' + bookingId;
    if (cancelModal) cancelModal.style.display = 'flex';
}

function closeCancelModal() {
    if (cancelModal) cancelModal.style.display = 'none';
}

function updateSelectedTotal() {
    const checkboxes = document.querySelectorAll('.item-checkbox:checked');
    let total = 0;
    checkboxes.forEach(cb => {
        total += parseFloat(cb.dataset.total) || 0;
    });

    const countEl = document.getElementById('selectedCount');
    const totalEl = document.getElementById('selectedTotal');
    if (countEl) countEl.textContent = checkboxes.length;
    if (totalEl) totalEl.textContent = total.toLocaleString('vi-VN') + ' VND';

    const btnBooking = document.getElementById('btnBooking');
    if (btnBooking) btnBooking.disabled = checkboxes.length === 0;

    // chọn all
    const all = document.querySelectorAll('.item-checkbox');
    const selectAll = document.getElementById('selectAll');
    if (selectAll) {
        selectAll.checked = all.length > 0 && checkboxes.length === all.length;
    }
}

function toggleSelectAll(selectAllCb) {
    document.querySelectorAll('.item-checkbox').forEach(cb => {
        cb.checked = selectAllCb.checked;
    });
    updateSelectedTotal();
}

function submitBooking() {
    const checked = document.querySelectorAll('.item-checkbox:checked');
    if (checked.length === 0) return;

    const form = document.getElementById('bookingForm');
    if (form) {
        form.querySelectorAll('input[name="selectedItems"]').forEach(el => el.remove());
        checked.forEach(cb => {
            const input = document.createElement('input');
            input.type  = 'hidden';
            input.name  = 'selectedItems';
            input.value = cb.value;
            form.appendChild(input);
        });
        form.submit();
    }
}

document.addEventListener('DOMContentLoaded', function () {
    updateSelectedTotal();
});
function switchTab(tabName) {
    var tabCart = document.getElementById('tabCart');
    var tabHistory = document.getElementById('tabHistory');
    var cartSection = document.getElementById('cartSection');
    var historySection = document.getElementById('historySection');
    var rightPanel = document.getElementById('rightPanel');

    if (tabName == 'cart') {
        tabCart.className = "tab active";
        tabHistory.className = "tab";
        cartSection.style.display = "block";
        rightPanel.style.display = "block";
        historySection.style.display = "none";
    } else {
        tabCart.className = "tab";
        tabHistory.className = "tab active";
        cartSection.style.display = "none";
        rightPanel.style.display = "none";
        historySection.style.display = "block";
    }
}

window.addEventListener('load', function () {
    var currentUrl = window.location.href;
    if (currentUrl.indexOf("statusFilter") != -1) {
        switchTab('history');
    } else {
        switchTab('cart');
    }
});