<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<!-- <input type="hidden" name="weight" id="totalWeight" /> -->
<div class="row">
	<div class="col-md-12">
	<!-- Grey header and footer -->
	<div class="card">
		<div class="card-header bg-light d-flex justify-content-between">
			<span class="font-size-sm text-uppercase font-weight-semibold"><fmt:message key="material.info"/></span>
			<span class="font-size-sm text-uppercase text-success font-weight-semibold">&nbsp;</span>
		</div>
		<div class="card-body">
			<div class="table-responsive">
               	<table id="tblSelectedMaterials"  class="table table-bordered table-striped table-scroll-x">
					<thead>
						<tr class="table-success">
							<th width="3%">#</th>
							<th width="5%" class="text-center"><i class="icon-menu-open2"></i></th>
							<th class="mw-300" class = "text-left"><fmt:message key="purchaserequisition.materialCode" /></th>
							<th class="mw-300" class = "text-left"><fmt:message key="purchaserequisition.materialName" /></th>
							<th class="mw-300" class = "text-left"><fmt:message key="purchaserequisition.batch" /></th>
							<th class="mw-300" class = "text-left"><fmt:message key="purchaserequisition.quantity" /></th>
							<th class="mw-300" class = "text-left"><fmt:message key="goodAttrition.unit" /></th>
							
						</tr>
					</thead>
					<tbody class="material-container">
						<c:choose>
							<c:when test = "${not empty goodsIssue.id}">
				            	<c:forEach items="${materialExistings}" var="item" varStatus="cnt">
									<tr id = "rec-material${cnt.index }">
										<td><span class="no">${ cnt.count }</span></td>
										<td class="text-center">							
											<div class="list-icons">
			 									<button type="button" class="btn-primary btn-xs" onclick="javascript:MaterialSelector.addRow()" title="Add Row" style="display: inline-block; float: none; border: none"><i class="fa fa-plus "></i></button>
												<button type="button" class="btn-danger btn-xs" onclick="javascript:MaterialSelector.removeRow(${cnt.index})" title="Remove Row" style="display: inline-block; float: none; border: none"><i class="fa fa-times"></i></button>
											</div>
										</td>
										<td><select class="form-control selected-material-code" name="materials[${cnt.index}].code" id="${cnt.index}" data-placeholder="Chọn vật tư" data-fouc></select>
											<input type="hidden" class="selected-code" value="${item.code}">
										</td>
										<td><input type="text" class="form-control" name="materials[${cnt.index }].name" value="${item.name}" id="selected-item-name${cnt.index}"/>
											<input type="hidden" name="materials[${cnt.index}].requiredBatch" class="form-control" id="selected-item-requiredBatch${cnt.index}" value="${item.requiredBatch}">
										</td>
										<td><input type="text" class="form-control" name="materials[${cnt.index }].batch" value="${item.batch}"  /></td>
										<td><input type="text" id="selected-item-actuallyExported${cnt.index}" class="form-control material-actuallyExported" name="materials[${cnt.index }].actuallyExported" value="${item.actuallyExported}" /><input type="hidden" class="index-table" value="${cnt.index}"></td>
										<td><input type="text" class="form-control" name="materials[${cnt.index }].unit" value="${item.unit}" /></td>
									</tr>
								</c:forEach>
				         	</c:when>
				         	<c:when test = "${empty materialExistings}">
				            	<c:forEach items="${materialExistings}" var="item" varStatus="cnt">
									<tr id = "rec-material${cnt.index }">
										<td><span class="no">${ cnt.count }</span></td>
										<td class="text-center">							
											<div class="list-icons">
			 									<button type="button" class="btn-primary btn-xs" onclick="javascript:MaterialSelector.addRow()" title="Add Row" style="display: inline-block; float: none; border: none"><i class="fa fa-plus "></i></button>
												<button type="button" class="btn-danger btn-xs" onclick="javascript:MaterialSelector.removeRow(${cnt.index})" title="Remove Row" style="display: inline-block; float: none; border: none"><i class="fa fa-times"></i></button>
											</div>
										</td>
										<td><select class="form-control selected-material-code" name="materials[${cnt.index}].code" id="${cnt.index}" data-placeholder="Chọn vật tư" data-fouc></select>
											<input type="hidden" class="selected-code" value="${item.code}">
										</td>
										<td><input type="text" class="form-control" name="materials[${cnt.index }].name" value="${item.name}" id="selected-item-name${cnt.index}"/>
											<input type="hidden" name="materials[${cnt.index}].requiredBatch" class="form-control" id="selected-item-requiredBatch${cnt.index}" value="${item.requiredBatch}">
										</td>
										<td><input type="text" class="form-control" name="materials[${cnt.index }].batch" value="${item.batch}"  /></td>
										<td><input type="text" id="selected-item-actuallyExported${cnt.index}" class="form-control material-actuallyExported" name="materials[${cnt.index }].actuallyExported" value="${item.actuallyExported}" /><input type="hidden" class="index-table" value="${cnt.index}"></td>
										<td><input type="text" class="form-control" name="materials[${cnt.index }].unit" value="${item.unit}" /></td>
									</tr>
								</c:forEach>
				         	</c:when>
				        	 <c:otherwise>
					        	 <c:forEach items="${materialExistings}" var="item" varStatus="cnt">
									<tr id = "rec-material${cnt.index }">
										<td><span class="no">${ cnt.count }</span></td>
										<td class="text-center">							
											<div class="list-icons">
			 									<button type="button" class="btn-primary btn-xs" onclick="javascript:MaterialSelector.addRow()" title="Add Row" style="display: inline-block; float: none; border: none"><i class="fa fa-plus "></i></button>
												<button type="button" class="btn-danger btn-xs" onclick="javascript:MaterialSelector.removeRow(${cnt.index})" title="Remove Row" style="display: inline-block; float: none; border: none"><i class="fa fa-times"></i></button>
											</div>
										</td>
										<td><select class="form-control selected-material-code" name="materials[${cnt.index}].code" id="${cnt.index}" data-placeholder="Chọn vật tư" data-fouc></select>
											<input type="hidden" class="selected-code" value="${item.code}">
										</td>
										<td><input type="text" class="form-control" name="materials[${cnt.index }].name" value="${item.name}" id="selected-item-name${cnt.index}" />
											<input type="hidden" name="materials[${cnt.index}].requiredBatch" class="form-control" id="selected-item-requiredBatch${cnt.index}" value="${item.requiredBatch}">
										</td>
										<td>
											<select	id="selected-item-batch${cnt.index}" name="materials[${cnt.index}].batch" class="form-control select2" data-placeholder="chọn mã lô">
												<c:forEach items="${item.batchs }" var="materialBatch">
													<option value="${materialBatch}" ${item.batch == materialBatch ? 'selected' : '' }><c:out value = "${materialBatch}"/></option>
												</c:forEach>
											</select>
										</td>
										<td><input type="text" id="selected-item-actuallyExported${cnt.index}" class="form-control material-actuallyExported" name="materials[${cnt.index }].actuallyExported" value="${item.actuallyExported}" /><input type="hidden" class="index-table" value="${cnt.index}"></td>
										<td>
											<select	id="selected-item-unit${cnt.index}" name="materials[${cnt.index }].unit" class="form-control select2" data-placeholder="chọn đơn vị tính">
												<c:forEach items="${item.units }" var="materialUnit">
													<option value="${materialUnit}" ${item.unit == materialUnit ? 'selected' : '' }><c:out value = "${materialUnit}"/></option>
												</c:forEach>
											</select>
										</td>
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
