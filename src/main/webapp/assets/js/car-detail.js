document.addEventListener("DOMContentLoaded", function() {
    const thumbs = document.querySelectorAll('.cd-thumb');
    thumbs.forEach(thumb => {
        thumb.addEventListener('click', function() {
            thumbs.forEach(t => t.classList.remove('active'));
            this.classList.add('active');
        });
    });
});
//ajax
function addToCart(productId, quantity, isDriver, productName, btn) {
    var url = CONTEXT_PATH + '/add-cart'
        + '?productId=' + productId
        + '&quantity=' + quantity
        + '&isDriver=' + isDriver;

    var originalText = btn.textContent;

    btn.disabled = true;
    btn.textContent = 'Đang xử lý...';

    fetch(url, {
        headers: { 'X-Requested-With': 'XMLHttpRequest' }
    })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data.success) {
                //cập nhật sl giỏ hàng
                var badge = document.querySelector('.cart-count');
                if (badge) badge.textContent = data.cartCount;

                var modal = document.getElementById('cartModal');
                var nameSpan = document.getElementById('modalProductName');

                if (modal && nameSpan) {
                    nameSpan.textContent = productName;
                    modal.style.display = 'flex';
                }

                btn.disabled = false;
                btn.textContent = 'Thêm vào giỏ hàng';
            }
        })
        .catch(function() {
            btn.disabled = false;
            btn.textContent = originalText;

            var errorModal = document.getElementById('errorModal');
            var errorMsgSpan = document.getElementById('modalErrorMessage');

            if (errorModal && errorMsgSpan) {
                errorMsgSpan.textContent = "Không thể kết nối đến hệ thống hoặc có lỗi xảy ra. Vui lòng thử lại!";
                errorModal.style.display = 'flex';
            }
        });
}

function closeModal(modalId) {
    var modal = document.getElementById(modalId);
    if(modal) {
        modal.style.display = 'none';
    }
}