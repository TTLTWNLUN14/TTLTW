document.addEventListener("DOMContentLoaded", function () {
    const coupons = document.querySelectorAll(".coupon-item");
    const discountInput = document.getElementById("discount-code");
    const applyBtn = document.querySelector(".btn-apply");

    const discountAmountText = document.getElementById("discount-amount");
    const finalPriceText = document.getElementById("final-price");

    coupons.forEach(coupon => {
        coupon.addEventListener("click", function () {
            coupons.forEach(c => c.classList.remove("active"));
            this.classList.add("active");
            discountInput.value = this.querySelector("strong").innerText;
        });
    });

    applyBtn.addEventListener("click", function () {
        if (discountInput.value === "") {
            alert("Vui lòng chọn mã giảm giá!");
        } else {
            alert("Áp dụng mã thành công: " + discountInput.value);
            discountAmountText.innerText = "-100.000đ";
            discountAmountText.style.color = "#ef4444";
            finalPriceText.innerText = "900.000đ";
        }
    });

    const paymentCards = document.querySelectorAll(".payment-card");
    const btnNextLink = document.querySelector(".btn-next a");
    const agreeTerms = document.getElementById("agree-terms");

    paymentCards.forEach(card => {
        card.addEventListener("click", function () {
            paymentCards.forEach(c => c.classList.remove("active"));
            this.classList.add("active");

            const radio = this.querySelector("input[type='radio']");
            radio.checked = true;
        });
    });

    btnNextLink.addEventListener("click", function (e) {
        const selectedPayment = document.querySelector("input[name='payment_method']:checked");
        if (!selectedPayment) {
            e.preventDefault();
            alert("Vui lòng chọn phương thức thanh toán!");
            return;
        }
        if (!agreeTerms.checked) {
            e.preventDefault();
            alert("Bạn phải đồng ý với điều khoản dịch vụ!");
            return;
        }
    });
});