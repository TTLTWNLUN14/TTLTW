function filterTable() {
        const search = document.getElementById('searchInput').value.toLowerCase();
        const tier   = document.getElementById('tierFilter').value.toLowerCase();
        const status = document.getElementById('statusFilter').value;

        document.querySelectorAll('#memberTable tbody tr').forEach(row => {
            const text      = row.innerText.toLowerCase();
            const rowTier   = (row.dataset.tier   || '').toLowerCase();
            const rowStatus =  row.dataset.status || '';

            const matchSearch = !search || text.includes(search);
            const matchTier   = !tier   || rowTier === tier;
            const matchStatus = !status || rowStatus === status;

            row.style.display = (matchSearch && matchTier && matchStatus) ? '' : 'none';
        });
    }


    function openEditModal(customerId, fullName, email, memberTier, points) {
        document.getElementById('modalCustomerId').value = customerId;
        document.getElementById('modalFullName').value   = fullName;
        document.getElementById('modalEmail').value      = email;
        document.getElementById('modalPoints').value     = points;

        const sel = document.getElementById('modalTier');
        for (let i = 0; i < sel.options.length; i++) {
            sel.options[i].selected = sel.options[i].value === memberTier;
        }

        document.getElementById('editModal').classList.add('open');
    }

    function closeModal() {
        document.getElementById('editModal').classList.remove('open');
    }

    document.getElementById('editModal').addEventListener('click', function(e) {
        if (e.target === this) closeModal();
    });
