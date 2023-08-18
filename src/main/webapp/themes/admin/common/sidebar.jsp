<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

		<div class="sidebar sidebar-light sidebar-main sidebar-expand-md bgc-primary">
			<!-- Sidebar mobile toggler -->
			<div class="sidebar-mobile-toggler text-center">
				<a href="#" class="sidebar-mobile-main-toggle"><i class="icon-arrow-left8"></i></a>
				Navigation
				<a href="#" class="sidebar-mobile-expand"><i class="icon-screen-full"></i><i class="icon-screen-normal"></i></a>
			</div>
			<!-- /sidebar mobile toggler -->

			<!-- Sidebar content -->
			<div class="sidebar-content">
				<!-- User menu -->
				<div class="sidebar-user d-xs-none">
					<div class="card-body text-center">
						<a href='<c:url value="/"></c:url>'>
							<img src="<c:url value='/themes/login/images/logo_mavin.svg'/>" width="120" height="70" alt="">
						</a>
					</div>
					<div class="card-body d-md-none">
						<div class="media">
							<div class="media-body text-white">
								<div class="row">
									<div class="col-8 media-title font-weight-semibold">Hello, ${pageContext.request.remoteUser}</div>
									<a href="${ctx }/logout" class="col-4 text-right text-white"><i class="icon-switch2"></i></a>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- /user menu -->
				

				<!-- Main navigation -->
				<div class="card card-sidebar-mobile">
					<ul class="nav nav-sidebar" data-nav-type="accordion">
						<!-- Main -->
						<li class="nav-item"><a menu="homeMenu" href="<c:url value='/'/>" class="nav-link "><i class="icon-home2"></i><span><fmt:message key="menu.home"/></span></a></li>

						<!--Customer  -->
						<security:authorize access="hasAnyRole('ROLE_SUPER_ADMIN')">
						<li class="nav-item"><a menu="custMenu" href="<c:url value='/tenant/list'/>" class="nav-link "><i class="fa fa-server" aria-hidden="true"></i><span><fmt:message key="menu.tenant"/></span></a></li>
						</security:authorize>

						<!-- User -->
						<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GROUP_VIEW,ROLE_USER_VIEW')">
						<li class=" nav-item nav-item-submenu ">
							<a  href="#" class="nav-link "><i class="icon-cog3"></i> <span><fmt:message key="menu.system"/></span></a>
							<ul class="nav nav-group-sub bgc-primary" >
								<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_SYS_PARAM_VIEW')">
 								<li class="nav-item"><a menu="parameterMenu" href="<c:url value='/systemParameter/list'/>" class="nav-link"><fmt:message key="menu.system.parameter"/></a></li>
 								</security:authorize>
								<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GROUP_VIEW,ROLE_USER_VIEW')">
								<li class="nav-item"><a menu="groupMenu" href="<c:url value='/group/list'/>" class="nav-link"><fmt:message key="menu.group"/></a></li>
								</security:authorize>
								<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GROUP_VIEW,ROLE_USER_VIEW')">
								<li class="nav-item"><a menu="userList" href="<c:url value='/user/list'/>" class="nav-link"><fmt:message key="menu.user"/></a></li>
								</security:authorize>
							</ul>
						</li>
						</security:authorize>

						<!-- \Farm  -->
						<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_FARM_VIEW')">
						<li class="nav-item"><a menu="farmMenu" href="<c:url value='/farm/list'/>" class="nav-link "><i class="icon-office" aria-hidden="true"></i><span><fmt:message key="menu.farm"/></span></a></li>
						</security:authorize>
						<!-- /Farm  -->
						
						<!-- \MasterData Management -->
						<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_MATERIAL_VIEW')">
						<li class=" nav-item nav-item-submenu nav-item-submenu-parent">
							<a  href="#" class="nav-link "><i class="icon-database4" aria-hidden="true"></i><span><fmt:message key="menu.master.data"/></span></a>
							<ul class="nav nav-group-sub nav-group-sub-parent" >
								<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_MATERIAL_VIEW')">
								<li class="nav-item"><a menu="materialMenu" href="/material/list" class="nav-link"><fmt:message key="menu.master.data.material"/></a></li>
								</security:authorize>
								<security:authorize access="hasAnyRole('ROLE_ADMIN')">
									<li class="nav-item"><a menu="vendorMenu" href="/vendor/list" class="nav-link"><fmt:message key="menu.master.data.vendor"/></a></li>
								</security:authorize>
							</ul>
						</li>
						</security:authorize>
						<!-- /MasterData Management -->

						<!-- \Material Management -->
						<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_STOCK_COUNT_VIEW,ROLE_INSTOCK_VIEW,ROLE_PURCHASE_REQUISITION_VIEW,ROLE_GOODS_RECEIPT_VIEW,ROLE_GOODS_RECEIPT_REQUISITION_VIEW,ROLE_GOODS_ISSUE_REQUISITION_VIEW,ROLE_GOODS_ISSUE_VIEW')">
						<li class=" nav-item nav-item-submenu nav-item-submenu-parent">
							<a  href="#" class="nav-link "><i class="icon-database" aria-hidden="true"></i><span><fmt:message key="menu.store"/></span></a>
							<ul class="nav nav-group-sub nav-group-sub-parent bgc-primary" >
								<li class="nav-item nav-item-submenu">
									<a href="#"  class="nav-link"><fmt:message key="instock"/></a>
									<ul class="nav nav-group-sub"  >
										<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_INSTOCK_VIEW')">
											<li class="nav-item"><a menu="instockMenu" href="/instock/list" class="nav-link"><fmt:message key="menu.instock"/></a></li>
										</security:authorize>
										<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_STOCK_COUNT_VIEW')">
											<li class="nav-item"><a menu="stockCountMenu" href="/stockCount/list" class="nav-link"><fmt:message key="menu.stock.count"/></a></li>
										</security:authorize>
										<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_INSTOCK_BASELINE_VIEW')">
											<li class="nav-item"><a menu="instockBaselineMenu" href="/instock-baseline/list" class="nav-link"><fmt:message key="menu.instock.baseline"/></a></li>
										</security:authorize>
									</ul>
								</li>

								<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PURCHASE_REQUISITION_VIEW')">
								<li class="nav-item"><a menu="purchaseRequisitionMenu" href="/purchaseRequisition/list" class="nav-link"><fmt:message key="menu.store.pr"/></a></li>
								</security:authorize>

								<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_RECEIPT_REQUISITION_VIEW')">
									<li class="nav-item"><a menu="goodsReceiptRequisitionMenu" href="/goodsReceipt-Requisition/list" class="nav-link"><fmt:message key="menu.store.import"/></a></li>
								</security:authorize>
								<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_ISSUE_REQUISITION_VIEW')">
									<li class="nav-item"><a href="/goodsIssue-Requisition/list" menu="goodsIssueRequisitionMenu"  class="nav-link"><fmt:message key="menu.store.export"/></a></li>
								</security:authorize>
								
								<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_INSTOCK_ADJUSTMENT_VIEW')">
									<li class="nav-item"><a menu="instockAdjustmentMenu" href="/instockAdjustment/list" class="nav-link"><fmt:message key="menu.instock.adjustment"/></a></li>
								</security:authorize>
								<security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_PERIOD_CLOSE')">
									<li class="nav-item"><a menu="closePeriodMenu" href="/periodClose/list" class="nav-link"><fmt:message key="menu.closePeriod"/></a></li>
								</security:authorize>
							</ul>
						</li>
						</security:authorize>
						<!-- /Material Management -->

						<!-- \Production Management -->
						<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_ATTRITION_SUPPORT_VIEW,ROLE_BARN_PLAN_VIEW,ROLE_PROCESS_ORDER_VIEW')">
						<li class=" nav-item nav-item-submenu nav-item-submenu-parent">
							<a  href="#" class="nav-link "><i class="icon-piggy-bank" aria-hidden="true"></i><span><fmt:message key="menu.production"/></span></a>
							<ul class="nav nav-group-sub nav-group-sub-parent bgc-primary" >
								<li class="nav-item nav-item-submenu">
									<a  href="#" class="nav-link "><span><fmt:message key="menu.goods.attrition.support"/></span></a>
									<ul class="nav nav-group-sub" >
										<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_ATTRITION_SUPPORT_VIEW')">
											<li class="nav-item"><a menu="goodsAttritionSupportMenu" href="/goodsAttritionSupport/list" class="nav-link"><fmt:message key="menu.goods.attrition.support"/></a></li>
										</security:authorize>
										<security:authorize access="hasAnyRole('ROLE_ADMIN')">
											<li class="nav-item"><a menu="closeAttritionMenu" href="/goodsAttristionClose/list" class="nav-link"><fmt:message key="menu.closeAttrition"/></a></li>
										</security:authorize>
									</ul>
								</li>
								<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_BARN_PLAN_VIEW')">
								<li class="nav-item"><a menu="barnPlanMenu" href="/barnPlan/list" class="nav-link"><fmt:message key="menu.barn.plan"/></a></li>
								</security:authorize>
								<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PROCESS_ORDER_VIEW')">
								<li class="nav-item"><a menu="processOrderMenu" href="/processOrder/list" class="nav-link"><fmt:message key="menu.production.po"/></a></li>
								</security:authorize>
								<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PROPOSAL_CONFIRM')">
								<li class="nav-item"><a menu="proposalConfirmMenu" href="/proposal/confirm/list" class="nav-link"><fmt:message key="menu.production.proposal"/></a></li>
								</security:authorize>
							</ul>
						</li>
						</security:authorize>
						<!-- /Production Management -->

						<!--\Water attrition  -->
						<security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_GENERAL_LEDGER_VIEW')">
						<li class="nav-item"><a menu="generalLedgerMenu" href="<c:url value='/general-ledger/list'/>" class="nav-link "><i class="icon-coins" aria-hidden="true"></i><span><fmt:message key="menu.generalLedger" /></span></a></li>
						</security:authorize>
						<!-- /Water attrition -->
						
						<!--\Report  -->
						<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_REPORT_VIEW')">
						<li class=" nav-item nav-item-submenu nav-item-submenu-parent">
							<a  href="#" class="nav-link "><i class="icon-chart"></i> <span><fmt:message key="menu.report"/></span></a>
							<ul class="nav nav-group-sub nav-group-sub-parent bgc-primary" >
							    <li class="nav-item"><a class="nav-link" menu="reportInstock" href="<c:url value='/report/instock' />"><fmt:message key="menu.report.instock" /></a></li>
							   <li class="nav-item nav-item-submenu">
								   <a  href="#" class="nav-link "><span><fmt:message key="menu.report.purchaseRequisition"/></span></a>
								   <ul class="nav nav-group-sub">
									   <li class="nav-item"><a menu="reportPurchaseRequisitionMenu" href="<c:url value='/report/purchase-requisition'/>" class="nav-link"><span><fmt:message key="menu.report.purchaseRequisition.FM"/></span></a></li>
									   <li class="nav-item"><a menu="reportPurchaseRequisitionVTDCMenu" href="<c:url value='/report/purchase-requisition-other'/>" class="nav-link"><span><fmt:message key="menu.report.purchaseRequisition.VTDC"/></span></a></li>
								   </ul>
							   </li>
 								<li class="nav-item"><a menu="salesMenu" href="<c:url value='/sales/list'/>" class="nav-link"><fmt:message key="menu.sales.data"/></a></li>
                                <li class="nav-item"><a menu="reportDayDetailMenu" href="<c:url value='/report/day-detail'/>" class="nav-link"><fmt:message key="menu.report.day.detail"/></a></li>
                                <li class="nav-item"><a menu="reportDailyAverageWeight" href="<c:url value='/report/daily-average-weight'/>" class="nav-link"><fmt:message key="menu.report.dailyaverageweight"/></a></li>
								<li class="nav-item nav-item-submenu">
								   <a  href="#" class="nav-link "><span><fmt:message key="menu.report.process.analyst"/></span></a>
								   <ul class="nav nav-group-sub" >
									   <li class="nav-item"><a menu="reportProcessAnalystPigLevel" href="<c:url value='/report/farm-analyst-pig-level'/>" class="nav-link"><span><fmt:message key="menu.report.process.analyst.pigLevel"/></span></a></li>
								   </ul>
							   </li>
                                <li class="nav-item"><a menu="handleListMaterialGA" href="<c:url value='/report/listMaterialGA'/>" class="nav-link"><fmt:message key="menu.report.listMaterialGA"/></a></li>
                                <li class="nav-item"><a menu="handleListGoodsReceipt" href="<c:url value='/report/listGoodsReceipt'/>" class="nav-link"><fmt:message key="menu.report.ListGoodsReceipt"/></a></li>
                                <li class="nav-item"><a menu="reportInstockPig" href="<c:url value='/report/instock-pig'/>" class="nav-link"><fmt:message key="menu.report.instock.pig"/></a></li>
                               	<li class="nav-item nav-item-submenu">
									<a  href="#" class="nav-link "><span><fmt:message key="menu.report.weightCompare"/></span></a>
									<ul class="nav nav-group-sub bgc-primary" >
										<li class="nav-item"><a menu="reportWeightCompare" href="<c:url value='/report/weight-compare'/>" class="nav-link"><fmt:message key="menu.report.weightCompare.byProcessOrder"/></a></li>
										<li class="nav-item"><a menu="reportWeightComparebyPigLevel" href="<c:url value='/report/weight-compare-by-pigLevel'/>" class="nav-link"><span><fmt:message key="menu.report.weightCompare.byPigLevel"/></span></a></li>
									</ul>
								</li>
                               	<li class="nav-item nav-item-submenu">
									<a  href="#" class="nav-link "><span><fmt:message key="menu.report.prodEstimate"/></span></a>
									<ul class="nav nav-group-sub bgc-primary" >
										<li class="nav-item"><a menu="reportProdEstimate" href="<c:url value='/report/prod-estimate'/>" class="nav-link"><span><fmt:message key="menu.report.prodEstimate.byPoCode"/></span></a></li>
										<li class="nav-item"><a menu="reportProdEstimateByLevel" href="<c:url value='/report/prod-estimate-by-level'/>" class="nav-link"><span><fmt:message key="menu.report.prodEstimate.byLevel"/></span></a></li>
									</ul>
								</li>
                               	<li class="nav-item nav-item-submenu">
									<a  href="#" class="nav-link "><span><fmt:message key="menu.report.prodResult"/></span></a>
									<ul class="nav nav-group-sub bgc-primary" >
										<li class="nav-item"><a menu="reportProdResult" href="<c:url value='/report/prod-result'/>" class="nav-link"><span><fmt:message key="menu.report.prodEstimate.byPoCode"/></span></a></li>
										<li class="nav-item"><a menu="reportProdResultByLevel" href="<c:url value='/report/prod-result-by-level'/>" class="nav-link"><span><fmt:message key="menu.report.prodEstimate.byLevel"/></span></a></li>
									</ul>
								</li>
                                <li class="nav-item"><a menu="reportSaleResult" href="<c:url value='/report/sale-estimate'/>" class="nav-link"><fmt:message key="menu.report.saleEstimate"/></a></li>
                                <li class="nav-item"><a menu="reportDayGRGA" href="<c:url value='/report/day-grga'/>" class="nav-link"><fmt:message key="menu.report.day.GRGA"/></a></li>
								<li class="nav-item"><a menu="reportDataInvest" href="<c:url value='/report/data-invest'/>" class="nav-link"><fmt:message key="menu.report.invest"/></a></li>
								<li class="nav-item"><a menu="reportTask" href="<c:url value='/report/task'/>" class="nav-link"><fmt:message key="menu.report.task"/></a></li>
							</ul>
						</li>
						
						</security:authorize>
						<!-- /Report -->
						
						<!-- \Document Management -->
						<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_DOCUMENT_TYPE_VIEW,ROLE_DOCUMENT_VIEW')">
						<li class=" nav-item nav-item-submenu nav-item-submenu-parent">
							<a  href="#" class="nav-link"><i class="icon-database4" aria-hidden="true"></i><span><fmt:message key="menu.document"/></span></a>
							<ul class="nav nav-group-sub nav-group-sub-parent" >
								<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_DOCUMENT_TYPE_VIEW')">
									<li class="nav-item"><a menu="documentTypeMenu" href="/documentType/list" class="nav-link"><fmt:message key="menu.document.type"/></a></li>
								</security:authorize>
								<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_DOCUMENT_VIEW')">
									<li class="nav-item"><a menu="documentMenu" href="/document/list" class="nav-link"><fmt:message key="menu.document"/></a></li>
								</security:authorize>
							</ul>
						</li>
						</security:authorize>
						<!-- /MasterData Management -->
						
						<security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_TASK_ADMIN_VIEW, ROLE_TASK_VIEW')">
							<li class="nav-item"><a menu="taskManagement" href="<c:url value='/task/table'/>" class="nav-link"><i class="icon-task"></i><span><fmt:message key="label.task.management"/></span></a></li>
						</security:authorize>

						<security:authorize access="hasAnyRole('ROLE_ADMIN')">
							<li class=" nav-item nav-item-submenu nav-item-submenu-parent">
								<a  href="#" class="nav-link"><i class="icon-database4" aria-hidden="true"></i><span>Form Template Solutions</span></a>
								<ul class="nav nav-group-sub nav-group-sub-parent" >
									<li class="nav-item"><a menu="templateImport1" href="/template/bootstrap" class="nav-link">Bootstrap Template</a></li>
									<li class="nav-item"><a menu="templateImport2" href="/template/utf-8" class="nav-link">UTF-8 Template</a></li>
								</ul>
							</li>
						</security:authorize>
						
						<!--\Help Require -->
						<li class="nav-item"><a class="nav-link" menu="supportRequire" href="<c:url value='/help/list'/>"><i class="icon-envelope"></i><span><fmt:message key="menu.help" /></span></a></li>
						
						<li class="nav-item d-xs-none">
							<a href="#" class="navbar-nav-link sidebar-control sidebar-main-toggle d-md-block" id="sidebar__toggle">
								<i class="icon-arrow-left12"></i>
							</a>
						</li>
					</ul>
				</div>
				<!-- /main navigation -->

			</div>
			<!-- /sidebar content -->
			
		</div>
