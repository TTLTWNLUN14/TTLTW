function goBook(from, to) {
  location.href = `booking.html?from=${encodeURIComponent(from)}&to=${encodeURIComponent(to)}`;
}
