function checkedItem(){
    var ids = [];
    $('input[class="item-check"]:checked').each(function() {
           ids.push(this.value);
    });
};

var FormComponent = function() {
    var contextPath = getContext();
    var initForm = function() {
        if (!$().select2) {
            return;
        }
        // select2
        $('.select2').select2();
    }
    
    // Switchery
    var initSwitchery = function() {
        if (typeof Switchery == 'undefined') {
            return;
        }
        // Initialize multiple switches
        var elems = Array.prototype.slice.call(document.querySelectorAll('.form-check-input-switchery'));
        elems.forEach(function(html) {
          var switchery = new Switchery(html);
        });
    };

    var _toastNotification = function(isChecked) {
        var x = document.getElementById("snackbar");
        if (isChecked)   $('#snackbar').html("<i class='icon-checkmark-circle mr-3 icon-2x'></i> Đã thêm vật tư cho tool.");
        else             $('#snackbar').html("<i class='icon-cancel-circle2 mr-3 icon-2x'></i> Đã loại vật tư cho tool");
        x.className = "show " + (isChecked ? "text-success":"text-danger");
        setTimeout(function(){ x.className = x.className.replace("show", ""); }, 3000);
    }

    var _showModalProcessing = () => $('#modalLoading').addClass('d-block').removeClass('d-none');
    var _hideModalProcessing = () => $('#modalLoading').addClass('d-none').removeClass('d-block');

    var saveMaterialsCheckAll = function(dataForm, ischecked) {
        _showModalProcessing();
        var list = $('#tblSelectedMaterials').closest('table').find('.showable').find("input[name='item[]']");
        $.each(list, function (i, val) {
            list[i].checked = ischecked;
        });
        $.ajax({
            url: contextPath + '/api/checkAllMaterialsForTool',
            method: 'POST',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify(dataForm),
            success: function(data) {
                _hideModalProcessing();
                if (data == true) _toastNotification(ischecked);
            },
            error: function(error) {
                _hideModalProcessing();
                console.log('error: ', error);
            }
        });
    }
    
    var checkAll = function(){
        $('body').on('change', '#checkAll', function (e) {
            e.preventDefault();
            var code = $('#materialCode').val();
            var name =  $('#materialName').val();
            var suggestName = $('#suggestName').val();
            var fastCode = $('#fastCode').val();
            var ischecked = this.checked;
            var dataForm = {code: code, name, suggestName, fastCode, selected: ischecked};
            var checkDataForm = code == '' && name == '' && suggestName == '' && fastCode == '';
            if (checkDataForm) {
                bootbox.confirm({
                    message: "Nếu thêm tất cả vật tư cho tool sẽ tốn thời gian thay vì tìm kiếm trước?",
                    buttons: {
                        confirm: {
                            label: 'Đồng ý',
                            className: 'btn-success'
                        },
                        cancel: {
                            label: 'Hủy',
                            className: 'btn-danger'
                        }
                    },
                    callback: function (result) {
                        console.log('result', result);
                        if (result) {
                            saveMaterialsCheckAll(dataForm, ischecked);
                        } else {
                            $('#checkAll').prop('checked', false);
                        }
                    }
                });
            } else {
                var list = $(this).closest('table').find('.showable').find("input[name='item[]']");
                var checked_status = this.checked;
                $.each(list, function (i, val) {
                    list[i].checked = checked_status;
                });
                saveMaterialsCheckAll(dataForm, ischecked);
            }
        });
    }

    var searchMaterial = function () {
        $('#btnSearch').on('click', function(e) {
            $('#materialSupportForm').attr('action', '/materialSupport/form');
            $('#materialSupportForm').submit();
        })
    }
    
    var getSelectedCode = function(){
        $('#btnSubmit').on('click',function(e){
            var codes = [];
            $('input[class="item-check"]:checked').each(function() {
                codes.push(this.value);
            });
            $('#materialSupportForm').attr('action', '/materialSupport/save');
            $('#materialSupportForm').submit();
        });
    }

    var addMaterialForTool = function () {
        $('.item-check').on('change', function(e) {
            var materialCode = $(this).val();
            var isChecked = this.checked;
            if (materialCode.trim()) {
                $.ajax({
                    url: contextPath + '/api/changeMaterialForTool/' + materialCode + '?isSelected=' + (isChecked ? 1 : 0),
                    method: 'POST',
                    contentType: 'application/json',
                    success: function (data) {
                        console.log('data', data)
                        if (data == true) {
                            _toastNotification(isChecked);
                        }
                    },
                    error: function(err) {
                        console.log('error: ', err);
                    }
                })
            }
        })
    }

    var _initHandleCheckAll = function() {
        var list = $('#checkAll').closest('table').find('.showable').find("input[name='item[]']");
        if (list.length < 1)
            return;
        for (let i = 0; i < list.length; i++) {
            if (list[i].checked === false) return;
        }
        $('#checkAll').prop('checked', true);
    }
    
    return {
        init: function() {
            initForm();
            initSwitchery();
            _initHandleCheckAll();
            searchMaterial();
            addMaterialForTool();
            checkAll();
            getSelectedCode();
        }
    }
}();

var Custom = {
        hideRow: () => {
            var codes = [];
            $('input[class="item-check"]:checked').each(function() {
                codes.push(this.value);
            });
            var table = document.getElementById("dataMaterials");
            var tr = table.getElementsByTagName("tr");
            for (i = 0; i < tr.length; i++) {
                var index = i;
                var codeId = "#materialCode" + index;
                var code = $(codeId).val();
                if (codes.includes(code)) {
                    $("#rec-material"+index).addClass("showable").removeClass("hidden");
                } else {
                    $("#rec-material"+index).addClass("hidden").removeClass("showable");
                    $("#rec-material"+index).css("display", "none");
                }
            }
        },
}
// Initialize module
// ------------------------------

document.addEventListener('DOMContentLoaded', function() {
    FormComponent.init();
    // Custom.hideRow();
});
