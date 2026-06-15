
function openCancelModal() {
    var modal = document.getElementById('cancelModal');
    if (modal) {
        modal.style.display = 'flex';
    }
}

function closeCancelModal() {
    var modal = document.getElementById('cancelModal');
    if (modal) {
        modal.style.display = 'none';
    }
}

//  click ra ngoài vùng trắng để đóng modal tự động
document.addEventListener('DOMContentLoaded', function () {
    var modal = document.getElementById('cancelModal');
    if (modal) {
        modal.addEventListener('click', function (e) {
            if (e.target === this) {
                closeCancelModal();
            }
        });
    }
});