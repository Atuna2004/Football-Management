//package controller.Admin;
//
//import model.SystemSetting;
//import dao.SettingDAO;
//
//import jakarta.servlet.*;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.*;
//import java.io.IOException;
//
//@WebServlet("/admin/settings/general")
//public class GeneralSettingServlet extends HttpServlet {
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
//        SettingDAO settingDAO = new SettingDAO(DBConnection.getConnection());
//        SystemSetting settings = settingDAO.loadGeneralSettings();
//
//        request.setAttribute("settings", settings);
//        request.getRequestDispatcher("/admin/settings/general.jsp").forward(request, response);
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        HttpSession session = request.getSession(false);
//        if (session == null || session.getAttribute("currentUser") == null) {
//            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
//            return;
//        }
//
//        String siteName = request.getParameter("siteName");
//        String supportEmail = request.getParameter("supportEmail");
//        String defaultRole = request.getParameter("defaultRole");
//
//        SystemSetting updatedSetting = new SystemSetting();
//        updatedSetting.setSiteName(siteName);
//        updatedSetting.setSupportEmail(supportEmail);
//        updatedSetting.setDefaultRole(defaultRole);
//
//        boolean success = new SettingDAO(DBConnection.getConnection()).save(updatedSetting);
//
//        if (success) {
//            request.setAttribute("successMessage", "Cài đặt đã được cập nhật thành công!");
//        } else {
//            request.setAttribute("errorMessage", "Không thể lưu cài đặt lúc này.");
//        }
//
//        request.getRequestDispatcher("/admin/settings/general.jsp").forward(request, response);
//    }
//}