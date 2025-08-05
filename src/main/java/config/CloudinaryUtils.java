package config;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.http.Part;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import org.apache.commons.io.FileUtils;


public class CloudinaryUtils {

    // Khởi tạo Cloudinary bằng cách đọc từ file config
    private static final Cloudinary cloudinary;

    static {
        cloudinary = new Cloudinary(ObjectUtils.asMap(
                "cloud_name", ConfigAPIKey.getProperty("cloudinary.cloud_name"),
                "api_key", ConfigAPIKey.getProperty("cloudinary.api.key"),
                "api_secret", ConfigAPIKey.getProperty("cloudinary.api_secret")
        ));
    }

    public static String uploadImage(Part filePart, int userID) throws IOException {
        System.out.println("[CloudinaryUtils] Starting upload for userID: " + userID);

        if (filePart == null || filePart.getSize() == 0) {
            System.out.println("[CloudinaryUtils] File is null or empty");
            throw new IllegalArgumentException("Invalid file (null or empty)");
        }

        // ... (phần còn lại của phương thức không thay đổi)
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
    
    public static String uploadImage(InputStream inputStream, String fileName, String folder) throws IOException {
        File tempFile = null;
        try {
            // Create temporary file
            String fileExtension = "";
            if (fileName != null && fileName.contains(".")) {
                fileExtension = fileName.substring(fileName.lastIndexOf("."));
            }
            tempFile = File.createTempFile("upload_" + UUID.randomUUID().toString(), fileExtension);
            
            // Copy input stream to temporary file
            FileUtils.copyInputStreamToFile(inputStream, tempFile);
            
            // Configure upload options
            Map<String, Object> uploadOptions = new HashMap<>();
            uploadOptions.put("resource_type", "image");
            uploadOptions.put("quality", "auto");
            uploadOptions.put("fetch_format", "auto");
            
            // Add folder if specified
            if (folder != null && !folder.trim().isEmpty()) {
                uploadOptions.put("folder", folder);
            }
            
            // Upload to Cloudinary
            Map uploadResult = cloudinary.uploader().upload(tempFile, uploadOptions);
            
            // Return secure URL
            return (String) uploadResult.get("secure_url");
            
        } catch (Exception e) {
            throw new IOException("Failed to upload image to Cloudinary: " + e.getMessage(), e);
        } finally {
            // Clean up temporary file
            if (tempFile != null && tempFile.exists()) {
                tempFile.delete();
            }
        }
    }
}