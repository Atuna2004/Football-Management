<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xác nhận thanh toán</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #0d6efd;
            --secondary-color: #6c757d;
            --success-color: #198754;
            --vnpay-color: #00b894;
            --cash-color: #fdcb6e;
            --text-dark: #212529;
            --text-light: #6c757d;
            --background-light: #f8f9fa;
            --border-color: #dee2e6;
        }

        body {
            background: var(--background-light);
            font-family: 'Inter', sans-serif;
            padding: 40px 20px;
        }

        .confirmation-card {
            max-width: 900px;
            margin: auto;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.08);
            overflow: hidden;
        }

        .card-header-custom {
            background: var(--primary-color);
            color: white;
            padding: 24px;
            text-align: center;
        }

        .card-header-custom h2 {
            font-size: 1.75rem;
            font-weight: 600;
            margin: 0;
        }

        .card-body-custom {
            padding: 32px;
        }

        .section-title {
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 20px;
            color: var(--text-dark);
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .info-block p {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            font-size: 1rem;
            color: var(--text-light);
        }

        .info-block .info-value {
            font-weight: 500;
            color: var(--text-dark);
        }

        .summary-block {
            background: var(--background-light);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 24px;
        }

        .summary-block .total-price {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-top: 15px;
        }

        .payment-options {
            margin-top: 20px;
        }

        .payment-btn {
            width: 100%;
            padding: 15px;
            font-size: 1.1rem;
            font-weight: 500;
            border-radius: 8px;
            border: none;
            margin-bottom: 15px;
            text-align: left;
            transition: all 0.2s ease;
        }

        .payment-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .btn-cash {
            background-color: var(--cash-color);
            color: #2d3436;
        }

        .btn-vnpay {
            background-color: var(--vnpay-color);
            color: white;
        }

        .discount-section {
            margin-top: 24px;
        }

        .discount-input-group {
            display: flex;
            gap: 10px;
        }

        .discount-input-group input {
            flex-grow: 1;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            padding: 0 15px;
        }

        .discount-input-group button {
            border-radius: 8px;
            border: none;
            background-color: var(--secondary-color);
            color: white;
            padding: 0 20px;
            font-weight: 500;
        }

        .discount-result {
            margin-top: 10px;
            font-weight: 500;
        }

        .text-success {
            color: var(--success-color) !important;
        }

        .text-danger {
            color: #dc3545 !important;
        }
    </style>
</head>
<body>

<div class="confirmation-card">
    <div class="card-header-custom">
        <h2><i class="fas fa-check-circle me-2"></i>Xác nhận thông tin đặt sân</h2>
    </div>

    <div class="card-body-custom">
        <div class="row">
            <div class="col-md-7">
                <div class="section-title"><i class="fas fa-user-circle"></i>Thông tin khách hàng</div>
                <div class="info-block">
                    <p>Họ tên: <span class="info-value">${customerName}</span></p>
                    <p>Số điện thoại: <span class="info-value">${customerPhone}</span></p>
                    <p>Email: <span class="info-value">${customerEmail}</span></p>
                </div>

                <div class="section-title mt-4"><i class="fas fa-credit-card"></i>Chọn phương thức thanh toán</div>
                <div class="payment-options">
                    <form id="paymentForm" method="post">
                        <input type="hidden" name="stadiumId" value="${stadiumId}"/>
                        <input type="hidden" name="bookingId" value="${bookingId}"/>
                        <input type="hidden" name="totalAmount" id="finalAmountInput" value="${totalAmount}"/>
                        <input type="hidden" name="discountCode" id="appliedDiscountCode" value=""/>
                        <input type="hidden" name="method" id="paymentMethod" value=""/>

                        <button type="button" class="payment-btn btn-cash" data-method="offline">
                            <i class="fas fa-money-bill-wave me-2"></i> Thanh toán tại sân
                        </button>
                        <button type="button" class="payment-btn btn-vnpay" data-method="vnpay">
                            <i class="fab fa-cc-visa me-2"></i> Thanh toán qua VNPay
                        </button>
                    </form>
                </div>
            </div>

            <div class="col-md-5">
                <div class="summary-block">
                    <div class="section-title"><i class="fas fa-receipt"></i>Tóm tắt đơn hàng</div>
                    <div class="info-block">
                        <p>Sân bóng: <span class="info-value">${stadiumName}</span></p>
                        <p>Ngày đặt: <span class="info-value">${bookingDate}</span></p>
                        <p>Thời gian: <span class="info-value">${bookingTime}</span></p>
                        <hr>
                        <p class="mt-3">Thành tiền:</p>
                        <p class="total-price" id="totalPriceDisplay" data-original-total="${totalAmount}">
                            <fmt:formatNumber value="${totalAmount}" type="number" pattern="#,##0"/> VNĐ
                        </p>
                        <div id="discount-display" class="info-block" style="display: none;">
                            <p class="text-success">Giảm giá: <span id="discount-amount" class="info-value"></span></p>
                        </div>
                    </div>

                    <div class="discount-section">
                        <label for="discountCodeInput" class="form-label">Mã giảm giá</label>
                        <div class="discount-input-group">
                            <input type="text" class="form-control" id="discountCodeInput"
                                   placeholder="Nhập mã ở đây...">
                            <button type="button" id="applyDiscountBtn">Áp dụng</button>
                        </div>
                        <div id="discount-result" class="discount-result mt-2"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const paymentForm = document.getElementById('paymentForm');
        const paymentMethodInput = document.getElementById('paymentMethod');
        const paymentButtons = document.querySelectorAll('.payment-btn');
        const applyDiscountBtn = document.getElementById('applyDiscountBtn');
        const discountCodeInput = document.getElementById('discountCodeInput');
        const discountResult = document.getElementById('discount-result');
        const totalPriceDisplay = document.getElementById('totalPriceDisplay');
        const finalAmountInput = document.getElementById('finalAmountInput');
        const discountDisplay = document.getElementById('discount-display');
        const discountAmountSpan = document.getElementById('discount-amount');
        const appliedDiscountCodeInput = document.getElementById('appliedDiscountCode');
        const originalTotal = parseFloat(totalPriceDisplay.dataset.originalTotal);

        // Xử lý áp dụng mã giảm giá
        applyDiscountBtn.addEventListener('click', function () {
            const code = discountCodeInput.value.trim();
            if (!code) {
                discountResult.textContent = 'Vui lòng nhập mã giảm giá.';
                discountResult.className = 'discount-result text-danger';
                return;
            }

            // Tạo URL để gửi request
            const url = new URL('${pageContext.request.contextPath}/apply-discount');
            url.searchParams.append('code', code);
            url.searchParams.append('bookingId', '${bookingId}');

            // Gửi request AJAX
            fetch(url)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        const newTotal = data.newTotal;
                        const discountAmount = originalTotal - newTotal;

                        // Cập nhật giao diện
                        totalPriceDisplay.textContent = newTotal.toLocaleString('vi-VN') + ' VNĐ';
                        finalAmountInput.value = newTotal;
                        discountAmountSpan.textContent = '- ' + discountAmount.toLocaleString('vi-VN') + ' VNĐ';
                        discountDisplay.style.display = 'block';
                        appliedDiscountCodeInput.value = code; // Lưu mã đã áp dụng

                        discountResult.textContent = data.message;
                        discountResult.className = 'discount-result text-success';
                        applyDiscountBtn.disabled = true; // Vô hiệu hóa nút sau khi áp dụng thành công
                        discountCodeInput.disabled = true;
                    } else {
                        discountResult.textContent = data.message;
                        discountResult.className = 'discount-result text-danger';
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    discountResult.textContent = 'Đã có lỗi xảy ra. Vui lòng thử lại.';
                    discountResult.className = 'discount-result text-danger';
                });
        });

        // Xử lý nút thanh toán
        paymentButtons.forEach(button => {
            button.addEventListener('click', function () {
                const method = this.dataset.method;
                let confirmationMessage = '';

                if (method === 'offline') {
                    confirmationMessage = '💰 Bạn chắc chắn muốn thanh toán tại sân?';
                    paymentForm.action = '${pageContext.request.contextPath}/checkout';
                    paymentForm.method = 'get';
                } else if (method === 'vnpay') {
                    confirmationMessage = '🏦 Bạn chắc chắn muốn thanh toán qua VNPay?';
                    paymentForm.action = '${pageContext.request.contextPath}/payment';
                    paymentForm.method = 'post';
                }

                if (confirm(confirmationMessage)) {
                    paymentMethodInput.value = method;
                    paymentForm.submit();
                }
            });
        });
    });
</script>

</body>
</html>