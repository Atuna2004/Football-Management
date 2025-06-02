package utils;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailService {

    public static final String EMAIL_SENDER = "xxx";
    public static final String EMAIL_PASSWORD = "xxx";
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final int SMTP_PORT = 587;

    private void validateCredentials() {
        if (EMAIL_SENDER == null || EMAIL_SENDER == null) {
            System.out.println("? Please configure environment variables SENDER_EMAIL and SENDER_PASSWORD.");
            throw new IllegalStateException("Email credentials not configured.");
        }
        System.out.println("? SENDER_EMAIL: " + EMAIL_SENDER);
        System.out.println("? SENDER_PASSWORD: " + (EMAIL_SENDER != null ? "********" : "NULL"));
    }

    private Session createSession() {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.debug", "true");

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_SENDER, EMAIL_PASSWORD);
            }
        });
    }

    public void sendOTPEmail(String recipientEmail, String resetCode, String subject) {
        validateCredentials();
        Session session = createSession();

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_SENDER));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject(subject);
            message.setContent(
                    "<h1>OTP Request</h1>"
                    + "<p>Hello,</p>"
                    + "<p>We have received an OTP reset request for your account.</p>"
                    + "<p>Your verification code is: <strong>" + resetCode + "</strong></p>"
                    + "<p>This code is valid for 5 minutes. Please enter this code to proceed with resetting your password.</p>"
                    + "<p>If you did not request this, please ignore this email.</p>"
                    + "<p>Best regards,</p>"
                    + "<p>Application Team</p>",
                    "text/html; charset=UTF-8"
            );

            Transport.send(message);
            System.out.println("? Forgot password email sent successfully to: " + recipientEmail);

        } catch (MessagingException e) {
            System.err.println("? Email sending failed: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void sendManualSignupEmail(String recipientEmail, String username) {
        validateCredentials();
        Session session = createSession();

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_SENDER));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Welcome to Our Application!");
            message.setContent(
                    "<h1>Registration Successful</h1>"
                    + "<p>Hello " + username + ",</p>"
                    + "<p>Congratulations! You have successfully registered an account.</p>"
                    + "<p>Account details:</p>"
                    + "<ul>"
                    + "<li>Username: " + username + "</li>"
                    + "<li>Email: " + recipientEmail + "</li>"
                    + "</ul>"
                    + "<p>You can now log in and start exploring our services.</p>"
                    + "<p>Best regards,</p>"
                    + "<p>Application Team</p>",
                    "text/html; charset=UTF-8"
            );

            Transport.send(message);
            System.out.println("? Manual signup email sent successfully to: " + recipientEmail);

        } catch (MessagingException e) {
            System.err.println("? Email sending failed: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void sendGoogleSignupEmail(String recipientEmail, String username) {
        validateCredentials();
        Session session = createSession();

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_SENDER));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Welcome to Our Application - Google Signup");
            message.setContent(
                    "<h1>Google Signup Successful</h1>"
                    + "<p>Hello " + username + ",</p>"
                    + "<p>Congratulations! You have successfully signed up using Google.</p>"
                    + "<p>Account details:</p>"
                    + "<ul>"
                    + "<li>Username: " + username + "</li>"
                    + "<li>Email: " + recipientEmail + "</li>"
                    + "</ul>"
                    + "<p>You can log in anytime using your Google account.</p>"
                    + "<p>Best regards,</p>"
                    + "<p>Application Team</p>",
                    "text/html; charset=UTF-8"
            );

            Transport.send(message);
            System.out.println("? Google signup email sent successfully to: " + recipientEmail);

        } catch (MessagingException e) {
            System.err.println("? Email sending failed: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void sendConfirmationEmail(String recipientEmail, String orderDetails) {
        validateCredentials();
        Session session = createSession();

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_SENDER));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Order Confirmation");
            message.setContent(
                    "<h1>Thank you for your order!</h1>"
                    + "<p>Order details:</p>"
                    + "<pre>" + orderDetails + "</pre>"
                    + "<p><strong>Note:</strong> Your order will be shipped within 2-3 days.</p>",
                    "text/html; charset=UTF-8"
            );

            Transport.send(message);
            System.out.println("? Order confirmation email sent successfully to: " + recipientEmail);

        } catch (MessagingException e) {
            System.err.println("? Email sending failed: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static void sendEmail(String recipientEmail, String subject, String messageText) throws MessagingException {
        System.out.println("? [DEBUG] - B?t ??u g?i email...");
        System.out.println("? [DEBUG] - G?i t?i: " + recipientEmail);

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.debug", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_SENDER, EMAIL_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_SENDER));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject(subject);
            message.setText(messageText);

            System.out.println("? [INFO] - ?ang g?i email...");
            Transport.send(message);
            System.out.println("? Email ?� g?i th�nh c�ng!");

        } catch (MessagingException e) {
            System.err.println("? G?i email th?t b?i: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
