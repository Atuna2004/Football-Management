package service;

import config.ConfigAPIKey;
import jakarta.activation.DataHandler;
import jakarta.activation.FileDataSource;
import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeBodyPart;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeMultipart;
import java.io.File;
import java.util.Properties;

public class EmailService {




    private void validateCredentials() {
        String sender = ConfigAPIKey.getProperty("email.sender.address");
        String password = ConfigAPIKey.getProperty("email.sender.password");
        if (sender == null || sender.isEmpty() || password == null || password.isEmpty()) {
            System.out.println("⚠️ Lỗi: Vui lòng cấu hình 'email.sender.address' và 'email.sender.password' trong file config.properties.");
            throw new IllegalStateException("Chưa cấu hình đầy đủ thông tin email trong file config.properties.");
        }
        System.out.println("✅ SENDER_EMAIL được cấu hình: " + sender);
    }


    private Session createSession() {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", ConfigAPIKey.getProperty("email.smtp.host"));
        props.put("mail.smtp.port", ConfigAPIKey.getProperty("email.smtp.port"));
        props.put("mail.debug", "false"); // Nên đặt là false trong production

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(
                        ConfigAPIKey.getProperty("email.sender.address"),
                        ConfigAPIKey.getProperty("email.sender.password")
                );
            }
        });
    }


    private void sendHtmlEmail(String recipientEmail, String subject, String htmlContent) {
        validateCredentials();
        Session session = createSession();
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(ConfigAPIKey.getProperty("email.sender.address")));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject(subject);
            message.setContent(htmlContent, "text/html; charset=UTF-8");
            Transport.send(message);
            System.out.println("✅ Đã gửi email '" + subject + "' đến: " + recipientEmail);
        } catch (MessagingException e) {
            System.err.println("❌ Gửi email thất bại: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void sendOTPEmail(String recipientEmail, String resetCode, String subject) {
        String htmlContent = "<h1>Yêu cầu xác thực OTP</h1>"
                + "<p>Mã xác thực của bạn là: <strong>" + resetCode + "</strong></p>"
                + "<p>Mã này có hiệu lực trong vòng 5 phút.</p>";
        sendHtmlEmail(recipientEmail, subject, htmlContent);
    }

    public void sendManualSignupEmail(String recipientEmail, String username) {
        String htmlContent = "<h1>Đăng ký thành công</h1>"
                + "<p>Xin chào " + username + ",</p>"
                + "<p>Thông tin tài khoản của bạn đã được tạo thành công.</p>";
        sendHtmlEmail(recipientEmail, "Chào mừng bạn đến với Ứng dụng của chúng tôi!", htmlContent);
    }

    public void sendGoogleSignupEmail(String recipientEmail, String username) {
        String htmlContent = "<h1>Đăng ký bằng Google thành công</h1>"
                + "<p>Xin chào " + username + ",</p>"
                + "<p>Bạn đã đăng ký tài khoản thành công bằng Google.</p>";
        sendHtmlEmail(recipientEmail, "Chào mừng bạn - Đăng ký bằng Google", htmlContent);
    }

    public void sendConfirmationEmail(String recipientEmail, String orderDetails) {
        String htmlContent = "<h1>Cảm ơn bạn đã đặt hàng!</h1>"
                + "<p>Chi tiết đơn hàng:</p><pre>" + orderDetails + "</pre>";
        sendHtmlEmail(recipientEmail, "Xác nhận đơn hàng", htmlContent);
    }


    public static void sendEmail(String recipientEmail, String subject, String messageText) throws MessagingException {
        System.out.println("📨 [DEBUG] - Gửi tới: " + recipientEmail);

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", ConfigAPIKey.getProperty("email.smtp.host"));
        props.put("mail.smtp.port", ConfigAPIKey.getProperty("email.smtp.port"));
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.debug", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(
                        ConfigAPIKey.getProperty("email.sender.address"),
                        ConfigAPIKey.getProperty("email.sender.password")
                );
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(ConfigAPIKey.getProperty("email.sender.address")));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject(subject);
            message.setText(messageText);
            Transport.send(message);
            System.out.println("✅ Email đã gửi thành công!");
        } catch (MessagingException e) {
            System.err.println("❌ Gửi email thất bại: " + e.getMessage());
            throw e;
        }
    }

    public void sendCheckinQRCodeEmail(String recipientEmail, String fullName, int bookingId, File qrFile, String checkinUrl) {
        validateCredentials();
        Session session = createSession();
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(ConfigAPIKey.getProperty("email.sender.address")));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("🎟️ Mã QR Check-in - Đơn #" + bookingId);

            String html = "<h2>Xin chào " + fullName + ",</h2>"
                    + "<p>Vui lòng trình mã QR dưới đây khi đến sân để check-in.</p>"
                    + "<p><strong>Đơn #" + bookingId + "</strong></p>"
                    + "<img src='cid:qrImage' width='200' height='200'/>"
                    + "<p>Hoặc truy cập: <a href='" + checkinUrl + "'>" + checkinUrl + "</a></p>";

            MimeBodyPart htmlPart = new MimeBodyPart();
            htmlPart.setContent(html, "text/html; charset=UTF-8");

            MimeBodyPart imagePart = new MimeBodyPart();
            imagePart.setDataHandler(new DataHandler(new FileDataSource(qrFile)));
            imagePart.setHeader("Content-ID", "<qrImage>");
            imagePart.setDisposition(MimeBodyPart.INLINE);

            MimeMultipart multipart = new MimeMultipart("related");
            multipart.addBodyPart(htmlPart);
            multipart.addBodyPart(imagePart);

            message.setContent(multipart);
            Transport.send(message);
            System.out.println("✅ Đã gửi email QR code kèm ảnh đến " + recipientEmail);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}