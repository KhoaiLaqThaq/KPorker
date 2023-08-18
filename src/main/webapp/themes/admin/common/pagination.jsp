<%@ include file="/themes/common/taglibs.jsp"%>

<c:set var="pageNumber" value="${param.pageNumber}" />
<c:set var="maxPages" value="${param.maxPages}" />
<c:set var="size" value="${param.size}" />
<c:set var="currentPage" value="${param.pageNumber + 1}"/>
<c:set var="totalElements" value="${param.totalElements}" />

<input type="hidden" name="page" id="page" value="${param.pageNumber}">
<input type="hidden" name="size" id="size" value="${param.size}">


<c:choose>
	<c:when test="${maxPages gt 0}">
		<div class="row">
			<div class="col-lg-12">
				<%-- ${pageNumber}/${currentPage}/${maxPages} and ${pageNumber - 5} and ${pageNumber + 5} --%>
				<div class="card card-body card-custom text-center">
					<ul class="pagination pagination-separated align-self-center">
					<c:choose>
			      		<c:when test="${(currentPage + 1) <= maxPages}">
			      			<li class="page-item disabled"><span class="page-link">Showing ${(currentPage - 1) * size + 1} to ${(currentPage * size)} of ${totalElements} items</span></li>
			      		</c:when>
			      		<c:otherwise>
			      			<li class="page-item disabled"><span class="page-link">Showing ${(currentPage - 1) * size + 1} to ${totalElements} of ${totalElements} items</span></li>
			      		</c:otherwise>
			      	</c:choose>
			      	<c:choose>
						<c:when test="${(pageNumber - 1) >= 0}">
							<li class="page-item"><a href="#" onclick="submitSearchForm(0, ${size}, $(this));" class="page-link">&lt; &lt;</a></li>	
						</c:when>
						<c:otherwise>
							<li class="page-item disabled"><a href="#" class="page-link">&lt; &lt;</a></li>
						</c:otherwise>
					</c:choose>
					<c:choose>
						<c:when test="${(pageNumber - 1) >= 0}">
							<li class="page-item"><a href="#" onclick="submitSearchForm(${pageNumber - 1}, ${size}, $(this));" class="page-link">&larr; &nbsp; Prev</a></li>	
						</c:when>
						<c:otherwise>
							<li class="page-item disabled"><a href="#" class="page-link">&larr; &nbsp; Prev</a></li>
						</c:otherwise>
					</c:choose>
					<c:choose>
						<c:when test="${maxPages <= 5}">
					      	<c:forEach var="i" begin="1" end="${maxPages}">
					      		<c:choose>
					      			<c:when test="${i == (pageNumber + 1)}">
					      				<li class="page-item active"><a href="#" class="page-link"><c:out value="${i}"/></a></li>
					      			</c:when>
					      			<c:otherwise>
					      				<li class="page-item"><a href="#" onclick="submitSearchForm(${i - 1}, ${size}, $(this));" class="page-link"><c:out value="${i}"/></a></li>
					      			</c:otherwise>
					      		</c:choose>
					      	</c:forEach>
						</c:when>
						<c:otherwise>
							<c:choose>
								<c:when test="${(pageNumber + 5) > maxPages}">
									<%-- pageNumber + 5: ${pageNumber + 5} --%>
							      	<c:forEach var="i" begin="${maxPages - 4}" end="${maxPages}">
							      		<c:choose>
							      			<c:when test="${i == (pageNumber + 1)}">
							      				<li class="page-item active"><a href="#" class="page-link"><c:out value="${i}"/></a></li>
							      			</c:when>
							      			<c:otherwise>
							      				<li class="page-item"><a href="#" onclick="submitSearchForm(${i - 1}, ${size}, $(this));" class="page-link"><c:out value="${i}"/></a></li>
							      			</c:otherwise>
							      		</c:choose>
							      	</c:forEach>
								</c:when>
								<c:when test="${(pageNumber - 4) < 0}">
									<%--   pageNumber - 5: ${pageNumber - 5} --%>
							      	<c:forEach var="i" begin="1" end="5">
							      		<c:choose>
							      			<c:when test="${i == (pageNumber + 1)}">
							      				<li class="page-item active"><a href="#" class="page-link"><c:out value="${i}"/></a></li>
							      			</c:when>
							      			<c:otherwise>
							      				<li class="page-item"><a href="#" onclick="submitSearchForm(${i - 1}, ${size}, $(this));" class="page-link"><c:out value="${i}"/></a></li>
							      			</c:otherwise>
							      		</c:choose>
							      	</c:forEach>
								</c:when>
								<c:otherwise>
									<%--  ${pageNumber - 2} - ${pageNumber + 2} --%>
							      	<c:forEach var="i" begin="${currentPage - 2}" end="${currentPage + 2}">
							      		<c:choose>
							      			<c:when test="${i == (pageNumber + 1)}">
							      				<li class="page-item active"><a href="#" class="page-link"><c:out value="${i}"/></a></li>
							      			</c:when>
							      			<c:otherwise>
							      				<li class="page-item"><a href="#" onclick="submitSearchForm(${i - 1}, ${size}, $(this));" class="page-link"><c:out value="${i}"/></a></li>
							      			</c:otherwise>
							      		</c:choose>
							      	</c:forEach>
								</c:otherwise>
							</c:choose>
						</c:otherwise>
					</c:choose>
			      	<c:choose>
			      		<c:when test="${(currentPage + 1) <= maxPages}">
			      			<li class="page-item"><a href="#" onclick="submitSearchForm(${currentPage}, ${size}, $(this));" class="page-link">Next &nbsp; &rarr;</a></li>	
			      		</c:when>
			      		<c:otherwise>
			      			<li class="page-item disabled"><a href="#" class="page-link">Next &nbsp; &rarr;</a></li>
			      		</c:otherwise>
			      	</c:choose>
			      	<c:choose>
						<c:when test="${(currentPage + 1) <= maxPages}">
							<li class="page-item"><a href="#" onclick="submitSearchForm(${maxPages - 1}, ${size}, $(this));" class="page-link">&gt; &gt;</a></li>	
						</c:when>
						<c:otherwise>
							<li class="page-item disabled"><a href="#" class="page-link">&gt; &gt;</a></li>
						</c:otherwise>
					</c:choose>
			      		<li class="page-link">
			      			<span><c:out value="Show"></c:out></span>
			      			<select id="selectPage">
								<c:forEach var="i" begin="10" end="40" step="10">
									<option value="${i}" ${size eq i ? 'selected' : ''}>${i}</option>
								</c:forEach>
							</select>
							<c:out value="items"></c:out>
			      		</li>
					</ul>
				</div>
			</div>
		</div>
	</c:when>
	<c:otherwise></c:otherwise>
</c:choose>


<script>
$(document).ready(function(){
    $('#selectPage').on('change', function(){
    	submitSearchForm(0, this.value, this);
    });
  });
function submitSearchForm(page, size, $element) {
	$("#page").val(page);
	$("#size").val(size);
	$element.closest("form").submit();
}
</script>