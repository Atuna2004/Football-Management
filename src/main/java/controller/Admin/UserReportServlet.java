//package controller.Admin;
//
//import dao.ReportDAO;
//import model.Report;
//
//import jakarta.servlet.*;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.*;
//import java.io.IOException;
//import java.util.List;
//
//@WebServlet("/admin/reports/user")
//public class UserReportServlet extends HttpServlet {
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
//        ReportDAO reportDAO = new ReportDAO(DBConnection.getConnection());
//        List<Report> reports = reportDAO.getUserReports();
//
//        request.setAttribute("reports", reports);
//        request.getRequestDispatcher("/admin/reports/user.jsp").forward(request, response);
//    }
//}