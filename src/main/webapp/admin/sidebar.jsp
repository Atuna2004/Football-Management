<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
<style>

    .sidebar {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        color: #333;
        width: 280px;
        height: 100vh;
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(20px);
        position: fixed;
        left: 0;
        top: 0;
        overflow-y: auto;
        z-index: 1000;
        box-shadow: 4px 0 20px rgba(0, 0, 0, 0.1);
    }

    .sidebar-header {
        padding: 30px 20px;
        text-align: center;
        border-bottom: 1px solid rgba(0, 0, 0, 0.1);
    }

    .sidebar-header h3 {
        color: #667eea;
        font-weight: 700;
        font-size: 24px;
    }

    .sidebar-nav {
        padding: 20px 0;
    }

    .nav-item {
        margin: 5px 20px;
    }

    .nav-link {
        display: flex;
        align-items: center;
        padding: 15px 20px;
        color: #555;
        text-decoration: none;
        border-radius: 12px;
        transition: all 0.3s ease;
        font-weight: 500;
    }

    .nav-link:hover, .nav-link.active {
        background: linear-gradient(135deg, #667eea, #764ba2);
        color: white;
        transform: translateX(5px);
    }

    .nav-link i {
        margin-right: 12px;
        font-size: 18px;
        width: 20px;
    }

    @media (max-width: 768px) {
        .sidebar {
            transform: translateX(-100%);
            transition: transform 0.3s ease;
        }

        .sidebar.active {
            transform: translateX(0);
        }
    }
</style>


<div class="sidebar">
    <div class="sidebar-header">
        <h3 style="margin: 0"></i> Quản lí </h3>
    </div>
    <nav class="sidebar-nav">
        <div class="nav-item">
            <a href="./adminPage.jsp" class="nav-link active">
                <i class="fas fa-tachometer-alt"></i>
                Thống Kê Tổng Quan
            </a>
        </div>
        <div class="nav-item">
            <a href="./user-list" class="nav-link">
                <i class="fas fa-users"></i>
                Quản Lý Người Dùng
            </a>
        </div>
        <div class="nav-item">
            <a href="./fieldOwnerApprove.jsp" class="nav-link">
                <i class="fas fa-user-check"></i>
                Phê Duyệt Chủ Sân
            </a>
        </div>
        <div class="nav-item">
            <a href="./userReport.jsp" class="nav-link">
                <i class="fas fa-flag"></i>
                Báo Cáo Người Dùng
            </a>
        </div>
        <div class="nav-item">
            <a href="./activityHistory.jsp" class="nav-link">
                <i class="fas fa-history"></i>
                Lịch Sử Hành Động
            </a>
        </div>
        <div class="nav-item">
            <a href="./setting.jsp" class="nav-link">
                <i class="fas fa-cog"></i>
                Cài Đặt
            </a>
        </div>
        <div class="nav-item">
            <a href="#" class="nav-link">
                <i class="fas fa-sign-out-alt"></i>
                Đăng Xuất
            </a>
        </div>
    </nav>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const links = document.querySelectorAll(".nav-link");

            links.forEach(link => {
                link.addEventListener("click", function () {
                    links.forEach(l => l.classList.remove("active"));
                    this.classList.add("active");


                    localStorage.setItem("activeSidebar", this.getAttribute("href"));
                });
            });


            const currentActive = localStorage.getItem("activeSidebar");
            if (currentActive) {
                links.forEach(link => {
                    if (link.getAttribute("href") === currentActive) {
                        link.classList.add("active");
                    } else {
                        link.classList.remove("active");
                    }
                });
            }
        });
    </script>

</div>

