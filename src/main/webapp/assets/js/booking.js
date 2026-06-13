    function syncProvinceNames() {
        var pairs = [
            ['fromProvinceSelect', 'fromProvinceName'],
            ['toProvinceSelect', 'toProvinceName']
        ];
        pairs.forEach(function (p) {
            var sel = document.getElementById(p[0]);
            var hidden = document.getElementById(p[1]);
            if (!sel || !hidden) return;
            var opt = sel.options[sel.selectedIndex];
            hidden.value = opt ? (opt.getAttribute('data-name') || '') : '';
        });
    }

    /* Thêm vào giỏ hàng */
    function submitAddCart() {
        var form = document.getElementById('bookingForm');
        syncProvinceNames();
        // Xoá flag bookNow nếu còn sót
        var old = form.querySelector('input[name="bookNow"]');
        if (old) old.remove();
        // Đảm bảo action đúng
        form.action = CONTEXT_PATH + '/add-cart';
        form.method = 'get';
        form.submit();
    }

    /* Đặt ngay → booking-confirm, không qua giỏ */
    function submitBookNow() {
        var form = document.getElementById('bookingForm');
        syncProvinceNames();
        // Thêm flag bookNow=1
        var inp = form.querySelector('input[name="bookNow"]');
        if (!inp) {
            inp = document.createElement('input');
            inp.type = 'hidden';
            inp.name = 'bookNow';
            form.appendChild(inp);
        }
        inp.value = '1';
        // Set action thẳng, không dùng replace (tránh double context-path)
        form.action = CONTEXT_PATH + '/booking';
        form.method = 'get';
        form.submit();
    }
