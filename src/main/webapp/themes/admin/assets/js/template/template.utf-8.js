const FieldDataType = {
    Text: "text",
    Input: "input",
    Select: "select",
    Textarea: "textarea",
    File: "file"
}

const TemplateComponent = function(){

    // tải file template chuẩn html
    const _eventUploadTemplateFile = function() {
        $('#btn_upload').on('click', function(e) {
            e.preventDefault();
            let fileSelector = $('#excelFile');
            if (fileSelector) {
                let containerTemp = $('#container__temp');
                let fileExcelData = fileSelector.prop('files')[0];
                let formData = new FormData();
                formData.append("excelFile", fileExcelData);

                $.ajax({
                    url: `${getContext()}/api/template/utf-8`,
                    method: 'POST',
                    cache: false,
                    processData: false, // Important!
                    contentType: false,
                    data: formData,
                    success: function(response) {
                        if (response) {
                            console.log(response);
                            containerTemp.html(_generateTemplateBootstrap(response.fields));
                            $('#container__card').show();
                        } else containerTemp.html('');
                    }, error: function(error) {
                        console.log("error", error)
                    }
                });
            } else {
                alert("File must not empty!");
            }
        });
    }

    const _generateTemplateBootstrap = (fields) => {
        let temp = "";
        if (fields && fields.length > 0) {
            for (let i = 0; i < fields.length; i++) {
                let field = fields[i];
                if (field?.fieldDataType === FieldDataType.Text || field?.fieldDataType === FieldDataType.Input) {
                    temp += _templateFieldInput(field, i);
                } else if (field?.fieldDataType === FieldDataType.Select) {
                    temp +=  _templateFieldSelect(field, i);
                } else if (field?.fieldDataType === FieldDataType.Textarea) {
                    temp +=  _templateFieldTextArea(field, i);
                } else temp += "";
            }
        }
        return temp;
    }

    const _templateFieldInput = function(field, index) {
        return `
            <div class="col-12">
                <div class="form-group">
                    <label for="${field.fieldId}">${field.labelName}</label>
                    <input type="text" id="${field.fieldId}" name="field[${index}].${field.fieldName}" class="form-control"
                        ${field.fieldMaxLength ? "maxlength=" + field.fieldMaxLength : "" }
                    />
                </div>
            </div>
        `;
    }

    const _templateFieldTextArea = function(field, index) {
        return `
            <div class="col-12">
                <div class="form-group">
                    <label for="${field.fieldId}">${field.labelName}</label>
                    <textarea id="${field.fieldId}" name="field[${index}].${field.fieldName}" class="form-control"></textarea>
                </div>
            </div>
        `;
    }

    const _templateFieldSelect = function(field, index) {
        return `
            <div class="col-12">
                <div class="form-group">
                    <label for="${field.fieldId}">${field.labelName}</label>
                    <select id="${field.fieldId}" name="field[${index}].${field.fieldName}" class="form-control select2"></select>
                </div>
            </div>
        `;
    }

    const _submitForm = function() {
        $('#btn__Submit').on('click', function(e) {
            showModal();
            e.preventDefault();
            $('form').submit();


        })
    }

    const showModal = () => $('#modalLoading').addClass('d-block').removeClass('d-none');

    return {
        init: function() {
            _eventUploadTemplateFile();
            _submitForm();
        }
    }
}();

document.addEventListener("DOMContentLoaded", function () {
    TemplateComponent.init();
});
