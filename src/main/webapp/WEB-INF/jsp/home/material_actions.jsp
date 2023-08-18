<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<div class="row px-2 mb-3">
	<div class="col-12">
		<p class="fs-5 text-color-primary"><fmt:message key="menu.store"></fmt:message></p>
	</div>
	
	<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_INSTOCK_VIEW,ROLE_STOCK_COUNT_VIEW,ROLE_INSTOCK_BASELINE_VIEW')">
		<div class="col-12 col-sm-6 col-md-3 pl-0 pr-2 mb-3">
			<div class="group--actions__store bg-white rounded-16 p-3 zoom-in-little">
				<div class="group--actions__title mb-3">
					<div class="group--actions__img mr-5">
						<img alt="" src="<c:url value='/themes/admin/assets/images/ton_kho.svg' />" width="65" />
					</div>
					<div class="group--actions__name flex-center-vertical d-xs-none">
						<p class="fs-5" style="color: #FF0000;"><fmt:message key="instock"/></p>
					</div>
				</div>
				<div class="group--routing">
					<ul class="pl-0">
						<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_INSTOCK_VIEW')">
							<li><a href="/instock/list" class="text-dark"><fmt:message key="menu.instock"/></a></li>
						</security:authorize>
						<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_STOCK_COUNT_VIEW')">
							<li><a href="/stockCount/list" class="text-dark"><fmt:message key="menu.stock.count"/></a></li>
						</security:authorize>
						<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_INSTOCK_BASELINE_VIEW')">
							<li><a href="/instock-baseline/list" class="text-dark"><fmt:message key="menu.instock.baseline"/></a></li>
						</security:authorize>
					</ul>
				</div>
			</div>
		</div>
	</security:authorize>
	
	<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_RECEIPT_REQUISITION_VIEW')">
		<div class="col-12 col-sm-6 col-md-3 pl-0 pr-2 mb-3">
			<div class="group--actions__store bg-white rounded-16 p-3 zoom-in-little">
				<div class="group--actions__title mb-3">
					<div class="group--actions__img mr-5">
						<img alt="" src="<c:url value='/themes/admin/assets/images/nhap_kho.svg' />" width="65" />
					</div>
					<div class="group--actions__name flex-center-vertical d-xs-none">
						<p class="fs-5" style="color: #FEC015;"><fmt:message key="menu.store.import"/></p>
					</div>
				</div>
				<div class="group--routing">
					<ul class="pl-0">
						<li><a href="/goodsReceipt-Requisition/list" class="text-dark"><fmt:message key="menu.goods.receipt.requisition"/></a></li>
						<li><a href="/goodsReceipt/list" class="text-dark"><fmt:message key="menu.confirm.goods.receipt"/></a></li>
					</ul>
				</div>
			</div>
			
		</div>
	</security:authorize>
	
	<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_ISSUE_REQUISITION_VIEW')">
		<div class="col-12 col-sm-6 col-md-3 pl-0 pr-2 mb-3">
			<div class="group--actions__store bg-white rounded-16 p-3 zoom-in-little">
				<div class="group--actions__title mb-3">
					<div class="group--actions__img mr-5">
						<img alt="" src="<c:url value='/themes/admin/assets/images/xuat_kho.svg' />" width="65" />
					</div>
					<div class="group--actions__name flex-center-vertical d-xs-none">
						<p class="fs-5" style="color: #3BB800;"><fmt:message key="menu.store.export"/></p>
					</div>
				</div>
				<div class="group--routing">
					<ul class="pl-0">
						<li><a href="/goodsIssue-Requisition/list" class="text-dark"><fmt:message key="menu.goods.issue.requisition"/></a></li>
						<li><a href="/goodsIssue/list" class="text-dark"><fmt:message key="menu.store.export.internal"/></a></li>
					</ul>
				</div>
			</div>
		</div>
	</security:authorize>
	
	<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PURCHASE_REQUISITION_VIEW,ROLE_INSTOCK_ADJUSTMENT_VIEW')">
		<div class="col-12 col-sm-6 col-md-3 pl-0">
		<div class="row">
			<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PURCHASE_REQUISITION_VIEW')">
				<div class="col-12 mb-2">
					<a href="/purchaseRequisition/list">
						<div class="group--actions__other d-flex rounded-16 bg-white p-3 zoom-in-little">
							<div class="group--actions__img mr-5">
								<img src="<c:url value='/themes/admin/assets/images/yeu_cau.svg'/>" width="65" alt="">
							</div>
							<div class="group--action__name flex-center-vertical">
								<p class="fs-5 text-dark"><fmt:message key="menu.store.pr"/></p>
							</div>
						</div>
					</a>
				</div>
			</security:authorize>
			<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_INSTOCK_ADJUSTMENT_VIEW')">
				<div class="col-12">
					<a href="/instockAdjustment/list">
						<div class="group--actions__other d-flex rounded-16 bg-white p-3 zoom-in-little">
							<div class="group--actions__img mr-5">
								<img src="<c:url value='/themes/admin/assets/images/dieu_chinh.svg'/>" width="65" alt="">
							</div>
							<div class="group--action__name flex-center-vertical">
								<p class="fs-5 text-dark"><fmt:message key="menu.instock.adjustment"/></p>
							</div>
						</div>
					</a>
				</div>
			</security:authorize>
			
		</div>
	</div>
	</security:authorize>
	
</div>
