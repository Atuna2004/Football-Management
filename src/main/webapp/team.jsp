<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý đội bóng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footballField.css"/>
        <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <%@ include file="/includes/header.jsp" %>
        <div class="container mt-5">
            <% 
                String successMsg = (String) session.getAttribute("success");
                String errorMsg = (String) session.getAttribute("error");
                if (successMsg != null) {
            %>
                <div class="alert alert-success alert-dismissible fade show mt-3" role="alert" id="autoHideSuccess">
                    <%= successMsg %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <%
                    session.removeAttribute("success");
                }
                if (errorMsg != null) {
            %>
                <div class="alert alert-danger alert-dismissible fade show mt-3" role="alert" id="autoHideError">
                    <%= errorMsg %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <%
                    session.removeAttribute("error");
                }
            %>
            <script>
                setTimeout(function() {
                    const success = document.getElementById('autoHideSuccess');
                    if (success) {
                        success.classList.remove('show');
                        setTimeout(() => success.remove(), 500);
                    }
                    const error = document.getElementById('autoHideError');
                    if (error) {
                        error.classList.remove('show');
                        setTimeout(() => error.remove(), 500);
                    }
                }, 3000);
            </script>
            <c:choose>
                <c:when test="${ownerTeam == null}">
                    <div class="text-center">
                        <h4>Bạn chưa có đội bóng nào!</h4>
                        <button class="btn btn-success mt-3" data-bs-toggle="modal" data-bs-target="#createTeamModal">
                            <i class="fas fa-plus"></i> Tạo đội của bạn
                        </button>
                    </div>
                    <!-- Modal tạo đội -->
                    <div class="modal fade" id="createTeamModal" tabindex="-1" aria-labelledby="createTeamModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <form action="${pageContext.request.contextPath}/team/create" method="post" class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="createTeamModalLabel">Tạo đội bóng mới</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <div class="mb-3">
                                        <label for="teamName" class="form-label">Tên đội bóng</label>
                                        <input type="text" class="form-control" id="teamName" name="teamName" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="description" class="form-label">Mô tả</label>
                                        <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                    <button type="submit" class="btn btn-success">Tạo đội</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card mb-4">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0"><i class="fas fa-users"></i> Đội của bạn: ${ownerTeam.teamName}</h5>
                        </div>
                        <div class="card-body">
                            <p><strong>Mô tả:</strong> ${ownerTeam.description}</p>
                            <div class="d-flex mb-3 gap-2">
                                <a href="#" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#createMemberModal">
                                    <i class="fas fa-user-plus"></i> Thêm thành viên mới
                                </a>
                                <!-- Nút Import file Excel -->
                                <form id="importForm" action="${pageContext.request.contextPath}/team/member/import" method="post" enctype="multipart/form-data" class="d-inline">
                                    <input type="hidden" name="teamId" value="${ownerTeam.id}" />
                                    <label class="btn btn-primary mb-0">
                                        <i class="fas fa-file-import"></i> Import file
                                        <input type="file" name="excelFile" accept=".xlsx,.xls" style="display:none" id="excelInput" required>
                                    </label>
                                </form>
                            </div>

                            <!-- Loading overlay -->
                            <div id="loadingOverlay" style="display:none;position:fixed;top:0;left:0;width:100vw;height:100vh;z-index:2000;background:rgba(255,255,255,0.7)">
                                <div class="d-flex justify-content-center align-items-center" style="height:100vh;">
                                    <div class="spinner-border text-primary" style="width:4rem;height:4rem;" role="status">
                                        <span class="visually-hidden">Loading...</span>
                                    </div>
                                </div>
                            </div>
                            <!-- Modal tạo thành viên -->
                            <div class="modal fade" id="createMemberModal" tabindex="-1" aria-labelledby="createMemberModalLabel" aria-hidden="true">
                                <div class="modal-dialog">
                                    <form action="${pageContext.request.contextPath}/team/member/create" method="post" class="modal-content">
                                        <input type="hidden" name="teamId" value="${ownerTeam.id}" />
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="createMemberModalLabel">Thêm thành viên mới</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                        </div>
                                        <div class="modal-body">
                                            <div class="mb-3">
                                                <label for="userName" class="form-label">Tên thành viên</label>
                                                <input type="text" class="form-control" id="userName" name="userName" required>
                                            </div>
                                            <div class="mb-3">
                                                <label for="userPhone" class="form-label">Số điện thoại</label>
                                                <input type="text" class="form-control" id="userPhone" name="userPhone" required>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                            <button type="submit" class="btn btn-success">Thêm thành viên</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                            <table class="table table-bordered align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Tên thành viên</th>
                                        <th>Số điện thoại</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="member" items="${teamMembers}" varStatus="loop">
                                        <tr>
                                            <td>${loop.index + 1}</td>
                                            <td>${member.userName}</td>
                                            <td>${member.userPhone}</td>
                                            <td>
                                                <button type="button"
                                                    class="btn btn-warning btn-sm btn-edit-member"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#editMemberModal"
                                                    data-id="${member.id}"
                                                    data-name="${member.userName}"
                                                    data-phone="${member.userPhone}">
                                                    <i class="fas fa-edit"></i> Sửa
                                                </button>
                                                <button type="button"
                                                    class="btn btn-danger btn-sm btn-delete-member"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#deleteMemberModal"
                                                    data-id="${member.id}"
                                                    data-name="${member.userName}">
                                                    <i class="fas fa-trash"></i> Xóa
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty teamMembers}">
                                        <tr>
                                            <td colspan="4" class="text-center text-muted">Chưa có thành viên nào trong đội</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        

        <!-- Modal Sửa thành viên -->
        <div class="modal fade" id="editMemberModal" tabindex="-1" aria-labelledby="editMemberModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <form id="editMemberForm" action="${pageContext.request.contextPath}/team/member/edit" method="post" class="modal-content">
                    <input type="hidden" name="memberId" id="editMemberId">
                    <input type="hidden" name="teamId" value="${ownerTeam.id}">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editMemberModalLabel">Sửa thông tin thành viên</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="editUserName" class="form-label">Tên thành viên</label>
                            <input type="text" class="form-control" id="editUserName" name="userName" required>
                        </div>
                        <div class="mb-3">
                            <label for="editUserPhone" class="form-label">Số điện thoại</label>
                            <input type="text" class="form-control" id="editUserPhone" name="userPhone" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal Xóa thành viên -->
        <div class="modal fade" id="deleteMemberModal" tabindex="-1" aria-labelledby="deleteMemberModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <form id="deleteMemberForm" action="${pageContext.request.contextPath}/team/member/delete" method="post" class="modal-content">
                    <input type="hidden" name="memberId" id="deleteMemberId">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deleteMemberModalLabel">Xác nhận xóa thành viên</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p>Bạn có chắc chắn muốn xóa thành viên <strong id="deleteMemberName"></strong> khỏi đội bóng?</p>
                        <div class="alert alert-warning">
                            <i class="fas fa-info-circle me-2"></i>
                            Việc xóa thành viên sẽ không thể hoàn tác!
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-danger">Xóa</button>
                    </div>
                </form>
            </div>
        </div>

        <%@ include file="/includes/footer.jsp" %>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script> 
        <script>
            // Sửa thành viên
            document.querySelectorAll('.btn-edit-member').forEach(btn => {
                btn.addEventListener('click', function () {
                    document.getElementById('editMemberId').value = this.getAttribute('data-id');
                    document.getElementById('editUserName').value = this.getAttribute('data-name');
                    document.getElementById('editUserPhone').value = this.getAttribute('data-phone');
                });
            });

            // Xóa thành viên
            document.querySelectorAll('.btn-delete-member').forEach(btn => {
                btn.addEventListener('click', function () {
                    document.getElementById('deleteMemberId').value = this.getAttribute('data-id');
                    document.getElementById('deleteMemberName').textContent = this.getAttribute('data-name');
                });
            });

            // Import file Excel
            document.getElementById('excelInput').addEventListener('change', function () {
                if (this.files.length > 0) {
                    document.getElementById('loadingOverlay').style.display = 'block';
                    document.getElementById('importForm').submit();
                }
            });
        </script>
    </body>
</html>