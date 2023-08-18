<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
  <title><fmt:message key="vendor.title.list" /></title>
  <meta name="menu" content="vendorMenu" />

  <link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">

  <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
  <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/bootstrap_multiselect.js'/>"></script>

  <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>

  <script src="<c:url value='/themes/admin/assets/js/select2.js'/>"></script>
  <script src="<c:url value='/themes/admin/assets/js/vendor/list.js'/>"></script>

</head>

<div class="content">
  <div class="row mb-2">
    <div class="col-12 col-md-6">
      <div class="text-color-primary fs-5"><fmt:message key="vendor.title.list" /></div>
    </div>
  </div>
  <form:form id="vendorForm" modelAttribute="criteria" action="${ctx}/vendor/list" method="POST">
    <!-- \Searching -->
    <div class="card rounded-16 mb-2">
      <div class="row">
        <div class="col-6 px-3 py-2 fw-bold">
          <fmt:message key="label.search" />
        </div>
        <div class="col-6 text-right">
          <button type="button" id="btnReset" class="btn btn-secondary rounded-10 mt-2 mr-2">Đặt lại</button>
          <button type="submit" id="btnSubmit" class="btn btn-secondary rounded-10 mt-2 mr-2"><i class="mr-2 icon-search4"></i><span class="mr-2"><fmt:message key="label.search"/></span></button>
        </div>
      </div>
      <div class="card-body py-0">
        <div class="row">
          <div class="col-12 col-md-8">
            <div class="row">
              <div class="col-12 col-sm-6 col-md-3">
                <div class="form-group">
                  <label><fmt:message key="generalLedger.vendor.name" /></label>
                  <input class="form-control rounded-10" type="text" id="name" name="name" value="${criteria.name}" placeholder="Nhập tên NCC"/>
                </div>
              </div>
              <div class="col-12 col-sm-6 col-md-3">
                <div class="form-group">
                  <label><fmt:message key="label.vendor.taxNumber" /></label>
                  <input class="form-control rounded-10" type="text" id="taxNumber" name="taxNumber" value="${criteria.taxNumber}" placeholder="Nhập mã số "/>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- /Searching -->

    <div class="col-12 text-right mb-2">
      <button type="button" id="btnSyncVendorFromSAP" class="btn bgc-warning"><fmt:message key="vendor.sync.from.sap"/></button>
    </div>

    <!-- \Table -->
    <div class="card">
      <div class="table-responsive">
        <table class="table table-bordered table-striped">
          <thead>
          <tr class="table-success">
            <th class="bgc-primary border-primary text-white text-center" style="width: 2%">#</th>
            <th class="bgc-primary border-primary text-white "><fmt:message key="ncc.code" /></th>
            <th class="bgc-primary border-primary text-white "><fmt:message key="ncc.name" /></th>
            <th class="bgc-primary border-primary text-white "><fmt:message key="ncc.address" /></th>
            <th class="bgc-primary border-primary text-white "><fmt:message key="ncc.taxNumber" /></th>
            <th class="bgc-primary border-primary text-white text-center">#</th>
          </tr>
          </thead>
          <tbody>
          <c:if test="${empty page.content}">
            <tr>
              <td colspan="5" class="text-center text-none-data">
                <fmt:message key="not.data" />
              </td>
            </tr>
          </c:if>
          <c:forEach var="item" items="${page.content}" varStatus="cnt">
            <tr>
              <td class="text-center"><c:out value="${cnt.count + page.size * page.number}" /></td>
              <td>${item.code}</td>
              <td>${item.name}</td>
              <td>
                <span>${item.street} ${item.district} ${item.city}</span>
              </td>
              <td>${item.taxNumber}</td>
              <td class="text-center">
                <security:authorize access="hasAnyRole('ROLE_ADMIN')">
                  <button type="button" class="btn text-link show_detail" id="${item.code}" data-toggle="modal" data-target="#modal--vendor_preview_detail"><i class="icon-pencil7"></i><span> <fmt:message key="button.preview"/></span></button>
                </security:authorize>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
      <!-- Pagination -->
      <jsp:include page="/themes/admin/common/pagination.jsp">
        <jsp:param value="${page.number}" name="pageNumber" />
        <jsp:param value="${page.totalPages}" name="maxPages" />
        <jsp:param value="${page.size}" name="size" />
        <jsp:param value="${page.totalElements}" name="totalElements" />
      </jsp:include>
    </div>
    <!-- /Table -->
  </form:form>
</div>

<div id="modal--vendor_preview_detail" class="modal fade">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <span class="font-weight-semibold modal-title"><fmt:message key="label.ncc.detail"/></span>
        <button type="button" id="close__modal_confirm" class="close" data-dismiss="modal">&times;</button>
      </div>

      <div class="modal-body">
        <div class="row">
          <div class="col-12 col-md-6">
            <div class="form-group">
              <label for="ncc_code"><fmt:message key="ncc.code"/>: <strong id="ncc_code"></strong></label>
            </div>
          </div>
          <div class="col-12 col-md-6">
            <div class="form-group">
              <label for="ncc_name"><fmt:message key="ncc.name"/>: <strong id="ncc_name"></strong></label>
            </div>
          </div>
          <div class="col-12 col-md-6">
            <div class="form-group">
              <label for="ncc_taxNumber"><fmt:message key="ncc.taxNumber"/>: <strong id="ncc_taxNumber"></strong></label>
            </div>
          </div>
          <div class="col-12 col-md-6">
            <div class="form-group">
              <label for="ncc_address"><fmt:message key="ncc.address"/>: <strong id="ncc_address"></strong></label>
            </div>
          </div>
        </div>
      </div>

      <div class="modal-footer">
        <button type="button" class="btn btn-link" data-dismiss="modal"><fmt:message key="action.close"/></button>
      </div>
    </div>
  </div>
</div>
