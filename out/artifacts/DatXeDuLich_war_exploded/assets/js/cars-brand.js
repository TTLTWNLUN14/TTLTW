    const modal = document.getElementById('brandModal');
    const closeIcon = document.getElementById('closeIcon');
    const closeBtn = document.getElementById('closeBtn');

    const brandCards = document.querySelectorAll('.brand-card');

    function openModal() {
    modal.classList.add('show');
    document.body.style.overflow = 'hidden';
}

    function closeModal() {
    modal.classList.remove('show');
    document.body.style.overflow = 'auto';
}

    brandCards.forEach(card => {
    card.addEventListener('click', openModal);
});

    closeIcon.addEventListener('click', closeModal);
    closeBtn.addEventListener('click', closeModal);
    window.addEventListener('click', (event) => {
    if (event.target === modal) {
    closeModal();
}
});
