package com.dtheng.bitcoin.core;

import com.dtheng.bitcoin.model.BitPayResponse;
import com.dtheng.bitcoin.util.ShellUtil;
import com.dtheng.bitcoin.util.WebUtil;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.logging.Logger;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
* @author Daniel Thengvall
*/
public class Servlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(Servlet.class.getSimpleName());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {

        // do something here

        // then redirect to the homepage
        res.sendRedirect(WebUtil.buildUrl(req, "/"));
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {

        System.out.println("doPost");
        if (req.getParameterMap().containsKey("create")) {
            System.out.println("doPost create");
            System.out.println("doPost value : "+ req.getParameter("value"));
            System.out.println("doPost access_token : "+ Config.getProperty("bitpay_access_token"));
            System.out.println("doPost password : "+ Config.getProperty("bitpay_password"));


            BufferedReader in = new BufferedReader(new InputStreamReader(
                    ShellUtil.getNewProcess("new.sh",
                            req.getParameter("value"),
                            Config.getProperty("bitpay_access_token"),
                            Config.getProperty("bitpay_password")).getInputStream()));
            String inputLine;
            StringBuilder resp = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                System.out.println(inputLine);
                resp.append(inputLine);
            }
            in.close();

            Gson gson = new Gson();
            BitPayResponse response = gson.fromJson(resp.toString(), new TypeToken<BitPayResponse>() {}.getType());

            Document url = Jsoup.connect(response.url).get();

            for (Element elm : url.select("a")) {

                if (elm.attr("href").toString().contains("bitcoin:")) {
                    String href = elm.attr("href");
                    System.out.println(href);
                    response.address = href.substring(href.indexOf(":") +1, href.indexOf("?"));
                    break;
                }
            }

            if (!response.exceptionStatus) {
                res.getWriter().write(gson.toJson(response));
                res.setContentType("application/json");
                return;
            }
            return;
        }

        if (req.getParameterMap().containsKey("id")) {
            System.out.println("doPost id");
            BufferedReader in = new BufferedReader(
                    new InputStreamReader(ShellUtil.getNewProcess("status.sh",
                            req.getParameter("id"),
                            Config.getProperty("bitpay_access_token"),
                            Config.getProperty("bitpay_password")).getInputStream()));
            String inputLine;
            StringBuilder resp = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                System.out.println(inputLine);
                resp.append(inputLine);
            }
            in.close();

            Gson gson = new Gson();
            BitPayResponse response = gson.fromJson(resp.toString(), new TypeToken<BitPayResponse>(){}.getType());

            Document url = Jsoup.connect(response.url).get();

            for (Element elm : url.select("a")) {

                if (elm.attr("href").toString().contains("bitcoin:")) {
                    String href = elm.attr("href");
                    System.out.println(href);

                    response.address = href.substring(href.indexOf(":") +1, href.indexOf("?"));
                    break;
                }
            }

            if (!response.exceptionStatus) {
                res.getWriter().write(gson.toJson(response));
                res.setContentType("application/json");
                return;
            }

        }
        //res.sendRedirect(WebUtil.buildUrl(req, "/"));
    }
}
