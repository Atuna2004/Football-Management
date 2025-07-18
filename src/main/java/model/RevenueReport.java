package model;
// File: model/RevenueReport.java



public class RevenueReport {
    private String stadiumName;   // Tên sân bóng
    private String period;        // Khoảng thời gian: ngày/tháng/năm
    private double totalRevenue;  // Tổng doanh thu

    public RevenueReport() {}

    public RevenueReport(String stadiumName, String period, double totalRevenue) {
        this.stadiumName = stadiumName;
        this.period = period;
        this.totalRevenue = totalRevenue;
    }

    // Getter và Setter

    public String getStadiumName() {
        return stadiumName;
    }

    public void setStadiumName(String stadiumName) {
        this.stadiumName = stadiumName;
    }

    public String getPeriod() {
        return period;
    }

    public void setPeriod(String period) {
        this.period = period;
    }

    public double getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }
}