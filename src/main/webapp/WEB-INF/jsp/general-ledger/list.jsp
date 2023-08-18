<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="generalLedger.list.title" /></title>
    <meta name="menu" content="generalLedgerMenu" />

    <link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
    <link href="<c:url value='/themes/admin/assets/css/general-ledger.css'/>" rel="stylesheet" type="text/css">

    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/ui/moment/moment.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/daterangepicker.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/anytime.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.date.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.time.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/demo_pages/picker_date.js'/>"></script>
    <script src="<c:url value='/themes/admin/assets/js/select2.js'/>"></script>

    <script src="<c:url value='/themes/admin/assets/js/general-ledger.list.js'/>"></script>

</head>

<div class="content px-0">
    <div class="row py-2 px-3 task--header__container mb-2">
        <div class="col-12 col-sm-6">
            <div class="text-color-primary fs-5"><fmt:message key="generalLedger.list.title" /></div>
        </div>
        <div class="col-12 col-md-6 text-right">
            <security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GENERAL_LEDGER_CREATE')">
                <a href="<c:url value='/general-ledger/form'/>" class="btn bgc-warning text-color-primary fw-bold text-uppercase rounded-10 mr-2" title="<fmt:message key="button.add"/>"><i class="icon-plus22"></i><fmt:message key="button.add"/></a>
            </security:authorize>
            <button type="button" id="btn__sync" class="btn bgc-warning text-color-primary fw-bold text-uppercase rounded-10 mr-2"><fmt:message key="label.generalLedger.action.sync"/></button>
            <button type="button" id="btn__export" class="btn bgc-warning  fw-bold text-uppercase rounded-10"><fmt:message key="label.export.file"/></button>
        </div>
    </div>

    <form:form id="generalLedger__form" modelAttribute="criteria" action="${ctx}/general-ledger/list" method="post">
        <div class="card rounded-16 mx-2 mb-2">
            <div class="row">
                <div class="col-6 px-3 py-2 fw-bold"><fmt:message key="label.search" /></div>
                <div class="col-6 text-right">
                    <button type="button" id="btn__reset" class="btn btn-secondary rounded-10 mt-2 mr-2">Đặt lại</button>
                    <button type="submit" id="btn__submit" class="btn btn-secondary rounded-10 mt-2 mr-2"><i class="mr-2 icon-search4"></i><span class="mr-2"><fmt:message key="label.search"/></span></button>
                </div>
            </div>
            <div class="card-body py-0">
                <div class="row">
                    <div class="col-12 col-md-8">
                        <div class="row">
                            <div class="col-12 col-md-3">
                                <span class="flex-center-vertical"><fmt:message key="barn.farmCode" /></span>
                                <select name="searchFarmCode" id="farmCode" class="select2 form-control rounded-10" data-placeholder="Chọn trại">
                                    <option value=""></option>
                                    <c:forEach var="farm" items="${farms}">
                                        <option value="${farm.code}" ${farm.code eq criteria.searchFarmCode ? "selected":""}>${farm.name}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-12 col-md-3">
                                <span class="flex-center-vertical"><fmt:message key="doc.num"/></span>
                                <input type="text" class="form-control rounded-10" name="docNum" value="${criteria.docNum}" data-placeholder="Nhập số hóa đơn...">
                            </div>

                            <div class="col-12 col-md-3">
                                <span class="flex-center-vertical"><fmt:message key="label.task.status"/></span>
