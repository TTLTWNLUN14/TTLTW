let writeStars = 0;

// Star hover + click
document.querySelectorAll('#writeStars .star').forEach(s => {
  s.addEventListener('mouseover', () => {
    document.querySelectorAll('#writeStars .star').forEach((x,i) => x.classList.toggle('lit', i <= s.dataset.v - 1));
  });
  s.addEventListener('mouseout', () => {
    document.querySelectorAll('#writeStars .star').forEach((x,i) => x.classList.toggle('lit', i < writeStars));
  });
  s.addEventListener('click', () => {
    writeStars = +s.dataset.v;
    document.querySelectorAll('#writeStars .star').forEach((x,i) => x.classList.toggle('lit', i < writeStars));
  });
});

function renderFeedbacks() {
  const filter = +document.getElementById('filterStars').value || 0;
  let fbs = Store.getFeedbacks();
  if (filter) fbs = fbs.filter(f => f.stars === filter);

  const list = document.getElementById('feedbackList');
  if (!fbs.length) { list.innerHTML = '<div class="empty">Chưa có đánh giá nào.</div>'; return; }

  list.innerHTML = fbs.map(f => {
    const initial = (f.user || 'K').charAt(0).toUpperCase();
    const starStr = '★'.repeat(f.stars) + '☆'.repeat(5 - f.stars);
    return `
      <div class="fb-card">
        <div class="fb-avatar">${initial}</div>
        <div class="fb-body">
          <div class="fb-header">
            <span class="fb-name">${f.user}</span>
            <span class="fb-stars">${starStr}</span>
            <span class="fb-date">${Store.fmtDate(f.date)}</span>
          </div>
          <div class="fb-text">${f.text}</div>
        </div>
      </div>`;
  }).join('');
}

function renderStats() {
  const fbs = Store.getFeedbacks();
  const avg  = fbs.length ? (fbs.reduce((s,f) => s + f.stars, 0) / fbs.length).toFixed(1) : 0;
  const five = fbs.filter(f => f.stars === 5).length;
  document.getElementById('statsRow').innerHTML = `
    <div class="stat-box"><div class="stat-box__num">${avg}⭐</div><div class="stat-box__lbl">Điểm trung bình</div></div>
    <div class="stat-box"><div class="stat-box__num">${fbs.length}</div><div class="stat-box__lbl">Lượt đánh giá</div></div>
    <div class="stat-box"><div class="stat-box__num">${five}</div><div class="stat-box__lbl">Đánh giá 5 sao</div></div>
  `;
}

function submitFeedback() {
  const name = document.getElementById('fbName').value.trim();
  const text = document.getElementById('fbText').value.trim();
  if (!name || !writeStars || !text) { toast('Vui lòng điền đầy đủ và chọn số sao!', 'err'); return; }
  Store.addFeedback({ user: name, stars: writeStars, text, date: new Date().toISOString().slice(0,10) });
  document.getElementById('fbName').value = '';
  document.getElementById('fbText').value = '';
  writeStars = 0;
  document.querySelectorAll('#writeStars .star').forEach(s => s.classList.remove('lit'));
  toast('Cảm ơn bạn đã đánh giá!');
  renderStats();
  renderFeedbacks();
}

renderStats();
renderFeedbacks();
