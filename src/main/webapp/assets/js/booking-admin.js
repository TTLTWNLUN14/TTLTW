function fmt(n) {
    return Number(n).toLocaleString('vi-VN') + ' đ';
}

function closeModal(id) {
    document.getElementById(id).classList.remove('open');
}

function openOverlay(id) {
    document.getElementById(id).classList.add('open');
}

// Đóng khi click ngoài modal box
document.querySelectorAll('.modal-overlay').forEach(overlay => {
    overlay.addEventListener('click', function (e) {
        if (e.target === this) this.classList.remove('open');
    });
});

const toast = document.getElementById('toastMsg');
if (toast) {
    setTimeout(() => {
        toast.style.opacity  = '0';
        toast.style.transform = 'translateY(-16px)';
        setTimeout(() => toast.remove(), 420);
    }, 3000);
}
function openEditModal(id, name, phone, address,
                       pickup, dropoff, pickupTime, returnTime,
                       note, status, totalPrice) {
    document.getElementById('editBookingLabel').textContent = '#' + id;
    document.getElementById('editBookingId').value    = id;
    document.getElementById('editBookerName').value   = name;
    document.getElementById('editBookerPhone').value  = phone;
    document.getElementById('editBookerAddress').value = address;
    document.getElementById('editPickup').value       = pickup;
    document.getElementById('editDropoff').value      = dropoff;
    document.getElementById('editPickupTime').value   = pickupTime;
    document.getElementById('editReturnTime').value   = returnTime;
    document.getElementById('editNote').value         = (note && note !== 'null') ? note : '';
    document.getElementById('editTotalPrice').value   = totalPrice;

    const statusSel = document.getElementById('editStatus');
    statusSel.value = status;

    openOverlay('editOverlay');
}

function openDeleteConfirm(bookingId, label) {
    document.getElementById('deleteBookingLabel').textContent = label;
    document.getElementById('deleteBookingId').value          = bookingId;
    openOverlay('deleteOverlay');
}

function submitDelete() {
    document.getElementById('deleteForm').submit();
}