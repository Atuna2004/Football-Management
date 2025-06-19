package controller.FieldOwner;


import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.Date;

import dao.StadiumDAO;
import jakarta.servlet.annotation.WebServlet;
import model.Stadium;
import model.User;

@WebServlet("/stadium/config")
public class StadiumServlet extends HttpServlet {
    private StadiumDAO stadiumDAO = new StadiumDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            // Mặc định chuyển về danh sách sân
            response.sendRedirect(request.getContextPath() + "/fieldOwner/FOSTD");
            return;
        }

        switch (action) {
            case "create":
                showCreateForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteStadium(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/fieldOwner/FOSTD");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action) {
            case "create":
                createStadium(request, response);
                break;
            case "update":
                updateStadium(request, response);
                break;
            case "delete":
                deleteStadium(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/fieldOwner/FOSTD");
                break;
        }
    }

    // Hiển thị form tạo sân mới
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/fieldOwner/createStadium.jsp").forward(request, response);
    }

    // Xử lý tạo sân mới
    private void createStadium(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        String name = request.getParameter("name");
        String location = request.getParameter("location");
        String description = request.getParameter("description");
        String status = request.getParameter("status");
        String phoneNumber = request.getParameter("phoneNumber");
        Timestamp createdAt = new Timestamp(new Date().getTime());
        User currentUser = (User) session.getAttribute("currentUser");
        int OwnerID = currentUser.getUserID();
        
        Stadium stadium = new Stadium();
        stadium.setName(name);
        stadium.setLocation(location);
        stadium.setDescription(description);
        stadium.setStatus(status);
        stadium.setPhoneNumber(phoneNumber);
        stadium.setCreatedAt(createdAt);
        stadium.setOwnerID(OwnerID);

        if (stadiumDAO.insertStadium(stadium)) {
            response.sendRedirect(request.getContextPath() + "/fieldOwner/FOSTD");
        } else {
            request.setAttribute("errorMessage", "Có lỗi khi thêm sân.");
            request.getRequestDispatcher("/fieldOwner/createStadium.jsp").forward(request, response);
        }
    }

    // Hiển thị form sửa sân
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int stadiumId = Integer.parseInt(request.getParameter("id"));
        Stadium stadium = stadiumDAO.getStadiumById(stadiumId);
        request.setAttribute("stadium", stadium);
        request.getRequestDispatcher("/fieldOwner/updateStadium.jsp").forward(request, response);
    }

    // Xử lý cập nhật sân
    private void updateStadium(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");

        int stadiumID = Integer.parseInt(request.getParameter("stadiumID"));
        String name = request.getParameter("name");
        String location = request.getParameter("location");
        String description = request.getParameter("description");
        String status = request.getParameter("status");
        String phoneNumber = request.getParameter("phoneNumber");

        Stadium stadium = new Stadium();
        stadium.setStadiumID(stadiumID);
        stadium.setName(name);
        stadium.setLocation(location);
        stadium.setDescription(description);
        stadium.setStatus(status);
        stadium.setPhoneNumber(phoneNumber);

        if (stadiumDAO.updateStadium(stadium)) {
            response.sendRedirect(request.getContextPath() + "/fieldOwner/FOSTD");
        } else {
            request.setAttribute("errorMessage", "Cập nhật thất bại.");
            request.getRequestDispatcher("/fieldOwner/updateStadium.jsp").forward(request, response);
        }
    }

    // Xử lý xóa sân
    private void deleteStadium(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int stadiumId = Integer.parseInt(request.getParameter("stadiumId"));
        if (stadiumDAO.deleteStadium(stadiumId)) {
            request.getSession().setAttribute("successMessage", "Xóa sân thành công!");
        } else {
            request.getSession().setAttribute("errorMessage", "Xóa sân thất bại!");
        }
        response.sendRedirect(request.getContextPath() + "/fieldOwner/FOSTD");
    }
}