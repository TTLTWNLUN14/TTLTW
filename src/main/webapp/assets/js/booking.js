
document.querySelectorAll('.rt-card').forEach(card => {
    card.addEventListener('click', function() {
        document.querySelectorAll('.rt-card').forEach(el => el.classList.remove('active'));
        this.classList.add('active');
    });
});

document.querySelectorAll('.cc-card').forEach(card => {
    card.addEventListener('click', function() {
        document.querySelectorAll('.cc-card').forEach(c => c.classList.remove('active'));
        this.classList.add('active');
    });
});