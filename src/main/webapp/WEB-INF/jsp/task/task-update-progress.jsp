<div id="modal--task__progress" class="modal fade">
  <div class="modal-dialog">
    <form:form id="updateProgress" action="${ctx}/task/update-progress" modelAttribute="task" method="post" enctype="multipart/form-data">
      <input type="hidden" name="id" id="tId" value="${task.id}" />
      <input type="hidden" name="code" id="tCode" value="${task.code}" />
      <div class="modal-content">
        <div class="modal-header">
          <span class="font-weight-semibold modal-title"><fmt:message key="action.task.update.progress"/></span>
          <button type="button" id="close__modal_progress" class="close" data-dismiss="modal">&times;</button>
        </div>
  
        <div class="modal-body">
          <div class="evidences">
            <div class="row">
              <div class="col-12">
                <p><fmt:message key="action.task.update.progress.required"/></p>
                <b><fmt:message key="action.task.update.maxSize"/></b>
                <input type="file" id="photos" name="photos" class="file-input-preview" multiple>
              </div>
            </div>
          </div>
        </div>
  
        <div class="modal-footer">
          <button type="button" id="btn--submit__progress" class="btn bgc-warning"><i class="icon-stack-check mr-1"></i><span><fmt:message key="action.task.update"/></span></button>
        </div>
      </div>
    </form:form>
  </div>
</div>