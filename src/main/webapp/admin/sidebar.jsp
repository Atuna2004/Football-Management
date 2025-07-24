<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

<style>
    * {
        box-sizing: border-box;
    }

    .sidebar {
        font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
        color: #1e293b;
        width: 300px;
        height: 100vh;
        background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
        position: fixed;
        left: 0;
        top: 0;
        overflow-y: auto;
        z-index: 1000;
        box-shadow: 0 10px 40px rgba(59, 130, 246, 0.15);
        border-right: 1px solid rgba(59, 130, 246, 0.1);
    }

    .sidebar-header {
        padding: 40px 30px 30px;
        text-align: center;
        background: linear-gradient(135deg, #3b82f6, #1d4ed8);
        color: white;
        position: relative;
        overflow: hidden;
    }

    .sidebar-header::before {
        content: '';
        position: absolute;
        top: -50%;
        right: -50%;
        width: 200%;
        height: 200%;
        background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
        animation: float 6s ease-in-out infinite;
    }

    @keyframes float {
        0%, 100% { transform: translateY(0px) rotate(0deg); }
        50% { transform: translateY(-10px) rotate(5deg); }
    }

    .sidebar-header h3 {
        margin: 0;
        font-weight: 700;
        font-size: 28px;
        letter-spacing: -0.5px;
        position: relative;
        z-index: 1;
    }

    .sidebar-header p {
        margin: 8px 0 0;
        opacity: 0.9;
        font-size: 14px;
        font-weight: 400;
        position: relative;
        z-index: 1;
    }

    .sidebar-nav {
        padding: 30px 20px;
    }

    .nav-section {
        margin-bottom: 35px;
    }

    .nav-section:last-child {
        margin-bottom: 0;
        margin-top: auto;
        padding-top: 20px;
        border-top: 1px solid rgba(59, 130, 246, 0.1);
    }

    .nav-item {
        margin: 8px 0;
    }

    .nav-link {
        display: flex;
        align-items: center;
        padding: 16px 20px;
        color: #475569;
        text-decoration: none;
        border-radius: 16px;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        font-weight: 500;
        font-size: 15px;
        position: relative;
        overflow: hidden;
        background: rgba(255, 255, 255, 0.6);
        border: 1px solid rgba(59, 130, 246, 0.08);
        backdrop-filter: blur(10px);
    }

    .nav-link:hover {
        background: rgba(59, 130, 246, 0.08);
        color: #1d4ed8;
        transform: translateX(8px);
        border-color: rgba(59, 130, 246, 0.2);
        box-shadow: 0 8px 25px rgba(59, 130, 246, 0.15);
    }

    .nav-link.active {
        background: linear-gradient(135deg, #3b82f6, #1d4ed8);
        color: white;
        transform: translateX(8px);
        box-shadow: 0 10px 30px rgba(59, 130, 246, 0.3);
        border-color: transparent;
    }

    .nav-link i {
        margin-right: 16px;
        font-size: 18px;
        width: 24px;
        text-align: center;
        transition: transform 0.3s ease;
    }

    .nav-link:hover i,
    .nav-link.active i {
        transform: scale(1.1);
    }

    .nav-link span {
        flex: 1;
        font-weight: 500;
    }

    .nav-link.logout {
        background: rgba(239, 68, 68, 0.08);
        color: #dc2626;
        border-color: rgba(239, 68, 68, 0.2);
    }

    .nav-link.logout:hover {
        background: linear-gradient(135deg, #ef4444, #dc2626);
        color: white;
    }

    /* Dropdown Styles */
    .nav-item-dropdown {
        position: relative;
        margin: 8px 0;
    }

    .nav-link-dropdown {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 16px 20px;
        color: #475569;
        text-decoration: none;
        border-radius: 16px;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        font-weight: 500;
        font-size: 15px;
        position: relative;
        overflow: hidden;
        background: rgba(255, 255, 255, 0.6);
        border: 1px solid rgba(59, 130, 246, 0.08);
        backdrop-filter: blur(10px);
        cursor: pointer;
        min-height: 54px; /* Fixed height to match other nav items */
    }

    .nav-link-dropdown.active {
        background: linear-gradient(135deg, #3b82f6, #1d4ed8);
        color: white;
        transform: translateX(8px);
        box-shadow: 0 10px 30px rgba(59, 130, 246, 0.3);
        border-color: transparent;
    }

    .nav-link-dropdown:hover {
        background: rgba(59, 130, 246, 0.08);
        color: #1d4ed8;
        transform: translateX(8px);
        border-color: rgba(59, 130, 246, 0.2);
        box-shadow: 0 8px 25px rgba(59, 130, 246, 0.15);
    }

    .nav-link-dropdown .nav-link-content {
        display: flex;
        align-items: center;
        flex: 1;
        min-width: 0; /* Allow text to truncate if needed */
    }

    .nav-link-dropdown .nav-link-content i {
        margin-right: 16px;
        font-size: 18px;
        width: 24px;
        text-align: center;
        transition: transform 0.3s ease;
        flex-shrink: 0; /* Prevent icon from shrinking */
    }

    .nav-link-dropdown .nav-link-content span {
        flex: 1;
        font-weight: 500;
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
        flex-shrink: 0; /* Prevent arrow from shrinking */
    }

    .nav-link-dropdown.open .dropdown-arrow {
        transform: rotate(180deg);
    }

    .dropdown-menu {
        max-height: 0;
        overflow: hidden;
        transition: max-height 0.3s cubic-bezier(0.4, 0, 0.2, 1), opacity 0.3s ease;
        opacity: 0;
        margin-top: 8px;
        background: rgba(255, 255, 255, 0.95);
        border-radius: 12px;
        border: 1px solid rgba(59, 130, 246, 0.1);
        backdrop-filter: blur(10px);
        box-shadow: 0 8px 25px rgba(59, 130, 246, 0.1);
    }

    .dropdown-menu.open {
        max-height: 180px;
        opacity: 1;
    }

    .dropdown-item {
        display: flex;
        align-items: center;
        padding: 12px 20px;
        color: #475569;
        text-decoration: none;
        transition: all 0.3s ease;
        font-size: 14px;
        border-radius: 8px;
        margin: 4px 8px;
        background: rgba(255, 255, 255, 0.5);
        min-height: 40px;
    }

    .dropdown-item:hover {
        background: rgba(59, 130, 246, 0.08);
        color: #1d4ed8;
        transform: translateX(4px);
    }

    .dropdown-item.active {
        background: linear-gradient(135deg, #3b82f6, #1d4ed8);
        color: white;
        font-weight: 600;
    }

    .dropdown-item i {
        margin-right: 10px;
        width: 16px;
        text-align: center;
        font-size: 14px;
        flex-shrink: 0;
    }

    /* Mobile responsiveness */
    @media (max-width: 768px) {
        .sidebar {
            width: 280px;
            transform: translateX(-100%);
            transition: transform 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .sidebar.active {
            transform: translateX(0);
        }

        .sidebar-header {
            padding: 30px 25px 25px;
        }

        .sidebar-header h3 {
            font-size: 24px;
        }

        .sidebar-nav {
            padding: 25px 15px;
        }
    }

    /* Scrollbar styling */
    .sidebar::-webkit-scrollbar {
        width: 6px;
    }

    .sidebar::-webkit-scrollbar-track {
        background: rgba(59, 130, 246, 0.05);
    }

    .sidebar::-webkit-scrollbar-thumb {
        background: rgba(59, 130, 246, 0.3);
        border-radius: 10px;
    }

    .sidebar::-webkit-scrollbar-thumb:hover {
        background: rgba(59, 130, 246, 0.5);
    }

    /* Add subtle animation to the entire sidebar */
    .sidebar {
        animation: slideInLeft 0.5s ease-out;
    }

    @keyframes slideInLeft {
        from {
            transform: translateX(-20px);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
</style>

<div class="sidebar">
    <div class="sidebar-header">
        <h3>Quản Lý</h3>
        <p>Admin Dashboard</p>
    </div>
    
    <nav class="sidebar-nav">
        <div class="nav-section">
            <div class="nav-item">
                <a href="<%= request.getContextPath() %>/adminDashboard" class="nav-link active">
                    <i class="fas fa-chart-line"></i>
                    <span>Thống Kê Tổng Quan</span>
                </a>
            </div>
            
            <!-- User Management Dropdown -->
            <div class="nav-item-dropdown">
                <div class="nav-link-dropdown" id="userManagementDropdown">
                    <div class="nav-link-content">
                        <i class="fas fa-users"></i>
                        <span>Quản Lý Người Dùng</span>
                    </div>
                    <i class="fas fa-chevron-down dropdown-arrow"></i>
                </div>
                <div class="dropdown-menu" id="userDropdownMenu">
                    <a href="${pageContext.request.contextPath}/admin/user-list?filter=all" class="dropdown-item" data-filter="all">
                        <i class="fas fa-users"></i>
                        Tất Cả Người Dùng
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/user-list?filter=user" class="dropdown-item" data-filter="user">
                        <i class="fas fa-user"></i>
                        Người Dùng
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/user-list?filter=owner" class="dropdown-item" data-filter="owner">
                        <i class="fas fa-user-tie"></i>
                        Chủ Sân
                    </a>
                </div>
            </div>
            
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/pending" class="nav-link">
                    <i class="fas fa-user-check"></i>
                    <span>Phê Duyệt Chủ Sân</span>
                </a>
            </div>
            
            <div class="nav-item">
                <a href="<%= request.getContextPath() %>/admin/reports/user" class="nav-link">
                    <i class="fas fa-flag"></i>
                    <span>Báo Cáo Người Dùng</span>
                </a>
            </div>
        </div>
        
        <div class="nav-section">
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/logoutAdmin.jsp" class="nav-link logout">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Đăng Xuất</span>
                </a>
            </div>
        </div>
    </nav>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const links = document.querySelectorAll(".nav-link:not(.logout)");
        const dropdownToggle = document.getElementById('userManagementDropdown');
        const dropdownMenu = document.getElementById('userDropdownMenu');
        const dropdownItems = document.querySelectorAll('.dropdown-item');
        
        // Dropdown functionality
        dropdownToggle.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            
            const isOpen = dropdownMenu.classList.contains('open');
            
            if (isOpen) {
                // Close dropdown
                dropdownMenu.classList.remove('open');
                dropdownToggle.classList.remove('open');
            } else {
                // Open dropdown
                dropdownMenu.classList.add('open');
                dropdownToggle.classList.add('open');
            }
        });
        
        // Close dropdown when clicking outside
        document.addEventListener('click', function(e) {
            if (!dropdownToggle.contains(e.target) && !dropdownMenu.contains(e.target)) {
                dropdownMenu.classList.remove('open');
                dropdownToggle.classList.remove('open');
            }
        });
        
        // Handle dropdown item clicks
        dropdownItems.forEach(item => {
            item.addEventListener('click', function(e) {
                // Remove active class from all dropdown items
                dropdownItems.forEach(i => i.classList.remove('active'));
                
                // Add active class to clicked item
                this.classList.add('active');
                
                // Close dropdown
                dropdownMenu.classList.remove('open');
                dropdownToggle.classList.remove('open');
                
                // Set dropdown toggle as active
                dropdownToggle.classList.add('active');
                
                // Remove active from other nav links
                links.forEach(l => l.classList.remove('active'));
                
                // Store the selected filter
                const filter = this.getAttribute('data-filter');
                try {
                    sessionStorage.setItem('userFilter', filter);
                    sessionStorage.setItem('activeSidebarLink', 'user-management');
                } catch (e) {
                    console.warn("SessionStorage not available");
                }
                
                // Optional: You can trigger a custom event for the main page to listen to
                const filterEvent = new CustomEvent('userFilterChanged', {
                    detail: { filter: filter }
                });
                window.dispatchEvent(filterEvent);
            });
        });
        
        // Enhanced click handling for regular nav links
        links.forEach(link => {
            link.addEventListener("click", function (e) {
                // Add loading state
                this.style.opacity = "0.7";
                
                // Remove active class from all links and dropdown
                links.forEach(l => l.classList.remove("active"));
                dropdownToggle.classList.remove('active');
                dropdownItems.forEach(i => i.classList.remove('active'));
                
                // Add active class to clicked link
                this.classList.add("active");
                
                // Store active state
                const href = this.getAttribute("href");
                try {
                    sessionStorage.setItem("activeSidebarLink", href);
                    sessionStorage.removeItem('userFilter'); // Clear user filter when switching pages
                } catch (e) {
                    console.warn("SessionStorage not available");
                }
                
                // Restore opacity after a short delay
                setTimeout(() => {
                    this.style.opacity = "1";
                }, 150);
            });
            
            // Add hover sound effect (optional)
            link.addEventListener("mouseenter", function() {
                this.style.transition = "all 0.2s cubic-bezier(0.4, 0, 0.2, 1)";
            });
        });
        
        // Restore active state from session storage
        try {
            const currentActive = sessionStorage.getItem("activeSidebarLink");
            const userFilter = sessionStorage.getItem('userFilter');
            
            if (currentActive === 'user-management' || userFilter) {
                // User management section is active
                dropdownToggle.classList.add('active');
                links.forEach(l => l.classList.remove('active'));
                
                if (userFilter) {
                    // Set specific filter as active
                    dropdownItems.forEach(item => {
                        if (item.getAttribute('data-filter') === userFilter) {
                            item.classList.add('active');
                        }
                    });
                }
            } else if (currentActive) {
                // Regular nav link is active
                links.forEach(link => {
                    const href = link.getAttribute("href");
                    if (href === currentActive) {
                        link.classList.add("active");
                    } else {
                        link.classList.remove("active");
                    }
                });
            }
        } catch (e) {
            console.warn("SessionStorage not available, using default active state");
        }
        
        // Check URL parameters to set active dropdown item
        const urlParams = new URLSearchParams(window.location.search);
        const filterParam = urlParams.get('filter');
        if (filterParam) {
            dropdownItems.forEach(item => {
                if (item.getAttribute('data-filter') === filterParam) {
                    item.classList.add('active');
                    dropdownToggle.classList.add('active');
                    links.forEach(l => l.classList.remove('active'));
                }
            });
        }
        
        // Add mobile menu toggle functionality (if needed)
        const addMobileMenuToggle = () => {
            if (window.innerWidth <= 768) {
                const sidebar = document.querySelector('.sidebar');
                const toggleBtn = document.createElement('button');
                toggleBtn.innerHTML = '<i class="fas fa-bars"></i>';
                toggleBtn.className = 'mobile-menu-toggle';
                toggleBtn.style.cssText = `
                    position: fixed;
                    top: 20px;
                    left: 20px;
                    z-index: 1001;
                    background: #3b82f6;
                    color: white;
                    border: none;
                    border-radius: 12px;
                    padding: 12px;
                    font-size: 18px;
                    cursor: pointer;
                    box-shadow: 0 4px 15px rgba(59, 130, 246, 0.3);
                    transition: all 0.3s ease;
                `;
                
                toggleBtn.addEventListener('click', () => {
                    sidebar.classList.toggle('active');
                });
                
                document.body.appendChild(toggleBtn);
            }
        };
        
        // Initialize mobile menu on load and resize
        addMobileMenuToggle();
        window.addEventListener('resize', () => {
            const existingToggle = document.querySelector('.mobile-menu-toggle');
            if (existingToggle) {
                existingToggle.remove();
            }
            addMobileMenuToggle();
        });
    });
</script>