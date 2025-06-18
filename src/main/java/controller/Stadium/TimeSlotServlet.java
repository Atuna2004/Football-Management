package controller.Stadium;

import dao.TimeSlotDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.TimeSlot;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/timeslot")
public class TimeSlotServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int stadiumId = Integer.parseInt(request.getParameter("stadiumId")); // ✅ NEW

        int weekOffset = 0;
        try {
            weekOffset = Integer.parseInt(request.getParameter("weekOffset"));
        } catch (Exception ignored) {}

        LocalDate today = LocalDate.now();
        LocalDate startOfWeek = today.plusWeeks(weekOffset).with(java.time.DayOfWeek.MONDAY);

        TimeSlotDAO dao = new TimeSlotDAO();
        List<TimeSlot> slots = dao.getTimeSlotsByStadiumAndWeek(stadiumId, startOfWeek); // ✅ NEW DAO

        request.setAttribute("startOfWeek", startOfWeek);
        request.setAttribute("timeSlots", slots);
        request.setAttribute("weekOffset", weekOffset);
        request.setAttribute("stadiumId", stadiumId); // ✅ để giữ lại khi chuyển tuần

        request.getRequestDispatcher("/stadium/timeslot.jsp").forward(request, response);
    }
}
