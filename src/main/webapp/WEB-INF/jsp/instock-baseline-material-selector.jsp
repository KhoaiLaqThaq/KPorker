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
		    <div class="row mb-3">
		        <div class="col-12">
		          <a data-toggle="collapse" href="#searchCollapse" role="button" aria-expanded="false" class="text-decoration-underline" aria-controls="searchCollapse"><fmt:message key="label.search"></fmt:message></a>
		        </div>
		        <div class="col-12 collapse" id="searchCollapse">
					  <div class="row">
					    <div class="col-md-5 col-sm-4">
						    <div class="form-group">
						       <label><fmt:message key="purchaserequisition.materialName" /></label>
	                           <input type="text" name="materialName" class="form-control" id="materialName"/>
						    </div>
					    </div>
					    <div class="col-md-5 col-sm-4">
                            <div class="form-group">
                               <label><fmt:message key="material.purchasingGroup" /></label>
                               <input type="text" name="materialPurchasingGroup" class="form-control" id="materialPurchasingGroup"/>
                            </div>
                        </div>
                        <div class="col-md-2 col-sm-2">
                            <div class="form-group mt-4">
                                <!-- <button type="button" id="btnResetForm" class="btn">Reset</button> -->
                                <button type="button" id="btnSearch" class="btn btn-primary">Search</button>
                            </div>
                        </div>
					  </div>
		        
		        </div>
		    </div>
			<div class="table-responsive maxH-600 table-scroll">  
               	<table id="tblSelectedMaterials" class="table table-bordered table-striped">
					<thead>
						<tr class="table-success">
							<th width="1%">#</th>
							<th class="mw-200"><fmt:message key="purchaserequisition.materialCode" /></th>
							<th class="mw-300"><fmt:message key="purchaserequisition.materialName" /></th>
							<th class="mw-100"><fmt:message key="goods.requisition..quantity" /></th>
							<th class="mw-100"><fmt:message key="purchaserequisition.unit" /></th>
							<th class="mw-200"><fmt:message key="purchaserequisition.batch" /></th>
							<th class="mw-100"><fmt:message key="instock.groupCode" /></th>
							<th class="mw-200"><fmt:message key="instock.groupName" /></th>
							<th class="mw-100"><fmt:message key="material.purchasingGroup" /></th>
							<th class="mw-200"><fmt:message key="purchaserequisition.manufacturedDate" /></th>
							<th class="mw-200"><fmt:message key="purchaserequisition.expiredDate" /></th>
						</tr>
					</thead>
					<tbody id="dataMaterials">
						<c:forEach begin="0" items="${materialExistings}" var="item" varStatus="cnt">
							<tr id="rec-material${cnt.index}" class="tr">
								<td><span class="no"><c:out value="${cnt.count+page.size*page.number}"></c:out></span></td>
								<td>${item.code}</td>
								<td>${item.name}</td>
								<td>${item.quantity}</td>
								<td>${item.unit}</td>
								<td>${item.batch}</td>
								<td>${item.groupCode}</td>
								<td>${item.groupName}</td>
								<td>${item.purchasingGroup}</td>
								<td>${item.manufacturedDateStr}</td>
								<td>${item.expiredDateStr}</td>
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