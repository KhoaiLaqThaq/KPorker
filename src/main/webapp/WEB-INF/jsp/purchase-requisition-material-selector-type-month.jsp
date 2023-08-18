<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<!-- Dự trù tháng Z6 -->
	<table id="tblSelectedMaterialPrTypeMonths" class="table table-bordered table-striped">
        		<thead>
				<tr class="table-success">
					<th width="1%">#</th>
					<th class="text-center mw-100"><i class="icon-menu-open2"></i></th>
					<th class="mw-300"><fmt:message key="material.search.name" /></th>
					<th class="mw-300"><fmt:message key="purchaserequisition.materialName" /></th>
					<th class="mw-100"><fmt:message key="purchase.requisition.amountEarlyStage" /></th>
					<th class="mw-100"><fmt:message key="purchase.requisition.amountGoodsReceipt" /></th>
					<th class="mw-100"><fmt:message key="purchase.requisition.amountGoodsIssue" /></th>
					<th class="mw-100"><fmt:message key="purchase.requisition.amountFinalStage" /></th>
					<th class="mw-100"><fmt:message key="purchase.requisition.quantity" /></th>
					<th class="mw-200"><fmt:message key="purchaserequisition.unit" /></th>
					<th class="mw-200"><fmt:message key="purchaserequisition.deliveryDate" /></th>
					<th class="mw-300"><fmt:message key="material.specification" /></th>
					<th class="mw-100"><fmt:message key="material.purchasingGroup" /></th>
					<th class="mw-600"><fmt:message key="purchaserequisition.note" /></th>
				</tr>
			</thead>
			<tbody class="chimneyClone">
				<c:forEach begin="0" items="${materialExistings}" var="item" varStatus="cnt">
					<tr id="rec-material-type-month${cnt.index}">
						<td><span class="no"><c:out value="${cnt.count+page.size*page.number}"></c:out></span></td>
						<td class="text-center">
				        	<div class="list-icons">
								<button type="button" class="btn-primary btn-xs addRow" onclick="javascript:MaterialSelector.addRow()" title="Add Row" style="display: inline-block; float: none; border: none"><i class="fa fa-plus "></i></button>
								<button type="button" class="btn-danger btn-xs" onclick="javascript:MaterialSelector.removeRow(${cnt.index})" title="Remove Row" style="display: inline-block; float: none; border: none"><i class="fa fa-times"></i></button>
				        	</div>
				        </td>
						<td class="select2ContainerPRMonth"><select class="form-control selected-material-code" name="materialDetailTypeMonths[${cnt.index}].code" id="selected-pr-type-month-item-code${cnt.index}" data-placeholder="Chọn vật tư" data-fouc></select><input type="hidden" class="selected-code" value="${item.code}"></td>
						<td><input type="text" name="materialDetailTypeMonths[${cnt.index}].name" class="form-control" id="selected-pr-type-month-item-name${cnt.index}" readonly="readonly" value="${item.name}"></td>
						<td><input type="text" name="materialDetailTypeMonths[${cnt.index}].amountEarlyStage" class="form-control selected-item-amountEarlyStage float" id="selected-pr-type-month-item-amountEarlyStage${cnt.index}" value="${item.amountEarlyStage}"></td>
						<td><input type="text" name="materialDetailTypeMonths[${cnt.index}].amountGoodsReceipt" class="form-control selected-item-amountGoodsReceipt float" id="selected-pr-type-month-item-amountGoodsReceipt${cnt.index}" value="${item.amountGoodsReceipt}"></td>
						<td><input type="text" name="materialDetailTypeMonths[${cnt.index}].amountGoodsIssue" class="form-control selected-item-amountGoodsIssue float" id="selected-pr-type-month-item-amountGoodsIssue${cnt.index}" value="${item.amountGoodsIssue}"></td>
						<td><input type="text" name="materialDetailTypeMonths[${cnt.index}].amountFinalStage" class="form-control selected-item-amountFinalStage float" id="selected-pr-type-month-item-amountFinalStage${cnt.index}" value="${item.amountFinalStage}"></td>
						<td><input type="text" name="materialDetailTypeMonths[${cnt.index}].quantity" class="form-control selected-item-quantity float" id="selected-pr-type-month-item-quantity${cnt.index}" value="${item.quantity}"></td>
						<td><input type="text" name="materialDetailTypeMonths[${cnt.index}].unit" class="form-control" id="selected-pr-type-month-item-unit${cnt.index}" readonly="readonly" value="${item.unit}"></td>
						<td><input type="text" name="materialDetailTypeMonths[${cnt.index}].deliveryDateStr" class="form-control" id="selected-pr-type-month-item-deliveryDate${cnt.index}" value="${item.deliveryDateStr}" placeholder="dd.mm.yyyy"></td>
						<td><input type="text" name="materialDetailTypeMonths[${cnt.index}].description" class="form-control" id="selected-pr-type-month-item-description${cnt.index}" value="${item.description}" readonly="readonly"></td>
						<td>
							<input type="text" name="materialDetailTypeMonths[${cnt.index}].purchasingGroup" class="form-control" id="selected-pr-type-month-item-purchasingGroup${cnt.index}" readonly="readonly" value="${item.purchasingGroup}">
							<input type="hidden" class="index-purchasingGroup-type-month" value="${cnt.index}">
							<input type="hidden" class="index-table-type-month" value="${cnt.index}">
						</td>
						<td><input type="text" name="materialDetailTypeMonths[${cnt.index}].note" class="form-control" id="selected-pr-type-month-item-note${cnt.index}" value="${item.note}"></td>
					</tr>
				</c:forEach> 
			</tbody>
		</table>
