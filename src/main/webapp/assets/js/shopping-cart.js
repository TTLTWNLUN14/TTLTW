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

cancelModal.addEventListener('click', function(e) {
    if (e.target === cancelModal) {
        closeCancelModal();
    }
});

document.getElementById('cancelModalClose').addEventListener('click', closeCancelModal);

function updateSelectedTotal() {
    const checkboxes = document.querySelectorAll('.item-checkbox:checked');
    let total = 0;
    checkboxes.forEach(cb => {
        total += parseFloat(cb.dataset.total) || 0;
    });

    document.getElementById('selectedCount').textContent = checkboxes.length;
    document.getElementById('selectedTotal').textContent =
        total.toLocaleString('vi-VN') + ' VND';

    // enable/disable nút thanh toán
    document.getElementById('btnPayment').disabled = checkboxes.length === 0;

    // chọn all
    const all = document.querySelectorAll('.item-checkbox');
    document.getElementById('selectAll').checked =
        all.length > 0 && checkboxes.length === all.length;
}

function toggleSelectAll(selectAllCb) {
    document.querySelectorAll('.item-checkbox').forEach(cb => {
        cb.checked = selectAllCb.checked;
    });
    updateSelectedTotal();
}

function submitPayment() {
    const checkboxes = document.querySelectorAll('.item-checkbox:checked');
    if (checkboxes.length === 0) return;

    const form = document.getElementById('paymentForm');

    form.querySelectorAll('input[name="selectedItems"]').forEach(i => i.remove());

    checkboxes.forEach(cb => {
        const input = document.createElement('input');
        input.type   = 'hidden';
        input.name   = 'selectedItems';
        input.value  = cb.value;
        form.appendChild(input);
    });

    form.submit();
}

function submitBooking() {
    const checked = document.querySelectorAll('.item-checkbox:checked');
    if (checked.length === 0) return;

    const form = document.getElementById('bookingForm');
    if (form) {
        form.querySelectorAll('input[name="selectedItems"]').forEach(el => el.remove());

        checked.forEach(cb => {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'selectedItems';
            input.value = cb.value;
            form.appendChild(input);
        });

        form.submit();
    }
}

document.addEventListener('DOMContentLoaded', function () {
    const originalUpdateSelectedTotal = updateSelectedTotal;

    updateSelectedTotal = function() {
        originalUpdateSelectedTotal();
        const checkboxes = document.querySelectorAll('.item-checkbox:checked');
        const btnBooking = document.getElementById('btnBooking');
        if (btnBooking) {
            btnBooking.disabled = checkboxes.length === 0;
        }
    };

    const checkBoxesExist = document.querySelectorAll('.item-checkbox');
    if (checkBoxesExist.length > 0) {
        updateSelectedTotal();
    }
});