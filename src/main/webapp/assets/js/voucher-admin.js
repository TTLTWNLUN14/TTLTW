document.getElementById('openAddModalBtn').onclick = function() {
    document.getElementById('addModal').style.display = 'flex';
}

document.querySelectorAll('.btn-edit').forEach(btn => {
    btn.addEventListener('click', function() {
        document.getElementById('editVoucherId').value = this.dataset.id;
        document.getElementById('editCode').value = this.dataset.code;
        document.getElementById('editName').value = this.dataset.name;
        document.getElementById('editDiscount').value = this.dataset.discount;
        document.getElementById('editPriceMaxDiscount').value = this.dataset.maxdiscount;
        document.getElementById('editMinOrder').value = this.dataset.minorder;
        document.getElementById('editMinTier').value = this.dataset.mintier;
        document.getElementById('editUsesLeft').value = this.dataset.usesleft;
        document.getElementById('editExpiresAt').value = this.dataset.expires;
        document.getElementById('editIsActive').checked = (this.dataset.active === 'true');
        document.getElementById('editModal').style.display = 'flex';
    });
});

function closeModal(modalId) {
    document.getElementById(modalId).style.display = 'none';
}

window.onclick = function(event) {
    if (event.target.classList.contains('modal')) {
        event.target.style.display = 'none';
    }
}