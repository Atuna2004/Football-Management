/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.Tournament;

import dao.StadiumDAO;
import dao.TournamentDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Tournament;
import model.User;
/**
 *
 * @author Dell
 */
@WebServlet("/edit-tournament")
public class EditTournamentServlet extends HttpServlet {
    // Khai báo Logger cho servlet này
    private static final Logger logger = Logger.getLogger(EditTournamentServlet.class.getName());

   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<title>Servlet EditTournamentServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditTournamentServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
    throws ServletException, IOException {
        logger.info("Bắt đầu xử lý doGet: Nạp trang sửa giải đấu");

        try {
            // Lấy ID từ request
            String idParam = req.getParameter("id");
            logger.fine("Tham số 'id' nhận được: " + idParam);

            int id = Integer.parseInt(idParam);
            logger.fine("Chuyển đổi id thành công: " + id);

            // Lấy thông tin giải
            Tournament t = new TournamentDAO().getById(id);
            if (t == null) {
                logger.warning("Không tìm thấy món ăn với ID: " + id);
                resp.sendRedirect(req.getContextPath() + "/tournament");
                return;
            }

            // Lấy currentUser từ session
            HttpSession session = req.getSession();
            User currentUser = (User) session.getAttribute("currentUser");

            // Kiểm tra nếu currentUser == null
            if (currentUser == null) {
                logger.warning("Không tìm thấy currentUser trong session");
                resp.sendRedirect(req.getContextPath() + "/login.jsp");
                return;
            }

            int ownerId = currentUser.getUserID(); // Lấy ID từ đối tượng User
            logger.fine("Lấy được ownerId từ session: " + ownerId);

            // Lấy danh sách sân theo ownerId
            List<?> stadiumList = new StadiumDAO().getStadiumsByOwnerId(ownerId);
            if (stadiumList == null || stadiumList.isEmpty()) {
                logger.warning("Không có sân nào thuộc về ownerId: " + ownerId);
            } else {
                logger.fine("Số lượng sân lấy được: " + stadiumList.size());
            }

            // Set dữ liệu vào request và forward sang JSP
            req.setAttribute("tournament", t);
            req.setAttribute("stadiumList", stadiumList);
            logger.info("Đã chuẩn bị xong dữ liệu, chuyển hướng sang tour-edit.jsp");
            req.getRequestDispatcher("fieldOwner/tournamentSoccer/tour-edit.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            logger.log(Level.SEVERE, "ID không hợp lệ hoặc bị thiếu", e);
            resp.sendRedirect(req.getContextPath() + "/fieldOwner/error.jsp");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Lỗi trong doGet", e);
            resp.sendRedirect(req.getContextPath() + "/fieldOwner/error.jsp");
        }
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
    throws ServletException, IOException {
       logger.info("Bắt đầu xử lý doPost: Lưu thay đổi giải");

        req.setCharacterEncoding("UTF-8");

        try {
            // Lấy dữ liệu từ form
            String tournamentIdStr = req.getParameter("tournamentId");
            String stadiumIdStr = req.getParameter("stadiumId");
            String name = req.getParameter("nameTournament");
            String desc = req.getParameter("description");
            String startStr = req.getParameter("startDate");
            String endStr = req.getParameter("endDate");
            String createdAtStr = req.getParameter("createdAt");

            logger.fine(String.format("Thông tin nhận được: %s, %s, %s, %s, %s, %s, %s",
                    tournamentIdStr, stadiumIdStr, name, desc, startStr, endStr, createdAtStr));

            int id = Integer.parseInt(tournamentIdStr);
            int stadiumId = Integer.parseInt(stadiumIdStr);
            
            java.sql.Date startDate = java.sql.Date.valueOf(startStr);
            java.sql.Date endDate = java.sql.Date.valueOf(endStr);

            java.sql.Timestamp createdAt = java.sql.Timestamp.valueOf(createdAtStr + " 00:00:00");

            // Lấy đối tượng giải đấu từ DB
            TournamentDAO dao = new TournamentDAO();
            Tournament t = dao.getById(id);
            if (t == null) {
                logger.warning("Không tìm thấy giải đấu để cập nhật, ID: " + id);
                req.getSession().setAttribute("error", "Không tìm thấy giải.");
                resp.sendRedirect(req.getContextPath() + "/tournament");
                return;
            }

            // Cập nhật thông tin cơ bản
            t.setStadiumID(stadiumId);
            t.setName(name);
            t.setDescription(desc);
            t.setStartDate(startDate);
            t.setEndDate(endDate);
            t.setCreatedAt(createdAt);

            
            // Cập nhật database
            boolean ok = dao.updateTournament(t);
            if (ok) {
                logger.info("Cập nhật giải đấu thành công, ID: " + id);
                req.getSession().setAttribute("success", "Cập nhật giải đấu thành công!");
            } else {
                logger.warning("Cập nhật giải đấu thất bại, ID: " + id);
                req.getSession().setAttribute("error", "Cập nhật giải đấu thất bại!");
            }

            resp.sendRedirect(req.getContextPath() + "/tournament");

        } catch (NumberFormatException e) {
            logger.log(Level.SEVERE, "Dữ liệu đầu vào không hợp lệ", e);
            req.getSession().setAttribute("error", "Dữ liệu đầu vào không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/fieldOwner/tournamentSoccer/tour-edit.jsp?id=" + req.getParameter("tournament"));
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Lỗi khi xử lý doPost", e);
            req.getSession().setAttribute("error", "Có lỗi xảy ra khi cập nhật giải đấu.");
            resp.sendRedirect(req.getContextPath() + "/tournament");
        }
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
