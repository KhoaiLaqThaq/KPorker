<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<!-- Dự trù tuần Z1 -->
       <table id="tblSelectedMaterialPrTypeWeeks" class="table table-bordered table-striped">
            <thead>
				<tr class="table-success">
					<th width="1%">#</th>
					<th class="text-center mw-100"><i class="icon-menu-open2"></i></th>
					<th class="mw-300"><fmt:message key="material.search.name" /></th>
					<th class="mw-300"><fmt:message key="purchaserequisition.materialName" /></th>
					<th class="mw-200"><fmt:message key="purchase.requisition.retained" /></th>
					<th class="mw-200"><fmt:message key="purchase.requisition.quantity" /></th>
					<th class="mw-100"><fmt:message key="purchaserequisition.unit" /></th>
					<th class="mw-200"><fmt:message key="purchaserequisition.deliveryDate" /></th>
					<th class="mw-300"><fmt:message key="material.specification" /></th>
					<th class="mw-100"><fmt:message key="material.purchasingGroup" /></th>
					<th class="mw-600"><fmt:message key="purchaserequisition.note" /></th>
				</tr>
			</thead>
			<tbody class="chimneyClone">
				<c:forEach begin="0" items="${materialExistings}" var="item" varStatus="cnt">
					<tr id="rec-material${cnt.index}">
						<td><span class="no"><c:out value="${cnt.count+page.size*page.number}"></c:out></span></td>
						<td class="text-center">
				        	<div class="list-icons">
								<button type="button" class="btn-primary btn-xs addRow" onclick="javascript:MaterialSelector.addRow()" title="Add Row" style="display: inline-block; float: none; border: none"><i class="fa fa-plus "></i></button>
								<button type="button" class="btn-danger btn-xs" onclick="javascript:MaterialSelector.removeRow(${cnt.index})" title="Remove Row" style="display: inline-block; float: none; border: none"><i class="fa fa-times"></i></button>
				        	</div>
				        </td>
						<td class="select2ContainerPRWeek"><select class="form-control selected-material-code" name="materialDetailTypeWeeks[${cnt.index}].code" id="selected-item-code${cnt.index}" data-placeholder="Chọn vật tư" data-fouc></select><input type="hidden" class="selected-code" value="${item.code}"></td>
						<td><input type="text" name="materialDetailTypeWeeks[${cnt.index}].name" class="form-control" id="selected-item-name${cnt.index}" readonly="readonly" value="${item.name}"></td>
						<td><input type="text" name="materialDetailTypeWeeks[${cnt.index}].retained" class="form-control selected-item-retained float" id="selected-item-retained${cnt.index}" value="${item.retained}"></td>
						<td><input type="text" name="materialDetailTypeWeeks[${cnt.index}].quantity" class="form-control selected-item-quantity float" id="selected-item-quantity${cnt.index}" value="${item.quantity}"></td>
						<td><input type="text" name="materialDetailTypeWeeks[${cnt.index}].unit" class="form-control" id="selected-item-unit${cnt.index}" readonly="readonly" value="${item.unit}"></td>
						<td><input type="text" name="materialDetailTypeWeeks[${cnt.index}].deliveryDateStr" class="form-control" id="selected-item-deliveryDate${cnt.index}" value="${item.deliveryDateStr}" placeholder="dd.mm.yyyy"></td>
						<td><input type="text" name="materialDetailTypeWeeks[${cnt.index}].description" class="form-control" id="selected-item-description${cnt.index}" value="${item.description}" readonly="readonly"></td>
						<td>
							<input type="text" name="materialDetailTypeWeeks[${cnt.index}].purchasingGroup" class="form-control" id="selected-item-purchasingGroup${cnt.index}" readonly="readonly" value="${item.purchasingGroup}">
							<input type="hidden" class="index-purchasingGroup" value="${cnt.index}">
							<input type="hidden" class="index-table" value="${cnt.index}">
						</td>
						<td><input type="text" name="materialDetailTypeWeeks[${cnt.index}].note" class="form-control" id="selected-item-note${cnt.index}" value="${item.note}"></td>
					</tr>
				</c:forEach> 
			</tbody>
		</table>     