<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>DTHENG | bitcoin</title>
        <link href="/static/css/foundation.min.css" rel="stylesheet" media="screen">
        <link href="/static/css/normalize.css" rel="stylesheet" media="screen">
        <link href="/static/css/bitcoin.css" rel="stylesheet" media="screen">
        <script src="/static/js/vendor/modernizr.js"></script>
        <script src="/static/js/vendor/custom.modernizr.js"></script>
    </head>
    <body>
        <div id="init" class="page hide">

            <!-- START FORM HEADER -->
            <div class="row">
                <div class="small-4 medium-3 columns hide-for-small">
                    &#160;
                </div>
                <div class="small-12 medium-6 large-4 columns">
                    <div class="row">
                        <div class="start_payment_title small-12 columns">
                            <h1>&#160;</h1>
                            <h4>start a new payment</h4>
                            <h1>&#160;</h1>
                        </div>
                    </div>
                </div>
                <div class="small-4 medium-3 columns hide-for-small">
                    &#160;
                </div>
            </div>

            <!-- START FORM -->
            <div class="row">
                <div class="small-4 medium-3 columns hide-for-small">
                    &#160;
                </div>
                <div class="small-10 medium-5 large-3 columns">

                    <div class="row">
                        <div class="small-12 columns">
                            <p class="start_form_amount_label">amount</p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="small-12 columns">
                            <input type="text" placeholder="100.00" id="amount"/>
                        </div>
                    </div>
                </div>
                <div class="small-2 medium-1 large-1 columns">
                    <p class="start_form_currency_label">USD</p>
                </div>
                <div class="small-4 medium-3 columns hide-for-small">
                    &#160;
                </div>
            </div>

            <!-- START FORM SUBMIT -->
            <div class="row">
                <div class="small-4 medium-3 columns hide-for-small">
                    &#160;
                </div>
                <div class="start_form_button_wrap small-12 medium-6 large-4 columns">
                    <a id="createInvoice" class="button expand success" onclick="window.BitCoin.create($('#amount').val());">start</a>
                </div>
                <div class="small-4 medium-3 columns hide-for-small">
                    &#160;
                </div>
            </div>
        </div>

        <div id="view" class="page hide">

            <!-- INVOICE HEADER -->
            <div class="row">
                <div class="small-3 medium-2 columns hide-for-small">
                    &#160;
                </div>
                <div class="invoice_header small-12 medium-8 large-6 columns">
                    <h1><span id="price"></span> USD</h1>
                    <h4 class="btcPrice"><span id="btcPrice"></span> BTC</h4>
                    <h4 id="partial_payment" class="btcPaid"></h4>
                </div>
                <div class="small-3 medium-2 columns hide-for-small">
                    &#160;
                </div>
            </div>

            <!-- QR CODE -->
            <div class="row">
                <div class="small-4 medium-3 columns hide-for-small">
                    &#160;
                </div>
                <div class="invoice_qr small-12 medium-6 large-4 columns">
                    <img id="qr" src="http://placehold.it/500x500"/>
                </div>
                <div class="small-4 medium-3 columns hide-for-small">
                    &#160;
                </div>
            </div>

            <!-- INVOICE STATUS -->
            <div class="row">
                <div class="small-3 medium-2 columns hide-for-small">
                    &#160;
                </div>
                <div class="invoice_status small-12 medium-8 large-6 columns">
                    <h4 id="status"></h4>
                </div>
                <div class="small-3 medium-2 columns hide-for-small">
                    &#160;
                </div>
            </div>

            <!-- STATUS BAR -->
            <div class="row">
                <div class="small-3 medium-2 columns hide-for-small">
                    &#160;
                </div>
                <div class="invoice_bar small-12 medium-8 large-6 columns">
                    <hr id="status_color"/>
                </div>
                <div class="small-3 medium-2 columns hide-for-small">
                    &#160;
                </div>
            </div>

            <!-- INVOICE INFO -->
            <div class="row">
                <div class="small-3 medium-2 columns hide-for-small">
                    &#160;
                </div>
                <div class="invoice_info small-12 medium-8 large-6 columns">
                    <p class="address">
                        <a id="link" target="_blank" onclick="_gaq.push(['_trackEvent', 'BitCoin', 'Links', 'Address']);">
                            <span id="address"></span>
                        </a>
                    </p>
                    <p class="exchange_rate"><span id="rate"></span> USD = 1 BTC</p>
                    <p id="expMsg" class="expiration">expires in <span id="expirationTime"></span></p>
                </div>
                <div class="small-3 medium-2 columns hide-for-small">
                    &#160;
                </div>
            </div>

            <!-- REFRESH & RESTART BUTTONS -->
            <div class="row">
                <div class="small-3 medium-2 columns hide-for-small">
                    &#160;
                </div>
                <div class="small-6 medium-4 large-3 columns">
                    <a id="refresh" onclick="window.BitCoin.refresh(true);" class="button secondary">refresh</a>
                    <a id="newPayment" onclick="window.BitCoin.reset();" class="newPayment button success">start a new payment</a>
                </div>
                <div class="small-3 medium-2 columns hide-for-small">
                    &#160;
                </div>
            </div>

            <!-- FOOTER -->
            <h1>&#160;</h1>
            <h1 class="hide-for-small">&#160;</h1>
        </div>
        <script src="/static/js/vendor/jquery.js"></script>
        <script src="/static/js/bitcoin.js"></script>
        <script src="/static/js/vendor/foundation.min.js"></script>
        <script src="/static/js/vendor/fastclick.js"></script>
        <script src="/static/js/vendor/placeholder.js"></script>
        <script src="/static/js/vendor/jquery.autocomplete.js"></script>
        <script src="/static/js/vendor/jquery.cookie.js"></script>
        <script type="text/javascript">
            var _gaq = _gaq || [];
            _gaq.push(['_setAccount', 'UA-18339357-1']);
            _gaq.push(['_trackPageview']);
            (function() {
                var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
                ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
                var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
            })();
        </script>
    </body>
</html>