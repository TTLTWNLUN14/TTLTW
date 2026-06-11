package vn.edu.nlu.fit.datxedulich.Util;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Scanner;
public class MoMoPayment {

    private static final String MOMO_API_ENDPOINT = "https://test-payment.momo.vn/v3/gateway/api/create";
    private static final String PARTNER_CODE = "MOMO5SKY20200902";
    private static final String ACCESS_KEY = "F8590000000000000000";
    private static final String SECRET_KEY = "K951B6PE1waDMi640xQKv2QKPDlrCKO8";

    private static final String BANK_ACCOUNT = "0123456789";
    private static final String BANK_NUMBER = "970418";

    public String generateQRCode(int amount, String orderId) {
        try {
            long requestId = System.currentTimeMillis();
            String extraData = "bookingId=" + orderId;
            String orderInfo = "Thanh toan dat xe - Booking #" + orderId;
            String ipnUrl = "https://your-domain.com/payment-callback";
            String redirectUrl = "https://your-domain.com/payment-success?bookingId=" + orderId;

            JsonObject requestBody = new JsonObject();
            requestBody.addProperty("partnerCode", PARTNER_CODE);
            requestBody.addProperty("partnerName", "Auto Cars");
            requestBody.addProperty("storeId", "MomoStore");
            requestBody.addProperty("requestId", requestId);
            requestBody.addProperty("amount", amount);
            requestBody.addProperty("orderId", "AUTO_" + orderId + "_" + requestId);
            requestBody.addProperty("orderInfo", orderInfo);
            requestBody.addProperty("redirectUrl", redirectUrl);
            requestBody.addProperty("ipnUrl", ipnUrl);
            requestBody.addProperty("lang", "vi");
            requestBody.addProperty("autoCapture", true);
            requestBody.addProperty("extraData", encodeToBase64(extraData));

            String rawSignature = "accessKey=" + ACCESS_KEY + "&amount=" + amount +
                    "&extraData=" + encodeToBase64(extraData) +
                    "&ipnUrl=" + ipnUrl +
                    "&orderId=" + requestBody.get("orderId").getAsString() +
                    "&orderInfo=" + orderInfo +
                    "&partnerCode=" + PARTNER_CODE +
                    "&redirectUrl=" + redirectUrl +
                    "&requestId=" + requestId +
                    "&storeId=MomoStore";

            String signature = generateSignature(rawSignature, SECRET_KEY);
            requestBody.addProperty("signature", signature);

            return callMoMoAPI(requestBody.toString());

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private String callMoMoAPI(String requestBodyStr) {
        try {
            URL url = new URL(MOMO_API_ENDPOINT);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", "application/json");
            connection.setDoOutput(true);

            byte[] postData = requestBodyStr.getBytes(StandardCharsets.UTF_8);
            connection.setFixedLengthStreamingMode(postData.length);

            try (OutputStream os = connection.getOutputStream()) {
                os.write(postData);
            }

            int responseCode = connection.getResponseCode();
            String responseBody;

            if (responseCode >= 200 && responseCode < 300) {
                try (Scanner scanner = new Scanner(connection.getInputStream())) {
                    responseBody = scanner.useDelimiter("\\A").hasNext() ? scanner.next() : "";
                }
            } else {
                try (Scanner scanner = new Scanner(connection.getErrorStream())) {
                    responseBody = scanner.useDelimiter("\\A").hasNext() ? scanner.next() : "";
                }
            }

            connection.disconnect();

            Gson gson = new Gson();
            JsonObject responseJson = gson.fromJson(responseBody, JsonObject.class);

            if (responseJson.has("payUrl")) {
                return responseJson.get("payUrl").getAsString();
            } else if (responseJson.has("qrCodeUrl")) {
                return responseJson.get("qrCodeUrl").getAsString();
            }

            return generateQRCodeLocal(responseJson.get("orderId").getAsString());

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private String generateQRCodeLocal(String orderId) {
        return "https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=MoMo|" + orderId;
    }

    private String generateSignature(String data, String key) throws Exception {
        Mac hmacSha256 = Mac.getInstance("HmacSHA256");
        SecretKeySpec secretKeySpec = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
        hmacSha256.init(secretKeySpec);
        byte[] hash = hmacSha256.doFinal(data.getBytes(StandardCharsets.UTF_8));

        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) hexString.append('0');
            hexString.append(hex);
        }
        return hexString.toString();
    }

    private String encodeToBase64(String data) {
        return java.util.Base64.getEncoder().encodeToString(data.getBytes(StandardCharsets.UTF_8));
    }

    public String getBankAccount() {
        return BANK_ACCOUNT;
    }

    public String getBankNumber() {
        return BANK_NUMBER;
    }

    public boolean verifyCallback(String signature, String data) {
        try {
            String calculatedSignature = generateSignature(data, SECRET_KEY);
            return calculatedSignature.equals(signature);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
