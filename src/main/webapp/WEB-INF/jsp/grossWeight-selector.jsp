<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>


<div class="row">
	<div class="col-md-12">
	<!-- Grey header and footer -->
	<div class="card">
		<div class="card-header bg-light d-flex justify-content-between">
			<span class="font-size-sm text-uppercase font-weight-semibold"><fmt:message key="grossWeight.material.info"/></span>
			<span class="font-size-sm font-weight-semibold" id="showFormDetailModal">
			    <button type="button" class="btn-primary btn py-1 add-row-form-detail" id="addRowFormDetail">
                    <i class="icon-file-plus mr-1"></i> Thêm lần cân
                </button>
                <button type="button" class="add-plus" data-toggle="modal" data-target="#modal_form_detail" id="add-plus">+</button>
			</span>
		</div>
		<div class="card-body">
			<div class="table-responsive table-scroll">
               	<table id="tblSelectedphieuCanChiTiets" class="table table-bordered table-striped">
					<thead>
						<tr class="table-success">
							<th width="3%">#</th>
							<th width="5%" class="text-center icon_head"><i class="icon-menu-open2"></i></th>
							<th class="mw-300"><fmt:message key="barn.name" /></th>
							<th class="mw-300"><fmt:message key="grossWeight.mahang" /></th>
							<th class="mw-100"><fmt:message key="grossWeight.dvt" /></th>
							<th class="mw-100"><fmt:message key="grossWeight.amount" /></th>
							<th class="mw-100"><fmt:message key="grossWeight.tlCan" /></th>
							<th class="mw-100"><fmt:message key="grossWeight.amount.female" /></th>
							<th class="mw-100"><fmt:message key="grossWeight.khoiluonggiamtru" /></th>
							<th class="mw-300"><fmt:message key="grossWeight.status" /></th>
						</tr>
					</thead>
					<tbody>
						<c:forEach begin="0" items="${phieuCanChiTiets}" var="item" varStatus="cnt">
						    <tr id="rec-material${cnt.index}">
								<td><span class="no"><c:out value="${cnt.count+page.size*page.number}"></c:out></span></td>
								<td class="text-center icon">
						        	<div class="list-icons">
						        	    <security:authorize access="hasAnyRole('ROLE_ADMIN')">
						        	         <button type="button" class="btn-primary btn-xs btn-edit btn-shadow px-2 py-1" id="edit_form_item-${item.id}"><i class="icon-pencil7"></i></button>
						        	    </security:authorize>
										<button type="button" class="btn-danger btn-remove btn-xs btn-shadow px-2 py-1" onclick="javascript:MaterialSelector.removeRow(${cnt.index})" title="Remove Row" style="display: inline-block; float: none; border: none"><i class="fa fa-times"></i></button>
						        	</div>
						        </td>
								<td data-popup="tooltip" title="${item.tenChuong}">
								    <input type="text" class="form-control" id="chuong-${cnt.index}" value="${item.tenChuong}" disabled="disabled" />
								    <input type="hidden" id="input-item-id_${cnt.index}" value="${item.id}" />
								</td>
								<td data-popup="tooltip" title="${item.loaiHang}"><input type="text" class="form-control" id="loaiHang-${cnt.index }" value="${item.loaiHang}" disabled="disabled" /></td>
						        <td data-popup="tooltip" title="${item.dvt}">
						            <input type="text" class="form-control" id="selected-item-dvt${cnt.index}" value="${item.dvt}" disabled="disabled" />
						        </td>
						        <td data-popup="tooltip" title="${item.soLuong}">
                                    <input type="text" class="form-control" id="selected-item-soLuong${cnt.index}" value="${item.soLuong}" disabled="disabled"/>
                                </td>
                                <td data-popup="tooltip" title="${item.tlCan}">
                                    <input type="text" class="form-control" id="selected-item-tlCan${cnt.index}" value="${item.tlCan}" disabled="disabled" />
                                    <%-- <input type="hidden" name="phieuCanChiTiets[${cnt.index}].ngayCan" class="form-control" id="selected-item-ngay${cnt.index}" value="${item.ngayCan}" /> --%>
                                </td>
                                <td data-popup="tooltip" title="${item.slHeoCai}">
                                    <input type="text" class="form-control" id="selected-item-slHeoCai${cnt.index}" value="${item.slHeoCai}" disabled="disabled" />
                                </td>
                                <td data-popup="tooltip" title="${item.tlGiamTru}">
                                    <input type="text" class="form-control" id="selected-item-tlGiamTru${cnt.index}" value="${item.tlGiamTru}" disabled="disabled" />
                                </td>
                                <td data-popup="tooltip" title="${item.trangThai}">
                                    <input type="text" class="form-control" id="selected-item-trangThai${cnt.index}" value="${item.trangThai}" disabled="disabled" />
                                    <input type="hidden" class="index-table" value="${cnt.index}">
                                </td>
							</tr>
						</c:forEach>
					</tbody>
				</table>            	
			</div>
		</div>
	</div>
	<!-- /grey header and footer -->
	</div>
