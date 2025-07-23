    package controller.ChatBox;

    import com.google.gson.Gson;
    import dao.AccountDAO;
    import model.User;
    import connect.DBConnection;

    import jakarta.servlet.ServletException;
    import jakarta.servlet.annotation.WebServlet;
    import jakarta.servlet.http.HttpServlet;
    import jakarta.servlet.http.HttpServletRequest;
    import jakarta.servlet.http.HttpServletResponse;
    import jakarta.servlet.http.HttpSession;

    import java.io.IOException;
    import java.sql.Connection;
    import java.util.ArrayList;
    import java.util.List;
    import java.util.stream.Collectors;

    @WebServlet("/api/chatusers")
    public class ChatUserListServlet extends HttpServlet {

        private static final Gson gson = new Gson();

        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("currentUser");

            if (currentUser == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }

            try (Connection conn = DBConnection.getConnection()) {
                AccountDAO accountDAO = new AccountDAO(conn);
                List<User> allUsers = accountDAO.getAllUsers(); // Lấy tất cả và lọc sau
                List<User> chatableUsers = new ArrayList<>();

                // Logic phân quyền
                if (currentUser.isAdmin()) {
                    // Admin có thể chat với tất cả Field Owner và User
                    chatableUsers = allUsers.stream()
                            .filter(u -> u.isFieldOwner() || u.isUser())
                            .collect(Collectors.toList());
                } else if (currentUser.isFieldOwner()) {
                    // Field Owner có thể chat với Admin và User
                    chatableUsers = allUsers.stream()
                            .filter(u -> u.isAdmin() || u.isUser())
                            .collect(Collectors.toList());
                } else { // Là User bình thường
                    // User có thể chat với Admin và tất cả Field Owner
                    chatableUsers = allUsers.stream()
                            .filter(u -> u.isAdmin() || u.isFieldOwner())
                            .collect(Collectors.toList());
                }

                // Loại bỏ chính mình khỏi danh sách
                final int currentId = currentUser.getUserID();
                chatableUsers = chatableUsers.stream()
                        .filter(u -> u.getUserID() != currentId)
                        .collect(Collectors.toList());

                String jsonResponse = gson.toJson(chatableUsers);
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(jsonResponse);

            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                e.printStackTrace();
            }
        }
    }
