package controller.FieldOwner;


import connect.DBConnection;
import dao.FieldDAO;
import model.Field;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet("/field/config") // <-- DÙNG ĐƯỜNG DẪN NÀY TRONG JSP
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
                throw new ServletException("Lỗi khi tải thông tin sân nhỏ", e);
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
                
                try (Connection conn = DBConnection.getConnection()) {
                    CallableStatement cs = conn.prepareCall("{EXEC AutoGenerateTimeSlots}");
                    cs.execute();
                    // Nếu dùng SQL Server, có thể dùng: "EXEC AutoGenerateTimeSlots"
                    // Nhưng cú pháp chuẩn JDBC là {call ...}
                } catch (SQLException e) {
                    e.printStackTrace();
                    // Không nên throw lỗi làm sập cả quá trình nếu SP lỗi
                    // Vì Field đã tạo thành công
                    System.err.println("Lỗi khi gọi AutoGenerateTimeSlots: " + e.getMessage());
                }

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
            throw new ServletException("Lỗi xử lý yêu cầu", e);
        }
    }
}