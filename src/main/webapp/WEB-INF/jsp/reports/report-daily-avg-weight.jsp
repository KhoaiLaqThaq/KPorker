<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="menu.report.dailyaverageweight"/></title>
    <meta name="menu" content="reportDailyAverageWeight"/>
	<link href="<c:url value='/themes/admin/assets/css/components.min.css'/>" rel="stylesheet" type="text/css" />
    <link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">

    <link href="<c:url value='/themes/admin/assets/css/material-support.css'/>" rel="stylesheet" type="text/css">
    <link href="<c:url value='/themes/admin/assets/css/colors.min.css'/>" rel="stylesheet" type="text/css">
    
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
    <!-- Multi select -->
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/uniform.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/pnotify.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/bootstrap_multiselect.js'/>"></script>
    
    <script src="<c:url value='/themes/admin/global_assets/js/demo_pages/form_multiselect.js'/>"></script>
    
    <!-- Datepicker -->
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/ui/moment/moment.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/daterangepicker.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/anytime.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.date.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.time.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/legacy.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/jgrowl.min.js'/>"></script>
    
    <script src="<c:url value='/themes/admin/global_assets/js/demo_pages/picker_date.js'/>"></script>
    
</head>

<div class="content">
<form:form id="reportInstockForm" modelAttribute="criteria" action="/report/daily-average-weight"  method="post">
	<input type="hidden" id="barnCodeStrSelected" value="${criteria.barnCodeStr}"/>
	<input type="hidden" id="rangeStrSelected" value="${criteria.weightRangeStr}"/>
	<!-- \Searching -->
	<input type="hidden" value="${criteria.processOrderCode}" id="poCodeHidden"/>
	<div class="card rounded-16">
		<div class="row">
			<div class="col-6 px-3 py-2 fw-bold"><fmt:message key="label.search" /></div>
			<div class="col-6 text-right">
				<button type="button" class="btn btn-secondary mt-2 mr-2" id="btnReset">Đặt lại</button>
				<button type="submit" id="btnSubmit" class="btn btn-secondary mt-2 mr-2"><i class="icon-search4 mr-2"></i><fmt:message key="button.search"/></button>
			</div>
		</div>
        <div class="card-body py-0">
            <div class="row">
                <div class="col-md-3 col-sm-6 col-xs-12">
                    <div class="form-group">
                        <label>Trại:<span class="text-danger"> *</span></label>
                        <select class="form-control" name="farmCodes[]" multiple="multiple" id="stockSelect" data-placeholder="Chọn trại...">
	                        <c:if test="${not empty farms}">
	                            <c:forEach var="farm" items="${farms}">
	                            	<option value="${farm.code}" ${fn:contains(criteria.farmCodesStr , farm.code) ? 'selected' : ''}>${farm.name}</option>
	                            </c:forEach>
	                        </c:if>
	                    </select>
                    </div>
                </div>
                <div class="col-md-3 col-sm-6 col-xs-12">
                    <div class="form-group">
                        <label>Chuồng:<span class="text-danger"> *</span></label>
                        <select class="form-control multiselect-select-all-filtering" disabled="true" name="barnCodes[]" multiple="multiple" id="barnSelect" data-placeholder="Chọn chuồng..."></select>
                    </div>
                </div>
				<div class="col-12 col-sm-6 col-md-3">
					<label>Ngày đặt báo cáo:<span class="text-danger"> *</span></label>
					<div class="input-group">
                        <span class="input-group-prepend">
                            <span class="input-group-text"><i class="icon-calendar22"></i></span>
                        </span>
						<input type="text" id="stage" name="stage" placeholder="Ngày ghi nhận sự kiện" value="${criteria.stage }" autocomplete="off" class="form-control" >
					</div>
				</div>
				<div class="col-12 col-sm-6 col-md-3">
					<div class="form-group">
						<label>Biểu Cân:</label>
						<select class="form-control multiselect-select-all-filtering" name="weightRange[]" multiple="multiple" id="weightRange" data-placeholder="Chọn biểu cân...">

							<c:if test="${not empty ranges}">
								<c:forEach var="range" items="${ranges}">
									<option value="${range}" ${fn:contains(criteria.weightRangeStr , range) ? 'selected' : ''}>${range}</option>
								</c:forEach>
							</c:if>
						</select>
					</div>
				</div>
            </div>
        </div>
    </div>
    <!-- /Searching -->

	<div class="row mb-3">
		<div class="col-12 col-md-6">
			<div class="text-color-primary fs-5"><fmt:message key="report.dailyaverageweight" /><span class="text-warning font-weight-bold"><fmt:message key="report.pr.suggest" /></span></div>
		</div>
		<div class="col-12 col-md-6 text-right">
			<a href="/report/daily-average-weight-export-excel" id="exportReportDailyAverageWeight" class="btn bgc-warning text-white"><i class="icon-database-export pr-2"></i>Xuất báo cáo</a>
		</div>
	</div>
	    
	<!-- \Table -->
	<div class="card">
		<div class="table-responsive">
				            <table class="table table-bordered table-hover">
	                <thead>
	                    <tr class="table-success">
	                    	<th id="expandAll" class="bgc-primary border-primary text-white text-center expandAll"> <i class="icon-arrow-down5"></i></th>
	                        <th class="bgc-primary border-primary text-white text-center">STT</th>
	                        <th class="bgc-primary border-primary text-white text-center"><fmt:message key="report.table.th.processOrder"></fmt:message></th>
	                        <th class="bgc-primary border-primary text-white text-center"><fmt:message key="processOrder.pigType"></fmt:message></th>
	                        <th class="bgc-primary border-primary text-white text-center"><fmt:message key="report.table.th.chuong"></fmt:message></th>
	                        <th class="bgc-primary border-primary text-white text-center"><fmt:message key="report.dailyaverageweight.table.th.bieuheo" /></th>
	                        <th class="bgc-primary border-primary text-white text-center"><fmt:message key="report.dailyaverageweight.table.th.amount" /></th>
	                        <th class="bgc-primary border-primary text-white text-center"><fmt:message key="report.dailyaverageweight.table.th.weigh" /></th>
	                        <th class="bgc-primary border-primary text-white text-center"><fmt:message key="report.dailyaverageweight.table.th.avgWeight" /></th>
	                        <th class="bgc-primary border-primary text-white text-center"><fmt:message key="report.dailyaverageweight.table.th.amount" /></th>
	                        <th class="bgc-primary border-primary text-white text-center"><fmt:message key="report.dailyaverageweight.table.th.weigh" /></th>
	                        <th class="bgc-primary border-primary text-white text-center"><fmt:message key="report.dailyaverageweight.table.th.avgWeight" /></th>
	                    </tr>
	                </thead>
	                <tbody id="tbodyReportInstock">
						<c:forEach items="${report.weightNotes}" var="note" varStatus="cnt">
							<c:choose>
								<c:when test="${empty note.weightCharts}">
									<tr class="header table-active expand">
										<td class="text-center spanButton"> <i class="icon-arrow-down5"></i></td>
			                        	<td class="text-center counter">${cnt.count}</td>
			                        	<td class="text-center poCode">${note.processOrderCode}</td>
			                        	<td class="text-center pigType">${note.pigType }</td>
			                        	<td class="text-center barnName">${note.barnName}</td>
			                        	<td style="background-color: #efedb0;" colspan="5"></td>
			                       </tr>
								</c:when>
								<c:otherwise>
									<tr class="header table-active expand">
										<td class="text-center spanButton" rowspan="${note.weightCharts.size()+2}"> <i class="icon-arrow-down5"></i></td>
										<td class="text-center counter" rowspan="${note.weightCharts.size()+2}">${cnt.count}</td>
										<td class="text-center poCode" rowspan="${note.weightCharts.size()+2}" >${note.processOrderCode}</td>
										<td class="text-center pigType" rowspan="${note.weightCharts.size()+2}" >${note.pigType }</td>
										<td class="text-center barnName" rowspan="${note.weightCharts.size()+2}" >${note.barnName}</td>
										<td></td>
										<td class="text-center" colspan="3">${note.createdDateEarly}</td>
										<td class="text-center" colspan="3">${note.createdDateLatest}</td>
									</tr>
									<tr class="table-active">
										<%-- <td class="text-center spanButton" rowspan="${note.weightCharts.size()+1}"> <i class="icon-arrow-down5"></i></td>
										<td class="text-center counter" rowspan="${note.weightCharts.size()+1}">${cnt.count}</td>
										<td class="text-center poCode" rowspan="${note.weightCharts.size()+1}" >${note.processOrderCode}</td>
										<td class="text-center pigType" rowspan="${note.weightCharts.size()+1}" >${note.pigType }</td>
										<td class="text-center barnName" rowspan="${note.weightCharts.size()+1}" >${note.barnName}</td> --%>
										<td></td>
										<td class="text-center">${note.sumQuantityEarly}</td>
										<td class="text-center">${note.sumWeightEarly}</td>
										<c:choose>
											<c:when test="${note.sumQuantityEarly == 0 }">
												<td class="text-center">0</td>
											</c:when>
											<c:otherwise>
												<td class="text-center">${note.sumWeightEarly/note.sumQuantityEarly}</td>
											</c:otherwise>
										</c:choose>
										<td class="text-center">${note.sumQuantityLatest}</td>
										<td class="text-center">${note.sumWeightLatest}</td>
										<c:choose>
											<c:when test="${note.sumQuantityLatest == 0 }">
												<td class="text-center">0</td>
											</c:when>
											<c:otherwise>
												<td class="text-center">${note.sumWeightLatest/note.sumQuantityLatest}</td>
											</c:otherwise>
										</c:choose>
										
									</tr>
									<c:forEach items="${note.weightCharts }" var="chart" varStatus="cnt2">
			                       		<tr>
				                           <td class="text-center">${chart.range }</td>
				                           <td class="text-center">${chart.quantityEarly }</td>
				                           <td class="text-center">${chart.weightEarly }</td>
				                           <c:choose>
												<c:when test="${chart.quantityEarly == 0 }">
													<td class="text-center">0</td>
												</c:when>
												<c:otherwise>
													<td class="text-center">${chart.weightEarly/chart.quantityEarly }</td>
												</c:otherwise>
											</c:choose>
				                           
				                           <td class="text-center">${chart.quantityLatest }</td>
				                           <td class="text-center">${chart.weightLatest }</td>
				                           <c:choose>
												<c:when test="${chart.quantityLatest == 0 }">
													<td class="text-center">0</td>
												</c:when>
												<c:otherwise>
													<td class="text-center">${chart.weightLatest/chart.quantityLatest }</td>
												</c:otherwise>
											</c:choose>
				                           
				                       </tr>
			                       </c:forEach>
								</c:otherwise>
							</c:choose>
						</c:forEach>
	                  
	                   <tr class="header fixed">
	                       <td colspan="6">Tổng</td>
	                       <td class="text-center">${report.totalQuantityEarly}</td>
	                       <td class="text-center">${report.totalWeightEarly }</td>
	                       <td></td>
	                       <td class="text-center">${report.totalQuantityLatest}</td>
	                       <td class="text-center">${report.totalWeightLatest }</td>
	                       <td></td>
	                   </tr>
	                   <tr>
	                       <td colspan="7">Trung bình</td>
	                       <td class="text-center">${report.totalAvgWeightEarly }</td>
	                       <td colspan="2"></td>
	                       <td class="text-center">${report.totalAvgWeightLatest }</td>
	                       <td></td>
	                   </tr>
	                </tbody> 
	            </table>
		</div>
	</div>
	<!-- /Table -->
</form:form>
</div>

<script src="<c:url value='/themes/admin/assets/js/select2.js'/>"></script>
<script src="<c:url value='/themes/admin/assets/js/reportDailyAverageWeight.js'/>"></script>
