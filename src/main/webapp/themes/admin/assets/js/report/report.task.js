const BOOTBOX_TITLE = {
    TITLE: "Thông báo"
};

const MESSAGE = {
    FROM_DATE_REQUIRED: "Khoảng thời gian đầu bắt buộc nhập",
    TO_DATE_REQUIRED: "Khoảng thời gian sau bắt buộc nhập"
}

const ReportTaskComponent = function() {

    const _loaded = function() {
        let fromDate = $('input[name="searchFromDate"]');
        fromDate.daterangepicker({
            singleDatePicker: true,
            autoUpdateInput: false,
            locale: {
                cancelLabel: 'Clear',
                format: 'DD-MM-YYYY'
            }
        });
        fromDate.on('apply.daterangepicker', function(ev, picker) {
            $(this).val(picker.startDate.format('DD-MM-YYYY'));
        });
        fromDate.on('cancel.daterangepicker', function(ev, picker) {
            $(this).val('');
        });

        let toDate = $('input[name="searchToDate"]');
        toDate.daterangepicker({
            singleDatePicker: true,
            autoUpdateInput: false,
            locale: {
                cancelLabel: 'Clear',
                format: 'DD-MM-YYYY'
            }
        });
        toDate.on('apply.daterangepicker', function(ev, picker) {
            $(this).val(picker.startDate.format('DD-MM-YYYY'));
        });
        toDate.on('cancel.daterangepicker', function(ev, picker) {
            $(this).val('');
        });

    }

    /**
     *
     * @param data: Map<key, value> Key: assigneeFullname, value: cause
     * @private
     */
    const _getKey = function(data, i) {
        let keyStr = "";
        if (data && data instanceof Object) {
            Object.entries(data).forEach(([key, value], index) => {
                if (index === i) keyStr = key;
            });
        }
        return keyStr;
    }
    
    const _getValue = function(data, i) {
        let valueStr = "";
        if (data && data instanceof Object) {
            Object.entries(data).forEach(([key, value], index) => {
                if (index === i) valueStr = value
            });
        }
        return valueStr;
    }

    /**
     * Create sub template table
     * @param data
     * @param dataRowNumber
     * @returns {string}
     * @private
     */
    const _generateSubTemplate = function(subReport, dataRowNumber) {
        let subTemplate = "";
        for (let i = 1; i < dataRowNumber; i++) {
            subTemplate += `
                           <tr>
                                <td class="text-center">${subReport.assigned?.length > i ? subReport.assigned[i] : ''}</td>
                                <td class="text-center">${subReport.todos?.length > i ? subReport.todos[i] : ''}</td>
                                <td class="text-center">${subReport.overdues ? _getKey(subReport.overdues, i) : ''}</td>
                                <td class="text-center">${subReport.overdues ? _getValue(subReport.overdues, i) : ''}</td>
                                <td class="text-center">${subReport.dones?.length > i ? subReport.dones[i] : ''}</td>
                                <td class="text-center">${subReport.rejects ? _getKey(subReport.rejects, i) : ''}</td>
                                <td class="text-center">${subReport.rejects ? _getValue(subReport.rejects, i) : ''}</td>
                            </tr>
                            `;
        }
        return subTemplate;
    }

    /**
     * Create template table
     * @param data
     * @returns {string}
     * @private
     */
    const _generateTemplate = function(data) {
        let template = "";
        if (data) {
            for (let i = 0; i < data.length; i++) {
                let report = data[i];
                let dataRowNumber = parseInt(report.dataRowNumber);
                template += `<tr>
                                <td class="text-center" rowspan="${dataRowNumber}">${i + 1}</td>
                                <td class="text-center" rowspan="${dataRowNumber}">${report.taskTitle}</td>
                                <td class="text-center" rowspan="${dataRowNumber}">${report.deadline}</td>
                                <td class="text-center">${report.assigned?.length > 0 ? report.assigned[0] : ''}</td>
                                <td class="text-center">${report.todos?.length > 0 ? report.todos[0] : ''}</td>
                                <td class="text-center">${report.overdues ? _getKey(report.overdues, 0) : ''}</td>
                                <td class="text-center">${report.overdues ? _getValue(report.overdues, 0) : ''}</td>
                                <td class="text-center">${report.dones?.length > 0 ? report.dones[0] : ''}</td>
                                <td class="text-center">${report.rejects ? _getKey(report.rejects, 0) : ''}</td>
                                <td class="text-center">${report.rejects ? _getValue(report.rejects, 0) : ''}</td>
                            </tr>
                            ${dataRowNumber > 1 ? _generateSubTemplate(report, dataRowNumber) : ''}
                            `;
            }
        }
        return template;
    }

    const _validate = function(field, message) {
        if (field && field.val().length > 0)
            return field.val();
        bootbox.alert({
            title: BOOTBOX_TITLE.TITLE,
            message: message
        })
        return '';
    }

    const _searchReportData = function() {
        $('#btn__submit').on('click', function() {
            let fromDate = _validate($('input[name="searchFromDate"]'), MESSAGE.FROM_DATE_REQUIRED);
            if (fromDate === '') return false;
            let toDate = _validate($('input[name="searchToDate"]'), MESSAGE.TO_DATE_REQUIRED);
            if (toDate === '') return false;
            showLoading();
            let criteria = {
                taskTitle: $('#taskTitle').val(),
                assigneeUsername: $('#assigneeUsername').val(),
                searchFromDate: fromDate,
                searchToDate: toDate
            };
            $.ajax({
                url: `${getContext()}/report/task`,
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(criteria),
                success: function(response) {
                    if (response && response.code === '200') {
                        console.log("response: ", response);
                        let reportData = response.data;
                        let template = _generateTemplate(reportData);
                        let tbody = $('tbody');
                        tbody.html(); // reset
                        tbody.html(template);
                    }
                },
                error: function(error) {
                    console.log(error);
                }
            }).always(() => hideLoading());
        });
    }

    const _eventToExportExcel = function() {
        $('#btn__export').on('click', function(e) {
            console.log("entering: 'event-to-export-excel' method...");
            // Validate
            let taskTitle = $('#taskTitle').val();
            let fromDate = _validate($('input[name="searchFromDate"]'), MESSAGE.FROM_DATE_REQUIRED);
            if (fromDate === '') return false;
            let toDate = _validate($('input[name="searchToDate"]'), MESSAGE.TO_DATE_REQUIRED);
            if (toDate === '') return false;
            let assigneeUsername = $('#assigneeUsername').val();
            showLoading();
            e.preventDefault();
            location.href = `/report/task/export?taskTitle=${taskTitle}&assigneeUsername=${assigneeUsername}&fromDate=${fromDate}&toDate=${toDate}`;
            hideLoading();
        });
    }

    const showLoading = () => $('#modalLoading').addClass('d-block').removeClass('d-none');
    const hideLoading = () => $('#modalLoading').addClass('d-none').removeClass('d-block');

    return {
        init: function() {
            _loaded();
            _searchReportData();
            _eventToExportExcel();
        }
    }
}();

document.addEventListener('DOMContentLoaded', function() {
    ReportTaskComponent.init();
})
