document.addEventListener('DOMContentLoaded', function () {
    const discountInput = document.getElementById('discount-code');
    const savedVoucher = localStorage.getItem('selectedVoucher');

    if (savedVoucher && discountInput) {
        discountInput.value = savedVoucher;
        localStorage.removeItem('selectedVoucher');
    }

    const paymentCards = document.querySelectorAll('.payment-card');
    paymentCards.forEach(card => {
        card.addEventListener('click', function () {
            paymentCards.forEach(c => c.classList.remove('active'));
            this.classList.add('active');
            const radio = this.querySelector('input[type="radio"]');
            if (radio) radio.checked = true;
        });
    });

    const btnSubmit = document.getElementById('link-submit-payment');
    const agreeCheckbox = document.getElementById('agree-terms');

    btnSubmit.addEventListener('click', function (e) {
        const isMethodSelected = document.querySelector('.payment-card.active');
        const isAgreed = agreeCheckbox.checked;
        if (!isAgreed || !isMethodSelected) {
            e.preventDefault();

            // Thông báo cho người dùng
            if (!isMethodSelected) {
                alert("Vui lòng chọn phương thức thanh toán!");
            } else if (!isAgreed) {
                alert("Vui lòng tích vào 'Tôi đồng ý với điều khoản' để tiếp tục!");
            }
        }
    });
});