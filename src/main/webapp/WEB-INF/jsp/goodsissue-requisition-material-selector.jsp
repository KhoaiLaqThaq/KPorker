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
							<th class="bgc-primary border-primary text-white " width="3%">#</th>
							<th class="bgc-primary border-primary text-white mw-300"><fmt:message key="purchaserequisition.materialCode" /></th>
							<th class="bgc-primary border-primary text-white mw-300"><fmt:message key="purchaserequisition.materialName" /></th>
							<th class="bgc-primary border-primary text-white mw-200"><fmt:message key="purchaserequisition.batch" /></th>
							<th class="bgc-primary border-primary text-white mw-200"><fmt:message key="goods.requisition..quantity" /></th>
							<th class="bgc-primary border-primary text-white mw-200"><fmt:message key="goods.requisition.actuallyExported" /></th>
							<th class="bgc-primary border-primary text-white mw-200"><fmt:message key="goods.requisition.retained" /></th>
							<th class="bgc-primary border-primary text-white mw-200"><fmt:message key="purchaserequisition.weight" /></th>
							<th class="bgc-primary border-primary text-white mw-200"><fmt:message key="purchaserequisition.unit" /></th>
							<th class="bgc-primary border-primary text-white mw-200"><fmt:message key="purchaserequisition.manufacturedDate" /></th>
							<th class="bgc-primary border-primary text-white mw-200"><fmt:message key="purchaserequisition.expiredDate" /></th>
						</tr>
					</thead>
					<tbody>
						<c:forEach begin="0" items="${materialExistings}" var="item" varStatus="cnt">
							<tr id="rec-material${cnt.index}">
								<td><span class="no"><c:out value="${cnt.count+page.size*page.number}"></c:out></span></td>
								<td><input type="text" name="materialDetails[${cnt.index}].code" class="form-control" id="selected-item-code${cnt.index}" value="${item.code}"></td>
								<td><input type="text" name="materialDetails[${cnt.index}].name" class="form-control" id="selected-item-name${cnt.index}" value="${item.name}"></td>
								<td><input type="text" name="materialDetails[${cnt.index}].batch" class="form-control" id="selected-item-batch${cnt.index}" value="${item.batch}"></td>
								<td><input type="text" name="materialDetails[${cnt.index}].quantity" class="form-control float" id="selected-item-quantity${cnt.index}" value="${item.quantity}"></td>
								<td><input type="text" name="materialDetails[${cnt.index}].actuallyExported" class="form-control float" id="selected-item-actuallyExported${cnt.index}" value="${item.actuallyExported}"></td>
								<td><input type="text" name="materialDetails[${cnt.index}].retained" class="form-control float" id="selected-item-retained${cnt.index}" value="${item.retained}"></td>
								<td><input type="text" name="materialDetails[${cnt.index}].weight" class="form-control float" id="selected-item-weight${cnt.index}" value="${item.weight}"></td>
								<td><input type="text" name="materialDetails[${cnt.index}].unit" class="form-control" id="selected-item-unit${cnt.index}" value="${item.unit}"></td>
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