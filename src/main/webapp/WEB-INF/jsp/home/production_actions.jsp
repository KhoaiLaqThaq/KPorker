<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<div class="row px-2 mb-3">
	<div class="col-12">
		<p class="text-color-primary fs-5"><fmt:message key="menu.production"></fmt:message></p>
	</div>
	<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_ATTRITION_SUPPORT_VIEW')">
		<div class="col-12 col-sm-6 col-md-4 pl-0 pr-2 mb-3">
			<a href="/goodsAttritionSupport/list">
				<div class="route--action__link d-flex p-3 maxH-110px rounded-16 bg-white cursor-pointer zoom-in-little">
					<div class="img mr-3">
						<img src="<c:url value='/themes/admin/assets/images/xuat_tieu_hao.svg'/>" class="zoom-150p d-xs-none d-sm-none d-md-block" style="object-fit: none" width="50" alt="">
					</div>
					<div class="route--action__title text-dark flex-center-vertical"><fmt:message key="menu.goods.attrition.support"/></div>
				</div>
			</a>
		</div>
	</security:authorize>
	
	<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PROCESS_ORDER_VIEW')">
		<div class="col-12 col-sm-6 col-md-4 pl-0 pr-2 mb-3">
			<a href="/processOrder/list">
				<div class="route--action__link d-flex p-3 maxH-110px rounded-16 bg-white cursor-pointer zoom-in-little">
					<div class="img mr-3">
						<img src="<c:url value='/themes/admin/assets/images/lenh_san_xuat.svg'/>" class="zoom-150p d-xs-none d-sm-none d-md-block" style="object-fit: none" width="50" alt="">
					</div>
					<div class="route--action__title text-dark flex-center-vertical"><fmt:message key="menu.production.po"/></div>
				</div>
			</a>
		</div>
	</security:authorize>
	
	<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_BARN_PLAN_VIEW')">
		<div class="col-12 col-sm-6 col-md-4 pl-0 pr-2 mb-3">
			<a href="/barnPlan/list">
				<div class="route--action__link d-flex p-3 maxH-110px rounded-16 bg-white cursor-pointer zoom-in-little">
					<div class="img mr-3">
						<img src="<c:url value='/themes/admin/assets/images/ke_hoach_trong_chuong.svg'/>" class="zoom-150p d-xs-none d-sm-none d-md-block" style="object-fit: none" width="50" alt="">
					</div>
					<div class="route--action__title text-dark flex-center-vertical"><fmt:message key="menu.barn.plan"/></div>
				</div>
			</a>
		</div>
	</security:authorize>
	
</div>
