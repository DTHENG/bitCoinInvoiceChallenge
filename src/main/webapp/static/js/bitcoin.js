(function($, window, document){

    "use strict";

    window.BitCoin = {

        invoice: null,

        state: "init",

        setInvoice: function (resp) {

            function calcUrl(invoice) {
                return "bitcoin:"+ invoice.address +"?amount="+ invoice.btcPrice;
            }
            function calcQr(invoice) {
                return "https://api.qrserver.com/v1/create-qr-code/?size=1000x1000&data="+ calcUrl(invoice);
            }
            function calcStatus(invoice) {
                switch (invoice.status) {
                    case "new":
                        return "awaiting payment";
                    default:
                        return invoice.status;
                }
            }
            // depreciated
            function calcStatusColor(invoice) {
                switch (invoice.status) {
                    default:
                        return "#aaa";
                }
            }
            window.BitCoin.invoice = resp;
            window.BitCoin.invoice.qr = calcQr(resp);
            window.BitCoin.invoice.status = calcStatus(resp);
            window.BitCoin.invoice.status_color = calcStatusColor(resp);
            window.BitCoin.invoice.link = calcUrl(resp);
            window.BitCoin.invoice.partial_payment = Number(resp.btcPaid) == 0 ? "" : "you paid "+ resp.btcPaid +" BTC";
            if (resp.currentTime < resp.expirationTime) {
                var minutes = Math.floor(((resp.expirationTime - resp.currentTime) / 1000) / 60);
                if (minutes == 0) {
                    window.BitCoin.invoice.expirationTime = "less than a minute";
                } else {
                    window.BitCoin.invoice.expirationTime = minutes + " minute" + (minutes != 1 ? "s" : "");
                }
            }
            switch (resp.status) {
                case "expired":
                case "paid":
                    $("#expMsg").addClass("hide");
                    $("#refresh").css("display","none");
                    $("#newPayment").css("display","block");
            }
            window.BitCoin.state = "view";
        },

        create: function (amt) {
            _gaq.push(['_trackEvent', 'BitCoin', 'Links', 'Start']);
            if (amt === "" || isNaN(amt)) {
                window.alert("please enter an amount");
                $("#amount").focus().select();
                return;
            }
            $("#createInvoice").addClass("disabled");
            $.post("/api?create", {value: amt}, function (resp, status) {
                if (status !== "success") return;
                if (resp.error) {
                    switch (resp.error.type) {
                        case "limitExceeded":
                            window.alert("you're very generous but I cannot accept an amount that large");
                            $("#amount").focus().select();
                            break;
                        case "ratesUnavailable":
                            window.alert("there was an error determining the bitcoin rate for that amount, try a smaller amount");
                            $("#amount").focus().select();
                            break;
                        default:
                            window.alert("an unknown error '"+ resp.error.type +"' has occurred");
                    }
                    $("#createInvoice").removeClass("disabled");
                    return;
                }
                window.BitCoin.setInvoice(resp);
                window.BitCoin.refresh(false);
                $("#createInvoice").removeClass("disabled");
                $("#amount").val("");
            });
        },

        get: function () {
            return this.invoice;
        },

        reset: function () {
            _gaq.push(['_trackEvent', 'BitCoin', 'Links', 'Start New Payment']);
            this.invoice = null;
            this.state = "init";
            this.refresh(false);
            $("#amount").focus();
            $("#expMsg").removeClass("hide");
            $("#refresh").css("display","block");
            $("#newPayment").css("display","none");
        },

        refresh: function (manual) {
            if (manual) {
                $("#refresh").addClass("disabled");
                _gaq.push(['_trackEvent', 'BitCoin', 'Links', 'Refresh']);
            }
            var pages = $(".page");
            var currentState = window.BitCoin.state;
            switch (currentState) {
                case "view":

                    var invoice = window.BitCoin.invoice;

                    if (invoice == null) {
                        window.BitCoin.state = "init";
                        currentState = "init";
                        break;
                    }
                    for (var attr in invoice) {

                        var newValue = "";
                        switch (attr) {
                            case "btcPrice":
                                newValue = invoice.btcPrice;
                                break;
                            case "price":
                                newValue = invoice.price.toFixed(2);
                                break;
                            default:

                                newValue = invoice[attr];
                        }

                        var objToUpdate = $("#" + attr);
                        switch (attr) {
                            case "qr":
                                if (window.BitCoin.invoice.status !== "awaiting payment") break;
                                if (objToUpdate.attr("src") === newValue) break;
                                if (newValue.indexOf("bitcoin:undefined") > 0) break;
                                objToUpdate.attr("src", newValue);
                                break;
                            case "status_color":
                                if (objToUpdate.css("border-color") == newValue) break;
                                $("body").attr("class",window.BitCoin.invoice.status);
                                break;
                            case "link":
                                if (objToUpdate.attr("href") === newValue) break;
                                objToUpdate.attr("href", newValue);
                                break;
                            default:
                                if (objToUpdate.html() === newValue) break;
                                objToUpdate.html(newValue);
                        }
                    }

                    $.post("/api",{id: window.BitCoin.invoice.id},
                        function (resp, status) {
                            if (status !== "success" &&
                                window.BitCoin.state !== "awaiting payment") return;
                            window.BitCoin.setInvoice(resp);
                        }
                    );
            }

            for (var i = 0; i < pages.length; i++) {
                if ($(pages[i]).attr("id") !== "#"+ currentState &&
                        ! $(pages[i]).hasClass("hide")) {
                    $(pages[i]).addClass("hide");
                }
            }

            var activePage = $("#"+ currentState);
            if (activePage.hasClass("hide")) {
                activePage.removeClass("hide");
            }

            window.setTimeout(function() {
                if (manual) $("#refresh").removeClass("disabled");
            }, 500);
        }

    };


    $(document).ready(function() {
        window.BitCoin.refresh(false);
        window.setInterval(window.BitCoin.refresh, 1000);
        switch (window.BitCoin.state) {
            case "init":
                $("#amount").focus();
                break;
        }
        $('#amount').keydown( function(e) {
            var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;
            if(key != 13) return;
            e.preventDefault();
            window.BitCoin.create($('#amount').val());
            _gaq.push(['_trackEvent', 'BitCoin', 'Links', 'Start']);
        });
    });

})(window.jQuery, window, document);