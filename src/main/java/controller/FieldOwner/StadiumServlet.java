package controller.FieldOwner;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.Date;

import dao.StadiumDAO;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import model.Stadium;
import model.User;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,  // 1MB
    maxFileSize = 10 * 1024 * 1024,   // 10MB
    maxRequestSize = 10 * 1024 * 1024 // 10MB
)

@WebServlet("/stadium/config")
public class StadiumServlet extends HttpServlet {
    private final StadiumDAO stadiumDAO = new StadiumDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "create":
                showCreateForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
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
                deactivateStadium(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/fieldOwner/FOSTD");
                break;
        }
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/fieldOwner/createStadium.jsp").forward(request, response);
    }

    private void createStadium(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        Stadium stadium = new Stadium();
        stadium.setName(request.getParameter("name"));
        stadium.setLocation(request.getParameter("location"));
        stadium.setDescription(request.getParameter("description"));
        stadium.setStatus(request.getParameter("status"));
        stadium.setPhoneNumber(request.getParameter("phoneNumber"));
        stadium.setCreatedAt(new Timestamp(new Date().getTime()));
        stadium.setOwnerID(currentUser.getUserID());

        if (stadiumDAO.insertStadium(stadium)) {
            response.sendRedirect(request.getContextPath() + "/fieldOwner/FOSTD");
        } else {
            request.setAttribute("errorMessage", "Có lỗi khi thêm sân.");
            request.getRequestDispatcher("/fieldOwner/createStadium.jsp").forward(request, response);
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int stadiumId = Integer.parseInt(request.getParameter("id"));
        Stadium stadium = stadiumDAO.getStadiumById(stadiumId);
        request.setAttribute("stadium", stadium);
        request.getRequestDispatcher("/fieldOwner/updateStadium.jsp").forward(request, response);
    }

    private void updateStadium(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");

        Stadium stadium = new Stadium();
        stadium.setStadiumID(Integer.parseInt(request.getParameter("stadiumID")));
        stadium.setName(request.getParameter("name"));
        stadium.setLocation(request.getParameter("location"));
        stadium.setDescription(request.getParameter("description"));
        stadium.setStatus(request.getParameter("status"));
        stadium.setPhoneNumber(request.getParameter("phoneNumber"));

        if (stadiumDAO.updateStadium(stadium)) {
            response.sendRedirect(request.getContextPath() + "/fieldOwner/FOSTD");
        } else {
            request.setAttribute("errorMessage", "Cập nhật thất bại.");
            request.getRequestDispatcher("/fieldOwner/updateStadium.jsp").forward(request, response);
        }
    }

    private void deactivateStadium(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int stadiumId = Integer.parseInt(request.getParameter("stadiumId"));
        if (stadiumDAO.deactivateStadium(stadiumId)) {
            request.getSession().setAttribute("successMessage", "Ngừng hoạt động sân thành công!");
        } else {
            request.getSession().setAttribute("errorMessage", "Thao tác thất bại!");
        }
        response.sendRedirect(request.getContextPath() + "/fieldOwner/FOSTD");
    }
}