package model;

public class SystemSetting {

    private String siteName;
    private String supportEmail;
    private String defaultRole;
    private boolean emailNotificationsEnabled;
    private boolean smsEnabled;
    private String language;
    private String timeZone;

    public SystemSetting() {
    }

    public SystemSetting(String siteName, String supportEmail, String defaultRole,
            boolean emailNotificationsEnabled, boolean smsEnabled,
            String language, String timeZone) {
        this.siteName = siteName;
        this.supportEmail = supportEmail;
        this.defaultRole = defaultRole;
        this.emailNotificationsEnabled = emailNotificationsEnabled;
        this.smsEnabled = smsEnabled;
        this.language = language;
        this.timeZone = timeZone;
    }

    public String getSiteName() {
        return siteName;
    }

    public void setSiteName(String siteName) {
        this.siteName = siteName;
    }

    public String getSupportEmail() {
        return supportEmail;
    }

    public void setSupportEmail(String supportEmail) {
        this.supportEmail = supportEmail;
    }

    public String getDefaultRole() {
        return defaultRole;
    }

    public void setDefaultRole(String defaultRole) {
        this.defaultRole = defaultRole;
    }

    public boolean isEmailNotificationsEnabled() {
        return emailNotificationsEnabled;
    }

    public void setEmailNotificationsEnabled(boolean emailNotificationsEnabled) {
        this.emailNotificationsEnabled = emailNotificationsEnabled;
    }

    public boolean isSmsEnabled() {
        return smsEnabled;
    }

    public void setSmsEnabled(boolean smsEnabled) {
        this.smsEnabled = smsEnabled;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getTimeZone() {
        return timeZone;
    }

    public void setTimeZone(String timeZone) {
        this.timeZone = timeZone;
    }
}
