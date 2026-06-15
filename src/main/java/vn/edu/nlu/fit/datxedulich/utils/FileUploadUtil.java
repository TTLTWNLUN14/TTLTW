package vn.edu.nlu.fit.datxedulich.utils;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

public class FileUploadUtil {
    private static final String UPLOAD_DIR = "uploads";

    public static String uploadFile(HttpServletRequest request, String partName, String subFolder)
            throws IOException, ServletException {

        Part filePart = request.getPart(partName);

        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }

        String submittedFileName = filePart.getSubmittedFileName();
        if (submittedFileName == null || submittedFileName.isEmpty()) {
            return null;
        }

        String fileName = Paths.get(submittedFileName).getFileName().toString();
        String newFileName = System.currentTimeMillis() + "_" + fileName;

        String basePath = request.getServletContext().getRealPath("");
        String uploadPath = basePath + File.separator + UPLOAD_DIR + File.separator + subFolder;

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        filePart.write(uploadPath + File.separator + newFileName);

        return UPLOAD_DIR + "/" + subFolder + "/" + newFileName;
    }

    public static String saveFile(Part filePart, HttpServletRequest request) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }

        String submittedFileName = filePart.getSubmittedFileName();
        if (submittedFileName == null || submittedFileName.isEmpty()) {
            return null;
        }
        String fileName = Paths.get(submittedFileName).getFileName().toString();
        String newFileName = System.currentTimeMillis() + "_avatar_" + fileName;
        String basePath = request.getServletContext().getRealPath("");
        String subFolder = "avatars";
        String uploadPath = basePath + File.separator + UPLOAD_DIR + File.separator + subFolder;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        filePart.write(uploadPath + File.separator + newFileName);
        return UPLOAD_DIR + "/" + subFolder + "/" + newFileName;
    }
}