package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.User;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
      
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String path = req.getRequestURI().substring(req.getContextPath().length());

        // Lấy currentUser từ session
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        // Chuyển hướng từ "/" hoặc "/home.jsp" sang dashboard nếu là admin
        if ((path.equals("/") || path.equals("/home.jsp")) && currentUser != null && currentUser.isAdmin()) {
            res.sendRedirect(req.getContextPath() + "/admin/adminPage.jsp");
            return;
        }

        // Cho phép truy cập /about mà không cần login
        if (path.equals("/about")) {
            chain.doFilter(request, response);
            return;
        }

        // Kiểm tra nếu là đường dẫn trong /admin/*
        if (path.startsWith("/admin")) {
            if (currentUser == null || !currentUser.isAdmin()) {
                res.sendRedirect(req.getContextPath() + "/account/login.jsp");
                return;
            }
        }

        // Cho phép các trang khác
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Dọn dẹp nếu cần
    }
}