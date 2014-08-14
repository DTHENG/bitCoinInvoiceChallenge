#!/bin/bash
curl https://bitpay.com/api/invoice -u $2 -d price=$1 -d currency=USD
$3