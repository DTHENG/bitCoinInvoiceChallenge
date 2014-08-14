package com.dtheng.bitcoin.model;

import org.json.JSONException;
import org.json.simple.JSONObject;

/**
 * 
 * @author Chaz Ferguson
 * @date 11.11.2013
 *
 */
public class Invoice {
	private String id;
	private String url;
	private String status;
	private String btcPrice;
	private String price;
	private String currency;
    private long currentTime;
    private double rate;
    private boolean exceptionStatus;
    private long expirationTime;
    private String btcPaid;
    private long invoiceTime;
	
	public Invoice(JSONObject finalResult) throws JSONException{

		this.id = (String) finalResult.get("id");
		this.url = (String) finalResult.get("url");
		this.status = (String) finalResult.get("status");
		this.btcPrice = (String) finalResult.get("btcPrice");
		this.price = finalResult.get("price").toString();
		this.currency = (String) finalResult.get("currency");
        this.currentTime = Long.parseLong(finalResult.get("currentTime").toString());
        this.rate = Double.parseDouble(finalResult.get("rate").toString());
        this.exceptionStatus = Boolean.parseBoolean(finalResult.get("exceptionStatus").toString());
        this.expirationTime = Long.parseLong(finalResult.get("expirationTime").toString());
        this.btcPaid = finalResult.get("btcPaid").toString();
        this.invoiceTime = Long.parseLong(finalResult.get("invoiceTime").toString());


	}
	
	public String getId() {
		return id;
	}

	public String getUrl() {
		return url;
	}

	public String getStatus() {
		return status;
	}

	public String getBtcPrice() {
		return this.btcPrice;
	}

	public double getPrice() {
		double val = Double.parseDouble(this.price);
		return val;
	}

	public String getCurrency() {
		return currency;
	}

    public long getCurrentTime() { return currentTime; }

    public double getRate() { return rate; }

    public boolean hasExceptionStatus() {
        return exceptionStatus;
    }

    public long getExpirationTime() { return expirationTime; }

    public String getBtcPaid() { return btcPaid; }

    public long getInvoiceTime() { return invoiceTime; }

}
