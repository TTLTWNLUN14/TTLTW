document.addEventListener("DOMContentLoaded", function () {
    const coupons = document.querySelectorAll(".coupon-item");
    const discountInput = document.getElementById("discount-code");

    coupons.forEach(coupon => {
        coupon.addEventListener("click", function () {

            coupons.forEach(c => c.classList.remove("active"));
            this.classList.add("active");

            const code = this.querySelector("strong").innerText;
            discountInput.value = code;
        });
    });
    const applyBtn = document.querySelector(".btn-apply");

    applyBtn.addEventListener("click", function () {
        if (discountInput.value === "") {
            alert("Vui lòng chọn mã giảm giá!");
        } else {
            alert("Áp dụng mã: " + discountInput.value);
        }
    });
    const paymentCards = document.querySelectorAll(".payment-card");

    paymentCards.forEach(card => {
        card.addEventListener("click", function () {

            paymentCards.forEach(c => c.classList.remove("active"));
            this.classList.add("active");

            const radio = this.querySelector("input[type='radio']");
            radio.checked = true;
        });
    });
    const btnNextLink = document.querySelector(".btn-next a"); // bắt vào <a>
    const agreeTerms = document.getElementById("agree-terms");

    btnNextLink.addEventListener("click", function (e) {

        const selectedPayment = document.querySelector("input[name='payment_method']:checked");
        if (!selectedPayment) {
            e.preventDefault();
            alert("Vui lòng chọn phương thức thanh toán!");
            return;
        }
        if (!agreeTerms.checked) {
            e.preventDefault();
            alert("Bạn phải đồng ý với điều khoản!");
            return;
        }
    });

});