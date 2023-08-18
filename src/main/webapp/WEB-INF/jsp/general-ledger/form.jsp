<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
  <title><fmt:message key="generalLedger.list.title" /></title>
  <meta name="menu" content="generalLedgerMenu" />

  <link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">

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

  <script src="<c:url value='/themes/admin/assets/js/general-ledger.form.js'/>"></script>
</head>

<div class="content">

  <form:form id="generalLedgerForm" modelAttribute="generalLedger" action="/general-ledger/form" method="POST">
    <form:hidden path="id" id="generalLedgerId" />
    <form:hidden path="transCode" />
    <form:hidden path="createdBy" />
    <form:hidden path="createdDate" />
    <c:if test="${generalLedger.status ne 'cancel'}">
      <form:hidden path="status"/>
    </c:if>

    <div class="row mb-3">
      <div class="col-12 col-md-6">
        <div class="text-color-primary fs-5"><fmt:message key="generalLedger.form.title" /></div>
      </div>
    </div>
    <div class="card rounded-16">
      <div class="card-body">
        <div class="row">
          <div class="col-12 col-md-6">
            <p class="text-uppercase fw-bold mb-0"><fmt:message key="label.generalLedger.info"/></p>
          </div>
          <c:if test="${generalLedger.status eq 'completed'}">
            <div class="col-12 col-md-6 text-md-right">
              <fmt:message key="doc.FI" />: <span class="fw-bold"><c:out value="${generalLedger.fiDoc}" /></span>
            </div>
          </c:if>
        </div>
        <hr>
        <div class="row">
          <div class="col-12 col-md-6">
            <%--transCode--%>
            <div class="col-12">
              <div class="form-group row">
                <span class="col-12 col-md-3 text-md-right flex-center-vertical"><fmt:message key="label.generalLedger.transCode" /></span>
                <div class="col-12 col-md-9">
                  <input type="text" id="transCode" class="form-control rounded-10" value="${generalLedger.transCode}" readonly
                    placeholder="Hệ thống tự động tạo khi thêm mới..."
                  />
                </div>
              </div>
            </div>
            <%--/transCode--%>

            <%--farmCode--%>
            <div class="col-12">
              <div class="form-group row">
                <span class="col-12 col-md-3 text-md-right"><fmt:message key="farm.code" /> <span class="text-danger">*</span></span>
                <div class="col-12 col-md-9 form-item__inner">
                  <select name="farm.code" id="farmCode" class="select2 form-control rounded-10" data-placeholder="Chọn trại" autofocus tabindex="1">
                    <option value=""></option>
                    <c:forEach var="farm" items="${farms}">
                      <option value="${farm.code}" ${generalLedger.farm != null && generalLedger.farm.code eq farm.code ? "selected" : ""}><c:out value="${farm.code}"/> <c:out value="${farm.name}"/></option>
                    </c:forEach>
                  </select>
                </div>
              </div>
            </div>
            <%--/farmCode--%>

            <%--docCode--%>
            <div class="col-12">
              <div class="form-group row">
                <span class="col-12 col-md-3 text-md-right"><fmt:message key="label.generalLedger.docCode"/> <span class="text-danger">*</span></span>
                <div class="col-12 col-md-9 form-item__inner">
                  <select name="docCode" id="docCode" class="select2 form-control rounded-10" data-placeholder="Chọn loại hóa đơn" required>
                    <option value=""></option>
                    <c:forEach var="item" items="${docCodes}">
                      <option value="${item}" ${item eq generalLedger.docCode ? "selected" : ""}><c:out value="${item}"/> - <fmt:message key="label.generalLedger.docCode.${item}"/></option>
                    </c:forEach>
                  </select>
                </div>
              </div>
            </div>
            <%--/docCode--%>

            <%--object name--%>
            <div class="col-12">
              <div class="form-group row">
                <span class="col-12 col-md-3 text-md-right"><fmt:message key="label.vendor.object.name"/> <span class="text-danger">*</span></span>
                <div class="col-12 col-md-9 form-item__inner">
                  <select name="vendor.code" id="vendorCode" class="select2 form-control rounded-10" data-placeholder="Chọn đối tượng công nợ" required>
                    <option value=""></option>
                    <c:forEach var="vendor" items="${vendors}">
                      <option value="${vendor.code}" ${generalLedger.vendor != null && generalLedger.vendor.code eq vendor.code ? "selected":""}><c:out value="${vendor.code}"/> <c:out value="${vendor.name}"/></option>
                    </c:forEach>
                  </select>
                </div>
              </div>
            </div>
            <%--/object --%>

              <%--vendorName--%>
            <div class="col-12">
              <div class="form-group row">
                <span class="col-12 col-md-3 text-md-right"><fmt:message key="label.vendor.name.other"/></span>
                <div class="col-12 col-md-9 form-item__inner">
                  <input type="text" id="vendorName" class="form-control rounded-10" name="vendorName" value="${generalLedger.vendorName}"
                    placeholder="Chọn đối tượng công nợ | nhập tay..." maxlength="35"
                  >
                </div>
              </div>
            </div>
                <%--/vendorName--%>

            <%--taxNumber--%>
            <div class="col-12">
              <div class="form-group row">
                <span class="col-12 col-md-3 text-md-right"><fmt:message key="label.vendor.taxNumber"/></span>
                <div class="col-12 col-md-9 form-item__inner">
                  <input type="text" id="taxNumber" class="form-control rounded-10" name="vendorTax"
                         value="${generalLedger.vendorTax}"
                         placeholder="Chọn đối tượng công nợ | nhập tay..."
                  />
                </div>
              </div>
            </div>
            <%--/taxNumber--%>

            <%--address--%>
            <div class="col-12">
              <div class="form-group row">
                <span id="label__address" class="col-12 col-md-3 text-md-right"><fmt:message key="label.vendor.address"/></span>
                <div class="col-12 col-md-9 form-item__inner">
                  <input type="text" id="address" class="form-control rounded-10" name="address" value="${generalLedger.address}"
                         placeholder="Chọn đối tượng cđơnng nợ | nhập tay..."
                  />
                </div>
              </div>
            </div>
            <%--/address--%>
          </div>
          <div class="col-12 col-md-6">

              <c:if test="${generalLedger.status eq 'cancel'}">
                <security:authorize access="hasAnyRole('ROLE_GENERAL_LEDGER_CANCEL,ROLE_GENERAL_LEDGER_STATUS')">
                <div class="col-12">
                  <div class="form-group row">
                    <label for="vendorName" class="col-12 col-md-3 text-md-right"><fmt:message key="label.generalLedger.status"/></label>
                    <div class="col-12 col-md-9">
                      <select name="status" id="status" class="select2 form-control rounded-10">
                        <option value="cancel" selected><fmt:message key="label.generalLedger.status.cancel"/></option>
                        <option value="completed"><fmt:message key="label.generalLedger.status.completed"/></option>
                      </select>
                    </div>
                  </div>
                </div>
                </security:authorize>
                <security:authorize access="!hasAnyRole('ROLE_GENERAL_LEDGER_CANCEL')">
                  <form:hidden path="status"/>
                </security:authorize>
              </c:if>
            <%--docSymbol--%>
            <div class="col-12">
              <div class="form-group row">
                <label for="docSymbol" class="col-12 col-md-3 text-md-right"><fmt:message key="label.generalLedger.docSymbol" /></label>
                <div class="col-12 col-md-9 form-item__inner">
                  <input type="text" id="docSymbol" class="form-control rounded-10" name="docSymbol" value="${generalLedger.docSymbol}" placeholder="Nhập ký hiệu hoá đơn..." maxlength="10" tabindex="2">
                </div>
              </div>
            </div>
            <%--/docSymbol--%>

            <%--docNum--%>
            <div class="col-12">
              <div class="form-group row">
                <label for="docNum" class="col-12 col-md-3 text-md-right"><fmt:message key="label.generalLedger.docNum"/> <span class="text-danger">*</span></label>
                <div class="col-12 col-md-9 form-item__inner">
                  <input type="text" id="docNum" class="form-control rounded-10" name="docNum" value="${generalLedger.docNum}" placeholder="Nhập số hoá đơn..." maxlength="10" required>
                </div>
              </div>
            </div>
            <%--/docNum--%>
              <%--postingDate--%>
            <div class="col-12">
              <div class="form-group row">
                <label for="postingDate" class="col-12 col-md-3 text-md-right"><fmt:message key="label.generalLedger.postingDate"/> <span class="text-danger">*</span></label>
                <div class="col-12 col-md-9 form-item__inner">
                  <input type="text" id="postingDate" class="form-control rounded-10" name="postingDateStr" placeholder="dd-MM-yyyy" value="${generalLedger.displayPostingDate}" autocomplete="off" required>
                </div>
              </div>
            </div>
              <%--/postingDate--%>



              <%--docDate--%>
            <div class="col-12">
              <div class="form-group row">
                <label for="docDate" class="col-12 col-md-3 text-md-right"><fmt:message key="label.generalLedger.docDate"/> <span class="text-danger">*</span></label>
                <div class="col-12 col-md-9 form-item__inner">
                  <input type="text" id="docDate" class="form-control rounded-10" name="docDateStr" placeholder="dd-MM-yyyy" value="${generalLedger.displayDocDate}" autocomplete="off" >
                </div>
              </div>
            </div>
              <%--/docDate--%>

              <%--amount--%>
            <div class="col-12">
              <div class="form-group row">
                <label for="amount" class="col-12 col-md-3 text-md-right"><fmt:message key="label.generalLedger.amount"/> <span class="text-danger">*</span></label>
                <div class="col-12 col-md-9">
                  <div class="input-group form-item__inner">
                    <input type="text" id="amount" class="form-control rounded-s-10 currency" name="amount" value="${generalLedger.amount}" placeholder="1,000,000" tabindex="3" required>
                    <span class="input-group-append"><span class="input-group-text">VND</span></span>
                  </div>
                </div>
              </div>
            </div>
              <%--/amount--%>

          </div>
        </div>

        <div class="row">
            <%--description--%>
          <div class="col-12">
            <div class="form-group d-flex">
              <label for="desc" id="label__desc__input" class="text-md-right"><fmt:message key="label.generalLedger.desc"/> <span class="text-danger">*</span></label>
              <div id="desc__input" class=" form-item__inner">
                <input type="text" id="desc" class="form-control rounded-10" name="description" value="${generalLedger.description}" maxlength="255" tabindex="4" required
                  placeholder="Nhập diễn giải chi tiết..."
                />
              </div>
            </div>
          </div>
            <%--/description--%>
        </div>
        <hr>
        <div class="row">
          <div class="col-12 col-md-6 text-left">
            <a href="/general-ledger/list" class="btn btn-secondary rounded-10 mr-2"><fmt:message key="button.back"/></a>
          </div>
          <div class="col-12 col-md-6 text-right">
            <c:if test="${empty generalLedger.status || generalLedger.status eq 'confirmed'}">
              <button type="button" id="btn-submit__temporary" class="btn btn-primary rounded-10 mr-2"><i class="icon-paperplane mr-1"></i><span><fmt:message key="button.save.temporary"/></span></button>
              <button type="button" id="btn-submit__sync" class="btn btn-primary rounded-10 mr-2"><i class="icon-database-refresh mr-1"></i><fmt:message key="button.save.sync"/></button>
            </c:if>
            <security:authorize access="hasAnyRole('ROLE_ADMIN', 'ROLE_GENERAL_LEDGER_CANCEL')">
              <c:if test="${not empty generalLedger.id && generalLedger.status ne 'cancel'}"><button type="button" class="btn btn-primary rounded-10" data-toggle="modal" data-target="#modal_cancel"><i class="icon-cancel-square mr-1"></i><fmt:message key="button.cancel"/></button></c:if>
            </security:authorize>
            </div>
        </div>
      </div>
    </div>
  </form:form>
</div>

<security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_GENERAL_LEDGER_CANCEL')">
<c:if test="${not empty generalLedger.id && generalLedger.status ne 'cancel'}">
  <div id="modal_cancel" class="modal fade">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title"><fmt:message key="label.generalLedger.action.cancel.title"/></h5>
          <button type="button" class="close" data-dismiss="modal">&times;</button>
        </div>
        <div class="modal-body">
          <c:choose>
            <c:when test="${generalLedger.status eq 'completed'}"><p><fmt:message key="label.generalLEdger.action.cancel.warning"/></p></c:when>
            <c:otherwise><p><fmt:message key="label.generalLedger.action.cancel.warning.common"/></p></c:otherwise>
          </c:choose>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-link" data-dismiss="modal"><fmt:message key="action.cancel"/></button>
          <button type="button" id="btn-submit__cancel" class="btn bg-primary"><fmt:message key="action.confirm"/></button>
        </div>
      </div>
    </div>
  </div>
</c:if>
</security:authorize>