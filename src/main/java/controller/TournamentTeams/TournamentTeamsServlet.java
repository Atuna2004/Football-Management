/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.TournamentTeams;

import dao.TeamsDAO;
import dao.TournamentDAO;
import dao.TournamentTeamDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.OwnerTeam;
import model.Tournament;
import model.TournamentTeam;
import model.User;

/**
 *
 * @author tridi
 */
@WebServlet(name = "TournamentTeamsServlet", urlPatterns = {"/tournamentTeam/register", "/tournamentTeam/user", "/tournamentTeam/cancel", "/tournament/registered-teams" })
public class TournamentTeamsServlet extends HttpServlet {

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
            out.println("<title>Servlet TournamentTeamsServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet TournamentTeamsServlet at " + request.getContextPath() + "</h1>");
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
        String path = request.getServletPath();
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
            return;
        }

        if ("/tournamentTeam/user".equals(path)) {
            TeamsDAO teamsDAO = new TeamsDAO();
            OwnerTeam ownerTeam = teamsDAO.getTeamByOwnerUserId(currentUser.getUserID());
            if (ownerTeam == null) {
                session.setAttribute("error", "Bạn chưa có đội bóng nào.");
                response.sendRedirect(request.getContextPath() + "/team");
                return;
            }

            TournamentTeamDAO tournamentTeamDAO = new TournamentTeamDAO();
            List<TournamentTeam> registeredTeams = new ArrayList<>();
            List<Tournament> tournaments = new ArrayList<>();
            TournamentDAO tournamentDAO = new TournamentDAO();

            for (TournamentTeam tt : tournamentTeamDAO.getAllTournamentTeams()) {
                if (tt.getTeamName().equals(ownerTeam.getTeamName())) {
                    registeredTeams.add(tt);
                    Tournament t = tournamentDAO.getById(tt.getTournamentID());
                    if (t != null) tournaments.add(t);
                }
            }

            request.setAttribute("registeredTeams", registeredTeams);
            request.setAttribute("tournaments", tournaments);
            request.getRequestDispatcher("/user-tournaments.jsp").forward(request, response);
            return;
        }

        if ("/tournament/registered-teams".equals(path)) {
            String tournamentIdStr = request.getParameter("tournamentId");
            int tournamentId = -1;
            try {
                tournamentId = Integer.parseInt(tournamentIdStr);
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/fieldOwner/tournamentSoccer/listTour.jsp");
                return;
            }
            TournamentTeamDAO tournamentTeamDAO = new TournamentTeamDAO();
            TournamentDAO tournamentDAO = new TournamentDAO();
            Tournament tournament = tournamentDAO.getById(tournamentId);
            List<TournamentTeam> teams = tournamentTeamDAO.getTeamsByTournamentId(tournamentId);

            request.setAttribute("tournament", tournament);
            request.setAttribute("teams", teams);
            request.getRequestDispatcher("/fieldOwner/tournamentSoccer/registered-teams.jsp").forward(request, response);
            return;
        }
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

        if ("/tournamentTeam/register".equals(path)) {
            TeamsDAO teamsDAO = new TeamsDAO();
            OwnerTeam ownerTeam = teamsDAO.getTeamByOwnerUserId(currentUser.getUserID());
            if (ownerTeam == null) {
                session.setAttribute("error", "Bạn chưa có đội bóng để đăng ký giải!");
                response.sendRedirect(request.getContextPath() + "/user/tournaments");
                return;
            }

            String tournamentIdStr = request.getParameter("tournamentId");
            int tournamentId = -1;
            try {
                tournamentId = Integer.parseInt(tournamentIdStr);
            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID giải đấu không hợp lệ!");
                response.sendRedirect(request.getContextPath() + "/user/tournaments");
                return;
            }
            
            TournamentDAO tournamentDAO = new TournamentDAO();
            Tournament tournament = tournamentDAO.getById(tournamentId);
            if (tournament == null) {
                session.setAttribute("error", "Không tìm thấy giải đấu!");
                response.sendRedirect(request.getContextPath() + "/user/tournaments");
                return;
            }

            Date now = new Date();
            if (now.after(tournament.getStartDate())) {
                session.setAttribute("error", "Đã quá thời gian đăng ký giải đấu này!");
                response.sendRedirect(request.getContextPath() + "/user/tournaments");
                return;
            }

            if (tournament.getQuantityTeams() + 1 > tournament.getTotalTeams()) {
                session.setAttribute("error", "Số lượng đội tham gia giải đã đủ, không thể đăng ký thêm!");
                response.sendRedirect(request.getContextPath() + "/user/tournaments");
                return;
            }

            TournamentTeam tournamentTeam = new TournamentTeam();
            tournamentTeam.setTournamentID(tournamentId);
            tournamentTeam.setTeamName(ownerTeam.getTeamName());
            tournamentTeam.setCaptainName(currentUser.getFullName());
            tournamentTeam.setContactPhone(currentUser.getPhone());
            tournamentTeam.setStatus(true);
            tournamentTeam.setIsApproved(false);

            TournamentTeamDAO tournamentTeamDAO = new TournamentTeamDAO();
            boolean success = tournamentTeamDAO.addTournamentTeam(tournamentTeam);

            if (success) {
                tournament.setQuantityTeams(tournament.getQuantityTeams() + 1);
                tournamentDAO.updateTournament(tournament);
                
                session.setAttribute("success", "Đăng ký giải đấu thành công! Vui lòng chờ phê duyệt.");
            } else {
                session.setAttribute("error", "Đăng ký giải đấu thất bại hoặc đã đăng ký trước đó.");
            }
            response.sendRedirect(request.getContextPath() + "/user/tournaments");
            return;
        }

        if ("/tournamentTeam/cancel".equals(path)) {
            String tournamentIdStr = request.getParameter("tournamentId");
            int tournamentId = -1;
            try {
                tournamentId = Integer.parseInt(tournamentIdStr);
            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID giải đấu không hợp lệ!");
                response.sendRedirect(request.getContextPath() + "/tournamentTeam/user");
                return;
            }
            
            TournamentDAO tournamentDAO = new TournamentDAO();
            Tournament tournament = tournamentDAO.getById(tournamentId);
            if (tournament == null) {
                session.setAttribute("error", "Không tìm thấy giải đấu!");
                response.sendRedirect(request.getContextPath() + "/user/tournaments");
                return;
            }

            TeamsDAO teamsDAO = new TeamsDAO();
            OwnerTeam ownerTeam = teamsDAO.getTeamByOwnerUserId(currentUser.getUserID());
            if (ownerTeam == null) {
                session.setAttribute("error", "Không tìm thấy đội bóng.");
                response.sendRedirect(request.getContextPath() + "/tournamentTeam/user");
                return;
            }

            TournamentTeamDAO tournamentTeamDAO = new TournamentTeamDAO();
            // Xóa đăng ký nếu chưa được duyệt
            boolean success = tournamentTeamDAO.cancelUnapprovedRegistration(ownerTeam.getTeamName(), tournamentId);

            if (success) {
                session.setAttribute("success", "Hủy đăng ký thành công!");
                tournament.setQuantityTeams(tournament.getQuantityTeams() - 1);
                tournamentDAO.updateTournament(tournament);
            } else {
                session.setAttribute("error", "Không thể hủy đăng ký (có thể đã được duyệt hoặc không tồn tại)!");
            }
            response.sendRedirect(request.getContextPath() + "/tournamentTeam/user");
            return;
        }

        if ("/tournament/registered-teams".equals(path)) {
            String teamName = request.getParameter("teamName");
            int tournamentId = Integer.parseInt(request.getParameter("tournamentId"));
            TournamentTeamDAO dao = new TournamentTeamDAO();
            boolean success = dao.approveTeam(teamName, tournamentId);
            if (success) {
                session.setAttribute("success", "Duyệt đội thành công!");
            } else {
                session.setAttribute("error", "Duyệt đội thất bại!");
            }
            response.sendRedirect(request.getContextPath() + "/tournament/registered-teams?tournamentId=" + tournamentId);
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