</div>

<div id="modal_form_detail" class="modal fade" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><fmt:message key="grossWeight.enter.detail" /></h5>
                <button type="button" class="close cancel_form_detail" data-dismiss="modal">&times;</button>
            </div>

            <div class="modal-body">
                <input type="hidden" name="phieuCanChiTiets[0].id" id="selector-item-id" value="" />
                <input type="hidden" name="phieuCanChiTiets[0].lanCan" id="selector-item-lanCan" value="" />
                <input type="hidden" name="phieuCanChiTiets[0].traiXuat" id="selector-item-traiXuat" value="" />
                <input type="hidden" name="phieuCanChiTiets[0].soPhieu" id="selector-item-soPhieu" value="" />
                <input type="hidden" name="phieuCanChiTiets[0].soPhieuXk" id="selector-item-soPhieuXk" value="" />
                <div class="row">
                    <div class="col-md-6">
                        <label><fmt:message key="barn.name" /></label>
                        <select class="form-control select2 selected-chuong-code" name="phieuCanChiTiets[0].chuong"
                             id="select-item-chuong" ${item.chuong != null ? 'disabled':'' } data-placeholder="Chọn Chuồng" data-fouc>
                         </select>
                    </div>
                    <div class="col-md-6">
                        <label><fmt:message key="grossWeight.mahang" /> <span class="text-danger">*</span></label>
                        <select class="form-control select2 selected-loaiHang-code" name="phieuCanChiTiets[0].loaiHang" 
                             id="select-item-loaihang" data-placeholder="Chọn loại hàng" data-fouc>
                         </select>
                    </div>
                </div>
                <div class="row mt-3">
                    <div class="col-md-6">
                        <label><fmt:message key="grossWeight.dvt" /> <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="input-item-dvt" name="phieuCanChiTiets[0].dvt" placeholder="Nhập đơn vị tính..." value="" required="required" />
                    </div>
                    <div class="col-md-6">
                        <label><fmt:message key="grossWeight.amount" /> <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="input-item-amount" name="phieuCanChiTiets[0].soLuong" placeholder="Nhập số lượng cân..." value="" required="required" />
                    </div>
                </div>
                <div class="row mt-3">
                    <div class="col-md-6">
                        <label><fmt:message key="grossWeight.tlCan" /> <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="input-item-tlCan" name="phieuCanChiTiets[0].tlCan" placeholder="Nhập khối lượng cân..." value="" required="required" />
                    </div>
                    <div class="col-md-6">
                        <label><fmt:message key="grossWeight.amount.female" /></label>
                        <input type="text" class="form-control" id="input-item-slHeoCai" name="phieuCanChiTiets[0].slHeoCai" placeholder="Nhập số lượng heo cái..." value="" />
                    </div>
                </div>
                <div class="row mt-3">
                    <div class="col-md-6">
                        <label><fmt:message key="grossWeight.khoiluonggiamtru" /></label>
                        <input type="text" class="form-control" id="input-item-tlGiamTru" name="phieuCanChiTiets[0].tlGiamTru" placeholder="Nhập khối lượng giảm trừ..." value="" />
                    </div>
                    <div class="col-md-6">
                        <label><fmt:message key="grossWeight.status" /></label>
                        <input type="text" class="form-control" id="input-item-status" name="phieuCanChiTiets[0].trangThai" placeholder="Nhập trạng thái bệnh/ghi chú..." value="" />
                    </div>
                </div>
                <hr>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-link cancel_form_detail" data-dismiss="modal">Hủy</button>
                <button type="button" class="btn bg-primary" id="submit_form_detail">Lưu</button>
            </div>
        </div>
    </div>
</div>
<br/>		