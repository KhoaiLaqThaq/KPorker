<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="user.list.title"/></title>
    <meta name="reset" content="reset"/>

	<link href="<c:url value='/themes/admin/assets/libs/bootstrapvalidator/dist/css/bootstrapValidator.min.css'/>"/>
	
	<script src="<c:url value='/themes/admin/assets/libs/bootstrapvalidator/dist/js/bootstrapValidator.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/demo_pages/components_modals.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/assets/css/custom_style.css'/>"></script>
</head>

<div class="content">
	<form:form id="userChangepw" modelAttribute="user" action="${ ctx }/user/resetpw" method="POST">
		<form:hidden path="id"/>
		<form:hidden path="username"/>

		<div class="card">
			<div class="card-body">
				<spring:bind path="user.changedPassword">
					<div class="col-12">
						<div class="form-group">
							<label><fmt:message key="user.password.change"></fmt:message></label>
							<input type="password" class="form-control" id="changedPassword" name="changedPassword"  maxlength="32" 
								placeholder="Nhập mật khẩu mới" autocomplete="off" autofocus="autofocus" />
						</div>
					</div>
				</spring:bind>
				<spring:bind path="user.confirmPassword">
					<div class="col-12">
						<div class="form-group">
							<label><fmt:message key="user.password.confirm"/></label>
							<input type="password" class="form-control" id="confirmPassword" name="confirmPassword" maxlength="32" 
								placeholder="Xác nhận lại mật khẩu mới" autocomplete="false" />
						</div>
					</div>
				</spring:bind>
				<div class="col-12 float-right">
					<button type="submit" class="btn btn-primary"><fmt:message key="user.password.save"/></button>
				</div>
			</div>
		</div>
		<c:if test="${flatChangedpw == true }">
			<div id="modal_theme_success" class="modal fade ${flatChangedpw == true ? 'show':'' }" tabindex="-1">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header bg-success">
							<h6 class="modal-title"><fmt:message key="user.password.changed"/></h6>
							<button type="button" class="close" data-dismiss="modal">&times;</button>
						</div>
	
						<div class="modal-body">
							<p><fmt:message key="user.password.changed.require"/></p>
						</div>
	
						<div class="modal-footer">
							<a href="${ctx }/logout" class="btn bg-success"><fmt:message key="user.logout.now"/></a>
						</div>
					</div>
				</div>
			</div>
		</c:if>
		
	</form:form>
</div>

<script type="text/javascript">
    $(document).ready(function() {
        $('#userChangepw').bootstrapValidator({
        	fields: {
                confirmPassword: {
                    validators: {
                        identical: {
                            field: 'changedPassword',
                            message: 'Mật khẩu mới không được trùng với mật khẩu cũ.'
                        },
        			
				        notEmpty: {
				        	message: 'Vui lòng không để trống mục này.'
				        }
                    },
                },
                changedPassword: {
                	validators: {
                        identical: {
                            field: 'changedPassword',
                            message: 'Mật khẩu mới không được trùng với mật khẩu cũ.'
                        },
                        
               			notEmpty: {
			        		message: 'Vui lòng không để trống mục này.'
			        	}
                	}
                }
            }	
        });
    });
</script>