package controller.Cart;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.CartItem;

import java.io.IOException;
import java.util.List;

@WebServlet("/update-cart")
public class UpdateCartServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String[] quantities = request.getParameterValues("quantities");
        String[] foodItemIds = request.getParameterValues("foodItemIds");

        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart != null && quantities != null && foodItemIds != null) {
            for (int i = 0; i < foodItemIds.length; i++) {
                int id = Integer.parseInt(foodItemIds[i]);
                int qty = Integer.parseInt(quantities[i]);

                for (CartItem item : cart) {
                    if (item.getFoodItem().getFoodItemID() == id) {
                        item.setQuantity(qty);
                        break;
                    }
                }
            }
        }

        // ✅ Changed from timeSlotId to bookingId
        String stadiumId = request.getParameter("stadiumId");
        String bookingId = request.getParameter("bookingId");

        response.sendRedirect(request.getContextPath() + "/stadium/cart.jsp?stadiumId=" + stadiumId + "&bookingId=" + bookingId);
    }
}
