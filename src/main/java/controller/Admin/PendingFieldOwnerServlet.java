//package controller.Admin;
//
//import dao.AccountDAO;
//import model.User;
//import connect.DBConnection;
//
//import jakarta.servlet.*;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.*;
//import java.io.IOException;
//import java.sql.Connection;
//import java.util.List;
//
//@WebServlet("/admin/field-owners/pending")
//public class PendingFieldOwnerServlet extends HttpServlet {
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        HttpSession session = request.getSession(false);
//        if (session == null || session.getAttribute("currentUser") == null) {
//            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
//            return;
//        }
//
//        try (Connection conn = DBConnection.getConnection()) {
//            AccountDAO accountDAO = new AccountDAO(conn);
//            List<User> pendingOwners = accountDAO.getPendingFieldOwners(); // Viết hàm này trong DAO
//            request.setAttribute("pendingOwners", pendingOwners);
//            request.getRequestDispatcher("/admin/field_owners/pending.jsp").forward(request, response);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            request.setAttribute("errorMessage", "Không thể tải danh sách chủ sân chờ duyệt.");
//            request.getRequestDispatcher("/Error.jsp").forward(request, response);
//        }
//    }
//}