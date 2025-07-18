package controller.FieldOwner;

import connect.DBConnection;
import dao.FieldDAO;
import model.Field;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/field/config") // <-- USE THIS PATH IN JSP
public class FieldCRUDServlet extends HttpServlet {
    private DBConnection connection;
    private FieldDAO fieldDAO;

    @Override
    public void init() throws ServletException {
        connection = new DBConnection();
        fieldDAO = new FieldDAO(connection);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            try {
                int fieldId = Integer.parseInt(request.getParameter("id"));
                Field field = fieldDAO.getFieldById(fieldId);
                request.setAttribute("field", field);
                request.getRequestDispatcher("/fieldOwner/updateField.jsp").forward(request, response);
            } catch (SQLException | NumberFormatException e) {
                throw new ServletException("Error loading field information", e);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            int stadiumId = Integer.parseInt(request.getParameter("stadiumId"));

            if ("create".equals(action)) {
                Field field = new Field();
                field.setStadiumID(stadiumId);
                field.setFieldName(request.getParameter("fieldName"));
                field.setType(request.getParameter("type"));
                field.setDescription(request.getParameter("description"));
                field.setActive("on".equals(request.getParameter("isActive")));

                fieldDAO.createField(field);

            } else if ("update".equals(action)) {
                int fieldId = Integer.parseInt(request.getParameter("fieldId"));
                Field field = fieldDAO.getFieldById(fieldId);
                field.setFieldName(request.getParameter("fieldName"));
                field.setType(request.getParameter("type"));
                field.setDescription(request.getParameter("description"));
                field.setActive("on".equals(request.getParameter("isActive")));

                fieldDAO.updateField(field);

            } else if ("delete".equals(action)) {
                int fieldId = Integer.parseInt(request.getParameter("fieldId"));
                fieldDAO.deleteField(fieldId);
            }

            response.sendRedirect(request.getContextPath() + "/fieldOwner/StadiumFieldList?id=" + stadiumId);

        } catch (SQLException | NumberFormatException e) {
            throw new ServletException("Error processing request", e);
        }
    }
}
