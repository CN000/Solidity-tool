//https://bulksender.phizhub.com/static/js/main_ex.js
function show_approve_alert() {
    var selfVue = vm;
    var total_amount = selfVue.upload_info.total_amount;
    var title = selfVue.language.sendInfo_page.approve_alert_title + selfVue.item.name;
    var cancelText = selfVue.language.button_cancel_title;
    var approveText = selfVue.language.button_approve_title;
    var approveFiledText = selfVue.language.sendInfo_page.approve_alert_amount_title;


    const ModalForm_Approve = {
        props: ['approve_amount'],
        methods: {
            approve_submit: function () {
                show_warning_info('Please open Metamasksend and sign the approve transaction in Metamasksend');
                $('#close').click();
                var amount = $("#approveAmount").val();
                selfVue.reset_amount = false;
                selfVue.approve_token(amount);
            }
        },
        mounted: function () {
            $("#approveAmount").focus();

        },
        template:
            '<div class="modal-card container">' +
            '<header class="modal-card-head">' +
            '<p class="title is-5">' + title + '</p>' +
            '</header>' +
            '<section class="modal-card-body">' +
            '<b-field label="' + approveFiledText + '">' +
            '<b-input type="text" name = "approveAmount" id="approveAmount" min="0" placeholder="" size="is-medium" value = "' + total_amount + '"  required></b-input>' +
            '</b-field>' +
            '</section>' +
            '<footer class="modal-card-foot">' +
            '<div class="field is-grouped ">' +
            '<button class="button is-rounded" id="close" type="button" @click="$parent.close()">' + cancelText + '</button>' +
            '<p class="control"></p>' +
            '<p class="control"></p>' +
            '<button id = "loginBtn" class="button is-info is-rounded" @click="approve_submit()">' + approveText + '</button>' +
            '</div>' +
            '</footer>' +
            '</div>'
    };
    selfVue.$modal.open({
        parent: selfVue,
        component: ModalForm_Approve,
        hasModalCard: true
    });

}

function dup_radio_clicked(value) {
    var selfVue = vm;
    selfVue.dup_option_combine = value;
    if (value == 0) {
        if (selfVue.upload_info.dup_address.length > 0 && selfVue.upload_info.invalid_address.length > 0) {
            $("#address_check_alert_bottom_text").html(selfVue.language.error.address_fix_error_tip);
        } else {
            $("#address_check_alert_bottom_text").html(selfVue.language.error.address_fix_dup_error_tip);
        }
    } else if (value == 1) {
        if (selfVue.upload_info.dup_address.length > 0 && selfVue.upload_info.invalid_address.length > 0) {
            $("#address_check_alert_bottom_text").html(selfVue.language.error.address_fix_dup_combine_and_invalid_error_tip);
        } else {
            $("#address_check_alert_bottom_text").html(selfVue.language.error.address_fix_dup_combine_error_tip);
        }
    }
}

function show_warning_info(msg) {
    vm.$toast.open({
        message: msg,
        type: 'is-info',
        duration: 3000
    });

}

function show_success_info(msg) {
    vm.$toast.open({
        message: msg,
        type: 'is-success',
        duration: 3000

    });
}

function show_error_info(msg) {
    vm.$toast.open({
        message: msg,
        type: 'is-danger',
        duration: 3000

    });
}


function show_confirm_alert(message, type, confirmText, cancelText, confirmCallback) {
    var selfVue = vm;

    selfVue.$dialog.confirm({
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        type: type,
        onConfirm: function () {
            confirmCallback();

        }
    });

}


function error_alert(message) {
    vm.$dialog.alert({
        message: message,
        confirmText: vm.language.button_Got_title,
        type: "is-info"
    });
}

function show_alert(message, type, confirmText) {
    vm.$dialog.alert({
        message: message,
        confirmText: confirmText,
        type: type
    });
}

function get_tx_status(tx_hash, callback) {
    var tx_status = 0;
    web3.eth.getTransactionReceipt(tx_hash, function (error, res) {
        if (res && res.blockNumber) {
            if (res.status === '0x1') {
                tx_status = 1;
            } else {
                //`Mined but with errors. Perhaps out of gas`
                tx_status = -2;
            }
        }
        callback(tx_status)
    });

}

function registerVIP() {
    if (vm.tobe_vip_loading) {
        window.open(vm.register_txhash_url, '_blank');
    } else {
        show_confirm_alert(
            vm.language.vip_info_text, "is-info",
            vm.language.button_done_title,
            vm.language.button_cancel_title,
            function () {
                vm.registerVIP();

            });
    }

}

(function () {
    var burger = document.querySelector('.burger');
    var menu = document.querySelector('#' + burger.dataset.target);
    burger.addEventListener('click', function () {
        burger.classList.toggle('is-active');
        menu.classList.toggle('is-active');
    });
})();

