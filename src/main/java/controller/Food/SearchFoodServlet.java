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
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.FoodItem;
import model.Stadium;
import model.User;

/**
 *
 * @author Dell
 */
@WebServlet("/food-search")
public class SearchFoodServlet extends HttpServlet {
    private final FoodItemDAO foodItemDAO = new FoodItemDAO();
    private final StadiumDAO stadiumDAO = new StadiumDAO();
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
            out.println("<title>Servlet SearchFoodServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SearchFoodServlet at " + request.getContextPath () + "</h1>");
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

        String keyword = request.getParameter("search");   // name="search" trên input

        // Kiểm tra đăng nhập
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
            return;
        }
        
        int ownerId = currentUser.getUserID(); 
        
        // Lọc theo tên
        List<FoodItem> foodItems = foodItemDAO.searchByName(keyword, ownerId);
        List<Stadium> stadiums = stadiumDAO.getStadiumsByOwnerId(ownerId);
        // Đẩy dữ liệu sang JSP
        request.setAttribute("foodItems", foodItems);
        request.setAttribute("search", keyword); // để giữ lại chữ vừa gõ
        request.setAttribute("stadiums", stadiums);

        request.getRequestDispatcher("fieldOwner/FoodItemList.jsp")
               .forward(request, response);
    }

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
        doGet(request, response); 
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
