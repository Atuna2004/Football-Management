package controller.Cart;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.CartItem;

import java.io.IOException;
import java.util.Iterator;
import java.util.List;

@WebServlet("/remove-from-cart")
public class RemoveFromCartServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int foodItemId = Integer.parseInt(request.getParameter("foodItemId"));
            String stadiumId = request.getParameter("stadiumId");
            String bookingId = request.getParameter("bookingId");

            if (stadiumId == null || bookingId == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing stadiumId or bookingId parameter.");
                return;
            }

            HttpSession session = request.getSession();
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

            if (cart != null) {
                Iterator<CartItem> it = cart.iterator();
                while (it.hasNext()) {
                    if (it.next().getFoodItem().getFoodItemID() == foodItemId) {
                        it.remove();
                        break;
                    }
                }
            }

            // Redirect back to cart.jsp with correct bookingId
            response.sendRedirect(request.getContextPath() + "/stadium/cart.jsp?stadiumId=" + stadiumId + "&bookingId=" + bookingId);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid ID.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
