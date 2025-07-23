package listener;

import jakarta.servlet.ServletContext;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;

@WebListener
public class OnlineUserListener implements HttpSessionListener {

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        ServletContext context = se.getSession().getServletContext();
        synchronized (context) {
            Integer onlineUsers = (Integer) context.getAttribute("onlineUsers");
            if (onlineUsers == null) {
                onlineUsers = 0;
            }
            onlineUsers++;
            context.setAttribute("onlineUsers", onlineUsers);
        }
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        ServletContext context = se.getSession().getServletContext();
        synchronized (context) {
            Integer onlineUsers = (Integer) context.getAttribute("onlineUsers");
            if (onlineUsers != null && onlineUsers > 0) {
                onlineUsers--;
            } else {
                onlineUsers = 0;
            }
            context.setAttribute("onlineUsers", onlineUsers);
        }
    }
}
