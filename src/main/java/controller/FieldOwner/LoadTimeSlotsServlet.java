package controller.FieldOwner;

import dao.TimeSlotDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.time.DayOfWeek;
import java.util.List;
import model.TimeSlot;
import model.User;

@WebServlet("/LoadTimeSlotsServlet")
public class LoadTimeSlotsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        int stadiumId = Integer.parseInt(request.getParameter("stadiumId"));
        String week = request.getParameter("week");

        LocalDate startOfWeek = "current".equals(week) ?
                LocalDate.now().with(java.time.DayOfWeek.MONDAY) :
                LocalDate.now().plusWeeks(1).with(java.time.DayOfWeek.MONDAY);

        TimeSlotDAO timeSlotDAO = new TimeSlotDAO();
        List<TimeSlot> timeSlots = timeSlotDAO.getTimeSlotsByStadiumAndWeek(stadiumId, startOfWeek);

        request.setAttribute("timeSlots", timeSlots);
        request.setAttribute("startOfWeek", startOfWeek);
        request.getRequestDispatcher("/fieldOwner/TimeSlotManagement.jsp").forward(request, response);
    }
}