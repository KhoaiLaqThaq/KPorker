<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<!-- <input type="hidden" name="weight" id="totalWeight" /> -->
<div class="row">
	<div class="col-md-12">
	<!-- Grey header and footer -->
	<div class="card">
		<div class="card-header bg-light d-flex justify-content-between">
			<span class="font-size-sm text-uppercase font-weight-semibold"><fmt:message key="material.info"/><span id="processOrderInfo"></span></span>
			<span class="font-size-sm text-uppercase text-success font-weight-semibold">&nbsp;</span>
		</div>
		<div class="card-body">
			<div class="row mb-3">
		        <div class="col-12">
		          <a href="#" onclick="showModal()"><fmt:message key="label.search"></fmt:message></a>
		        </div>
		    </div>
			<div class="table-responsive maxH-600 table-scroll">
               	<table id="tblSelectedMaterials"  class="table table-bordered table-striped">
					<thead>
						<tr class="table-success">
							<th class="bgc-primary border-primary text-white " width="3%">#</th>
							<th class="bgc-primary border-primary text-white text-center" width="5%"><i class="icon-menu-open2"></i></th>
							<th class="bgc-primary border-primary text-white mw-200 text-left"><fmt:message key="purchaserequisition.materialCode" /></th>
							<th class="bgc-primary border-primary text-white mw-300 text-left"><fmt:message key="material.suggest.name" /></th>
							<th class="bgc-primary border-primary text-white mw-200 text-left"><fmt:message key="purchaserequisition.batch" /></th>
							<th class="bgc-primary border-primary text-white mw-200 text-left"><fmt:message key="purchaserequisition.quantity" /></th>
							<th class="bgc-primary border-primary text-white mw-200 text-left"><fmt:message key="goodsissue.total.retained.quantity" /></th>
							<th class="bgc-primary border-primary text-white mw-100 text-left"><fmt:message key="goodAttrition.unit" /></th>
							<th class="bgc-primary border-primary text-white mw-200 text-left"><fmt:message key="material.status" /></th>
						</tr>
					</thead>
					<tbody class="material-container" id="dataMaterials">
		            	<c:forEach items="${materialExistings}" var="item" varStatus="cnt">
							<tr id = "rec-material${cnt.index }" class="showTr">
								<td><span class="no">${ cnt.count }</span></td>
								<td class="text-center">							
									<div class="list-icons">
										<button type="button" class="btn-danger btn-xs" onclick="javascript:MaterialSelector.removeRow(${cnt.index})" title="Remove Row" style="display: inline-block; float: none; border: none"><i class="fa fa-times"></i></button>
									</div>
								</td>
								<td><input type="text" class="form-control" name="materialDetails[${cnt.index}].code" id="${cnt.index}" value="${item.code}" readonly="readonly"></input>
									<input type="hidden" class="selected-code" value="${item.code}">
								</td>
								<td><input type="text" class="form-control" name="materialDetails[${cnt.index}].suggestName" id="selected-item-suggestName${cnt.index}" value="${item.suggestName}" readonly="readonly"></input>
									<input type="hidden" class="form-control" name="materialDetails[${cnt.index }].name" value="${item.name}" id="selected-item-name${cnt.index}"/>
									<input type="hidden" name="materialDetails[${cnt.index}].requiredBatch" class="form-control" id="selected-item-requiredBatch${cnt.index}" value="${item.requiredBatch}">
								</td>
								<td><input type="text" class="form-control" name="materialDetails[${cnt.index }].batch" value="${item.batch}" readonly="readonly" /></td>
								<td><input type="text" id="selected-item-actuallyExported${cnt.index}" class="form-control material-actuallyExported float" name="materialDetails[${cnt.index }].actuallyExported" value="${item.actuallyExported}" /><input type="hidden" class="index-table" value="${cnt.index}"></td>
								<td><input type="text" name="materialDetails[${cnt.index}].totalRetainedQuantity" class="form-control float" id="selected-item-totalRetainedQuantity${cnt.index}" value="${item.totalRetainedQuantity}" readonly="readonly"></td>
								<td><input type="text" class="form-control" name="materialDetails[${cnt.index }].unit" value="${item.unit}" readonly="readonly"/>
									<input type="hidden" class="form-control" name="materialDetails[${cnt.index }].type"  id="selected-item-type${cnt.index}" value="${item.type}"/>
									<input type="hidden" class="form-control" name="materialDetails[${cnt.index }].transCodeItem"  id="selected-item-transCodeItem${cnt.index}" value="${item.transCodeItem}"/>
								</td>
								<td><input type="text" name="materialDetails[${cnt.index}].status" class="form-control" id="selected-item-status${cnt.index}" value="${item.status}" readonly="readonly"></td>
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


