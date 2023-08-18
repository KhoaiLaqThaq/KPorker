const PURCHASING_GROUP_ENUM = {
    WEEK: 'Z1',
    MONTH: 'Z6'
};

const ReportPRComponent = function () {
    const contextPath = getContext();

    const _showModalProcessing = () => $('#modalLoading').addClass('d-block').removeClass('d-none');
    const _hideModalProcessing = () => $('#modalLoading').addClass('d-none').removeClass('d-block');

    const initDatePicker = function () {
        // toDate
        $('input[name="deliveryToDate"]').daterangepicker({
            singleDatePicker: true,
            autoUpdateInput: false,
            locale: {
                cancelLabel: 'Clear',
                format: 'DD/MM/YYYY'
            }
        });

        $('input[name="deliveryToDate"]').on('apply.daterangepicker', function (ev, picker) {
            $(this).val(picker.startDate.format('DD/MM/YYYY'));
        });

        $('input[name="deliveryToDate"]').on('cancel.daterangepicker', function (ev, picker) {
            $(this).val('');
        });

        // fromDate
        $('input[name="deliveryFromDate"]').daterangepicker({
            singleDatePicker: true,
            autoUpdateInput: false,
            locale: {
                cancelLabel: 'Clear',
                format: 'DD/MM/YYYY'
            }
        });

        $('input[name="deliveryFromDate"]').on('apply.daterangepicker', function (ev, picker) {
            $(this).val(picker.startDate.format('DD/MM/YYYY'));
        });

        $('input[name="deliveryFromDate"]').on('cancel.daterangepicker', function (ev, picker) {
            $(this).val('');
        });
    }

    const _checkStockCodeValue = function () {
        let stockCode = $('#stockSelect').val();
        if (stockCode || stockCode !== '') {
            return stockCode;
        }
        bootbox.alert({
            title: 'Thông báo',
            message: 'Vui lòng chọn trại.'
        });
        return '';
    }

    const _checkPrTypeSelect = function () {
        let prTypeSelect = $('#prTypeSelect').val();
        if (prTypeSelect || prTypeSelect !== '') {
            return prTypeSelect;
        }
        bootbox.alert({
            title: 'Thông báo',
            message: 'Vui lòng chọn loại dự trù.'
        });
        return '';
    }

    const _checkPurchasingGroupSelect = function () {
        let purchasingGroupSelect = $('#purchasingGroupSelect').val();
        if (purchasingGroupSelect || purchasingGroupSelect !== '') {
            return purchasingGroupSelect;
        }
        bootbox.alert({
            title: 'Thông báo',
            message: 'Vui lòng chọn nhóm dự trù.'
        });
        return '';
    }

    const _checkDeliveryFromDate = function() {
        let deliveryFromDate = $('#deliveryFromDate').val();
        if (deliveryFromDate || deliveryFromDate !== '') return deliveryFromDate;
        bootbox.alert({
            title: 'Thông báo',
            message: 'Vui lòng chọn ngày giao hàng.'
        });
        return '';
    }

    const _checkDeliveryToDate = function() {
        let deliveryToDate = $('#deliveryToDate').val();
        if (deliveryToDate || deliveryToDate !== '') return deliveryToDate;
        bootbox.alert({
            title: 'Thông báo',
            message: 'Vui lòng chọn ngày giao hàng.'
        });
        return '';
    }

    // TODO: convert date[] -> yyyy-MM-dd
    const _formatDate = function (date) {
        let month = parseInt(date[1]) < 10 ? '0' + date[1] : date[1];
        let day = parseInt(date[2]) < 10 ? '0' + date[2] : date[2];
        return date[0] + '-' + month + '-' + day;
    }

    // TODO: Loại dự trù tuần
    const _templateHeaderPrWeek = function () {
        let template = '<thead>';
        template += '<tr class="table-success">';
        template += '<th class="bgc-primary border-primary text-white">STT</th>';
        template += '<th class="bgc-primary border-primary text-white">Mã vật tư</th>';
        template += '<th class="bgc-primary border-primary text-white">Diễn giải</th>';
        template += '<th class="bgc-primary border-primary text-white">Số tồn</th>';
        template += '<th class="bgc-primary border-primary text-white">Đặt dự trù</th>';
        template += '<th class="bgc-primary border-primary text-white">Đơn vị tính</th>';
        template += '<th class="bgc-primary border-primary text-white">Ngày giao hàng</th>';
        template += '<th class="bgc-primary border-primary text-white">Thông số kỹ thuật</th>';
        template += '<th class="bgc-primary border-primary text-white">Ghi chú</th>';
        template += '</tr>';
        template += '</thead>';
        return template;
    }

    const _generateDataPrWeek = function (data) {
        if (data && data.results) {
            let results = data.results;
            let template = '<tbody>';
            for (let i = 0; i < results.length; i++) {
                const element = results[i];
                template += '<tr>';
                template += '<td>' + (i + 1) + '</td>';
                template += '<td>' + element.materialCode + '</td>';
                template += '<td>' + element.materialName + '</td>';
                template += '<td>' + element.retained + '</td>';
                template += '<td>' + element.quantity + '</td>';
                template += '<td>' + element.unit + '</td>';
                template += `<td>${element.deliveryDate != null ? _formatDate(element.deliveryDate) : ''}</td>`;
                template += '<td>' + element.description + '</td>';
                template += '<td>' + element.note + '</td>';
                template += '</tr>';
            }
            template += '</tbody>'
            return template;
        }
        return '';
    }

    // TODO: Loại dự trù tháng
    const _templateHeaderPrMonth = function () {

        let template = '<thead>';
        template += '<tr class="table-success">';
        template += '<th class="bgc-primary border-primary text-white">STT</th>';
        template += '<th class="bgc-primary border-primary text-white">Mã vật tư</th>';
        template += '<th class="bgc-primary border-primary text-white">Diễn giải</th>';
        template += '<th class="bgc-primary border-primary text-white">Tồn đầu</th>';
        template += '<th class="bgc-primary border-primary text-white">Tổng nhập</th>';
        template += '<th class="bgc-primary border-primary text-white">Tổng xuất</th>';
        template += '<th class="bgc-primary border-primary text-white">Tồn cuối</th>';
        template += '<th class="bgc-primary border-primary text-white">Đặt dự trù</th>';
        template += '<th class="bgc-primary border-primary text-white">Đơn vị tính</th>';
        template += '<th class="bgc-primary border-primary text-white">Ngày giao hàng</th>';
        template += '<th class="bgc-primary border-primary text-white">Thông số kỹ thuật</th>';
        template += '<th class="bgc-primary border-primary text-white">Ghi chú</th>';
        template += '</tr>';
        template += '</thead>';
        return template;
    }

    const _generateDataPrMonth = function (data) {
        if (data && data.results) {
            let results = data.results;
            let template = '<tbody>'

            for (let i = 0; i < results.length; i++) {
                const element = results[i];
                template += '<tr>';
                template += '<td>' + (i + 1) + '</td>';
                template += '<td>' + element.materialCode + '</td>';
                template += '<td>' + element.materialName + '</td>';
                template += '<td>' + element.amountEarlyStage + '</td>';
                template += '<td>' + element.amountGoodsReceipt + '</td>';
                template += '<td>' + element.amountGoodsAttrition + '</td>';
                template += '<td>' + element.amountFinalStage + '</td>';
                template += '<td>' + element.quantity + '</td>';
                template += '<td>' + element.unit + '</td>';
                template += `<td>${element.deliveryDate != null ? _formatDate(element.deliveryDate) : ''}</td>`;
                template += '<td>' + element.description + '</td>';
                template += '<td>' + element.note + '</td>';
                template += '</tr>';
            }
            template += '</tbody>'
            return template;
        }
        return '';
    }

    const _componentLoaded = function (prType, data) {
        if (prType === PURCHASING_GROUP_ENUM.WEEK) {
            let tempWeek = _templateHeaderPrWeek() + _generateDataPrWeek(data);
            $('#tblReportPrWeek').html(tempWeek);
            $('#tblReportPrMonth').html('');
        } else if (prType === PURCHASING_GROUP_ENUM.MONTH) {
            let tempMonth = _templateHeaderPrMonth() + _generateDataPrMonth(data);
            $('#tblReportPrWeek').html('');
            $('#tblReportPrMonth').html(tempMonth);
        } else {
            return false;
        }
    }

    const _hideErrorMessage = function () {
        let errorSelector = $('#errorMessage');
        errorSelector.addClass('d-none').removeClass('d-block');
        errorSelector.html('');
    }

    const _showErrorMessage = function (data) {
        let errorSelector = $('#errorMessage');
        errorSelector.addClass('d-block').removeClass('d-none');
        errorSelector.html(data.errorCode + ': ' + data.errorMessage);
    }

    const _onSubmitForm = function () {
        $('#btnSubmit').on('click', function (e) {
            e.preventDefault();
            // TODO: Check validate form before submit
            let stockCode = _checkStockCodeValue();
            if (stockCode === '') return false;
            let deliveryFromDate = _checkDeliveryFromDate();
            if (deliveryFromDate === '') return false;
            let deliveryToDate = _checkDeliveryToDate();
            if (deliveryToDate === '') return false;
            let prTypeSelect = _checkPrTypeSelect();
            if (prTypeSelect === '') return false;
            let purchasingGroupSelect = _checkPurchasingGroupSelect();
            if (purchasingGroupSelect === '') return false;
            // TODO: set data to submit
            let criteria = {
                stockCode: stockCode,
                prType: prTypeSelect,
                deliveryFromDate: deliveryFromDate,
                deliveryToDate: deliveryToDate,
                purchasingGroup: purchasingGroupSelect
            };
            _showModalProcessing();
            $.ajax({
                url: contextPath + '/report/purchase-requisition',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(criteria),
                success: function (data) {
                    if (data && data.results) {
                        _hideErrorMessage();
                        if (data.errorCode) {
                            _showErrorMessage(data);
                        } else {
                            _componentLoaded(prTypeSelect, data);
                        }
                    }
                },
                error: function (err) {
                    console.error(err);
                    bootbox.alert({
                        title: "Error",
                        message: 'Something wrong!'
                    });
                }
            }).always(() => _hideModalProcessing());
        });
    }

    return {
        init: function () {
            initDatePicker();
            _onSubmitForm();
        }
    }
}();

document.addEventListener('DOMContentLoaded', function() {
    ReportPRComponent.init();
})