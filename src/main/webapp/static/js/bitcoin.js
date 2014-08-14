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
            function calcStatusColor(invoice) {
                switch (invoice.status) {
                    case "awaiting payment":
                        return "#008cba";
                    case "paid":
                        return "#43ac6a";
                    case "expired":
                        return "#f00";
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

            if (resp.status === "expired") {
                $("#expMsg").addClass("hide");
                $("#refresh").css("display","none");
                $("#newPayment").css("display","block");
            }

            window.BitCoin.state = "view";
        },

        create: function (amt) {
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
            this.invoice = null;
            this.refresh(false);
            $("#description").focus();
        },

        refresh: function (manual) {

            if (manual) $("#refresh").addClass("disabled");
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
                                if (objToUpdate.attr("src") !== newValue) {
                                    objToUpdate.attr("src", newValue);
                                }
                                break;
                            case "status_color":
                                if (objToUpdate.css("border-color") !== newValue) {
                                    objToUpdate.css("border-color", newValue);
                                }
                                break;
                            case "link":
                                if (objToUpdate.attr("href") !== newValue) {
                                    objToUpdate.attr("href", newValue);
                                }
                                break;
                            default:
                                if (objToUpdate.html() !== newValue) {
                                    objToUpdate.html(newValue);
                                }
                        }
                    }

                    $.post("/api",{id: window.BitCoin.invoice.id},
                        function (resp, status) {
                            if (status === "success") {
                                window.BitCoin.setInvoice(resp);
                            }
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
    });

})(window.jQuery, window, document);