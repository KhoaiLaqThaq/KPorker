<%@ include file="/themes/common/taglibs.jsp"%>

<c:set var="action" value="${param.action}" />

<div class="row px-4">
	<div class="col-2 pl-0 pr-2">
		<a href="/instock/list">
			<div class="route--action__link d-flex px-2 py-2 maxH-86px rounded-16 bg-white cursor-pointer">
				<div class="img">
					<img src="<c:url value='/themes/admin/assets/images/ton_kho.svg'/>" class="zoom-150p" height="45" width="50" alt="">
				</div>
				<c:choose>
					<c:when test="${action eq 'instock'}"><div class="route--action__title active-action flex-center-vertical ml-3"></c:when>
					<c:otherwise><div class="route--action__title text-dark flex-center-vertical ml-3"></c:otherwise>
				</c:choose><fmt:message key="instock"/></div>
			</div>
		</a>
	</div>
	
	<div class="col-2 pl-0 pr-2">
		<a href="/goodsReceipt-Requisition/list">
			<div class="route--action__link d-flex px-2 py-2 maxH-86px rounded-16 bg-white cursor-pointer">
				<div class="img">
					<img src="<c:url value='/themes/admin/assets/images/nhap_kho.svg'/>" class="zoom-150p" height="45" width="50" alt="">
				</div>
				<c:choose>
					<c:when test="${action eq 'goodsReceipt'}"><div class="route--action__title active-action flex-center-vertical ml-3"></c:when>
					<c:otherwise><div class="route--action__title text-dark flex-center-vertical ml-3"></c:otherwise>
				</c:choose><fmt:message key="menu.goodsReceipt"/></div>
			</div>
		</a>
	</div>
	
	<div class="col-2 pl-0 pr-2">
		<a href="/goodsIssue-Requisition/list">
			<div class="route--action__link d-flex px-2 py-2 maxH-86px rounded-16 bg-white cursor-pointer">
				<div class="img">
					<img src="<c:url value='/themes/admin/assets/images/xuat_kho.svg'/>" class="zoom-150p" height="45" width="50" alt="">
				</div>
				<c:choose>
					<c:when test="${action eq 'goodsIssue'}"><div class="route--action__title active-action flex-center-vertical ml-3"></c:when>
					<c:otherwise><div class="route--action__title text-dark flex-center-vertical ml-3"></c:otherwise>
				</c:choose>
				<fmt:message key="menu.goodsIssue"/></div>
			</div>
		</a>
	</div>
	
	<div class="col-2 pl-0 pr-2">
		<a href="/purchaseRequisition/list">
			<div class="route--action__link d-flex px-2 py-2 maxH-86px rounded-16 bg-white cursor-pointer">
				<div class="img">
					<img src="<c:url value='/themes/admin/assets/images/yeu_cau.svg'/>" class="zoom-150p" height="45" width="50" alt="">
				</div>
				<c:choose>
					<c:when test="${action eq 'purchaseRequisition'}"><div class="route--action__title active-action flex-center-vertical ml-3"></c:when>
					<c:otherwise><div class="route--action__title text-dark flex-center-vertical ml-3"></c:otherwise>
				</c:choose><fmt:message key="menu.purchaseRequisition"/></div>
			</div>
		</a>
	</div>
	
	<div class="col-2 pl-0 pr-2">
		<a href="/instockAdjustment/list">
			<div class="route--action__link d-flex px-2 py-2 maxH-86px rounded-16 bg-white cursor-pointer">
				<div class="img">
					<img src="<c:url value='/themes/admin/assets/images/dieu_chinh.svg'/>" class="zoom-150p" height="45" width="50" alt="">
				</div>
				<c:choose>
					<c:when test="${action eq 'instockAdjustment'}"><div class="route--action__title active-action flex-center-vertical ml-3"></c:when>
					<c:otherwise><div class="route--action__title text-dark flex-center-vertical ml-3"></c:otherwise>
				</c:choose><fmt:message key="menu.instockAdjustment"/></div>
			</div>
		</a>
	</div>
</div>