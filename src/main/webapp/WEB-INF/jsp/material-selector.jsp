<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>


<div class="row">
	<div class="col-md-12">
	<div class="card">
		<div class="card-header bg-light d-flex justify-content-between">
			<span class="font-size-sm text-uppercase font-weight-semibold"><fmt:message key="material.info"/></span>
			<span class="font-size-sm text-uppercase text-success font-weight-semibold">&nbsp;</span>
		</div>
		<div class="card-body">
			<div class="table-responsive maxH-600 table-scroll">
					<jsp:include page="purchase-requisition-material-selector-type-week.jsp" />
					<jsp:include page="purchase-requisition-material-selector-type-month.jsp" />
			</div>
		</div>
	</div>
	</div>
</div>
<br/>	

<!-- form modal -->
<!-- <div id="modalMaterial" class="modal fade"> -->
<!-- 	<div class="modal-dialog"> -->
<!-- 		<div class="modal-content"> -->
<!-- 			<div class="modal-header"> -->
<%-- 				<h5 class="modal-title"><fmt:message key="material.info"/></h5> --%>
<!-- 				<button type="button" class="close" data-dismiss="modal">&times;</button> -->
<!-- 			</div> -->
<!-- 			<form action="#"> -->
<!-- 				<div class="modal-body"> -->
<!-- 					<div class="form-group"> -->
<!-- 						<div class="row"> -->
<!-- 							<div class="col-sm-6"> -->
<%-- 								<label><fmt:message key="material.groupName"/></label> --%>
<!-- 								<input type="text" id="modalMaterialGroupName" placeholder="Nhóm vật tư" class="form-control" readonly="readonly"> -->
<!-- 							</div> -->

<!-- 							<div class="col-sm-6"> -->
<%-- 								<label><fmt:message key="purchaserequisition.quantity"/></label> --%>
<!-- 								<input type="text" id="modalMaterialQuantity" placeholder="Số lượng" class="form-control"> -->
<!-- 							</div> -->
<!-- 						</div> -->
<!-- 					</div> -->
<!-- 					<div class="form-group"> -->
<!-- 						<div class="row"> -->
<!-- 							<div class="col-sm-6"> -->
<%-- 								<label><fmt:message key="purchaserequisition.unit"/></label> --%>
<!-- 								<input type="text" id="modalMaterialUnit" placeholder="Đơn vị tính" class="form-control"> -->
<!-- 							</div> -->

<!-- 							<div class="col-sm-6"> -->
<%-- 								<label><fmt:message key="purchaserequisition.orderUnit"/></label> --%>
<!-- 								<input type="text" id="modalMaterialOrderUnit" placeholder="Đơn vị mua" class="form-control"> -->
<!-- 							</div> -->
<!-- 						</div> -->
<!-- 					</div> -->
					
<!-- 				</div> -->
<!-- 				<div class="modal-footer"> -->
<!-- 					<button type="button" class="btn btn-link" data-dismiss="modal">Close</button> -->
<!-- 					<button type="button" id="btnSubmitModal" class="btn bg-primary">Save</button> -->
<!-- 				</div> -->
<!-- 			</form> -->
<!-- 		</div> -->
<!-- 	</div> -->
<!-- </div> -->
<!-- /form modal -->
