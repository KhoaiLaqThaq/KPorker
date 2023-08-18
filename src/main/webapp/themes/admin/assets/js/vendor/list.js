const VendorComponent = function() {

    const setModalData = function(vendor) {
        let nccCode = $('#ncc_code');
        let nccName = $('#ncc_name');
        let nccTaxNumber = $('#ncc_taxNumber');
        let nccAddress = $('#ncc_address');

        if (vendor) {
            nccCode.text(vendor.code);
            nccName.text(vendor.name);
            nccTaxNumber.text(vendor.taxNumber);
            nccAddress.text(vendor.street + " " + vendor.district + "" + vendor.city);
        } else {
            nccCode.text('');
            nccName.text('');
            nccTaxNumber.text('');
            nccAddress.text('');
        }
    }

    const _eventShowVendorDetail = function() {
        $('.show_detail').on('click', function() {
            let id = this.id;
            $.ajax({
                url: `${getContext()}/api/getVendorByCode/${id}`,
                method: 'GET',
                contentType: 'application/json',
                success: function(response) {
                    if (response) {
                        setModalData(response);
                    }
                }, error: function(err) {
                    console.log("error:", err);
                }
            });
        });
    }

    const _eventToSyncVendorFromSAP = function() {
        $('#btnSyncVendorFromSAP').on('click', function() {
            showLoading();
            $.ajax({
                url: `${getContext()}/api/vendor/syncFromSAP`,
                method: 'GET',
                success: function(response) {
                    if (response) {
                        bootbox.alert({
                            title: 'Thông báo',
                            message: response
                        })
                    }
                }, error: function(err) {
                    console.log(err);
                }
            }).always(() => hideLoading());
        });
    }

    const showLoading = () => $('#modalLoading').addClass('d-block').removeClass('d-none');
    const hideLoading = () => $('#modalLoading').addClass('d-none').removeClass('d-block');

    return {
        init: function() {
            _eventToSyncVendorFromSAP();
            _eventShowVendorDetail();
        }
    }
}();

document.addEventListener('DOMContentLoaded', function() {
    VendorComponent.init();
})