<!-- Full width modal -->
<div id="searchMaterial" class="modal fade">
	<div class="modal-dialog modal-full" id="modal-full-overflow">
		<div class="modal-content">
			<div class="modal-header bg-primary">
				<h5 class="modal-title"><fmt:message key="material.search"/></h5>
			</div>
			<div class="modal-body" id="modal-overflow">
       			<div class="row">
				    <div class="col-md-3 col-sm-4">
					    <div class="form-group">
					       <label><fmt:message key="material.code" /></label>
                           <input type="text" name="materialCode" class="form-control" id="materialCode" placeholder="Nhập mã vật tư (SAP)..." value=""/>
					    </div>
				    </div>
				    <div class="col-md-3 col-sm-4">
                          <div class="form-group">
                             <label><fmt:message key="material.name" /></label>
                             <input type="text" name="materialName" class="form-control" id="materialName" placeholder="Nhập tên vật tư..." value=""/>
                          </div>
                    </div>
                    <div class="col-md-3 col-sm-4">
                          <div class="form-group">
                             <label><fmt:message key="material.suggest.name" /></label>
                             <input type="text" name="materialSuggestName" class="form-control" id="materialSuggestName" placeholder="Nhập tên thường dùng..." value=""/>
                          </div>
                    </div>
                    <%-- <div class="col-md-3 col-sm-4">
                          <div class="form-group">
                             <label><fmt:message key="material.fastcode" /></label>
                             <input type="text" name="materialFastCode" class="form-control" id="materialFastCode" placeholder="Nhập mã fast..." value=""/>
                          </div>
                    </div> --%>
                    <div class="col-md-3 col-sm-4">
                          <div class="form-group">
                             <label><fmt:message key="material.batch" /></label>
                             <input type="text" name="materialBatch" class="form-control" id="materialBatch" placeholder="Nhập lô..." value=""/>
                          </div>
                    </div>
       			</div>
       			<div class="row text-right">
       				<div class="col-md-12 col-sm-12">
                        <div class="form-group mt-4">
                            <button type="button" id="btnSearchMaterial" class="btn btn-primary"><fmt:message key="material.search" /></button>
                        </div>
                    </div>
       			</div>
       			<hr>
       			<div class="row">
					<div class="col-md-12">
						<div class="table-responsive maxH-300 table-scroll">
				              	<table id="tblMaterials" class="table table-bordered table-striped">
								<thead>
									<tr class="table-success">
										<th width="5%"><input type="checkbox" class="wh-20" name="checkAll" id="checkAll"></th>
										<th class="mw-200 text-left"><fmt:message key="purchaserequisition.materialCode" /></th>
										<th class="mw-300 text-left"><fmt:message key="material.suggest.name" /></th>
										<th class="mw-200 text-left"><fmt:message key="material.fastcode" /></th>
										<th class="text-left" style="min-width: 165px;"><fmt:message key="purchaserequisition.batch" /></th>
										<th class="text-left" style="min-width: 165px;"><fmt:message key="purchaserequisition.quantity" /></th>
										<th class="text-left" style="min-width: 165px;"><fmt:message key="goodsissue.total.retained.quantity" /></th>
										<th class="text-left" style="min-width: 185px;"><fmt:message key="purchaserequisition.unit" /></th>
										<th class="mw-300 text-left"><fmt:message key="purchaserequisition.materialName" /></th>
									</tr>
								</thead>
								<tbody id="bodySearchMaterial">
								</tbody>
							</table>
						</div>
					</div>
				</div>
				<br/>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-link" id="closeModal" data-dismiss="modal">Close</button>
				<button type="button" class="btn bg-primary" id="btnAddMaterial"><fmt:message key="button.add.material"/></button>
			</div>
		</div>
	</div>
</div>
<!-- /full width modal -->