package service;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import config.ConfigAPIKey;
import java.io.IOException;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;
import model.GoogleAccount;

public class GoogleLogin {

    public static String getToken(String code) throws ClientProtocolException, IOException {
        String response = Request.Post(ConfigAPIKey.getProperty("google.token.url"))
                .bodyForm(
                        Form.form()
                                .add("client_id", ConfigAPIKey.getProperty("google.client.id"))
                                .add("client_secret", ConfigAPIKey.getProperty("google.client.secret"))
                                .add("redirect_uri", ConfigAPIKey.getProperty("google.redirect.uri"))
                                .add("code", code)
                                .add("grant_type", ConfigAPIKey.getProperty("google.grant.type"))
                                .build()
                )
                .execute().returnContent().asString();

        JsonObject jobj = new Gson().fromJson(response, JsonObject.class);
        String accessToken = jobj.get("access_token").toString().replaceAll("\"", "");
        return accessToken;
    }

    public static GoogleAccount getUserInfo(final String accessToken) throws ClientProtocolException, IOException {
        String link = ConfigAPIKey.getProperty("google.userinfo.url") + accessToken;
        String response = Request.Get(link).execute().returnContent().asString();
        GoogleAccount googlePojo = new Gson().fromJson(response, GoogleAccount.class);
        return googlePojo;
    }
}