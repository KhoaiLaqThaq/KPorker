<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="report.task.title"/></title>
    <meta name="menu" content="reportTask"/>
    <link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
    <link href="<c:url value='/themes/admin/assets/css/task.css'/>" rel="stylesheet" type="text/css">

    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/bootstrap_multiselect.js'/>"></script>

    <script src="<c:url value='/themes/admin/global_assets/js/plugins/ui/moment/moment.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/daterangepicker.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/anytime.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.date.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.time.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/demo_pages/picker_date.js'/>"></script>

    <script src="<c:url value='/themes/admin/assets/js/select2.js'/>"></script>
    <script src="<c:url value='/themes/admin/assets/js/report/report.task.js'/>"></script>
</head>

<div class="content">
    <form:form id="reportTaskForm" modelAttribute="criteria" action="/report/task" method="post">
        <%--Searching--%>
        <div class="card rounded-16">
            <div class="row">
                <div class="col-12 col-md-6 px-3 py-2 fw-bold"><fmt:message key="label.search"/></div>
                <div class="col-12 col-md-6 text-right">
                    <button type="reset" id="btn__reset" class="btn btn-secondary rounded-10 mt-2 mr-2">Đặt lại</button>
                    <button type="button" id="btn__submit" class="btn btn-secondary rounded-10 mt-2 mr-2"><i class="mr-2 icon-search4"></i><span class="mr-2"><fmt:message key="label.search"/></span></button>
                </div>
            </div>

            <div class="card-body py-0">
                <div class="row">
                    <div class="col-12 col-md-5">
                        <div class="form-group">
                            <label for="taskTitle"><fmt:message key="task.table.th.title"/></label>
                            <input type="text" class="form-control rounded-10" id="taskTitle" name="taskTitle"
                                   value="${criteria.taskTitle}" placeholder="Nhập tiêu đề công việc..."
                            />
                        </div>
                    </div>

                        <%--assignee--%>
                    <security:authorize access="hasRole('ROLE_TASK_ADMIN_VIEW')">
                        <div class="col-12 col-md-3">
                            <div class="form-group">
                                <label for="assigneeUsername"><fmt:message key="label.task.assignee.title"/></label>
                                <select class="select2 form-control rounded-10" name="assigneeUsername" id="assigneeUsername" data-placeholder="Người tiếp nhận">
                                    <option value=""></option>
                                    <c:forEach var="item" items="${assignees}">
                                        <option value="${item.username}" ${criteria.assigneeUsername eq item.username ? 'selected':''}><c:out value="${item.username}"/></option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </security:authorize>
                        <%--/assignee--%>

                    <div class="col-12 col-md-4">
                        <label class="text-label"><fmt:message key="report.range.date"/></label>
                        <div class="row">
                            <div class="col-12 col-md-6">
                                <div class="form-group row">
                                    <span class="flex-center-vertical"><fmt:message key="label.from" /></span>
                                    <div class="col-12 col-md-10">
                                        <input type="text" class="form-control rounded-10" name="searchFromDate" placeholder="dd-MM-yyyy" value="${criteria.searchFromDate}" autocomplete="off" />
                                    </div>
                                </div>
                            </div>

                            <div class="col-12 col-md-6">
                                <div class="form-group row">
                                    <span class="flex-center-vertical"><fmt:message key="label.to"/></span>
                                    <div class="col-12 col-md-10">
                                        <input type="text" class="form-control rounded-10" name="searchToDate" placeholder="dd-MM-yyyy" value="${criteria.searchToDate}" autocomplete="off">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <%--/Searching--%>
        <div class="row mb-3">
            <div class="col-12 text-right">
                <button type="button" id="btn__export" class="btn bgc-warning"><fmt:message key="label.report.export"/></button>
            </div>
        </div>

        <div class="card rounded-16">
            <div class="table-responsive">
                <table class="table table-bordered table-striped">
                    <thead>
                    <tr class="table-success">
                        <th class="border-0 text-center bgc-primary border-primary text-white">#</th>
                        <th class="border-0 text-center bgc-primary border-primary text-white"><fmt:message key="task.table.th.title"/></th>
                        <th class="border-0 text-center bgc-primary border-primary text-white"><fmt:message key="task.table.th.deadline"/></th>
                        <th class="border-0 text-center bgc-primary border-primary text-white"><fmt:message key="task.status.confirm.yet"/></th>
                        <th class="border-0 text-center bgc-primary border-primary text-white"><fmt:message key="task.status.todo"/></th>
                        <th class="border-0 text-center bgc-primary border-primary text-white"><fmt:message key="task.status.overdue"/></th>
                        <th class="border-0 text-center bgc-primary border-primary text-white"><fmt:message key="task.status.overdue.cause"/></th>
                        <th class="border-0 text-center bgc-primary border-primary text-white"><fmt:message key="task.status.done"/></th>
                        <th class="border-0 text-center bgc-primary border-primary text-white"><fmt:message key="task.status.rejected.farm"/></th>
                        <th class="border-0 text-center bgc-primary border-primary text-white"><fmt:message key="task.status.rejected.cause"/></th>
                    </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td colspan="10" class="text-center text-none-data"><fmt:message key="not.data"/></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </form:form>
</div>
