//package controller.Stadium;
//
//import dao.StadiumDAO;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import model.Stadium;
//import service.GeoUtil;
//
//import java.io.IOException;
//import java.util.ArrayList;
//import java.util.Comparator;
//import java.util.List;
//
//@WebServlet("/suggest-stadiums")
//public class StadiumSuggestionServlet extends HttpServlet {
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String latStr = request.getParameter("latitude");
//        String lonStr = request.getParameter("longitude");
//
//        System.out.println("📍 [DEBUG] Tọa độ nhận được:");
//        System.out.println("Latitude = " + latStr);
//        System.out.println("Longitude = " + lonStr);
//
//        if (latStr == null || latStr.isEmpty() || lonStr == null || lonStr.isEmpty()) {
//            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu hoặc sai định dạng tọa độ.");
//            return;
//        }
//
//        double userLat, userLon;
//
//        try {
//            userLat = Double.parseDouble(latStr);
//            userLon = Double.parseDouble(lonStr);
//        } catch (NumberFormatException e) {
//            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tọa độ không hợp lệ.");
//            return;
//        }
//
//        // Lấy tất cả sân bóng
//        StadiumDAO stadiumDAO = new StadiumDAO();
//        List<Stadium> allStadiums = stadiumDAO.getAllStadiums();
//        List<Stadium> validStadiums = new ArrayList<>();
//
//        for (Stadium stadium : allStadiums) {
//            Double lat = stadium.getLatitude();
//            Double lon = stadium.getLongitude();
//
//            if (lat != null && lon != null
//                    && lat >= -90 && lat <= 90
//                    && lon >= -180 && lon <= 180) {
//
//                double distance = GeoUtil.haversine(userLat, userLon, lat, lon);
//                stadium.setDistance(distance);
//                validStadiums.add(stadium);
//
//                  // 👉 LOG HERE
//        System.out.printf("✅ Sân gần hợp lệ: %s - %.2f km (lat=%.6f, lon=%.6f)%n",
//                stadium.getName(), distance, lat, lon);
//            }
//        }
//
//        // Sắp xếp theo khoảng cách tăng dần
//        validStadiums.sort(Comparator.comparingDouble(Stadium::getDistance));
//
//        // Lấy 3 sân gần nhất
//        List<Stadium> topStadiums = validStadiums.stream().limit(3).toList();
//
//        // Gửi sang JSP để render
//        request.setAttribute("suggestedStadiums", topStadiums);
//        request.getRequestDispatcher("suggestStadiums.jsp").forward(request, response);
//    }
//}
