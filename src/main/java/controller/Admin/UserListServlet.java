package controller.Admin;

import dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import java.io.*;
import java.sql.*;
import java.util.List;
import connect.DBConnection;

public class UserListServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Connection conn = DBConnection.getConnection();
            if (conn == null || conn.isClosed()) {
                System.out.println("🔴 Lỗi: Kết nối database không hợp lệ!");
                throw new ServletException("Kết nối database thất bại");
            }

            AccountDAO dao = new AccountDAO(conn);
            List<User> userList = dao.getAllUsers();

            System.out.println("Số lượng người dùng lấy được từ servlet: " + userList.size());

            request.setAttribute("userList", userList);
            request.getRequestDispatcher("/admin/userManagement.jsp").forward(request, response);

        } catch (Exception ex) {
            ex.printStackTrace();
            throw new ServletException("Lỗi tải người dùng", ex);
        }
    }
}
