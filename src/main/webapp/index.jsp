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
            <div class="row">
                <div class="small-4 medium-3 columns hide-for-small">
                    &#160;
                </div>
                <div class="small-12 medium-6 large-4 columns">
                    <div class="row">
                        <div class="small-12 columns" style="text-align: center">
                            <h1>&#160;</h1>
                            <h4 style="font-weight:500">start a new payment</h4>
                            <h1>&#160;</h1>
                        </div>
                    </div>
                </div>
                <div class="small-4 medium-3 columns hide-for-small">
                    &#160;
                </div>
            </div>
            <div class="row">
                <div class="small-4 medium-3 columns hide-for-small">
                    &#160;
                </div>
                <div class="small-10 medium-5 large-3 columns">

                    <div class="row">
                        <div class="small-12 columns">
                            <p style="margin-bottom:4px;">amount</p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="small-12 columns">
                            <input type="text" placeholder="100.00" id="amount"/>
                        </div>
                    </div>
                </div>
                <div class="small-2 medium-1 large-1 columns">
                    <p style="padding-top:35px;">USD</p>
                </div>
                <div class="small-4 medium-3 columns hide-for-small">
                    &#160;
                </div>
            </div>
            <div class="row">
                <div class="small-4 medium-3 columns hide-for-small">
                    &#160;
                </div>
                <div class="small-12 medium-6 large-4 columns" style="padding-top:10px;">
                    <a id="createInvoice" class="button expand success" onclick="window.BitCoin.create($('#amount').val());_gaq.push(['_trackEvent', 'BitCoin', 'Links', 'Start']);">start</a>
                </div>
                <div class="small-4 medium-3 columns hide-for-small">
                    &#160;
                </div>
            </div>
        </div>

        <div id="view" class="page hide">
            <div class="row">
                <div class="small-3 medium-2 columns hide-for-small">
                    &#160;
                </div>
                <div class="small-12 medium-8 large-6 columns" style="text-align: center;">
                    <h1 style="font-size:60px;font-weight:200;margin-bottom:0;"><span id="price"></span> USD</h1>
                    <h4 style="font-weight:500"><span id="btcPrice"></span> BTC</h4>
                    <h4 id="partial_payment" style="width:100%;min-height:40px;color:#aaa;font-weight:500"></h4>
                </div>
                <div class="small-3 medium-2 columns hide-for-small">
                    &#160;
                </div>
            </div>
            <div class="row">
                <div class="small-4 medium-3 columns hide-for-small">
                    &#160;
                </div>
                <div class="small-12 medium-6 large-4 columns" style="padding-left:20px;padding-right:20px;">
                    <img id="qr" src="http://placehold.it/500x500" style="width:100%;min-height:293px;background:#F7F7F7"/>
                </div>
                <div class="small-4 medium-3 columns hide-for-small">
                    &#160;
                </div>
            </div>
            <div class="row">
                <div class="small-3 medium-2 columns hide-for-small">
                    &#160;
                </div>
                <div class="small-12 medium-8 large-6 columns" style="text-align: center;padding-top:50px;">
                    <h4 style="font-weight:500" id="status"></h4>
                </div>
                <div class="small-3 medium-2 columns hide-for-small">
                    &#160;
                </div>
            </div>

            <div class="row">
                <div class="small-3 medium-2 columns hide-for-small">
                    &#160;
                </div>
                <div class="small-12 medium-8 large-6 columns">
                    <hr id="status_color" style="border-width:2px 0 0 0;"/>
                </div>
                <div class="small-3 medium-2 columns hide-for-small">
                    &#160;
                </div>
            </div>

            <div class="row">
                <div class="small-3 medium-2 columns hide-for-small">
                    &#160;
                </div>
                <div class="small-12 medium-8 large-6 columns" style="padding-top:20px;padding-bottom:60px">
                    <p style="margin:5px 0;"><a id="link" target="_blank" onclick="_gaq.push(['_trackEvent', 'BitCoin', 'Links', 'Address']);"><span id="address"></span></a></p>
                    <p style="margin:5px 0;color:#aaa;"><span id="rate"></span> USD = 1 BTC</p>
                    <p id="expMsg" style="margin:5px 0;color:#aaa;">expires in <span id="expirationTime"></span></p>
                </div>
                <div class="small-3 medium-2 columns hide-for-small">
                    &#160;
                </div>
            </div>
            <div class="row">
                <div class="small-3 medium-2 columns hide-for-small">
                    &#160;
                </div>
                <div class="small-6 medium-4 large-3 columns">
                    <a id="refresh" onclick="window.BitCoin.refresh(true);" class="button secondary">refresh</a>
                    <a id="newPayment" onclick="window.BitCoin.reset();_gaq.push(['_trackEvent', 'BitCoin', 'Links', 'Start New Payment']);" class="button success " style="display:none">start a new payment</a>
                </div>
                <div class="small-3 medium-2 columns hide-for-small">
                    &#160;
                </div>
            </div>

            <h1>&#160;</h1>
            <h1 class="hide-for-small">&#160;</h1>

            <!--<div class="row">
                <div class="small-12 columns">

                        <div class="panel">
                            <h4 id="btcPaid"></h4>
                            <h4 id="currency"></h4>
                            <h4 id="currentTime"></h4>
                        </div>

                </div>
            </div>-->
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
