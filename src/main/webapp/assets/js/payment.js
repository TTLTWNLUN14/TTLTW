document.addEventListener("DOMContentLoaded", function() {
    const paymentCards = document.querySelectorAll('.payment-card');
    paymentCards.forEach(card => {
        card.addEventListener('click', function() {
            paymentCards.forEach(m => m.classList.remove('active'));
            this.classList.add('active');
        });
    });
    const couponItems = document.querySelectorAll('.coupon-item');
    const discountInput = document.getElementById('discount-code');

    couponItems.forEach(item => {
        item.addEventListener('click', function() {
            couponItems.forEach(c => c.classList.remove('active'));
            this.classList.add('active');
            const codeName = this.querySelector('strong').innerText;
            if(discountInput) discountInput.value = codeName;
        });
    });
    const btnApply = document.querySelector('.btn-apply');
    const summaryDiscount = document.getElementById('summary-discount');
    const finalPrice = document.getElementById('final-price');

    if(btnApply) {
        btnApply.addEventListener('click', function() {
            if(discountInput.value.trim() !== "") {
                summaryDiscount.style.display = "flex";
                finalPrice.innerText = "844.800đ";
                alert("Đã áp dụng mã giảm giá thành công!");
            } else {
                alert("Vui lòng chọn một mã giảm giá trước.");
            }
        });
    }
});