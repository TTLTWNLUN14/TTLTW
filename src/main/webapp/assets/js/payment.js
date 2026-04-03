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

    const btnNext = document.querySelector('.btn-next');
    if (btnNext) {
        btnNext.addEventListener('click', function(event) {
            const paymentMethod = document.querySelector('input[name="payment_method"]:checked');
            const agreeTerms = document.getElementById('agree-terms');

            if (!paymentMethod) {
                alert("Vui lòng chọn một phương thức thanh toán!");
                event.preventDefault();
                return;
            }

            if (agreeTerms && !agreeTerms.checked) {
                alert("Vui lòng tick chọn 'Tôi đồng ý với điều khoản dịch vụ và chính sách thuê xe'!");
                event.preventDefault();
                return;
            }
        });
    }

});