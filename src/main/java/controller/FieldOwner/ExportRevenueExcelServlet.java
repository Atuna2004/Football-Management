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

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;

@WebServlet("/export-revenue-excel")
public class ExportRevenueExcelServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String period = request.getParameter("period");
        if (period == null || period.isEmpty()) {
            period = "month";
        }

        PaymentDAO paymentDAO = new PaymentDAO();

        try {
            List<String> stadiums = paymentDAO.getAllStadiumNames();
            List<RevenueReport> reports = paymentDAO.getRevenueByStadiumAndPeriod(period);

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

            // Thêm viền cho header
            headerStyle.setBorderTop(BorderStyle.THIN);
            headerStyle.setBorderBottom(BorderStyle.THIN);
            headerStyle.setBorderLeft(BorderStyle.THIN);
            headerStyle.setBorderRight(BorderStyle.THIN);

            // 2. Tạo style cho dữ liệu (tiền tệ + viền)
            CellStyle dataStyle = workbook.createCellStyle();
            DataFormat format = workbook.createDataFormat();
            dataStyle.setDataFormat(format.getFormat("#,##0 \"đ\"")); // 1,000,000 đ
            dataStyle.setAlignment(HorizontalAlignment.RIGHT);
            dataStyle.setVerticalAlignment(VerticalAlignment.CENTER);

            // Thêm viền cho dữ liệu
            dataStyle.setBorderTop(BorderStyle.THIN);
            dataStyle.setBorderBottom(BorderStyle.THIN);
            dataStyle.setBorderLeft(BorderStyle.THIN);
            dataStyle.setBorderRight(BorderStyle.THIN);

            // 3. Tạo style cho cột "Thời Gian" (text, căn giữa)
            CellStyle periodStyle = workbook.createCellStyle();
            periodStyle.setAlignment(HorizontalAlignment.CENTER);
            periodStyle.setVerticalAlignment(VerticalAlignment.CENTER);
            periodStyle.setBorderTop(BorderStyle.THIN);
            periodStyle.setBorderBottom(BorderStyle.THIN);
            periodStyle.setBorderLeft(BorderStyle.THIN);
            periodStyle.setBorderRight(BorderStyle.THIN);

            // 4. Tạo header
            Row headerRow = sheet.createRow(0);
            headerRow.setHeightInPoints(30); // Cao hơn một chút

            headerRow.createCell(0).setCellValue("Thời Gian");
            headerRow.getCell(0).setCellStyle(headerStyle);

            for (int i = 0; i < stadiums.size(); i++) {
                Cell cell = headerRow.createCell(i + 1);
                cell.setCellValue(stadiums.get(i));
                cell.setCellStyle(headerStyle);
            }

            // 5. Lấy danh sách các mốc thời gian
            java.util.Set<String> periods = new java.util.LinkedHashSet<>();
            for (RevenueReport r : reports) {
                periods.add(r.getPeriod());
            }

            // 6. Điền dữ liệu vào bảng
            int rowIdx = 1;
            for (String periodValue : periods) {
                Row row = sheet.createRow(rowIdx++);
                row.setHeightInPoints(25); // Chiều cao hàng

                // Cột "Thời Gian"
                Cell periodCell = row.createCell(0);
                periodCell.setCellValue(periodValue);
                periodCell.setCellStyle(periodStyle);

                // Các cột doanh thu
                for (int i = 0; i < stadiums.size(); i++) {
                    String stadiumName = stadiums.get(i);
                    double revenue = 0;

                    for (RevenueReport r : reports) {
                        if (r.getStadiumName().equals(stadiumName) && r.getPeriod().equals(periodValue)) {
                            revenue = r.getTotalRevenue();
                            break;
                        }
                    }

                    Cell cell = row.createCell(i + 1);
                    cell.setCellValue(revenue);
                    cell.setCellStyle(dataStyle);
                }
            }

            // 7. Tự động căn chỉnh độ rộng cột
            sheet.setColumnWidth(0, 15 * 256); // Cột thời gian
            for (int i = 1; i <= stadiums.size(); i++) {
                sheet.autoSizeColumn(i);
                int width = sheet.getColumnWidth(i);
                int newWidth = Math.min(width + 1000, 25 * 256);
                sheet.setColumnWidth(i, newWidth);
            }

            // 8. Ghi file và trả về
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