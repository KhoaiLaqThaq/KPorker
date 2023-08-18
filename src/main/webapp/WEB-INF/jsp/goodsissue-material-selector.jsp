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
							<th class="bgc-primary border-primary text-white " width="1%">#</th>
							<th class="bgc-primary border-primary text-white text-center icon_head mw-100"><i class="icon-menu-open2"></i></th>
							<th class="bgc-primary border-primary text-white mw-300"><fmt:message key="material.search.name" /></th>
							<th class="bgc-primary border-primary text-white mw-300"><fmt:message key="purchaserequisition.materialName" /></th>
							<th class="bgc-primary border-primary text-white mw-200"><fmt:message key="purchaserequisition.batch" /></th>
							<th class="bgc-primary border-primary text-white mw-200"><fmt:message key="purchaserequisition.quantity" /></th>
							<th class="bgc-primary border-primary text-white mw-200"><fmt:message key="goodsissue.total.retained.quantity" /></th>
							<th class="bgc-primary border-primary text-white mw-200"><fmt:message key="purchaserequisition.unit" /></th>
							<th class="bgc-primary border-primary text-white mw-200"><fmt:message key="goodsissue.grossweight" /></th>
							<th class="bgc-primary border-primary text-white mw-200"><fmt:message key="goodsissue.weightUnit" /></th>
							<th class="bgc-primary border-primary text-white mw-200"><fmt:message key="purchaserequisition.manufacturedDate" /></th>
							<th class="bgc-primary border-primary text-white mw-200"><fmt:message key="purchaserequisition.expiredDate" /></th>
							<th class="bgc-primary border-primary text-white mw-100"><fmt:message key="material.purchasingGroup" /></th>
						</tr>
					</thead>
					<tbody>
						<c:choose>
							<c:when test = "${not empty goodsIssue.goodsRequisitionId}">
				            	<c:forEach begin="0" items="${materialExistings}" var="item" varStatus="cnt">
										<tr id="rec-material${cnt.index}">
										<td><span class="no"><c:out value="${cnt.count+page.size*page.number}"></c:out></span></td>
										<c:if test ="${empty goodsIssue.id || goodsIssue.type eq 'template'}">
											<td class="text-center icon">
									        	<div class="list-icons">
										        	<button type="button" class="btn-primary btn-xs addRow" onclick="javascript:MaterialSelector.addRow()" title="Add Row" style="display: inline-block; float: none; border: none">
														<i class="fa fa-plus "></i>
													</button>
													<button type="button" class="btn-danger btn-xs" onclick="javascript:MaterialSelector.removeRow(${cnt.index})" title="Remove Row" style="display: inline-block; float: none; border: none">
														<i class="fa fa-times"></i>
													</button>
									        	</div>
									        </td>
										</c:if>
										<td><select class="form-control selected-material-code" name="materialDetails[${cnt.index}].code" id="${cnt.index}" data-placeholder="Chọn vật tư" data-fouc></select><input type="hidden" class="selected-code" value="${item.code}"></td>
										<td>
											<input type="text" name="materialDetails[${cnt.index}].name" class="form-control" id="selected-item-name${cnt.index}" value="${item.name}" readonly="readonly">
											<input type="hidden" name="materialDetails[${cnt.index}].batch" class="form-control" id="selected-item-batch${cnt.index}" value="${item.batch}">	
											<input type="hidden" name="materialDetails[${cnt.index}].groupCode" class="form-control" id="selected-item-groupCode${cnt.index}" value="${item.groupCode}">
											<input type="hidden" name="materialDetails[${cnt.index}].groupName" class="form-control" id="selected-item-groupName${cnt.index}" value="${item.groupName}">
											<input type="hidden" name="materialDetails[${cnt.index}].itemNum" class="form-control" id="selected-item-itemNum${cnt.index}" value="${item.itemNum}">
											<input type="hidden" name="materialDetails[${cnt.index}].requiredBatch" class="form-control" id="selected-item-requiredBatch${cnt.index}" value="${item.requiredBatch}">
											<input type="hidden" name="materialDetails[${cnt.index}].retained" class="form-control float" id="selected-item-retained${cnt.index}" value="${item.retained}">
											<input type="hidden" name="materialDetails[${cnt.index}].weight" class="form-control" id="selected-item-weight${cnt.index}" value="${item.weight}">
											<input type="hidden" name="materialDetails[${cnt.index}].quantity" class="form-control float" id="selected-item-quantity${cnt.index}" value="${item.quantity}">
										</td>
										<td>
											<select	id="selected-batch${cnt.index}" class="form-control select2" data-placeholder="chọn mã lô" onchange="changeBatch(${cnt.index})">
												<c:forEach items="${item.batchs }" var="materialBatch">
													<c:set var="arr" value="${fn:split(materialBatch, ':/')}" />
													<option value="${materialBatch}" ${item.batch == arr[0] ? 'selected' : '' }><c:out value = "${arr[0]}"/></option>
												</c:forEach>
											</select>
										</td>
									   <c:choose>
									         <c:when test ="${empty goodsIssue.id }">
									           <td><input type="text" name="materialDetails[${cnt.index}].actuallyExported" class="form-control float" id="selected-item-actuallyExported${cnt.index}" value="${item.retained}"><input type="hidden" id="val-item-actuallyExported${cnt.index}" value="${item.retained}"></td>
									         </c:when>
									         <c:otherwise>
									            <td><input type="text" name="materialDetails[${cnt.index}].actuallyExported" class="form-control float" id="selected-item-actuallyExported${cnt.index}" value="${item.actuallyExported}"><input type="hidden" id="val-item-actuallyExported${cnt.index}" value="${item.actuallyExported}"></td>
									         </c:otherwise>
									    </c:choose>
									    <td><input type="text" name="materialDetails[${cnt.index}].totalRetainedQuantity" class="form-control float" id="selected-item-totalRetainedQuantity${cnt.index}" value="${item.totalRetainedQuantity}" readonly="readonly"></td>
										<td><input type="text" name="materialDetails[${cnt.index}].unit" class="form-control" id="selected-item-unit${cnt.index}" value="${item.unit}" readonly="readonly"></td>
										<td><input type="text" name="materialDetails[${cnt.index}].grossWeight" class="form-control float" id="selected-item-grossWeight${cnt.index}" value="${item.grossWeight}"></td>
										<td><input type="text" name="materialDetails[${cnt.index}].weightUnit" class="form-control" id="selected-item-weightUnit${cnt.index}" value="${item.weightUnit}"></td>
										<td><input type="text" name="materialDetails[${cnt.index}].manufacturedDateStr" class="form-control" id="selected-item-manufacturedDate${cnt.index}" value="${item.manufacturedDateStr}" placeholder="dd.mm.yyyy"></td>
										<td><input type="text" name="materialDetails[${cnt.index}].expiredDateStr" class="form-control" id="selected-item-expiredDate${cnt.index}" value="${item.expiredDateStr}" placeholder="dd.mm.yyyy"><input type="hidden" class="index-table" value="${cnt.index}"></td>
										<td><input type="text" name="materialDetails[${cnt.index}].purchasingGroup" class="form-control" id="selected-item-purchasingGroup${cnt.index}" value="${item.purchasingGroup}" readonly="readonly"></td>
									</tr>
								</c:forEach>
				         	</c:when>
				         	<c:when test = "${empty materialExistings}">
				            	<c:forEach begin="0" items="${materialExistings}" var="item" varStatus="cnt">
										<tr id="rec-material${cnt.index}">
										<td><span class="no"><c:out value="${cnt.count+page.size*page.number}"></c:out></span></td>
										<c:if test ="${empty goodsIssue.id || goodsIssue.type eq 'template'}">
											<td class="text-center icon">
									        	<div class="list-icons">
										        	<button type="button" class="btn-primary btn-xs addRow" onclick="javascript:MaterialSelector.addRow()" title="Add Row" style="display: inline-block; float: none; border: none">
														<i class="fa fa-plus "></i>
													</button>
													<button type="button" class="btn-danger btn-xs" onclick="javascript:MaterialSelector.removeRow(${cnt.index})" title="Remove Row" style="display: inline-block; float: none; border: none">
														<i class="fa fa-times"></i>
													</button>
									        	</div>
									        </td>
										</c:if>
										<td><select class="form-control selected-material-code" name="materialDetails[${cnt.index}].code" id="${cnt.index}" data-placeholder="Chọn vật tư" data-fouc></select><input type="hidden" class="selected-code" value="${item.code}"></td>
										<td>
											<input type="text" name="materialDetails[${cnt.index}].name" class="form-control" id="selected-item-name${cnt.index}" value="${item.name}" readonly="readonly">
											<input type="hidden" name="materialDetails[${cnt.index}].groupCode" class="form-control" id="selected-item-groupCode${cnt.index}" value="${item.groupCode}">
											<input type="hidden" name="materialDetails[${cnt.index}].groupName" class="form-control" id="selected-item-groupName${cnt.index}" value="${item.groupName}">
											<input type="hidden" name="materialDetails[${cnt.index}].itemNum" class="form-control" id="selected-item-itemNum${cnt.index}" value="${item.itemNum}">
											<input type="hidden" name="materialDetails[${cnt.index}].requiredBatch" class="form-control" id="selected-item-requiredBatch${cnt.index}" value="${item.requiredBatch}">
											<input type="hidden" name="materialDetails[${cnt.index}].retained" class="form-control float" id="selected-item-retained${cnt.index}" value="${item.retained}">
											<input type="hidden" name="materialDetails[${cnt.index}].weight" class="form-control float" id="selected-item-weight${cnt.index}" value="${item.weight}">
											<input type="hidden" name="materialDetails[${cnt.index}].quantity" class="form-control float" id="selected-item-quantity${cnt.index}" value="${item.quantity}">
										</td>
										<td><input type="text" name="materialDetails[${cnt.index}].batch" class="form-control" id="selected-item-batch${cnt.index}" value="${item.batch}">
										</td>
									   <c:choose>
									         <c:when test ="${empty goodsIssue.id }">
									           <td><input type="text" name="materialDetails[${cnt.index}].actuallyExported" class="form-control float" id="selected-item-actuallyExported${cnt.index}" value="${item.retained}"><input type="hidden" id="val-item-actuallyExported${cnt.index}" value="${item.retained}"></td>
									         </c:when>
									         <c:otherwise>
									            <td><input type="text" name="materialDetails[${cnt.index}].actuallyExported" class="form-control float" id="selected-item-actuallyExported${cnt.index}" value="${item.actuallyExported}"><input type="hidden" id="val-item-actuallyExported${cnt.index}" value="${item.actuallyExported}"></td>
									         </c:otherwise>
									    </c:choose>
									    <td><input type="text" name="materialDetails[${cnt.index}].totalRetainedQuantity" class="form-control float" id="selected-item-totalRetainedQuantity${cnt.index}" value="${item.totalRetainedQuantity}" readonly="readonly"></td>
										<td><input type="text" name="materialDetails[${cnt.index}].unit" class="form-control" id="selected-item-unit${cnt.index}" value="${item.unit}" readonly="readonly"></td>
										<td><input type="text" name="materialDetails[${cnt.index}].grossWeight" class="form-control float" id="selected-item-grossWeight${cnt.index}" value="${item.grossWeight}"></td>
										<td><input type="text" name="materialDetails[${cnt.index}].weightUnit" class="form-control" id="selected-item-weightUnit${cnt.index}" value="${item.weightUnit}"></td>
										<td><input type="text" name="materialDetails[${cnt.index}].manufacturedDateStr" class="form-control" id="selected-item-manufacturedDate${cnt.index}" value="${item.manufacturedDateStr}" placeholder="dd.mm.yyyy"></td>
										<td><input type="text" name="materialDetails[${cnt.index}].expiredDateStr" class="form-control" id="selected-item-expiredDate${cnt.index}" value="${item.expiredDateStr}" placeholder="dd.mm.yyyy"><input type="hidden" class="index-table" value="${cnt.index}"></td>
										<td><input type="text" name="materialDetails[${cnt.index}].purchasingGroup" class="form-control" id="selected-item-purchasingGroup${cnt.index}" value="${item.purchasingGroup}" readonly="readonly"></td>
									</tr>
								</c:forEach>
				         	</c:when>
				        	 <c:otherwise>
					        	 <c:forEach begin="0" items="${materialExistings}" var="item" varStatus="cnt">
										<tr id="rec-material${cnt.index}">
										<td><span class="no"><c:out value="${cnt.count+page.size*page.number}"></c:out></span></td>
										<c:if test ="${empty goodsIssue.id || goodsIssue.type eq 'template'}">
											<td class="text-center icon">
									        	<div class="list-icons">
										        	<button type="button" class="btn-primary btn-xs addRow" onclick="javascript:MaterialSelector.addRow()" title="Add Row" style="display: inline-block; float: none; border: none">
														<i class="fa fa-plus "></i>
													</button>
													<button type="button" class="btn-danger btn-xs" onclick="javascript:MaterialSelector.removeRow(${cnt.index})" title="Remove Row" style="display: inline-block; float: none; border: none">
														<i class="fa fa-times"></i>
													</button>
									        	</div>
									        </td>
										</c:if>
										<td><select class="form-control selected-material-code" name="materialDetails[${cnt.index}].code" id="${cnt.index}" data-placeholder="Chọn vật tư" data-fouc></select><input type="hidden" class="selected-code" value="${item.code}"></td>
										<td><input type="text" name="materialDetails[${cnt.index}].name" class="form-control" id="selected-item-name${cnt.index}" value="${item.name}" readonly="readonly">
											<input type="hidden" name="materialDetails[${cnt.index}].groupCode" class="form-control" id="selected-item-groupCode${cnt.index}" value="${item.groupCode}">
											<input type="hidden" name="materialDetails[${cnt.index}].groupName" class="form-control" id="selected-item-groupName${cnt.index}" value="${item.groupName}">
											<input type="hidden" name="materialDetails[${cnt.index}].itemNum" class="form-control" id="selected-item-itemNum${cnt.index}" value="${item.itemNum}">
											<input type="hidden" name="materialDetails[${cnt.index}].requiredBatch" class="form-control" id="selected-item-requiredBatch${cnt.index}" value="${item.requiredBatch}">
											<input type="hidden" name="materialDetails[${cnt.index}].retained" class="form-control float" id="selected-item-retained${cnt.index}" value="${item.retained}">
											<input type="hidden" name="materialDetails[${cnt.index}].weight" class="form-control float" id="selected-item-weight${cnt.index}" value="${item.weight}">
											<input type="hidden" name="materialDetails[${cnt.index}].quantity" class="form-control float" id="selected-item-quantity${cnt.index}" value="${item.quantity}">
										</td>
										<td><input type="text" name="materialDetails[${cnt.index}].batch" class="form-control" id="selected-item-batch${cnt.index}" value="${item.batch}">
										</td>
									   <c:choose>
									         <c:when test ="${empty goodsIssue.id }">
									           <td><input type="text" name="materialDetails[${cnt.index}].actuallyExported" class="form-control float" id="selected-item-actuallyExported${cnt.index}" value="${item.retained}"><input type="hidden" id="val-item-actuallyExported${cnt.index}" value="${item.retained}"></td>
									         </c:when>
									         <c:otherwise>
									            <td><input type="text" name="materialDetails[${cnt.index}].actuallyExported" class="form-control float" id="selected-item-actuallyExported${cnt.index}" value="${item.actuallyExported}"><input type="hidden" id="val-item-actuallyExported${cnt.index}" value="${item.actuallyExported}"></td>
									         </c:otherwise>
									    </c:choose>
									    <td><input type="text" name="materialDetails[${cnt.index}].totalRetainedQuantity" class="form-control float" id="selected-item-totalRetainedQuantity${cnt.index}" value="${item.totalRetainedQuantity}" readonly="readonly"></td>
										<td><input type="text" name="materialDetails[${cnt.index}].unit" class="form-control" id="selected-item-unit${cnt.index}" value="${item.unit}" readonly="readonly"></td>
										<td><input type="text" name="materialDetails[${cnt.index}].grossWeight" class="form-control float" id="selected-item-grossWeight${cnt.index}" value="${item.grossWeight}"></td>
										<td><input type="text" name="materialDetails[${cnt.index}].weightUnit" class="form-control" id="selected-item-weightUnit${cnt.index}" value="${item.weightUnit}"></td>
										<td><input type="text" name="materialDetails[${cnt.index}].manufacturedDateStr" class="form-control" id="selected-item-manufacturedDate${cnt.index}" value="${item.manufacturedDateStr}" placeholder="dd.mm.yyyy"></td>
										<td><input type="text" name="materialDetails[${cnt.index}].expiredDateStr" class="form-control" id="selected-item-expiredDate${cnt.index}" value="${item.expiredDateStr}" placeholder="dd.mm.yyyy"><input type="hidden" class="index-table" value="${cnt.index}"></td>
										<td><input type="text" name="materialDetails[${cnt.index}].purchasingGroup" class="form-control" id="selected-item-purchasingGroup${cnt.index}" value="${item.purchasingGroup}" readonly="readonly"></td>
									</tr>
								</c:forEach>
				         	</c:otherwise>
				      	</c:choose>
					</tbody>
				</table>            	
			</div>
      			
		</div>
		
	</div>
	<!-- /grey header and footer -->
	</div>
</div>
<br/>		