<%--                                <input type="text" class="form-control rounded-10" name="status" value="${criteria.status}">--%>
                                <select name="status" id="status" class="select2 form-control rounded-10" data-placeholder="Chọn trạng thái">
                                    <option value=""></option>
                                    <c:forEach var="status" items="${listStatus}">
                                        <option value="${status}" ${status eq criteria.status ? "selected" : ""}><fmt:message key="generalLedger.status.${status}"/></option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-md-4">
                        <label class="text-label"><fmt:message  key="doc.postingDate"/>:</label>
                        <div class="row">
                            <div class="col-md-6 col-sm- col-xs-12">
                                <div class="form-group row">
                                    <span class="flex-center-vertical">Từ</span>
                                    <div class="col-lg-10">
                                        <input type="text" class="form-control rounded-10" placeholder="DD-MM-YYYY" id="from__date" name="searchFromDateStr" value="${criteria.searchFromDateStr }" autocomplete="off" />
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6 col-sm-6 col-xs-12">
                                <div class="form-group row">
                                    <span class="flex-center-vertical">đến</span>
                                    <div class="col-lg-10">
                                        <input type="text" class="form-control rounded-10" placeholder="DD-MM-YYYY" id="to__date" name="searchToDateStr" value="${criteria.searchToDateStr }" autocomplete="off" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card rounded-16 mx-2">
            <div class="table-responsive">
                <table class="table table-bordered table-striped">
                    <thead>
                        <tr class="table-success">
                            <td class="border-0 text-center bgc-primary border-primary text-white">
                                <input type="checkbox" id="checkAll" name="checkAll" />
                            </td>
                            <td class="border-0 text-center bgc-primary border-primary text-white">#</td>
                            <td class="border-0 text-center bgc-primary border-primary text-white"><fmt:message key="farm.code"/></td>
                            <td class="border-0 text-center bgc-primary border-primary text-white mw-100"><fmt:message key="farm.name"/></td>
                            <td class="border-0 text-center bgc-primary border-primary text-white"><fmt:message key="doc.code"/></td>
                            <td class="border-0 text-center bgc-primary border-primary text-white"><fmt:message key="doc.num"/></td>
                            <%--<td class="border-0 text-center bgc-primary border-primary text-white"><fmt:message key="doc.symbol" /></td>--%>
                            <td class="border-0 text-center bgc-primary border-primary text-white"><fmt:message key="doc.postingDate"/></td>
                            <td class="border-0 text-center bgc-primary border-primary text-white"><fmt:message key="doc.date" /></td>
                            <td class="border-0 text-center bgc-primary border-primary text-white"><fmt:message key="generalLedger.amount"/> VND</td>
                            <td class="border-0 text-center bgc-primary border-primary text-white mw-100"><fmt:message key="generalLedger.vendor.name" /></td>
                            <td class="border-0 text-center bgc-primary border-primary text-white"><fmt:message key="generalLedger.object.name" /></td>
                            <td class="border-0 text-center bgc-primary border-primary text-white mw-200"><fmt:message key="generalLedger.description"/></td>
                            <td class="border-0 text-center bgc-primary border-primary text-white"><fmt:message key="doc.FI" /></td>
                            <td class="border-0 text-center bgc-primary border-primary text-white"><fmt:message key="label.task.status" /></td>
                            <td class="border-0 text-center bgc-primary border-primary text-white">#</td>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty page.content}">
                            <tr>
                                <td colspan="15" class="text-center text-none-data"><fmt:message key="not.data"/></td>
                            </tr>
                        </c:if>
                        <c:forEach var="item" items="${page.content}" varStatus="cnt">
                            <tr>
                                <td>
                                    <c:choose>
                                        <c:when test="${item.status eq 'confirmed'}">
                                            <input type="checkbox" id="${item.transCode}" class="non--checked"/>
                                        </c:when>
                                        <c:otherwise>
                                            <input type="checkbox" id="item_${item.transCode}" checked disabled>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center"><c:out value="${cnt.count + page.size*page.number}" /></td>
                                <td class="text-center">${item.farm != null ? item.farm.code : ""}</td>
                                <td class="text-center">${item.farm != null ? item.farm.name : ""}</td>
                                <td class="text-center">${item.docCode}</td>
                                <td class="text-center">${item.docNum}</td>
                                <td class="text-center">${item.displayPostingDate}</td>
                                <td class="text-center">${item.displayDocDate}</td>
                                <td class="text-center currency mw-100"><c:out value="${item.displayAmount}"/></td>
                                <td class="text-center">${item.vendorName}</td>
                                <td class="text-center">${item.vendor != null ? item.vendor.name : ""}</td>
                                <td class="text-center">${item.description}</td>
                                <td class="text-center">${item.fiDoc}</td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${item.status eq 'completed' || item.status eq 'COMPLETED'}">
                                            <span class="badge badge-success"><fmt:message key="generalLedger.status.${item.status}"/></span>
                                        </c:when>
                                        <c:when test="${item.status eq 'cancel'}">
                                            <span class="badge badge-danger"><fmt:message key="generalLedger.status.${item.status}"/></span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-secondary"><fmt:message key="generalLedger.status.${item.status}"/></span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center"><a href="${ctx}/general-ledger/form?id=${item.id}"><i class="icon-pencil7"></i></a></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <jsp:include page="/themes/admin/common/pagination.jsp">
                <jsp:param value="${page.number}" name="pageNumber"/>
                <jsp:param value="${page.totalPages}" name="maxPages"/>
                <jsp:param value="${page.size}" name="size"/>
                <jsp:param value="${page.totalElements}" name="totalElements"/>
            </jsp:include>
        </div>
    </form:form>
</div>
