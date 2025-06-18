//package controller.Admin;
//
//import dao.ActivityLogDAO;
//import model.ActivityLog;
//import jakarta.servlet.*;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.*;
//import java.io.IOException;
//import java.util.List;
//
//@WebServlet("/admin/logs/activity")
//public class ActivityLogServlet extends HttpServlet {
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
//        ActivityLogDAO logDAO = new ActivityLogDAO(DBConnection.getConnection());
//        List<ActivityLog> logs = logDAO.getAllLogs();
//
//        request.setAttribute("logs", logs);
//        request.getRequestDispatcher("/admin/logs/activity.jsp").forward(request, response);
//    }
//}