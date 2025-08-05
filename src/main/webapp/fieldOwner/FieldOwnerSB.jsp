<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <style>
        .navigation-sidebar {
            width: 300px; /* Giảm nhẹ để nhất quán với các trang khác */
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-right: 1px solid rgba(59, 130, 246, 0.1);
            position: fixed;
            left: 0;
            top: 80px;
            height: calc(100vh - 80px);
            overflow-y: auto;
            z-index: 999;
            box-shadow: 8px 0 32px rgba(59, 130, 246, 0.08);
            transition: transform 0.3s ease;
        }

        .nav-menu {
            padding: 24px 0;
            list-style: none;
            margin: 0;
        }

        .nav-item, .nav-item-dropdown {
            margin: 0 16px 8px 16px;
        }

        .nav-link, .nav-link-dropdown {
            display: flex;
            align-items: center;
            padding: 16px 20px;
            color: #64748b;
            text-decoration: none;
            border-radius: 12px;
            transition: all 0.3s ease;
            font-weight: 500;
            font-size: 15px;
        }

        .nav-link:hover, .nav-link-dropdown:hover {
            background: rgba(59, 130, 246, 0.08);
            color: #3b82f6;
            transform: translateX(4px);
        }

        .nav-link.active, .nav-link-dropdown.active {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            font-weight: 600;
            box-shadow: 0 8px 24px rgba(59, 130, 246, 0.25);
        }

        .nav-link i, .nav-link-dropdown i {
            width: 22px;
            margin-right: 18px;
            font-size: 18px;
            text-align: center;
        }

        /* === THAY ĐỔI QUAN TRỌNG: Cho phép văn bản xuống dòng === */
        .nav-link span, .nav-link-dropdown .nav-link-content span {
            white-space: normal; /* Cho phép ngắt dòng */
            word-break: break-word; /* Ngắt các từ quá dài nếu cần */
            line-height: 1.4; /* Cải thiện khoảng cách dòng khi có 2 dòng */
            flex: 1;
        }

        /* ======================================================= */

        .nav-link-dropdown {
            justify-content: space-between;
            cursor: pointer;
        }

        .nav-link-dropdown .nav-link-content {
            display: flex;
            align-items: center;
            flex: 1;
            min-width: 0;
        }

        .dropdown-arrow {
            margin-left: 12px;
            font-size: 12px;
            transition: transform 0.3s ease;
        }

        .nav-link-dropdown.open .dropdown-arrow {
            transform: rotate(180deg);
        }

        .dropdown-menu {
            display: none;
            margin-top: 8px;
            padding-left: 20px; /* Thụt vào so với menu cha */
            animation: dropdownSlide 0.3s ease-out;
        }

        .dropdown-menu.open {
            display: block;
        }

        @keyframes dropdownSlide {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .dropdown-item {
            display: flex;
            align-items: center;
            padding: 14px 20px;
            color: #64748b;
            text-decoration: none;
            transition: all 0.3s ease;
            font-size: 14px;
            border-radius: 10px;
            margin: 4px 0;
        }

        .dropdown-item:hover {
            background: rgba(59, 130, 246, 0.08);
            color: #3b82f6;
        }

        .dropdown-item.active {
            background: #e0e7ff;
            color: #3b82f6;
            font-weight: 600;
        }

        .dropdown-item i {
            margin-right: 14px;
            width: 18px;
            text-align: center;
            font-size: 14px;
        }

        /* Responsive */
        @media (max-width: 1200px) {
            .navigation-sidebar {
                transform: translateX(-100%);
            }

            .navigation-sidebar.show {
                transform: translateX(0);
            }
        }
    </style>
</head>

<nav class="navigation-sidebar">
    <ul class="nav-menu">
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/dashboard" class="nav-link">
                <i class="fas fa-chart-line"></i>
                <span>Dashboard</span>
            </a>
        </li>

        <li class="nav-item-dropdown">
            <div class="nav-link-dropdown" id="businessDropdown">
                <div class="nav-link-content">
                    <i class="fas fa-business-time"></i>
                    <span>Vận hành kinh doanh</span>
                </div>
                <i class="fas fa-chevron-down dropdown-arrow"></i>
            </div>
            <div class="dropdown-menu" id="businessDropdownMenu">
                <a href="${pageContext.request.contextPath}/completed-payments" class="dropdown-item">
                    <i class="fa-solid fa-clock"></i>
                    <span>Lịch đặt sân</span>
                </a>
                <a href="${pageContext.request.contextPath}/pending-payments" class="dropdown-item">
                    <i class="fa-solid fa-pen-to-square"></i>
                    <span>Đơn đặt sân</span>
                </a>
                <a href="${pageContext.request.contextPath}/fieldOwner/booking-list.jsp" class="dropdown-item">
                    <i class="fas fa-users"></i>
                    <span>Khách hàng</span>
                </a>
            </div>
        </li>

        <li class="nav-item-dropdown">
            <div class="nav-link-dropdown" id="reportsDropdown">
                <div class="nav-link-content">
                    <i class="fas fa-chart-bar"></i>
                    <span>Báo cáo doanh thu</span>
                </div>
                <i class="fas fa-chevron-down dropdown-arrow"></i>
            </div>
            <div class="dropdown-menu" id="reportsDropdownMenu">
                <a href="${pageContext.request.contextPath}/owner/reports" class="dropdown-item">
                    <i class="fas fa-chart-bar"></i>
                    <span>Báo cáo</span>
                </a>
                <a href="${pageContext.request.contextPath}/revenue-report" class="dropdown-item">
                    <i class="fas fa-dollar-sign"></i>
                    <span>Doanh thu</span>
                </a>
            </div>
        </li>

        <li class="nav-item-dropdown">
            <div class="nav-link-dropdown" id="systemDropdown">
                <div class="nav-link-content">
                    <i class="fas fa-cogs"></i>
                    <span>Quản lý hệ thống</span>
                </div>
                <i class="fas fa-chevron-down dropdown-arrow"></i>
            </div>
            <div class="dropdown-menu" id="systemDropdownMenu">
                <a href="${pageContext.request.contextPath}/fieldOwner/FOSTD" class="dropdown-item">
                    <i class="fas fa-warehouse"></i>
                    <span>Quản lý sân</span>
                </a>
                <a href="${pageContext.request.contextPath}/owner/food-items" class="dropdown-item">
                    <i class="fas fa-hamburger"></i>
                    <span>Quản lý Món ăn</span>
                </a>
                <a href="${pageContext.request.contextPath}/fieldOwner/TimeSlotManagement.jsp" class="dropdown-item">
                    <i class="fa-regular fa-calendar-days"></i>
                    <span>Chỉnh sửa khung thời gian</span>
                </a>
                <a href="#" class="dropdown-item">
                    <i class="fas fa-tags"></i>
                    <span>Quản lý mã giảm giá</span>
                </a>
            </div>
        </li>

        <!-- Chat Section Fixed -->
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/fieldOwner/fieldowner-chat" class="nav-link">
                <i class="fas fa-comments"></i>
                <span>Tin Nhắn</span>
            </a>
        </li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/tournament" class="nav-link">
                <i class="fas fa-trophy"></i>
                <span>Giải đấu</span>
            </a>
        </li>

        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                <i class="fas fa-sign-out-alt"></i>
                <span>Đăng xuất</span>
            </a>
        </li>
    </ul>
</nav>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const dropdownToggles = document.querySelectorAll(".nav-link-dropdown");

        dropdownToggles.forEach(toggle => {
            toggle.addEventListener("click", function (e) {
                e.preventDefault();
                const dropdownMenu = this.nextElementSibling;

                // Đóng các dropdown khác
                document.querySelectorAll('.dropdown-menu.open').forEach(menu => {
                    if (menu !== dropdownMenu) {
                        menu.classList.remove('open');
                        menu.previousElementSibling.classList.remove('open');
                    }
                });

                // Mở/đóng dropdown hiện tại
                this.classList.toggle("open");
                dropdownMenu.classList.toggle("open");
            });
        });

        // Tự động đánh dấu active cho trang hiện tại
        const currentUrl = window.location.href;
        document.querySelectorAll('.nav-link, .dropdown-item').forEach(link => {
            if (link.href && currentUrl.includes(link.getAttribute('href'))) {
                link.classList.add('active');

                // Mở dropdown cha nếu item con active
                const parentDropdown = link.closest('.nav-item-dropdown');
                if (parentDropdown) {
                    const toggle = parentDropdown.querySelector('.nav-link-dropdown');
                    toggle.classList.add('active');
                    toggle.classList.add('open'); // Mở sẵn
                    toggle.nextElementSibling.classList.add('open');
                }
            }
        });
    });
</script>   