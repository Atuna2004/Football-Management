package listener;

import jakarta.servlet.ServletContext;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;

import java.util.HashSet;

import model.User;

@WebListener
public class OnlineUserListener implements HttpSessionListener {


    @Override
    public void sessionCreated(HttpSessionEvent se) {

    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        ServletContext context = session.getServletContext();
        User currentUser = (User) session.getAttribute("currentUser");


        if (currentUser != null) {
            synchronized (context) {

                HashSet<Integer> onlineUsers = (HashSet<Integer>) context.getAttribute("onlineUsers");
                if (onlineUsers != null) {

                    onlineUsers.remove(currentUser.getUserID());
                    context.setAttribute("onlineUsers", onlineUsers);
                }
            }
        }
    }
}