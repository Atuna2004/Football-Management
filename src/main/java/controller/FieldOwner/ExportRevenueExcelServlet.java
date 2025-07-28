// File: src/main/java/controller/FieldOwner/ExportRevenueExcelServlet.java
package controller.FieldOwner;

import dao.PaymentDAO;
import model.RevenueReport;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;
import model.User;

@WebServlet("/export-revenue-excel")
public class ExportRevenueExcelServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy tham số
        HttpSession session = request.getSession(false);
        String period = request.getParameter("period"); // day, month, year
        String stadium = request.getParameter("stadium"); // optional
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        Integer ownerId = (Integer) user.getUserID();

        if (ownerId == null) {
            response.sendError(403, "Bạn cần đăng nhập với tư cách chủ sân.");
            return;
        }

        if (period == null || period.isEmpty()) {
            period = "month"; // mặc định
        }

        PaymentDAO paymentDAO = new PaymentDAO();

        try {
            List<RevenueReport> reports = paymentDAO.getRevenueByOwnerAndPeriod(ownerId, period, stadium);

            // Tạo workbook và sheet
            Workbook workbook = new XSSFWorkbook();
            Sheet sheet = workbook.createSheet("Báo cáo doanh thu");

            // 1. Tạo style cho header
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerFont.setFontHeightInPoints((short) 12);

            CellStyle headerStyle = workbook.createCellStyle();
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(IndexedColors.LIGHT_TURQUOISE.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerStyle.setAlignment(HorizontalAlignment.CENTER);
            headerStyle.setVerticalAlignment(VerticalAlignment.CENTER);
            headerStyle.setBorderTop(BorderStyle.THIN);
            headerStyle.setBorderBottom(BorderStyle.THIN);
            headerStyle.setBorderLeft(BorderStyle.THIN);
            headerStyle.setBorderRight(BorderStyle.THIN);

            // 2. Style cho dữ liệu thông thường (căn giữa)
            CellStyle dataStyle = workbook.createCellStyle();
            dataStyle.setAlignment(HorizontalAlignment.CENTER);
            dataStyle.setVerticalAlignment(VerticalAlignment.CENTER);
            dataStyle.setBorderTop(BorderStyle.THIN);
            dataStyle.setBorderBottom(BorderStyle.THIN);
            dataStyle.setBorderLeft(BorderStyle.THIN);
            dataStyle.setBorderRight(BorderStyle.THIN);

            // 3. Style cho cột Doanh thu (tiền tệ + căn phải)
            CellStyle currencyStyle = workbook.createCellStyle();
            DataFormat format = workbook.createDataFormat();
            currencyStyle.setDataFormat(format.getFormat("#,##0 \"đ\""));
            currencyStyle.setAlignment(HorizontalAlignment.RIGHT);
            currencyStyle.setVerticalAlignment(VerticalAlignment.CENTER);
            currencyStyle.setBorderTop(BorderStyle.THIN);
            currencyStyle.setBorderBottom(BorderStyle.THIN);
            currencyStyle.setBorderLeft(BorderStyle.THIN);
            currencyStyle.setBorderRight(BorderStyle.THIN);

            // 4. Tạo header
            Row headerRow = sheet.createRow(0);
            headerRow.setHeightInPoints(30);

            String[] headers = {"STT", "Sân", "Thời Gian", "Doanh Thu"};
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            // 5. Điền dữ liệu
            for (int i = 0; i < reports.size(); i++) {
                RevenueReport r = reports.get(i);
                Row row = sheet.createRow(i + 1);
                row.setHeightInPoints(25);

                // STT
                Cell cell0 = row.createCell(0);
                cell0.setCellValue(i + 1);
                cell0.setCellStyle(dataStyle);

                // Sân
                Cell cell1 = row.createCell(1);
                cell1.setCellValue(r.getStadiumName());
                cell1.setCellStyle(dataStyle);

                // Thời Gian
                Cell cell2 = row.createCell(2);
                cell2.setCellValue(r.getPeriod());
                cell2.setCellStyle(dataStyle);

                // Doanh Thu
                Cell cell3 = row.createCell(3);
                cell3.setCellValue(r.getTotalRevenue());
                cell3.setCellStyle(currencyStyle);
            }

            // 6. Tự động căn chỉnh độ rộng cột
            sheet.setColumnWidth(0, 10 * 256); // STT
            sheet.setColumnWidth(1, 25 * 256); // Sân
            sheet.setColumnWidth(2, 18 * 256); // Thời Gian
            sheet.setColumnWidth(3, 22 * 256); // Doanh Thu

            // 7. Ghi file và trả về
            ByteArrayOutputStream bos = new ByteArrayOutputStream();
            workbook.write(bos);
            byte[] bytes = bos.toByteArray();
            workbook.close();
            bos.close();

            String filename = "Bao_cao_doanh_thu_" + period + "_" + System.currentTimeMillis() + ".xlsx";
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=" + filename);
            response.setContentLength(bytes.length);

            response.getOutputStream().write(bytes);
            response.getOutputStream().flush();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi khi tạo file Excel: " + e.getMessage());
        }
    }
}