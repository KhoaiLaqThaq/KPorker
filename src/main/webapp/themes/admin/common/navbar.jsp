<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>
<div class="container-fluid">
	<div class="row">
		<div class="col-12 text-right d-md-none">
			<button class="navbar-toggler sidebar-mobile-main-toggle mr-2" type="button"><i class="icon-paragraph-justify3"></i></button>
		</div>
	</div>
	<div class="row p-3">
		<div class="col-12 col-sm-12 col-md-3 pl-0">
				<div class="bg-white px-2 py-1 rounded-16 hide" id="homeStatistic">
					<div class="row">
						<div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-6"><fmt:message key="pig.total"/>: <span id="totalPig" class="fw-bold">0</span></div>
						<security:authorize access="hasAnyRole('ROLE_ADMIN')">
						<div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-6"><fmt:message key="farm.total"/> <span id="totalFarm" class="fw-bold">0</span></div>
						<div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-6"><fmt:message key="farm.status.rent"/>: <span id="farmRent" class="fw-bold">0</span></div>
						<div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-6"><fmt:message key="farm.status.machining"/>: <span id="farmMachining" class="fw-bold">0</span></div>
						</security:authorize>
					</div>
				</div>
		</div>
		<div class="col-12 col-sm-12 col-md-9 list-sm px-0 text-end">
	         <a href="<c:url value='/all/sync-from-sap'/>" id="sync-master-data-from-sap" class="btn btn-sm bgc-primary text-uppercase text-white rounded-10 py-2 px-3 col-lg-6 col-md-12" title="<fmt:message key="button.sync.master.data"/>"><i class="icon-download4 mr-2 text-color-warning"></i><fmt:message key="button.sync.master.data"/></a>
	         <a href="<c:url value='/all/sync-to-sap'/>" id="sync-data-to-sap" class="btn btn-sm bgc-warning text-uppercase text-white rounded-10 py-2 px-3 col-lg-6 col-md-12" title="<fmt:message key="button.sync.data.to.sap"/>"><i class="icon-upload4 mr-2 text-color-primary"></i><fmt:message key="button.sync.data.to.sap"/></a>
	         
			<div class="nav-item dropdown d-md-inline-block d-xs-none ml-3">
				<a href="#" class="navbar-nav-link dropdown-toggle caret-0  bg-white p-2 rounded-10" data-toggle="dropdown" id="notify_notification"><i class="fa fa-bell notification" aria-hidden="true" id="notification__icon"></i></a>
				<div class="dropdown-menu dropdown-menu-right dropdown-content wmin-md-350">
					<div class="dropdown-content-header"><span class="font-weight-semibold"><fmt:message key="system.notification"/></span></div>

					<div class="card-body">
						<ul class="nav nav-tabs" style="border-bottom: none">
							<li class="nav-item"><a href="#basic-tab1" class="nav-link active" data-toggle="tab">Lệnh sản xuất</a></li>
							<li class="nav-item"><a href="#basic-tab2" class="nav-link" data-toggle="tab" id="task_notification">Công việc</a></li>
						</ul>

						<div class="tab-content noti--list__scroll">
							<div class="tab-pane fade show active" id="basic-tab1">
                                <ul class="pl-0" id="notificationList">
                                    <li class="notifyBox row event--notification__item"></li>
                                    <li class="notifyBox row justify-content-center text-decoration-underline text-primary">
                                        <p id="showMoreEventNotification" class="cursor-pointer">Show more</p>
                                    </li>
                                </ul>
							</div>

							<div class="tab-pane fade" id="basic-tab2">
								<ul class="media-list" id="task__list">
									<li class="row task--notification__item"></li>
                                    <li class="notifyBox row justify-content-center text-decoration-underline text-primary">
                                        <p id="showMoreTaskNotification" class="cursor-pointer">Show more</p>
                                    </li>
								</ul>
							</div>

						</div>
					</div>
				</div>
			</div>
			
			<div class="nav-item dropdown dropdown-user d-md-inline-block d-xs-none d-sm-none">
				<a href="#" class="navbar-nav-link dropdown-toggle pl-0" data-toggle="dropdown"><span class="mr-1 text-bold">${pageContext.request.remoteUser}</span><img src="<c:url value='/themes/admin/global_assets/images/placeholders/placeholder.jpg'/>" class="rounded-10" alt=""></a>
				<div class="dropdown-menu dropdown-menu-right">
					<a href="${ctx }/user/set-password" class="dropdown-item d-flex"><i class="icon-rotate-ccw2"></i><fmt:message key="password.change"/></a>
					<a href="${ctx }/logout" class="dropdown-item d-flex"><i class="icon-switch2"></i><fmt:message key="logout"/></a>
				</div>
			</div>
	     </div>
	</div>
</div>
	