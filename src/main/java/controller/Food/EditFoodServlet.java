package controller.Food;

import dao.FoodItemDAO;
import dao.StadiumDAO;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.FoodItem;
import model.User;

@WebServlet("/edit-food")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024)
public class EditFoodServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "images-food";

    // Khai báo Logger cho servlet này
    private static final Logger logger = Logger.getLogger(EditFoodServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        logger.info("Bắt đầu xử lý doGet: Nạp trang sửa món ăn");

        try {
            // Lấy ID từ request
            String idParam = req.getParameter("id");
            logger.fine("Tham số 'id' nhận được: " + idParam);

            int id = Integer.parseInt(idParam);
            logger.fine("Chuyển đổi id thành công: " + id);

            // Lấy thông tin món ăn
            FoodItem item = new FoodItemDAO().getFoodItemById(id);
            if (item == null) {
                logger.warning("Không tìm thấy món ăn với ID: " + id);
                resp.sendRedirect(req.getContextPath() + "/owner/food-items");
                return;
            }

            // Lấy currentUser từ session
            HttpSession session = req.getSession();
            User currentUser = (User) session.getAttribute("currentUser");

            // Kiểm tra nếu currentUser == null
            if (currentUser == null) {
                logger.warning("Không tìm thấy currentUser trong session");
                resp.sendRedirect(req.getContextPath() + "/login.jsp");
                return;
            }

            int ownerId = currentUser.getUserID(); // Lấy ID từ đối tượng User
            logger.fine("Lấy được ownerId từ session: " + ownerId);

            // Lấy danh sách sân theo ownerId
            List<?> stadiumList = new StadiumDAO().getStadiumsByOwnerId(ownerId);
            if (stadiumList == null || stadiumList.isEmpty()) {
                logger.warning("Không có sân nào thuộc về ownerId: " + ownerId);
            } else {
                logger.fine("Số lượng sân lấy được: " + stadiumList.size());
            }

            // Set dữ liệu vào request và forward sang JSP
            req.setAttribute("foodItem", item);
            req.setAttribute("stadiumList", stadiumList);
            logger.info("Đã chuẩn bị xong dữ liệu, chuyển hướng sang food-edit.jsp");
            req.getRequestDispatcher("fieldOwner/food-edit.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            logger.log(Level.SEVERE, "ID không hợp lệ hoặc bị thiếu", e);
            resp.sendRedirect(req.getContextPath() + "/fieldOwner/error.jsp");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Lỗi trong doGet", e);
            resp.sendRedirect(req.getContextPath() + "/fieldOwner/error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        logger.info("Bắt đầu xử lý doPost: Lưu thay đổi món ăn");

        req.setCharacterEncoding("UTF-8");

        try {
            // Lấy dữ liệu từ form
            String foodItemIdStr = req.getParameter("foodItemId");
            String stadiumIdStr = req.getParameter("stadiumId");
            String name = req.getParameter("nameFood");
            String desc = req.getParameter("description");
            String stockStr = req.getParameter("stockQuantity");
            String priceStr = req.getParameter("price");
            String isActiveStr = req.getParameter("isActive");

            logger.fine(String.format("Thông tin nhận được: %s, %s, %s, %s, %s, %s",
                    foodItemIdStr, stadiumIdStr, name, desc, stockStr, priceStr));

            int id = Integer.parseInt(foodItemIdStr);
            int stadiumId = Integer.parseInt(stadiumIdStr);
            int stock = Integer.parseInt(stockStr);
            double price = Double.parseDouble(priceStr);
            boolean active = "1".equals(isActiveStr);

            // Lấy đối tượng món ăn từ DB
            FoodItemDAO dao = new FoodItemDAO();
            FoodItem item = dao.getFoodItemById(id);
            if (item == null) {
                logger.warning("Không tìm thấy món ăn để cập nhật, ID: " + id);
                req.getSession().setAttribute("error", "Không tìm thấy món ăn.");
                resp.sendRedirect(req.getContextPath() + "/owner/food-items");
                return;
            }

            // Cập nhật thông tin cơ bản
            item.setStadiumID(stadiumId);
            item.setName(name);
            item.setDescription(desc);
            item.setStockQuantity(stock);
            item.setPrice(price);
            item.setActive(active);

            // Xử lý ảnh nếu người dùng chọn mới
            Part filePart = req.getPart("imageFood");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String appPath = req.getServletContext().getRealPath("/");
                File uploadDir = new File(appPath, UPLOAD_DIR);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                String filePath = new File(uploadDir, fileName).getAbsolutePath();
                filePart.write(filePath);
                item.setImageUrl(UPLOAD_DIR + "/" + fileName);
                logger.fine("Cập nhật ảnh mới: " + fileName);
            }

            // Cập nhật database
            boolean ok = dao.updateFoodItem(item);
            if (ok) {
                logger.info("Cập nhật món ăn thành công, ID: " + id);
                req.getSession().setAttribute("success", "Cập nhật món ăn thành công!");
            } else {
                logger.warning("Cập nhật món ăn thất bại, ID: " + id);
                req.getSession().setAttribute("error", "Cập nhật món ăn thất bại!");
            }

            resp.sendRedirect(req.getContextPath() + "/owner/food-items");

        } catch (NumberFormatException e) {
            logger.log(Level.SEVERE, "Dữ liệu đầu vào không hợp lệ", e);
            req.getSession().setAttribute("error", "Dữ liệu đầu vào không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/fieldOwner/edit-food.jsp?id=" + req.getParameter("foodItemId"));
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Lỗi khi xử lý doPost", e);
            req.getSession().setAttribute("error", "Có lỗi xảy ra khi cập nhật món ăn.");
            resp.sendRedirect(req.getContextPath() + "/owner/food-items");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet chỉnh sửa món ăn với logging";
    }
}