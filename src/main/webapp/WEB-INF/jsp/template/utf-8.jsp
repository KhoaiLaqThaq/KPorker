<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
  <title>Import template</title>
  <meta name="menu" content="templateImport2" />

  <script src="<c:url value="/themes/admin/assets/js/template/template.utf-8.js" />"></script>
</head>

<div class="content">
  <div class="card">
    <div class="card-body">
      <div class="row mb-3">
        <div class="col-12 col-md-6">Upload form template</div>
        <div class="col-12 col-md-6 text-right">
          <input type="file" name="excelFile" id="excelFile" />
          <button type="button" class="btn btn-warning" id="btn_upload">Upload</button>
        </div>
      </div>
    </div>
  </div>

  <div class="card hide" id="container__card">
    <form:form id="templateForm" modelAttribute="template" method="POST" action="/template/utf-8">
        <div class="card-body">
            <div class="row" id="container__temp">

            </div>
            <div class="row">
              <div class="col-12 text-right">
                <button type="button" id="btn__Submit" class="btn btn-primary"><fmt:message key="action.save"/></button>
              </div>
            </div>
        </div>
    </form:form>
  </div>
</div>

