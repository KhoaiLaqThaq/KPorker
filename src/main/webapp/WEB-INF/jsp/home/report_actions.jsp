<%@ include file="/themes/common/taglibs.jsp"%>

<div class="row px-2 mb-3">
  <div class="col-12">
    <p class="text-color-primary fs-5"><fmt:message key="menu.report"/></p>
  </div>

  <div class="col-12 col-sm-3 pl-0 pr-2 mb-3">
    <div class="group--actions__report bg-white rounded-16 p-3 zoom-in-little">
      <div class="group--actions__title mb-3">
        <div class="group--actions__img d-xs-none mr-5">
          <img src="<c:url value='/themes/admin/assets/images/bao_cao.svg'/>" width="65" alt="">
        </div>
        <div class="group--actions__name flex-center-vertical">
          <p class="fs-5 text-dark"><fmt:message key="label.report.stock"/></p>
        </div>
      </div>
      <div class="row">
        <div class="col-12 col-sm-12 group--routing">
          <ul class="pl-0">
            <li><a class="text-dark" href="<c:url value='/report/instock' />"><fmt:message key="menu.report.instock" /></a></li>
            <li><a class="text-dark" href="<c:url value='/report/purchase-requisition'/>"><fmt:message key="menu.report.purchaseRequisition.FM"/></a></li>
            <li><a class="text-dark" href="<c:url value='/report/purchase-requisition-other'/>"><fmt:message key="menu.report.purchaseRequisition.VTDC"/></a></li>
            <li><a class="text-dark" href="<c:url value='/report/listGoodsReceipt'/>"><fmt:message key="menu.report.ListGoodsReceipt"/></a></li>
            <li><a class="text-dark" href="<c:url value='/report/listMaterialGA'/>"><fmt:message key="menu.report.listMaterialGA"/></a></li>
            <li><a class="text-dark" href="<c:url value='/report/day-grga'/>"><fmt:message key="menu.report.day.GRGA"/></a></li>
          </ul>
        </div>
      </div>
    </div>
  </div>
  <div class="col-12 col-sm-9 pl-0 pr-2 mb-3">
    <div class="group--actions__report bg-white rounded-16 p-3 zoom-in-little">
      <div class="group--actions__title mb-3">
        <div class="group--actions__img d-xs-none mr-5">
          <img src="<c:url value='/themes/admin/assets/images/bao_cao.svg'/>" width="65" alt="">
        </div>
        <div class="group--actions__name flex-center-vertical">
          <p class="fs-5 text-dark"><fmt:message key="label.report.production"/></p>
        </div>
      </div>

      <div class="row">
        <div class="col-12 col-md-4 col-sm-4 group--routing">
          <ul class="pl-0">
            <li><a class="text-dark" href="<c:url value='/sales/list'/>"><fmt:message key="menu.sales.data"/></a></li>
            <li><a class="text-dark" href="<c:url value='/report/day-detail'/>"><fmt:message key="menu.report.day.detail"/></a></li>
            <li><a class="text-dark" href="<c:url value='/report/daily-average-weight'/>"><fmt:message key="menu.report.dailyaverageweight"/></a></li>
            <li><a class="text-dark" href="<c:url value='/report/farm-analyst-pig-level'/>"><span><fmt:message key="menu.report.process.analyst.pigLevel"/></span></a></li>
          </ul>
        </div>
        <div class="col-12 col-md-4 col-sm-4 group--routing">
          <ul class="pl-0">
            <li ><a class="text-dark" href="<c:url value='/report/instock-pig'/>"><fmt:message key="menu.report.instock.pig"/></a></li>
            <li><a class="text-dark" href="<c:url value='/report/weight-compare'/>"><fmt:message key="menu.report.weightCompare"/> - <fmt:message key="menu.report.weightCompare.byProcessOrder"/></a></li>
            <li><a class="text-dark" href="<c:url value='/report/weight-compare-by-pigLevel'/>"><span><fmt:message key="menu.report.weightCompare"/> - <fmt:message key="menu.report.weightCompare.byPigLevel"/></span></a></li>
            <li><a class="text-dark" href="<c:url value='/report/prod-estimate'/>"><span><fmt:message key="menu.report.prodEstimate"/> - <fmt:message key="menu.report.prodEstimate.byPoCode"/></span></a></li>
            <li><a class="text-dark" href="<c:url value='/report/prod-estimate-by-level'/>"><span><fmt:message key="menu.report.prodEstimate"/> - <fmt:message key="menu.report.prodEstimate.byLevel"/></span></a></li>
          </ul>
        </div>
        <div class="col-12 col-md-4 col-sm-4 group--routing">
          <ul class="pl-0">
            <li><a class="text-dark" href="<c:url value='/report/prod-result'/>"><span><fmt:message key="menu.report.prodResult"/> - <fmt:message key="menu.report.prodEstimate.byPoCode"/></span></a></li>
            <li><a class="text-dark" href="<c:url value='/report/prod-result-by-level'/>"><span><fmt:message key="menu.report.prodResult"/> - <fmt:message key="menu.report.prodEstimate.byLevel"/></span></a></li>
            <li><a class="text-dark" href="<c:url value='/report/sale-estimate'/>"><fmt:message key="menu.report.saleEstimate"/></a></li>
            <li><a class="text-dark" href="<c:url value='/report/data-invest'/>"><fmt:message key="menu.report.invest"/></a></li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</div>