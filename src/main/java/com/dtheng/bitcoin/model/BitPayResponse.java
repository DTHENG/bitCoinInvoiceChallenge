package com.dtheng.bitcoin.model;

import java.io.Serializable;

/**
 * Created by danielthengvall on 8/12/14.
 */
public class BitPayResponse implements Serializable {
    public String btcPaid;
    public String btcPrice;
    public String currency;
    public long currentTime;
    public boolean exceptionStatus;
    public long expirationTime;
    public String id;
    public long invoiceTime;
    public double price;
    public double rate;
    public String status;
    public String url;
    public String address;
}
