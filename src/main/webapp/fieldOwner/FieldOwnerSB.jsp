<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>

    <!-- Link CSS động với contextPath -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/FieldOwnerSB.css">

    <!-- Các CSS khác nếu cần -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <style>
        /* Modern Sidebar CSS - Following the blue theme design */
        .navigation-sidebar {
            width: 320px;
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
        }
        
        .nav-menu {
            padding: 32px 0;
            list-style: none;
            margin: 0;
        }
        
        .nav-item {
            margin: 0 20px 12px 20px;
        }
        
        .nav-item:last-child {
            margin-bottom: 0;
        }
        
        .nav-link {
            display: flex;
            align-items: center;
            padding: 18px 24px;
            color: #64748b;
            text-decoration: none;
            border-radius: 14px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            font-weight: 500;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
            font-size: 15px;
        }
        
        .nav-link:hover {
            background: rgba(59, 130, 246, 0.08);
            color: #3b82f6;
            text-decoration: none;
            transform: translateX(4px);
        }
        
        .nav-link.active {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            font-weight: 600;
            box-shadow: 0 8px 24px rgba(59, 130, 246, 0.25);
        }
        
        .nav-link.active:hover {
            transform: translateX(0);
            box-shadow: 0 12px 32px rgba(59, 130, 246, 0.35);
        }
        
        .nav-link i {
            width: 22px;
            margin-right: 18px;
            font-size: 18px;
            transition: all 0.3s ease;
            text-align: center;
        }
        
        .nav-link span {
            font-size: 15px;
            font-weight: inherit;
            letter-spacing: 0.25px;
            flex: 1;
        }

        /* Dropdown styles matching admin sidebar */
        .nav-item-dropdown {
            position: relative;
            margin: 0 20px 12px 20px;
        }
        
        .nav-link-dropdown {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 18px 24px;
            color: #64748b;
            text-decoration: none;
            border-radius: 14px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            font-weight: 500;
            font-size: 15px;
            position: relative;
            overflow: hidden;
            background: rgba(255, 255, 255, 0.6);
            border: 1px solid rgba(59, 130, 246, 0.08);
            backdrop-filter: blur(10px);
            cursor: pointer;
            min-height: 58px;
        }
        
        .nav-link-dropdown.active {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            font-weight: 600;
            box-shadow: 0 8px 24px rgba(59, 130, 246, 0.25);
            border-color: transparent;
        }
        
        .nav-link-dropdown:hover {
            background: rgba(59, 130, 246, 0.08);
            color: #3b82f6;
            transform: translateX(4px);
            border-color: rgba(59, 130, 246, 0.2);
            box-shadow: 0 8px 25px rgba(59, 130, 246, 0.15);
        }
        
        .nav-link-dropdown .nav-link-content {
            display: flex;
            align-items: center;
            flex: 1;
            min-width: 0;
        }
        
        .nav-link-dropdown .nav-link-content i {
            width: 22px;
            margin-right: 18px;
            font-size: 18px;
            text-align: center;
            transition: transform 0.3s ease;
            flex-shrink: 0;
        }
        
        .nav-link-dropdown .nav-link-content span {
            flex: 1;
            font-weight: 500;
            font-size: 15px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        
        .nav-link-dropdown:hover .nav-link-content i,
        .nav-link-dropdown.active .nav-link-content i {
            transform: scale(1.1);
        }
        
        .dropdown-arrow {
            margin-left: 12px;
            font-size: 12px;
            transition: transform 0.3s ease;
            flex-shrink: 0;
        }
        
        .nav-link-dropdown.open .dropdown-arrow {
            transform: rotate(180deg);
        }
        
        .dropdown-menu {
            display: none;
            margin-top: 8px;
            background: rgba(248, 250, 252, 0.95);
            border-radius: 12px;
            border: 1px solid rgba(59, 130, 246, 0.1);
            backdrop-filter: blur(10px);
            box-shadow: 0 8px 25px rgba(59, 130, 246, 0.1);
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
            padding: 14px 24px;
            color: #64748b;
            text-decoration: none;
            transition: all 0.3s ease;
            font-size: 14px;
            border-radius: 10px;
            margin: 4px 8px;
            background: rgba(255, 255, 255, 0.5);
            min-height: 46px;
        }
        
        .dropdown-item:hover {
            background: rgba(59, 130, 246, 0.08);
            color: #3b82f6;
            transform: translateX(4px);
            text-decoration: none;
        }
        
        .dropdown-item.active {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            font-weight: 600;
        }
        
        .dropdown-item i {
            margin-right: 14px;
            width: 18px;
            text-align: center;
            font-size: 14px;
            flex-shrink: 0;
        }

        /* User Menu at Bottom */
        .user-menu {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: rgba(248, 250, 252, 0.8);
            backdrop-filter: blur(10px);
            border-top: 1px solid rgba(59, 130, 246, 0.1);
            padding: 20px 0;
        }
        
        .user-menu .nav-menu {
            padding: 0;
        }
        
        .user-menu .nav-item {
            margin: 0 20px 6px 20px;
        }
        
        .user-menu .nav-link {
            padding: 14px 24px;
            font-size: 15px;
        }
        
        .user-menu .nav-link i {
            margin-right: 14px;
            font-size: 16px;
        }

        /* Scrollbar Styling */
        .navigation-sidebar::-webkit-scrollbar {
            width: 6px;
        }
        .navigation-sidebar::-webkit-scrollbar-track {
            background: rgba(59, 130, 246, 0.05);
            border-radius: 3px;
        }
        .navigation-sidebar::-webkit-scrollbar-thumb {
            background: rgba(59, 130, 246, 0.2);
            border-radius: 3px;
        }
        .navigation-sidebar::-webkit-scrollbar-thumb:hover {
            background: rgba(59, 130, 246, 0.3);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .navigation-sidebar {
                transform: translateX(-100%);
                transition: transform 0.3s ease;
                width: 300px;
            }
            .navigation-sidebar.show {
                transform: translateX(0);
            }
        }
    </style>
</head>

<!-- Left Navigation Sidebar -->
<nav class="navigation-sidebar">
    <ul class="nav-menu">
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/dashboard" class="nav-link">
                <i class="fas fa-chart-line"></i>
                <span>Dashboard</span>
            </a>
        </li>
        
        <!-- Vận hành kinh doanh dropdown -->
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
        
        <!-- Báo cáo doanh thu dropdown -->
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
        
        <!-- Quản lý hệ thống dropdown -->
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
        
        <!-- Tournament (standalone) -->
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/tournament" class="nav-link">
                <i class="fas fa-trophy"></i>
                <span>Giải đấu</span>
            </a>
        </li>
        
        <!-- Logout -->
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                <i class="fas fa-sign-out-alt"></i>
                <span>Đăng xuất</span>
            </a>
        </li>
    </ul>
</nav>

<!-- JavaScript xử lý active menu và dropdown -->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const navLinks = document.querySelectorAll(".nav-link");
        const dropdownToggles = document.querySelectorAll(".nav-link-dropdown");
        const dropdownItems = document.querySelectorAll(".dropdown-item");

        // Debug: Log elements found
        console.log("Found dropdown toggles:", dropdownToggles.length);
        console.log("Found dropdown items:", dropdownItems.length);

        // Handle dropdown toggles
        dropdownToggles.forEach((toggle, index) => {
            console.log(`Setting up dropdown ${index}:`, toggle.id);
            
            toggle.addEventListener("click", function (e) {
                e.preventDefault();
                e.stopPropagation();
                
                console.log("Dropdown clicked:", this.id);
                
                const dropdownMenu = this.nextElementSibling;
                const isOpen = dropdownMenu.classList.contains("open");
                
                console.log("Dropdown menu:", dropdownMenu);
                console.log("Is open:", isOpen);
                
                // Close all other dropdowns
                dropdownToggles.forEach(otherToggle => {
                    if (otherToggle !== this) {
                        otherToggle.classList.remove("open");
                        const otherMenu = otherToggle.nextElementSibling;
                        if (otherMenu) {
                            otherMenu.classList.remove("open");
                        }
                    }
                });
                
                // Toggle current dropdown
                if (isOpen) {
                    this.classList.remove("open");
                    dropdownMenu.classList.remove("open");
                    console.log("Closing dropdown");
                } else {
                    this.classList.add("open");
                    dropdownMenu.classList.add("open");
                    console.log("Opening dropdown");
                }
            });
        });

        // Close dropdown when clicking outside
        document.addEventListener('click', function(e) {
            let clickedInsideDropdown = false;
            
            dropdownToggles.forEach(toggle => {
                const dropdownMenu = toggle.nextElementSibling;
                if (toggle.contains(e.target) || (dropdownMenu && dropdownMenu.contains(e.target))) {
                    clickedInsideDropdown = true;
                }
            });
            
            if (!clickedInsideDropdown) {
                dropdownToggles.forEach(toggle => {
                    const dropdownMenu = toggle.nextElementSibling;
                    if (dropdownMenu) {
                        dropdownMenu.classList.remove('open');
                        toggle.classList.remove('open');
                    }
                });
            }
        });

        // Handle dropdown item clicks
        dropdownItems.forEach(item => {
            item.addEventListener('click', function(e) {
                console.log("Dropdown item clicked:", this.textContent.trim());
                
                // Remove active class from all nav links and dropdown items
                navLinks.forEach(l => l.classList.remove('active'));
                dropdownToggles.forEach(t => t.classList.remove('active'));
                dropdownItems.forEach(i => i.classList.remove('active'));
                
                // Add active class to clicked dropdown item
                this.classList.add('active');
                
                // Add active class to parent dropdown toggle
                const parentDropdown = this.closest('.nav-item-dropdown').querySelector('.nav-link-dropdown');
                if (parentDropdown) {
                    parentDropdown.classList.add('active');
                }
                
                // Close dropdown after a short delay
                setTimeout(() => {
                    const dropdownMenu = this.closest('.dropdown-menu');
                    const parentToggle = this.closest('.nav-item-dropdown').querySelector('.nav-link-dropdown');
                    if (dropdownMenu && parentToggle) {
                        dropdownMenu.classList.remove('open');
                        parentToggle.classList.remove('open');
                    }
                }, 100);
                
                // Store active state
                try {
                    sessionStorage.setItem('activeDropdownItem', this.getAttribute('href'));
                    sessionStorage.setItem('activeDropdownParent', parentDropdown ? parentDropdown.id : '');
                } catch (e) {
                    console.warn("SessionStorage not available");
                }
            });
        });

        // Handle regular nav links
        navLinks.forEach(link => {
            link.addEventListener("click", function (e) {
                if (this.closest('.dropdown-menu')) return; // Skip if it's a dropdown item
                
                console.log("Nav link clicked:", this.textContent.trim());
                
                // Remove active from all links and dropdowns
                navLinks.forEach(l => l.classList.remove("active"));
                dropdownToggles.forEach(t => t.classList.remove("active"));
                dropdownItems.forEach(i => i.classList.remove("active"));
                
                // Add active to clicked link
                this.classList.add("active");
                
                // Store active state
                try {
                    sessionStorage.setItem("activeNavLink", this.getAttribute("href"));
                    sessionStorage.removeItem('activeDropdownItem');
                    sessionStorage.removeItem('activeDropdownParent');
                } catch (e) {
                    console.warn("SessionStorage not available");
                }
            });
        });

        // Restore active state from session storage
        try {
            const activeNavLink = sessionStorage.getItem("activeNavLink");
            const activeDropdownItem = sessionStorage.getItem('activeDropdownItem');
            const activeDropdownParent = sessionStorage.getItem('activeDropdownParent');
            
            if (activeDropdownItem && activeDropdownParent) {
                // Restore dropdown item active state
                dropdownItems.forEach(item => {
                    if (item.getAttribute('href') === activeDropdownItem) {
                        item.classList.add('active');
                    }
                });
                
                // Restore parent dropdown active state
                const parentDropdown = document.getElementById(activeDropdownParent);
                if (parentDropdown) {
                    parentDropdown.classList.add('active');
                }
            } else if (activeNavLink) {
                // Restore regular nav link active state
                navLinks.forEach(link => {
                    if (link.getAttribute("href") === activeNavLink) {
                        link.classList.add("active");
                    }
                });
            }
        } catch (e) {
            console.warn("SessionStorage not available, using default active state");
        }

        // Auto-mark current page as active when loading
        const currentUrl = window.location.href;
        console.log("Current URL:", currentUrl);
        
        // Check dropdown items first
        dropdownItems.forEach(item => {
            if (item.href && currentUrl.includes(item.href)) {
                console.log("Found matching dropdown item:", item.textContent.trim());
                item.classList.add("active");
                const parentDropdown = item.closest('.nav-item-dropdown').querySelector('.nav-link-dropdown');
                if (parentDropdown) {
                    parentDropdown.classList.add("active");
                }
            }
        });
        
        // Then check regular nav links
        navLinks.forEach(link => {
            if (link.href && currentUrl.includes(link.href) && !link.closest('.dropdown-menu')) {
                console.log("Found matching nav link:", link.textContent.trim());
                link.classList.add("active");
            }
        });
    });
</script>