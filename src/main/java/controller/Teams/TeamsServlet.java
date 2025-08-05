/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Teams;

import dao.TeamsDAO;
import dao.TeamsMemberDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.util.ArrayList;
import java.util.List;
import model.OwnerTeam;
import model.OwnerTeamMember;
import model.User;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;

/**
 *
 * @author tridi
 */
@WebServlet(name = "TeamsServlet", urlPatterns = {"/team", "/team/create", "/team/member/create", "/team/member/edit", "/team/member/delete", "/team/member/import"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 10 * 1024 * 1024
)
public class TeamsServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet TeamsServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet TeamsServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            System.out.println("[AvatarUploadServlet] No user in session, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
            return;
        }
        TeamsDAO teamsDAO = new TeamsDAO();
        OwnerTeam ownerTeam = teamsDAO.getTeamByOwnerUserId(currentUser.getUserID());

        List<OwnerTeamMember> teamMembers = new ArrayList<>();
        if (ownerTeam != null) {
            TeamsMemberDAO memberDAO = new TeamsMemberDAO();
            teamMembers = memberDAO.getMembersByTeamId(ownerTeam.getId());
        }

        request.setAttribute("ownerTeam", ownerTeam);
        request.setAttribute("teamMembers", teamMembers);
        request.getRequestDispatcher("/team.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
            return;
        }

        if ("/team/create".equals(path)) {
            String teamName = request.getParameter("teamName");
            String description = request.getParameter("description");

            OwnerTeam newTeam = new OwnerTeam();
            newTeam.setOwnerUserID(currentUser.getUserID());
            newTeam.setTeamName(teamName);
            newTeam.setDescription(description);

            TeamsDAO teamsDAO = new TeamsDAO();
            boolean success = teamsDAO.addTeam(newTeam);

            if (success) {
                session.setAttribute("success", "Tạo đội bóng thành công!");
            } else {
                session.setAttribute("error", "Tạo đội bóng thất bại!");
            }
            response.sendRedirect(request.getContextPath() + "/team");
            return;
        }

        if ("/team/member/create".equals(path)) {
            String userName = request.getParameter("userName");
            String userPhone = request.getParameter("userPhone");
            String teamIdStr = request.getParameter("teamId");

            int teamId = -1;
            try {
                teamId = Integer.parseInt(teamIdStr);
            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID đội bóng không hợp lệ!");
                response.sendRedirect(request.getContextPath() + "/team");
                return;
            }

            OwnerTeamMember member = new OwnerTeamMember();
            member.setOwnerTeamID(teamId);
            member.setUserName(userName);
            member.setUserPhone(userPhone);

            TeamsMemberDAO memberDAO = new TeamsMemberDAO();
            boolean success = memberDAO.addMember(member);

            if (success) {
                session.setAttribute("success", "Thêm thành viên mới thành công!");
            } else {
                session.setAttribute("error", "Thêm thành viên mới thất bại!");
            }
            response.sendRedirect(request.getContextPath() + "/team");
            return;
        }

        if ("/team/member/edit".equals(path)) {
            String memberIdStr = request.getParameter("memberId");
            String teamIdStr = request.getParameter("teamId");
            String userName = request.getParameter("userName");
            String userPhone = request.getParameter("userPhone");

            int memberId = -1, teamId = -1;
            try {
                memberId = Integer.parseInt(memberIdStr);
                teamId = Integer.parseInt(teamIdStr);
            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID thành viên hoặc đội bóng không hợp lệ!");
                response.sendRedirect(request.getContextPath() + "/team");
                return;
            }

            OwnerTeamMember member = new OwnerTeamMember();
            member.setId(memberId);
            member.setOwnerTeamID(teamId);
            member.setUserName(userName);
            member.setUserPhone(userPhone);

            TeamsMemberDAO memberDAO = new TeamsMemberDAO();
            boolean success = memberDAO.updateMember(member);

            if (success) {
                session.setAttribute("success", "Cập nhật thành viên thành công!");
            } else {
                session.setAttribute("error", "Cập nhật thành viên thất bại!");
            }
            response.sendRedirect(request.getContextPath() + "/team");
            return;
        }

        if ("/team/member/delete".equals(path)) {
            String memberIdStr = request.getParameter("memberId");
            int memberId = -1;
            try {
                memberId = Integer.parseInt(memberIdStr);
            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID thành viên không hợp lệ!");
                response.sendRedirect(request.getContextPath() + "/team");
                return;
            }

            TeamsMemberDAO memberDAO = new TeamsMemberDAO();
            boolean success = memberDAO.deleteMember(memberId);

            if (success) {
                session.setAttribute("success", "Xóa thành viên thành công!");
            } else {
                session.setAttribute("error", "Xóa thành viên thất bại!");
            }
            response.sendRedirect(request.getContextPath() + "/team");
            return;
        }

        if ("/team/member/import".equals(path)) {
            try {
                Part filePart = request.getPart("excelFile");
                if (filePart == null || filePart.getSize() == 0) {
                    session.setAttribute("error", "Vui lòng chọn file Excel để import!");
                    response.sendRedirect(request.getContextPath() + "/team");
                    return;
                }

                String teamIdStr = request.getParameter("teamId");
                int teamId = -1;
                try {
                    teamId = Integer.parseInt(teamIdStr);
                } catch (NumberFormatException e) {
                    session.setAttribute("error", "ID đội bóng không hợp lệ!");
                    response.sendRedirect(request.getContextPath() + "/team");
                    return;
                }

                // Đọc file Excel
                List<OwnerTeamMember> membersToAdd = new ArrayList<>();
                try (Workbook workbook = WorkbookFactory.create(filePart.getInputStream())) {
                    Sheet sheet = workbook.getSheetAt(0);
                    for (int i = 1; i <= sheet.getLastRowNum(); i++) { // Bỏ qua dòng tiêu đề
                        Row row = sheet.getRow(i);
                        if (row == null) continue;
                        Cell nameCell = row.getCell(0);
                        Cell phoneCell = row.getCell(1);
                        if (nameCell == null || phoneCell == null) continue;

                        String userName = nameCell.toString().trim();
                        String userPhone = phoneCell.toString().trim();

                        if (!userName.isEmpty() && !userPhone.isEmpty()) {
                            OwnerTeamMember member = new OwnerTeamMember();
                            member.setOwnerTeamID(teamId);
                            member.setUserName(userName);
                            member.setUserPhone(userPhone);
                            membersToAdd.add(member);
                        }
                    }
                }

                // Thêm vào DB
                TeamsMemberDAO memberDAO = new TeamsMemberDAO();
                int successCount = 0;
                for (OwnerTeamMember member : membersToAdd) {
                    if (memberDAO.addMember(member)) {
                        successCount++;
                    }
                }

                if (successCount > 0) {
                    session.setAttribute("success", "Import thành công " + successCount + " thành viên!");
                } else {
                    session.setAttribute("error", "Không import được thành viên nào!");
                }
            } catch (Exception ex) {
                ex.printStackTrace();
                session.setAttribute("error", "Đã xảy ra lỗi khi import file: " + ex.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/team");
            return;
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
