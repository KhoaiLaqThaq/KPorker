const FieldDataType = {
    Text: "text",
    Select: "select",
    Textarea: "textarea",
    File: "file"
}

const TemplateComponent = function(){

    // tải file template chuẩn html
    let templateBootstrap = "";
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
                   url: `${getContext()}/api/template/bootstrap`,
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
                if (field?.fieldDataType === FieldDataType.Text || field?.fieldDataType === FieldDataType.File) {
                    temp += _templateFieldInput(field);
                } else if (field?.fieldDataType === FieldDataType.Select) {
                    temp +=  _templateFieldSelect(field);
                } else if (field?.fieldDataType === FieldDataType.Textarea) {
                    temp +=  _templateFieldTextArea(field);
                } else temp += "";
            }
        }
        return temp;
    }

    const _templateFieldInput = function(field) {
        return `
            <div class="${field.groupClassName}">
                <div class="form-group">
                    <label for="${field.fieldName}">${field.labelName}</label>
                    <input type="${field.fieldDataType}" id="${field.fieldName}" name="${field.fieldName}" class="${field.fieldClassName}"/>
                </div>
            </div>
        `;
    }

    const _templateFieldTextArea = function(field) {
        return `
            <div class="${field.groupClassName}">
                <div class="form-group">
                    <label for="${field.fieldName}">${field.labelName}</label>
                    <textarea id="${field.fieldName}" name="${field.fieldName}" class="${field.fieldClassName}"></textarea>
                </div>
            </div>
        `;
    }

    const _templateFieldSelect = function(field) {
        return `
            <div class="${field.groupClassName}">
                <div class="form-group">
                    <label for="${field.fieldName}">${field.labelName}</label>
                    <select id="${field.fieldName}" name="${field.fieldName}" class="${field.fieldClassName} select2"></select>
                </div>
            </div>
        `;
    }

    return {
        init: function() {
            _eventUploadTemplateFile();
        }
    }
}();

document.addEventListener("DOMContentLoaded", function () {
    TemplateComponent.init();
});
