package service;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordService {

    // Hash mật khẩu thô thành chuỗi hash Bcrypt
    public static String hashPassword(String rawPassword) {
        return BCrypt.hashpw(rawPassword, BCrypt.gensalt());
    }

    // Kiểm tra mật khẩu thô với chuỗi hash đã lưu
    public static boolean checkPassword(String rawPassword, String storedHash) {
        return BCrypt.checkpw(rawPassword, storedHash);
    }
}
