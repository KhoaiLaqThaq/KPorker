<%@ include file="/themes/common/taglibs.jsp"%>

<c:set var="action" value="${param.action}" />

<div class="row px-4">
	<div class="col-3 pl-0 pr-2">
		<a href="/goodsAttritionSupport/list">
			<div class="route--action__link d-flex px-2 py-2 maxH-86px rounded-16 bg-white cursor-pointer ">
				<div class="img">
					<img src="<c:url value='/themes/admin/assets/images/xuat_tieu_hao.svg'/>" class="zoom-150p" style="object-fit: none" width="50" alt="">
				</div>
				<c:choose>
					<c:when test="${action eq 'goodsAttritionSupport'}"><div class="route--action__title active-action flex-center-vertical ml-3"></c:when>
					<c:otherwise><div class="route--action__title text-dark flex-center-vertical ml-3"></c:otherwise>
				</c:choose><fmt:message key="menu.goods.attrition.support"/></div>
			</div>
		</a>
	</div>
	
	<div class="col-3 pl-0 pr-2">
		<a href="/processOrder/list">
			<div class="route--action__link d-flex px-2 py-2 maxH-86px rounded-16 bg-white cursor-pointer">
				<div class="img">
					<img src="<c:url value='/themes/admin/assets/images/lenh_san_xuat.svg'/>" class="zoom-150p" style="object-fit: none" width="50" alt="">
				</div>
				<c:choose>
					<c:when test="${action eq 'processOrder'}"><div class="route--action__title active-action flex-center-vertical ml-3"></c:when>
					<c:otherwise><div class="route--action__title text-dark flex-center-vertical ml-3"></c:otherwise>
				</c:choose>
				<fmt:message key="menu.production.po"/></div>
			</div>
		</a>
	</div>
	
	<div class="col-3 pl-0 pr-2">
		<a href="/barnPlan/list">
			<div class="route--action__link d-flex px-2 py-2 maxH-86px rounded-16 bg-white cursor-pointer">
				<div class="img">
					<img src="<c:url value='/themes/admin/assets/images/ke_hoach_trong_chuong.svg'/>" class="zoom-150p" style="object-fit: none" width="50" alt="">
				</div>
				<c:choose>
					<c:when test="${action eq 'barnPlan'}"><div class="route--action__title active-action flex-center-vertical ml-3"></c:when>
					<c:otherwise><div class="route--action__title text-dark flex-center-vertical ml-3"></c:otherwise>
				</c:choose>
				<fmt:message key="menu.barn.plan"/></div>
			</div>
		</a>
	</div>
</div>