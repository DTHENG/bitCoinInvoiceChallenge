#!/bin/bash
curl -XGET https://bitpay.com/api/invoice/$1 -u $2
$3
