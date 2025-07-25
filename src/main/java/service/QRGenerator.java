package service;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.common.BitMatrix;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;

public class QRGenerator {
    public static File generateQRCodeImage(String data, String fileName) throws Exception {
        int size = 250;
        QRCodeWriter qrWriter = new QRCodeWriter();
        BitMatrix matrix = qrWriter.encode(data, BarcodeFormat.QR_CODE, size, size);

        BufferedImage image = new BufferedImage(size, size, BufferedImage.TYPE_INT_RGB);
        for (int x = 0; x < size; x++)
            for (int y = 0; y < size; y++)
                image.setRGB(x, y, matrix.get(x, y) ? 0x000000 : 0xFFFFFF);

        File output = new File(fileName);
        ImageIO.write(image, "png", output);
        return output;
    }
}
