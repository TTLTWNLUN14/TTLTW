// checkbox lấy ra các checkbox để tính cho thanh toán
function recalcTotal() {
    let total = 0;
    document.querySelectorAll('.order-card').forEach(function(card) {
        const cb = card.querySelector('.cart-select');
        if (cb && cb.checked) {
            const price    = parseInt(card.dataset.price)    || 0;
            const quantity = parseInt(card.dataset.quantity) || 0;
            total += price * quantity;
        }
    });
    document.getElementById('total-display').textContent =
        total.toLocaleString('vi-VN') + ' VND';
}

// pain xem chi tiết
function toggleDetail(btn, productId) {
    const panel = document.getElementById('detail-' + productId);
    const isOpen = panel.classList.toggle('open');
    btn.textContent = isOpen ? 'Ẩn chi tiết ▴' : 'Xem chi tiết ▾';
}

window.onload = recalcTotal;