function openCancelModal() {
    document.getElementById('cancelModal').classList.add('open');
}

function closeCancelModal() {
    document.getElementById('cancelModal').classList.remove('open');
}

document.addEventListener('DOMContentLoaded', function () {
    var modal = document.getElementById('cancelModal');
    if (modal) {
        modal.addEventListener('click', function (e) {
            if (e.target === this) closeCancelModal();
        });
    }
});