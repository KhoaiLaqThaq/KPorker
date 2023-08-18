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
			<div class="table-responsive maxH-600 table-scroll">
               	<table id="tblSelectedMaterials" class="table table-bordered table-striped">
					<thead>
						<tr class="table-success">
							<th width="1%">#</th>
							<th class="text-center icon_head mw-100"><i class="icon-menu-open2"></i></th>
							<th class="mw-300"><fmt:message key="material.search.name" /></th>
							<th class="mw-300"><fmt:message key="purchaserequisition.materialName" /></th>
							<th class="mw-160"><fmt:message key="purchaserequisition.batch" /></th>
							<th class="mw-160"><fmt:message key="instock.adjustment.quantity" /></th>
							<th class="mw-160"><fmt:message key="instock.adjustment.total.retained.quantity" /></th>
							<th class="mw-100"><fmt:message key="purchaserequisition.unit" /></th>
							<th class="mw-200"><fmt:message key="purchaserequisition.manufacturedDate" /></th>
							<th class="mw-200"><fmt:message key="purchaserequisition.expiredDate" /></th>
						</tr>
					</thead>
					<tbody>
						<c:forEach begin="0" items="${materialExistings}" var="item" varStatus="cnt">
							<tr id="rec-material${cnt.index}">
								<td><span class="no"><c:out value="${cnt.count+page.size*page.number}"></c:out></span></td>
								
								<td class="text-center icon">
						        	<div class="list-icons">
						        	<c:if test ="${empty instockAdjustment.id }">
						        		<button type="button" class="btn-primary btn-xs addRow" onclick="javascript:MaterialSelector.addRow()" title="Add Row" style="display: inline-block; float: none; border: none"><i class="fa fa-plus "></i></button>
										<button type="button" class="btn-danger btn-xs" onclick="javascript:MaterialSelector.removeRow(${cnt.index})" title="Remove Row" style="display: inline-block; float: none; border: none"><i class="fa fa-times"></i></button>
						        	</c:if>
						        	</div>
						        </td>
								
								<td><select class="form-control selected-material-code" name="materialDetails[${cnt.index}].code" id="${cnt.index}" data-placeholder="Chọn vật tư" data-fouc></select><input type="hidden" class="selected-code" value="${item.code}"></td>
								<td><input type="text" name="materialDetails[${cnt.index}].name" class="form-control" id="selected-item-name${cnt.index}" value="${item.name}" readonly="readonly"><input type="hidden" class="selected-name" value="${item.name}">
									<input type="hidden" name="materialDetails[${cnt.index}].requiredBatch" class="form-control" id="selected-item-requiredBatch${cnt.index}" value="${item.requiredBatch}">
								</td>
								<td><input type="text" name="materialDetails[${cnt.index}].batch" class="form-control" id="selected-item-batch${cnt.index}" value="${item.batch}"></td>
							    <td><input type="text" name="materialDetails[${cnt.index}].quantity" class="form-control float" id="selected-item-quantity${cnt.index}" value="${item.quantity}"></td>
							     <td><input type="text" name="materialDetails[${cnt.index}].totalRetainedQuantity" class="form-control float" id="selected-item-totalRetainedQuantity${cnt.index}" value="${item.totalRetainedQuantity}" readonly="readonly"></td>
								<td><input type="text" name="materialDetails[${cnt.index}].unit" class="form-control" id="selected-item-unit${cnt.index}" value="${item.unit}" readonly="readonly"></td>
								<td><input type="text" name="materialDetails[${cnt.index}].manufacturedDateStr" class="form-control" id="selected-item-manufacturedDate${cnt.index}" value="${item.manufacturedDateStr}" placeholder="dd.mm.yyyy"></td>
								<td><input type="text" name="materialDetails[${cnt.index}].expiredDateStr" class="form-control" id="selected-item-expiredDate${cnt.index}" value="${item.expiredDateStr}" placeholder="dd.mm.yyyy"><input type="hidden" class="index-table" value="${cnt.index}"></td>
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