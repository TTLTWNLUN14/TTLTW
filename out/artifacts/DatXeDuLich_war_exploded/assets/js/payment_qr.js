document.addEventListener("DOMContentLoaded", function () {
    const btnPaid = document.getElementById("btn-paid");

    btnPaid.addEventListener("click", function() {
        this.innerText = "Đang kiểm tra giao dịch...";
        this.disabled = true;
        this.style.opacity = "0.7";
        this.style.cursor = "wait";

        setTimeout(() => {
            window.location.href = "payment_confirmation.html";
        }, 1500);
    });

});