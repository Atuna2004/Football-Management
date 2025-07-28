package controller.FieldOwner;

import connect.DBConnection;
import dao.FieldDAO;
import dao.StadiumDAO;
import model.Field;
import model.Stadium;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/fieldOwner/StadiumFieldList")
public class StadiumFieldListServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String stadiumIdStr = request.getParameter("id");
        int stadiumId = Integer.parseInt(stadiumIdStr);

        DBConnection conn = new DBConnection();

        try {
            FieldDAO fieldDAO = new FieldDAO(conn);
            List<Field> fields = fieldDAO.getFieldsByStadiumId(stadiumId);

            StadiumDAO stadiumDAO = new StadiumDAO();
            Stadium stadium = stadiumDAO.getStadiumById(stadiumId);

            request.setAttribute("fields", fields);
            request.setAttribute("stadiumId", stadiumId);
            request.setAttribute("stadiumName", stadium.getName());

            RequestDispatcher dispatcher = request.getRequestDispatcher("/fieldOwner/StadiumFieldList.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}