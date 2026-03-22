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
});