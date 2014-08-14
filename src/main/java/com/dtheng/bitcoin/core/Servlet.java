package com.dtheng.bitcoin.core;

import com.dtheng.bitcoin.model.BitPay;
import com.dtheng.bitcoin.model.BitPayResponse;
import com.dtheng.bitcoin.model.Invoice;
import com.dtheng.bitcoin.util.WebUtil;
import com.google.gson.Gson;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;

import java.io.IOException;
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

        BitPay bitpay = new BitPay(Config.getProperty("bitpay_access_token"), "USD");

        if (req.getParameterMap().containsKey("create")) {

            Invoice invoice = bitpay.createInvoice(Double.parseDouble(req.getParameter("value")));

            BitPayResponse response = new BitPayResponse();

            response.btcPrice = invoice.getBtcPrice();
            response.status = invoice.getStatus();
            response.price = invoice.getPrice();
            response.currency = invoice.getCurrency();
            response.url = invoice.getUrl();
            response.currentTime = invoice.getCurrentTime();
            response.rate = invoice.getRate();
            response.exceptionStatus = invoice.hasExceptionStatus();
            response.expirationTime = invoice.getExpirationTime();
            response.btcPaid = invoice.getBtcPaid();
            response.invoiceTime = invoice.getInvoiceTime();
            response.id = invoice.getId();

            Document url = Jsoup.connect(response.url).get();

            for (Element elm : url.select("a")) {

                if (elm.attr("href").toString().contains("bitcoin:")) {
                    String href = elm.attr("href");
                    response.address = href.substring(href.indexOf(":") +1, href.indexOf("?"));
                    break;
                }
            }

            if ( ! response.exceptionStatus) {
                res.getWriter().write(new Gson().toJson(response));
                res.setContentType("application/json");
                return;
            }
            return;
        }

        String id = req.getParameter("id");

        if (id != null) {
            Invoice invoice = bitpay.getInvoice(id);

            BitPayResponse response = new BitPayResponse();

            response.btcPrice = invoice.getBtcPrice();
            response.status = invoice.getStatus();
            response.price = invoice.getPrice();
            response.currency = invoice.getCurrency();
            response.url = invoice.getUrl();
            response.currentTime = invoice.getCurrentTime();
            response.rate = invoice.getRate();
            response.exceptionStatus = invoice.hasExceptionStatus();
            response.expirationTime = invoice.getExpirationTime();
            response.btcPaid = invoice.getBtcPaid();
            response.invoiceTime = invoice.getInvoiceTime();
            response.id = invoice.getId();

            Document url = Jsoup.connect(response.url).get();

            for (Element elm : url.select("a")) {

                if (elm.attr("href").toString().contains("bitcoin:")) {
                    String href = elm.attr("href");

                    response.address = href.substring(href.indexOf(":") + 1, href.indexOf("?"));
                    break;
                }
            }

            if (!response.exceptionStatus) {
                res.getWriter().write(new Gson().toJson(response));
                res.setContentType("application/json");
                return;
            }
        }


        //res.sendRedirect(WebUtil.buildUrl(req, "/"));
    }
}
