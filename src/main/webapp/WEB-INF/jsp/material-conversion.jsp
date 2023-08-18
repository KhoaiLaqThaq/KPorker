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
			<div class="table-responsive">
               	<table id="tblSelectedMaterials" class="table table-bordered table-striped">
					<thead>
						<tr class="table-success">
							<th width="3%">#</th>
							<th width="20%"><fmt:message key="material.conversion.numerator" /></th>
							<th width="20%"><fmt:message key="material.conversion.denominator" /></th>
							<th width="20%"><fmt:message key="material.conversion.meinh" /></th>
							<th width="20%"><fmt:message key="material.conversion.meinht" /></th>
						</tr>
					</thead>
					<tbody>
						<c:forEach begin="0" items="${unitConversions}" var="item" varStatus="cnt">
							<tr>
								<td><span class="no"><c:out value="${cnt.count+page.size*page.number}"></c:out></span></td>
								<td>${item.numerator}<input type="hidden" name="unitConversions[${cnt.index}].numerator" class="form-control" id="selected-item-numerator${cnt.index}" value="${item.numerator}"></td>
								<td>${item.denominator}<input type="hidden" name="unitConversions[${cnt.index}].denominator" class="form-control" id="selected-item-denominator${cnt.index}" value="${item.denominator}"></td>
								<td>${item.meinh}<input type="hidden" name="unitConversions[${cnt.index}].meinh" class="form-control" id="selected-item-denominator${cnt.index}" value="${item.meinh}"></td>
								<td>${item.meinht}<input type="hidden" name="unitConversions[${cnt.index}].meinht" class="form-control" id="selected-item-denominator${cnt.index}" value="${item.meinht}"></td>
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