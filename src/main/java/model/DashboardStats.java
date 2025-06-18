package model;
// DashboardStats.java


public class DashboardStats {
    private int todayBookings;
    private double monthlyRevenue;
    private int totalFields;
    private int totalCustomers;
    
    // Constructors
    public DashboardStats() {}
    
    public DashboardStats(int todayBookings, double monthlyRevenue, int totalFields, int totalCustomers) {
        this.todayBookings = todayBookings;
        this.monthlyRevenue = monthlyRevenue;
        this.totalFields = totalFields;
        this.totalCustomers = totalCustomers;
    }
    
    // Getters and Setters
    public int getTodayBookings() {
        return todayBookings;
    }
    
    public void setTodayBookings(int todayBookings) {
        this.todayBookings = todayBookings;
    }
    
    public double getMonthlyRevenue() {
        return monthlyRevenue;
    }
    
    public void setMonthlyRevenue(double monthlyRevenue) {
        this.monthlyRevenue = monthlyRevenue;
    }
    
    public int getTotalFields() {
        return totalFields;
    }
    
    public void setTotalFields(int totalFields) {
        this.totalFields = totalFields;
    }
    
    public int getTotalCustomers() {
        return totalCustomers;
    }
    
    public void setTotalCustomers(int totalCustomers) {
        this.totalCustomers = totalCustomers;
    }
    
    @Override
    public String toString() {
        return "DashboardStats{" +
                "todayBookings=" + todayBookings +
                ", monthlyRevenue=" + monthlyRevenue +
                ", totalFields=" + totalFields +
                ", totalCustomers=" + totalCustomers +
                '}';
    }
}
