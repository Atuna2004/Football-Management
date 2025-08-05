/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.AI;

import config.CloudinaryUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Base64;
import org.json.JSONObject;
import service.GeminiService;

/**
 *
 * @author PC
 */
@WebServlet(name = "AIServlet", urlPatterns = {"/aiImproveTournament", "/aiGenImage"})
public class AIServlet extends HttpServlet {
    private final GeminiService geminiService = new GeminiService();
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
            out.println("<title>Servlet AIServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AIServlet at " + request.getContextPath() + "</h1>");
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
        processRequest(request, response);
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

        if ("/aiImproveTournament".equals(path)) {
            // Nhận JSON, gọi AI tối ưu tiêu đề & mô tả
            request.setCharacterEncoding("UTF-8");
            response.setContentType("application/json;charset=UTF-8");
            StringBuilder sb = new StringBuilder();
            try (BufferedReader reader = request.getReader()) {
                String line;
                while ((line = reader.readLine()) != null) {
                    sb.append(line);
                }
            }
            JSONObject json = new JSONObject(sb.toString());

            String title = json.getString("nameTournament");
            String description = json.optString("description");
            String totalTeams = json.optString("totalTeams");
            String award = json.optString("award");
            if (description == null || description.trim().isEmpty() || totalTeams == null || totalTeams.trim().isEmpty()
                    || award == null || award.trim().isEmpty() || title == null || title.trim().isEmpty()) {
                response.setStatus(400);
                response.getWriter().write("{\"error\":\"Missing topic\"}");
                return;
            }

            // Gọi GeminiService để sinh tin tức
            String aiResult = geminiService.improveTournamentDescription(title,description,totalTeams,award);

            // Parse kết quả trả về từ Gemini (JSON)
            JSONObject outer = new JSONObject(aiResult);
            String innerText = outer
                    .getJSONArray("candidates")
                    .getJSONObject(0)
                    .getJSONObject("content")
                    .getJSONArray("parts")
                    .getJSONObject(0)
                    .getString("text");

            // innerText là chuỗi JSON, cần parse tiếp
            JSONObject inner = new JSONObject(innerText);

            // Trả về đúng JSON {title, content}
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(inner.toString());
            return;
        }

        if ("/aiGenImage".equals(path)) {
            response.setContentType("application/json;charset=UTF-8");
            String dataUrl = request.getParameter("imageData");
            String url = null;
            try (PrintWriter out = response.getWriter()) {
                if (dataUrl != null && dataUrl.startsWith("data:image/")) {
                    String base64 = dataUrl.substring(dataUrl.indexOf(",") + 1);
                    byte[] imageBytes = Base64.getDecoder().decode(base64);
                    String fileName = "ai-gen-" + System.currentTimeMillis() + ".png";
                    url = CloudinaryUtils.uploadImage(new java.io.ByteArrayInputStream(imageBytes), fileName, "ai/");
                    out.print("{\"url\":\"" + url + "\"}");
                } else {
                    out.print("{\"error\":\"Invalid image data\"}");
                }
                return;
            } catch (Exception e) {
                response.setStatus(500);
                response.getWriter().print("{\"error\":\"" + e.getMessage() + "\"}");
                return;
            }
        }

        // Nếu không đúng endpoint
        response.sendError(HttpServletResponse.SC_NOT_FOUND);
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
