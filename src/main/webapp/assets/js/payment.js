let SUBTOTAL = 0;
let DISCOUNT_AMOUNT = 0;
let APPLIED_VOUCHER_ID = null;

document.addEventListener('DOMContentLoaded', function () {
    const subtotalText = document.getElementById('subtotalDisplay')?.textContent || "0VND";
    SUBTOTAL = parseVND(subtotalText);

    const agreeTermsChk = document.getElementById('termsChk');
    if (agreeTermsChk) {
        agreeTermsChk.addEventListener('change', toggleSubmitBtn);
    }

    updateTotal();
});

function parseVND(text) {
    const cleaned = text.replace(/VND|\.|\s/g, '');
    const number = parseInt(cleaned) || 0;
    return number;
}

function formatVND(number) {
    return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".") + "VND";
}

function updateTotal() {
    const grandTotal = document.getElementById('grandTotal');

    const finalTotal = SUBTOTAL - APPLIED_DISCOUNT;

    if (grandTotal) {
        grandTotal.textContent = formatVND(finalTotal >= 0 ? finalTotal : 0);
    }
}

function toggleSubmitBtn() {
    const chk = document.getElementById('termsChk');
    const btnSubmit = document.getElementById('btnSubmit');
    const termsError = document.getElementById('termsError');

    if (chk && btnSubmit) {
        btnSubmit.disabled = !chk.checked;
    }

    if (chk && chk.checked && termsError) {
        termsError.style.display = 'none';
    }
}

function clearMethodError() {
    const methodError = document.getElementById('methodError');
    if (methodError) {
        methodError.style.display = 'none';
    }
}

function validateForm() {
    document.getElementById('termsError').style.display = 'none';
    document.getElementById('methodError').style.display = 'none';

    let isValid = true;

    const termsChk = document.getElementById('termsChk');
    if (!termsChk || !termsChk.checked) {
        document.getElementById('termsError').style.display = 'block';
        isValid = false;
    }

    const methodRadios = document.querySelectorAll('input[name="method"]');
    const methodSelected = Array.from(methodRadios).some(radio => radio.checked);

    if (!methodSelected) {
        document.getElementById('methodError').style.display = 'block';
        isValid = false;
    }

    if (!isValid) {
        window.scrollTo({ top: 0, behavior: 'smooth' });
        return false;
    }

    return true;
}

function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(amount);
}

function applyVoucher() {
    const voucherCode = document.getElementById('voucherCode').value.trim();

    document.getElementById('voucherSuccessMsg').style.display = 'none';
    document.getElementById('voucherErrorMsg').style.display = 'none';

    if (!voucherCode) {
        showVoucherError("Vui lòng nhập mã giảm giá.");
        return;
    }

    if (voucherCode.length < 3) {
        showVoucherError("Mã giảm giá phải có ít nhất 3 ký tự.");
        return;
    }

    const btnApply = document.getElementById('btnApplyVoucher');
    btnApply.disabled = true;
    btnApply.textContent = "Đang kiểm tra...";

    fetch("${pageContext.request.contextPath || '' }/apply-voucher", {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
        },
        body: 'voucherCode=' + encodeURIComponent(voucherCode) +
            '&totalAmount=' + SUBTOTAL
    })
        .then(response => response.text())
        .then(text => {
            btnApply.disabled = false;
            btnApply.textContent = "Áp dụng";

            const parts = text.split('|');
            const status = parts[0].trim();

            if (status === 'SUCCESS') {
                APPLIED_VOUCHER_ID = parts[1] ? parts[1].trim() : "";
                DISCOUNT_AMOUNT = parts[2] ? parseInt(parts[2].trim()) || 0 : 0;
                document.getElementById('appliedVoucherId').value = APPLIED_VOUCHER_ID;
                showVoucherSuccess('Áp dụng thành công! Tiết kiệm ' + formatVND(DISCOUNT_AMOUNT));
                updateTotal();
                document.getElementById('voucherCode').disabled = true;

            } else {
                DISCOUNT_AMOUNT = 0;
                APPLIED_VOUCHER_ID = null;
                document.getElementById('appliedVoucherId').value = "";
                const errorMessage = parts[1] ? parts[1].trim() : "Áp dụng mã giảm giá thất bại.";
                showVoucherError(errorMessage);
                updateTotal();
            }
        })
        .catch(error => {
            console.error('Error:', error);
            btnApply.disabled = false;
            btnApply.textContent = "Áp dụng";
            showVoucherError("Lỗi kết nối. Vui lòng thử lại.");
        });
}