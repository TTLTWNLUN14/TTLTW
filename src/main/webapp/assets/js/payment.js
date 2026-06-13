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

    //////
    const SUBTOTAL = 500000;

    function toggleSubmitBtn() {
        const chk = document.getElementById('agree-terms') || document.getElementById('termsChk');
        const btnSubmit = document.getElementById('btnSubmit') || document.querySelector('.btn-next');
        const termsError = document.getElementById('termsError');

        if (chk && btnSubmit) {
            btnSubmit.disabled = !chk.checked;
        }
        if (chk && chk.checked && termsError) {
            termsError.style.display = 'none';
        }
    }

    function validateForm() {
        const chk = document.getElementById('agree-terms') || document.getElementById('termsChk');
        const termsError = document.getElementById('termsError');

        if (chk && !chk.checked) {
            if (termsError) termsError.style.display = 'block';
            return false;
        }
        return true;
    }

    function updateTotal() {
        const discount = 0;
        const total = SUBTOTAL - discount;
        const grandTotalEl = document.getElementById('grandTotal');
        if (grandTotalEl) {
            grandTotalEl.textContent = total.toLocaleString('vi-VN') + 'đ';
        }
    }

    const agreeTermsChk = document.getElementById('agree-terms') || document.getElementById('termsChk');
    if (agreeTermsChk) {
        agreeTermsChk.addEventListener('change', toggleSubmitBtn);
    }

    updateTotal();

});