// msg
const msgNewPassword = $('#msgNewPassword');
const msgConfirmPassword = $('#msgConfirmPassword');
var isCheckNew = false;
var isCheckConfirm = false;
// regex password: ^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$ %^&*-]).{8,}$
var UserResetComponent = function() {

    var _additionalDisabled = function(isDisabled) {
        $('#btnSubmitChangepw').prop('disabled', isDisabled);
    }

    var _checkNewPassword = function() {
        $('#newPassword').keyup(function(e) {
            var newPassword = $(this).val();
            if (newPassword.length < 6) {
                msgNewPassword.addClass('text-danger');
                $('#msgNewPassword').text('Mật khẩu phải dài hơn 6 ký tự');
                _additionalDisabled(true);
                isCheckNew = false;
            } else {
                msgNewPassword.text('');
                isCheckNew = true;
            }
            _checkPasswordCompare();
        });
    }

    var _checkConfirmPassword = function() {
        $("#confirmPassword").keyup(function(e) {
            var confirmPassword = $(this).val();
            if (confirmPassword.length < 6){
                msgConfirmPassword.addClass('text-danger');
                msgConfirmPassword.text('Mật khẩu phải dài hơn 6 ký tự');
                _additionalDisabled(true);
                isCheckConfirm = false;
            } else {
                msgConfirmPassword.text('');
                isCheckConfirm = true;
            }
            _checkPasswordCompare();
        })
    }

    var _checkPasswordCompare = function() {
        var newPwValue = $('#newPassword').val();
        var confirmPwValue = $('#confirmPassword').val();
        if (newPwValue.trim().length > 0 && confirmPwValue.trim().length > 0)
            if (isCheckNew && isCheckConfirm) {
                if (newPwValue !== confirmPwValue) {
                    _additionalDisabled(true);
                    $('#comparePassword').addClass('text-danger').removeClass('text-success').text('Xác nhận mật khẩu không khớp!');
                }
                else {
                    _additionalDisabled(false);
                    $('#comparePassword').addClass('text-success').removeClass('text-danger').text('Xác nhận mật khẩu khớp');
                }
            } else {
                _additionalDisabled(true);
                $('#comparePassword').addClass('text-danger').removeClass('text-success').text('Xác nhận mật khẩu không khớp!');
            }
    }

    // var _onSubmit = function(e) {
    //     $('#btnSubmit').on('click', function(e) {
    //         e.preventDefault();
    //         $('#userform').submit();
    //     })
    // }


    return {
        init: function() {
            _checkNewPassword();
            _checkConfirmPassword();
            // _checkPasswordCompare();
            // _onSubmit();
        }
    }
}();

document.addEventListener('DOMContentLoaded', function() {
    UserResetComponent.init();
});