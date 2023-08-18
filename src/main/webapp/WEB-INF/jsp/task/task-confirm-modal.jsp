<div id="modal--task__confirm" class="modal fade">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <span class="font-weight-semibold modal-title"><fmt:message key="action.task.update.confirm"/></span>
        <button type="button" id="close__modal_confirm" class="close" data-dismiss="modal">&times;</button>
      </div>

      <div class="modal-body">
        <div class="note">
          <fmt:message key="action.task.update.confirm.note"/>
        </div>
      </div>

      <div class="modal-footer">
        <button type="button" class="btn btn-link" data-dismiss="modal"><fmt:message key="action.cancel"/></button>
        <button type="button" id="btn--update__rejected" class="btn btn-danger" data-toggle="modal" data-target="#request__enter--cause"><span class="mr-1 icon"></span><span><fmt:message key="action.task.update.rejected"/></span></button>
        <button type="button" id="btn--update__confirmed" class="btn btn-success"><i class="icon-stack-check mr-1"></i><span><fmt:message key="action.task.update.confirmed"/></span></button>
      </div>
    </div>
  </div>
</div>

<div id="request__enter--cause" class="modal fade">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header"><span class="font-weight-semibold modal-title"><fmt:message key="action.task.update.confirm"/></span><button type="button" class="close" data-dismiss="modal">&times;</button></div>
      <div class="modal-body">
        <div class="row"><div class="alert-danger" id="message__response"></div></div>
        <div class="row">
          <div class="col-12">
            <div class="form-group">
              <label><fmt:message key="label.task.input.note.required"/><span class="text-danger">(<fmt:message key="label.input.required"/>)*:</span></label>
              <input type="text" class="form-control" id="inputCause" placeholder="Entering your cause to reject for this task..." />
              <div class="message text-danger mt-2"></div>
            </div>
          </div>
        </div>
      </div>

      <div class="modal-footer">
        <button type="button" class="btn btn-link" data-dismiss="modal"><fmt:message key="action.cancel"/></button>
        <button type="button" id="btn__send--cause" class="btn btn-success"><span class="mr-1 icon"></span><span><fmt:message key="action.confirm"/></span></button>
      </div>
    </div>
  </div>
</div>
