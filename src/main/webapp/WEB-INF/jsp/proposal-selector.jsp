<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<div class="row">
	<div class="col-md-12">
		<div class="card mb-0">
			<div class="card-header bg-light d-flex justify-content-between">
				<span class="font-size-sm text-uppercase font-weight-semibold"><fmt:message key="content.proposal.info"/></span>
				<span class="font-size-sm text-uppercase text-success font-weight-semibold">&nbsp;</span>
			</div>
			<div class="card-body">
				<div class="table-responsive">
	               	<table id="tblSelectedNote" class="table table-bordered table-striped">
						<thead>
							<tr class="table-success">
								<th class="bgc-primary border-primary text-white" width="3%">#</th>
								<th class="bgc-primary border-primary text-white" width="30%"><fmt:message key="dailyAverageWeight.range" /></th>
								<th class="bgc-primary border-primary text-white" width="30%"><fmt:message key="dailyAverageWeight.quantity" /></th>
								<th class="bgc-primary border-primary text-white" width="30%"><fmt:message key="proposal.note" /></th>
								<th width="5%" class="text-center bgc-primary border-primary text-white"><i class="icon-menu-open2"></i></th>
							</tr>
						</thead>
						<tbody class="chimneyClone">
							<c:forEach begin="0" items="${contentProposalExistings}" var="item" varStatus="cnt">
								<tr id="rec-note${cnt.index}">
									<td><span class="no"><c:out value="${cnt.count+page.size*page.number}"></c:out></span><input type="hidden" class="index-table" value="${cnt.index}"/></td>
									<td>
										<select class="form-control selected-weight-range" name="contentProposals[${cnt.index}].range" id="select2${cnt.index}" data-placeholder="Chọn biểu cân" data-fouc></select>
										<input type="hidden" class="selected-weight" id="select-range${cnt.index}" value="${item.range}"/>
									</td>
									<td>
										<input type="number" name="contentProposals[${cnt.index}].quantity" class="form-control rounded-10 selected-item-quantity" id="selected-item-quantity${cnt.index}" value="${item.quantity}">
									</td>
									<td>
										<input type="text" id="selected-item-note${cnt.index}" name="contentProposals[${cnt.index}].note" value="${item.note}" class="form-control rounded-10" data-placeholder="Ghi chú"/>
									</td>
									<td class="text-center">
							        	<div class="list-icons">
											<button type="button" class="btn-primary btn-xs" onclick="addRow()" title="Add Row" style="display: inline-block; float: none; border: none"><i class="fa fa-plus "></i></button>
											<button type="button" class="btn-danger btn-xs" onclick="removeRow(${cnt.index})" title="Remove Row" style="display: inline-block; float: none; border: none"><i class="fa fa-times"></i></button>
							        	</div>
							        </td>
								</tr>
							</c:forEach> 
						</tbody>
					</table>  
				</div>
			</div>
		</div>
	</div>
</div>				
<br/>		