/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.Food;

import dao.FoodItemDAO;
import dao.StadiumDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import java.util.List;
import model.FoodItem;
import model.Stadium;
import model.User;

@WebServlet("/add-food")
@MultipartConfig(fileSizeThreshold = 1024 * 1024,   // 1 MB
                 maxFileSize = 5 * 1024 * 1024,     // 5 MB
                 maxRequestSize = 20 * 1024 * 1024) // 20 MB
public class AddFoodServlet extends HttpServlet {
    private static final String UPLOAD_DIR = "images-food";
    
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
            out.println("<title>Servlet AddFoodServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddFoodServlet at " + request.getContextPath () + "</h1>");
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            User currentUser = (User) request.getSession().getAttribute("currentUser");
            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp"); // hoặc thông báo lỗi
                return;
            }
            int ownerId = currentUser.getUserID();
            StadiumDAO stadiumDAO = new StadiumDAO();
            List<Stadium> stadiums = stadiumDAO.getStadiumsByOwnerId(ownerId);

            request.setAttribute("stadiums", stadiums);
            request.setAttribute("showModal", true); // để mở lại modal luôn nếu vào add
            request.getRequestDispatcher("/fieldOwner/FooItemList.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi lấy danh sách sân");
        }
    } 

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        try {
            /* 1. Đọc form-field đơn giản */
            String name     = req.getParameter("nameFood").trim();
            String desc     = req.getParameter("description");
            int stock       = Integer.parseInt(req.getParameter("stockQuantity"));
            double price    = Double.parseDouble(req.getParameter("price"));
            int stadiumId   = Integer.parseInt(req.getParameter("stadiumId"));
            boolean active  = "1".equals(req.getParameter("isActive"));

            /* 2. Xử lý file upload */
            Part filePart   = req.getPart("imageFood"); // <input name="imageFood">
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            // Tạo thư mục nếu chưa có
            String appPath = req.getServletContext().getRealPath("/");
            File uploadDir = new File(appPath, UPLOAD_DIR);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            // Ghi file
            File savedFile = new File(uploadDir, fileName);
            filePart.write(savedFile.getAbsolutePath());

            /* 3. Gọi DAO */
            FoodItem item = new FoodItem();
            item.setStadiumID(stadiumId);
            item.setName(name);
            item.setDescription(desc);
            item.setPrice(price);
            item.setStockQuantity(stock);
            item.setActive(active);
            item.setImageUrl(UPLOAD_DIR + "/" + fileName);   // lưu đường dẫn tương đối

            FoodItemDAO dao = new FoodItemDAO();
            int newId = dao.addFoodItem(item);

            /* 4. Chuyển hướng / Forward */
            if (newId > 0) {
                req.getSession().setAttribute("success", "Đã thêm món thành công!");
                resp.sendRedirect(req.getContextPath() + "/owner/food-items");      // servlet hiển thị list
            } else {
                req.setAttribute("error", "Thêm món thất bại!");
                req.setAttribute("showModal", true);                         // để mở lại modal
                req.getRequestDispatcher("/fieldOwner/FoodItemList.jsp").forward(req, resp);
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            req.setAttribute("error", "Có lỗi: " + ex.getMessage());
            req.setAttribute("showModal", true);
            req.getRequestDispatcher("/fieldOwner/FoodItemList.jsp").forward(req, resp);
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
