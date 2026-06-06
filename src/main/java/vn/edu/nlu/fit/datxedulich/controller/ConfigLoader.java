package vn.edu.nlu.fit.datxedulich.controller;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

public class ConfigLoader {
    private static final Map<String, String> config = new HashMap<>();
    private static final String ENV_FILE_NAME = ".env";
    private static boolean envFileLoaded = false;

    static {
        loadConfiguration();
    }

    private static void loadConfiguration() {
        loadEnvFile();

        loadEnvironmentVariables();

        if (!envFileLoaded) {
            System.out.println(" CẢNH BÁO: Tệp .env không tìm thấy!");
            System.out.println("  Đang tìm từ environment variables...");
        }

        if (!isValid()) {
            System.err.println("LỖI: Thiếu cấu hình bắt buộc!");
            System.err.println("  Vui lòng thiết lập .env hoặc environment variables");
        }
    }

    private static void loadEnvFile() {
        String[] possiblePaths = {
                ".env",
                System.getProperty("user.dir") + File.separator + ".env",
                System.getProperty("user.home") + File.separator + ".env",
                "/etc/.env",
                "d:\\.env"
        };

        for (String path : possiblePaths) {
            if (loadEnvFromPath(path)) {
                System.out.println("✓ Đã tải .env từ: " + path);
                envFileLoaded = true;
                return;
            }
        }
    }

    private static boolean loadEnvFromPath(String path) {
        try {
            File envFile = new File(path);
            if (!envFile.exists()) {
                return false;
            }

            BufferedReader reader = new BufferedReader(new FileReader(envFile));
            String line;
            int lineCount = 0;

            while ((line = reader.readLine()) != null) {
                line = line.trim();

                if (line.isEmpty() || line.startsWith("#")) {
                    continue;
                }

                if (line.contains("=")) {
                    String[] parts = line.split("=", 2);
                    String key = parts[0].trim();
                    String value = parts.length > 1 ? parts[1].trim() : "";

                    if ((value.startsWith("\"") && value.endsWith("\"")) ||
                            (value.startsWith("'") && value.endsWith("'"))) {
                        value = value.substring(1, value.length() - 1);
                    }

                    config.put(key, value);
                    lineCount++;
                }
            }
            reader.close();

            System.out.println(" Đã tải " + lineCount + " biến từ .env");
            return true;

        } catch (IOException e) {
            return false;
        }
    }

    private static void loadEnvironmentVariables() {
        String[] possibleKeys = {
                "GOOGLE_CLIENT_ID", "GOOGLE_CLIENT_SECRET", "GOOGLE_REDIRECT_URI",
                "FACEBOOK_APP_ID", "FACEBOOK_APP_SECRET", "FACEBOOK_REDIRECT_URI",
                "DB_URL", "DB_USERNAME", "DB_PASSWORD"
        };

        int envVarCount = 0;
        for (String key : possibleKeys) {
            String envValue = System.getenv(key);
            if (envValue != null && !envValue.isEmpty()) {
                config.put(key, envValue);
                envVarCount++;
            }
        }

        if (envVarCount > 0) {
            System.out.println("Đã tải " + envVarCount + " biến từ environment variables");
        }
    }

    public static String get(String key) {
        String value = config.get(key);
        if (value == null) {
            System.out.println("Cảnh báo: Không tìm thấy biến '" + key + "'");
        }
        return value;
    }

    public static String get(String key, String defaultValue) {
        return config.getOrDefault(key, defaultValue);
    }

    public static boolean isValid() {
        String[] requiredKeys = {
                "GOOGLE_CLIENT_ID", "GOOGLE_CLIENT_SECRET",
                "FACEBOOK_APP_ID", "FACEBOOK_APP_SECRET"
        };

        boolean valid = true;
        for (String key : requiredKeys) {
            String value = config.get(key);
            if (value == null || value.isEmpty() || value.startsWith("YOUR_")) {
                System.err.println(" Thiếu: " + key);
                valid = false;
            }
        }
        return valid;
    }

    public static void printLoadedKeys() {
        if (config.isEmpty()) {
            System.out.println("");
            return;
        }

        for (String key : config.keySet()) {
            String value = config.get(key);
            String displayValue = (value != null && value.length() > 15)
                    ? value.substring(0, 15) + "..."
                    : value;
            System.out.println(" " + key + " = " + displayValue);
        }
        System.out.println();
    }
}
