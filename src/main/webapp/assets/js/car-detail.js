document.addEventListener("DOMContentLoaded", function() {
    const thumbs = document.querySelectorAll('.cd-thumb');
    thumbs.forEach(thumb => {
        thumb.addEventListener('click', function() {
            thumbs.forEach(t => t.classList.remove('active'));
            this.classList.add('active');
        });
    });
});