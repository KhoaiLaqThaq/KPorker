<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>


<div class="row">
	<div class="col-md-12">
	<!-- Grey header and footer -->
	<div class="card">
		<div class="card-header bg-light d-flex justify-content-between">
			<span class="font-size-sm text-uppercase font-weight-semibold"><fmt:message key="material.info"/></span>
			<span class="font-size-sm text-uppercase text-success font-weight-semibold">&nbsp;</span>
		</div>
		<div class="card-body">
			
			<div class="col-md-12">
				<div class="row">
					<div class="col-md-1 text-right" style="margin-top: 5px"><strong><fmt:message key="material.select"/>: </strong></div>
					<div class="col-md-3 form-group">
						<!-- <select data-fouc class="select2-size-items" data-placeholder="Chọn món ăn">
							<option></option>
						</select> -->
						<select class="form-control select2" id="hallplan" aria-hidden="true" data-placeholder="Chọn vật tư">
							<option value="">&nbsp;</option>
							<option value="">Mã 1</option>
							<option value="">Mã 2</option>
						</select>
					</div>
					
					<div class="col-md-1 text-right" style="margin-top: 5px"><strong><fmt:message key="purchaserequisition.quantity"/>: </strong></div>
					<div class="col-md-2 form-group">
						<input type="text" id="nameDisplay" data-placeholder="Tên hiển thị" class="form-control"/>
					</div>
					
					<div class="col-md-1 text-right" style="margin-top: 5px"><strong><fmt:message key="processorder.requestDate"/>: </strong></div>
					<div class="col-md-3 form-group">
						<input type="date" id="nameDisplay" data-placeholder="Tên hiển thị" class="form-control"/>
					</div>
					
					<div class="col-md-1">
						<button type="button" class="btn bg-primary" id="btn-seclect-materials"><fmt:message key="button.select"/></button>
					</div>
				</div>
			</div>
			
			<div class="table-responsive">
               	<table id="tblSelectedMaterials" class="table table-bordered table-striped">
					<thead>
						<tr class="table-success">
							<th width="5%">#</th>
							<th width="15%"><fmt:message key="purchaserequisition.materialCode" /></th>
							<th width="25%"><fmt:message key="purchaserequisition.materialName" /></th>
							<th width="20"><fmt:message key="purchaserequisition.quantity" /></th>
							<th width="20%"><fmt:message key="processorder.requestDate" /></th>
							<th width="5%" class="text-center"><i class="icon-menu-open2"></i></th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${page.content}" var="soCat" varStatus="cnt">
							<tr>
								<td><c:out value="${cnt.count+page.size*page.number}"></c:out></td>
							</tr>
						</c:forEach> 
					</tbody>
				</table>            	
			</div>
      			
		</div>
		
	</div>
	<!-- /grey header and footer -->
	</div>
</div>

<br/>		
        	