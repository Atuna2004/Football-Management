/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Tournament;

import dao.StadiumDAO;
import dao.TournamentDAO;
import java.io.IOException;
// import java.io.PrintWriter; // Có thể không cần nếu không dùng processRequest
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.text.ParseException; // Thêm ParseException
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;
import java.util.logging.Logger; // Thêm import Logger
import java.util.logging.Level; // Thêm import Level
import model.Stadium;
import model.Tournament;
import model.User;

/**
 *
 * @author Dell
 */
@WebServlet("/add-tournament")
public class AddTournamentServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AddTournamentServlet.class.getName());
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        // --- Logging bắt đầu ---
        String clientIP = req.getRemoteAddr();
        String userAgent = req.getHeader("User-Agent");
        LOGGER.info(String.format("[%s] Received POST request to /add-tournament from IP: %s, User-Agent: %s",
                LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")),
                clientIP, userAgent));
        // ----------------------

        try {
            // --- Lấy thông tin người dùng đang đăng nhập ---
            User currentUser = (User) req.getSession().getAttribute("currentUser");
            if (currentUser == null) {
                String errorMsg = "Unauthorized access attempt to /add-tournament. User not logged in.";
                LOGGER.warning(String.format("[%s] %s Client IP: %s",
                        LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")),
                        errorMsg, clientIP));
                resp.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Người dùng chưa đăng nhập.");
                return;
            }
            int ownerId = currentUser.getUserID();
            LOGGER.info(String.format("[%s] Authenticated user ID: %d", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")), ownerId));
            // ------------------------------------------------

            /* 1. Đọc form-field đơn giản */
            String name = req.getParameter("nameTournament");
            if (name != null) {
                name = name.trim();
            }
            String desc = req.getParameter("description");
            if (desc == null) desc = ""; // Đảm bảo desc không null

            String stadiumIdStr = req.getParameter("stadiumId");
            String startStr = req.getParameter("startDate");
            String endStr = req.getParameter("endDate");

            // Kiểm tra null/empty cho các trường bắt buộc
            if (name == null || name.isEmpty() || stadiumIdStr == null || stadiumIdStr.isEmpty() ||
                startStr == null || startStr.isEmpty() || endStr == null || endStr.isEmpty()) {
                String errorMsg = "Missing required form parameters.";
                LOGGER.warning(String.format("[%s] %s User ID: %d, Client IP: %s",
                        LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")),
                        errorMsg, ownerId, clientIP));
                req.setAttribute("error", "Thiếu thông tin bắt buộc!");
                req.setAttribute("showModal", true);
                // Cần lấy stadiums để hiển thị lại modal
                StadiumDAO stadiumDAO = new StadiumDAO();
                List<Stadium> stadiums = stadiumDAO.getStadiumsByOwnerId(ownerId);
                req.setAttribute("stadiums", stadiums);
                req.getRequestDispatcher("/fieldOwner/tournamentSoccer/listTour.jsp").forward(req, resp);
                return; // Return sau khi forward
            }

            int stadiumId;
            Date start;
            Date end;
            try {
                stadiumId = Integer.parseInt(stadiumIdStr);
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                start = sdf.parse(startStr);
                end = sdf.parse(endStr);

                // Kiểm tra logic ngày tháng (tùy chọn nhưng tốt)
                if (start.after(end)) {
                     String errorMsg = "Start date is after end date.";
                     LOGGER.warning(String.format("[%s] %s User ID: %d, Start: %s, End: %s, Client IP: %s",
                            LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")),
                            errorMsg, ownerId, startStr, endStr, clientIP));
                    req.setAttribute("error", "Ngày bắt đầu không thể sau ngày kết thúc!");
                    req.setAttribute("showModal", true);
                    // Cần lấy stadiums để hiển thị lại modal
                    StadiumDAO stadiumDAO = new StadiumDAO();
                    List<Stadium> stadiums = stadiumDAO.getStadiumsByOwnerId(ownerId);
                    req.setAttribute("stadiums", stadiums);
                    req.getRequestDispatcher("/fieldOwner/tournamentSoccer/listTour.jsp").forward(req, resp);
                    return; // Return sau khi forward
                }

            } catch (NumberFormatException e) {
                String errorMsg = "Invalid number format for stadiumId.";
                 LOGGER.log(Level.WARNING, String.format("[%s] %s User ID: %d, StadiumIdStr: %s, Client IP: %s",
                        LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")),
                        errorMsg, ownerId, stadiumIdStr, clientIP), e);
                req.setAttribute("error", "Dữ liệu không hợp lệ (ID sân không đúng định dạng số)!");
                req.setAttribute("showModal", true);
                // Cần lấy stadiums để hiển thị lại modal
                StadiumDAO stadiumDAO = new StadiumDAO();
                List<Stadium> stadiums = stadiumDAO.getStadiumsByOwnerId(ownerId);
                req.setAttribute("stadiums", stadiums);
                req.getRequestDispatcher("/fieldOwner/tournamentSoccer/listTour.jsp").forward(req, resp);
                return; // Return sau khi forward
            } catch (ParseException e) {
                 String errorMsg = "Invalid date format.";
                 LOGGER.log(Level.WARNING, String.format("[%s] %s User ID: %d, StartStr: %s, EndStr: %s, Client IP: %s",
                        LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")),
                        errorMsg, ownerId, startStr, endStr, clientIP), e);
                req.setAttribute("error", "Định dạng ngày không hợp lệ (yyyy-MM-dd)!");
                req.setAttribute("showModal", true);
                // Cần lấy stadiums để hiển thị lại modal
                StadiumDAO stadiumDAO = new StadiumDAO();
                List<Stadium> stadiums = stadiumDAO.getStadiumsByOwnerId(ownerId);
                req.setAttribute("stadiums", stadiums);
                req.getRequestDispatcher("/fieldOwner/tournamentSoccer/listTour.jsp").forward(req, resp);
                return; // Return sau khi forward
            }

            LOGGER.info(String.format("[%s] Parsed form data - Name: '%s', StadiumId: %d, Start: %s, End: %s, Description length: %d, User ID: %d",
                    LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")),
                    name, stadiumId, startStr, endStr, desc.length(), ownerId));

            /* 2. Gọi DAO */
            Tournament t = new Tournament();
            t.setStadiumID(stadiumId);
            t.setName(name);
            t.setDescription(desc);
            t.setStartDate(start);
            t.setEndDate(end);
            // --- SET CreatedBy ---
            t.setCreatedBy(ownerId); // <-- Đây là phần quan trọng bạn thiếu
            LOGGER.fine(String.format("[%s] Created Tournament object with CreatedBy set to %d", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")), ownerId)); // Log mức FINE hơn
            // ---------------------

            TournamentDAO dao = new TournamentDAO();
            LOGGER.info(String.format("[%s] Calling TournamentDAO.addTournament() for user ID: %d", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")), ownerId));
            int newId = dao.addTournament(t); // Giả định addTournament đã sửa để lấy GeneratedKey
            LOGGER.info(String.format("[%s] TournamentDAO.addTournament() returned ID: %d for user ID: %d", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")), newId, ownerId));

            /* 3. Chuyển hướng / Forward */
            if (newId > 0) {
                String successMsg = "Tournament added successfully.";
                LOGGER.info(String.format("[%s] %s New Tournament ID: %d, User ID: %d, Client IP: %s",
                        LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")),
                        successMsg, newId, ownerId, clientIP));
                req.getSession().setAttribute("success", "Đã thêm giải thành công!");
                // Chuyển hướng về trang danh sách giải đấu
                resp.sendRedirect(req.getContextPath() + "/tournament");
            } else {
                String errorMsg = "TournamentDAO.addTournament returned ID <= 0.";
                LOGGER.warning(String.format("[%s] %s User ID: %d, Client IP: %s",
                        LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")),
                        errorMsg, ownerId, clientIP));
                req.setAttribute("error", "Thêm giải thất bại!");
                req.setAttribute("showModal", true);

                // --- Quan trọng: Lấy lại danh sách sân để hiển thị trong modal ---
                StadiumDAO stadiumDAO = new StadiumDAO();
                List<Stadium> stadiums = stadiumDAO.getStadiumsByOwnerId(ownerId);
                req.setAttribute("stadiums", stadiums);
                LOGGER.fine(String.format("[%s] Re-fetched stadiums for user ID: %d (count: %d)", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")), ownerId, stadiums.size())); // Log mức FINE hơn
                // -----------------------------------------------------------------

                req.getRequestDispatcher("/fieldOwner/tournamentSoccer/listTour.jsp").forward(req, resp);
            }

        } catch (Exception ex) { // Bắt tất cả các exception chưa được xử lý ở trên
            String errorMsg = "Unexpected error occurred in AddTournamentServlet doPost.";
            LOGGER.log(Level.SEVERE, String.format("[%s] %s Client IP: %s, Request details: User-Agent='%s'",
                    LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")),
                    errorMsg, clientIP, userAgent), ex); // Log exception với mức SEVERE
            req.setAttribute("error", "Có lỗi hệ thống: " + ex.getMessage()); // Tránh tiết lộ chi tiết lỗi cho người dùng
            req.setAttribute("showModal", true);

            // --- Cũng cần lấy lại danh sách sân nếu có lỗi ---
            try {
                User currentUser = (User) req.getSession().getAttribute("currentUser");
                if (currentUser != null) {
                    int ownerId = currentUser.getUserID();
                    StadiumDAO stadiumDAO = new StadiumDAO();
                    List<Stadium> stadiums = stadiumDAO.getStadiumsByOwnerId(ownerId);
                    req.setAttribute("stadiums", stadiums);
                     LOGGER.fine(String.format("[%s] Re-fetched stadiums after error for user ID: %d (count: %d)", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")), ownerId, stadiums.size())); // Log mức FINE hơn
                }
            } catch (Exception e) {
                String fetchStadiumsError = "Failed to re-fetch stadiums after main error.";
                LOGGER.log(Level.WARNING, String.format("[%s] %s", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")), fetchStadiumsError), e);
            }
            req.getRequestDispatcher("/fieldOwner/tournamentSoccer/listTour.jsp").forward(req, resp);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet for adding new tournaments";
    }// </editor-fold>

}