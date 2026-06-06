function openConfirm(brandId, brandName) {
    document.getElementById('confirmBrandName').textContent = brandName;
    document.getElementById('deleteBrandId').value = brandId;
    document.getElementById('confirmOverlay').classList.add('open');
}

function closeConfirm() {
    document.getElementById('confirmOverlay').classList.remove('open');
}

document.getElementById('confirmOverlay').addEventListener('click', function(e) {
    if (e.target === this) closeConfirm();
});

function submitDelete() {
    document.getElementById('deleteForm').submit();
}
const toast = document.getElementById('toastSuccess');
if (toast) {
    setTimeout(() => {
        toast.style.opacity = '0';
        toast.style.transform = 'translateY(-16px)';
        setTimeout(() => toast.remove(), 100);
    }, 1000);
}