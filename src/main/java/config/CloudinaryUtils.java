package config;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.http.Part;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

public class CloudinaryUtils {

    private static final Cloudinary cloudinary = new Cloudinary(ObjectUtils.asMap(
            "cloud_name", System.getenv("cloud_name"),
            "api_key", System.getenv("api_key"),
            "api_secret", System.getenv("api_secret")
    ));

    public static String uploadImage(Part filePart, int userID) throws IOException {
        System.out.println("[CloudinaryUtils] Starting upload for userID: " + userID);
        System.out.println("[CloudinaryUtils] Cloud Name: " + System.getenv("cloud_name"));
        System.out.println("[CloudinaryUtils] API Key: " + System.getenv("api_key"));

        if (filePart == null || filePart.getSize() == 0) {
            System.out.println("[CloudinaryUtils] File is null or empty");
            throw new IllegalArgumentException("Invalid file (null or empty)");
        }

        System.out.println("[CloudinaryUtils] File name: " + filePart.getSubmittedFileName());
        System.out.println("[CloudinaryUtils] File size: " + filePart.getSize() + " bytes");
        System.out.println("[CloudinaryUtils] Content type: " + filePart.getContentType());

        try (InputStream input = filePart.getInputStream()) {

            ByteArrayOutputStream buffer = new ByteArrayOutputStream();
            int nRead;
            byte[] data = new byte[1024];
            while ((nRead = input.read(data, 0, data.length)) != -1) {
                buffer.write(data, 0, nRead);
            }
            buffer.flush();
            byte[] fileBytes = buffer.toByteArray();
            System.out.println("[CloudinaryUtils] Converted file to byte array, size: " + fileBytes.length + " bytes");

            Map<String, Object> uploadParams = new HashMap<>();
            uploadParams.put("resource_type", "image");
            uploadParams.put("public_id", "avatar_user_" + userID + "_" + System.currentTimeMillis());
            uploadParams.put("overwrite", true);
            System.out.println("[CloudinaryUtils] Public ID: " + uploadParams.get("public_id"));

            Map<String, Object> uploadResult = cloudinary.uploader().upload(fileBytes, uploadParams);
            System.out.println("[CloudinaryUtils] Upload result: " + uploadResult);

            Object url = uploadResult.get("secure_url");
            if (url == null) {
                System.out.println("[CloudinaryUtils] Upload succeeded but no secure_url returned");
                throw new IOException("Upload succeeded but no URL received from Cloudinary.");
            }
            System.out.println("[CloudinaryUtils] Upload successful, URL: " + url);
            return url.toString();
        } catch (Exception ex) {
            System.out.println("[CloudinaryUtils] Error during upload: " + ex.getMessage());

            throw new IOException("Error uploading image to Cloudinary: " + ex.getMessage(), ex);
        }
    }
}
