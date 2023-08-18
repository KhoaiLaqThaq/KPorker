package com.keysoft.pigfarm.controller;

import com.keysoft.pigfarm.common.*;
import com.keysoft.pigfarm.common.util.FancyTree;
import com.keysoft.pigfarm.helper.DateTimeHelper;
import com.keysoft.pigfarm.integration.EntityResponse;
import com.keysoft.pigfarm.manager.*;
import com.keysoft.pigfarm.production.dto.*;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

@Slf4j
@RestController
@RequestMapping("/api")
public class AjaxController {
	@Autowired
	private PlantManager plantManager;
	@Autowired
	private FarmManager farmManager;
	@Autowired
	private UserManager userManager;
	@Autowired
	private MaterialManager materialManager;
	@Autowired
	private BarnManager barnManager;
	@Autowired
	private GrossWeightManager grossWeightManager;
	@Autowired
	private MaterialSupportManager materialSupportManager;
	@Autowired
	private ProcessOrderManager processOrderManager;
	@Autowired
	private GoodsAttritionSupportManager goodsAttritionSupportManager;
	@Autowired
	private GoodsIssueManager goodsIssueManager;
	@Autowired
	private MaterialDetailManager materialDetailManager;
	@Autowired
	private InstockAdjustmentManager instockAdjustmentManager;
	@Autowired
	private ProductionManager productionManager;
	@Autowired
	private NotificationManager notificationManager;
	@Autowired
	private TaskManager taskManager;
	@Autowired
	private HomeManager homeManager;
	@Autowired
	private VendorManager vendorManager;
	@Autowired
	private SyncDataManager syncDataManager;
	@Autowired
	private GeneralLedgerManager generalLedgerManager;
	@Autowired
	private InstockManager instockManager;
	@Autowired
	private RoleManager roleManager;

	@GetMapping("/farmByUsernameLogin")
	public ResponseEntity<?> getFarmByUsernameLogin() {
		return ResponseEntity.ok(farmManager.getFarmByUserName());
	}
	
	@GetMapping("/plants")
	public ResponseEntity<?> getPlants() {
		log.info("---------process=get-plants method...");
		return ResponseEntity.ok(plantManager.gets());
	}
	
	@GetMapping("/farmsByPlant/{code}")
	public ResponseEntity<?> getFarmsByPlantCode(@PathVariable(required = true, name = "code") String plantCode) {
		log.info("---------process=get-farms-by-plantcode, plantCode: {}", plantCode);
		return ResponseEntity.ok(farmManager.getsByPlantCode(plantCode));
	}
	
	@GetMapping("/barnsByFarm/{code}")
	public ResponseEntity<?> getBarnsByFarmCode(@PathVariable(required = true, name = "code") String farmCode) {
		log.info("************CONTROLLER::get-barns-by-farmCode, farmCode: {}********************", farmCode);
		return ResponseEntity.ok(barnManager.getsByFarmCode(farmCode));
	}
	
	@GetMapping("/user/{username}")
	@ResponseBody
	public boolean checkMessage(@PathVariable(required = true, name = "username") String username) {
		log.info("-------process=check-message, username={}", username);
		return userManager.getByUsername(username).getId() != null;
	}
	
	@GetMapping("/user/checkEmail/{email}")
	public ResponseEntity<?> checkExistEmail(@PathVariable(required = true, name = "email") String email) {
		log.info("-----process=check-email, email={}", email);
		return ResponseEntity.ok(userManager.getByEmail(email));
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@GetMapping("/get-tree/{username}")
	public ResponseEntity<FancyTree> getTree(@PathVariable(required = false, name = "username") String username) {
		FancyTree root = new FancyTree();
		List comNodes = new ArrayList();
		comNodes.add(farmManager.getTree(username));
		root.setChildren(comNodes);
		
		return ResponseEntity.ok(root);
	}
	
	@GetMapping("/get-material-by-name")
    @ResponseBody
    public List<MaterialDto> searchByName(@RequestParam(value="q", required=false) String name) throws Exception {
    	log.info("ENTERING 'SEARCH MATERIAL BY NAME' METHOD...");
    	MaterialDto materialDto = new MaterialDto();
    	materialDto.setKeyword(name);
    	return materialManager.searchByName(materialDto);
    }
	
	@GetMapping("/get-material-instock-by-name")
    @ResponseBody
    public List<MaterialDetailDto> searchMaterialInstockByName(@RequestParam(value="q", required=false) String name,
															   @RequestParam(value="stockCode", required=false) String stockCode,
															   @RequestParam(value="postingDate", required=false) String postingDate,
															   @RequestParam(value="movementType", required=false) String movementType) throws Exception {
    	log.info("ENTERING 'SEARCH MATERIAL_DETAIL IN INSTOCK BY NAME' METHOD...");
    	MaterialDetailDto materialDetailDto = new MaterialDetailDto();
    	materialDetailDto.setKeyword(name);
    	materialDetailDto.setStockCode(stockCode);
    	materialDetailDto.setDisplayPostingDate(postingDate);
    	materialDetailDto.setMovementTypeGI(movementType);
    	return materialDetailManager.searchMaterialInstockByName(materialDetailDto);
    }
	
	@GetMapping("/get-material-weigh")
	public ResponseEntity<?> getMaterialWeigh() {
		log.info("***************process=getMaterialWeigh, {}");
		List<MaterialDto> materials = new ArrayList<>();
		Arrays.asList(MaterialCodeWeighEnum.values()).stream().forEach(item -> {
			MaterialDto material = new MaterialDto();
			String[] data = item.val.split("_");
			material.setCode(data[0]);
			material.setName(data[1]);
			materials.add(material);
		});
		return ResponseEntity.ok(materials);
	}
	
	@PostMapping("/deletePhieuCanChiTiet/{id}")
	public ResponseEntity<?> deletePhieuCanChiTiet(@PathVariable(required = true) Long id) {
		log.info("******************CONTROLLER:delete-PhieCanChiTiet:, id={}", id);
		Boolean isDeleted = grossWeightManager.deletePhieuCanChiTiet(id);
		return ResponseEntity.ok(isDeleted);
	}
	
	@PostMapping("/changeMaterialForTool/{code}")
	public ResponseEntity<?> addMaterialForTool(@PathVariable(required = true) String code, @RequestParam(required = true, name = "isSelected") Integer isSelected) {
		return ResponseEntity.ok(materialSupportManager.saveOrDelete(code, isSelected));
	}
	
	@PostMapping("/checkAllMaterialsForTool")
	public ResponseEntity<?> handleCheckAllMaterialsForTool(@Valid @RequestBody MaterialSupportDto criteria) {
		List<MaterialDto> materials = materialSupportManager.checkAllMaterialsForTool(criteria);
		if (materials.isEmpty())
			return ResponseEntity.ok(false);
		return ResponseEntity.ok(true);
	}
	
	@GetMapping("/materialSupport/search")
    @ResponseBody
    public List<MaterialSupportDto> searchMaterialSupport(@RequestParam(value="farmCode", required=false) String farmCode, @RequestParam(value="materialCode", required=false) String materialCode, @RequestParam(value="materialName", required=false) String materialName, 
    		@RequestParam(value="materialSuggestName", required=false) String materialSuggestName,@RequestParam(value="materialFastCode", required=false) String materialFastCode,@RequestParam(value="materialBatch", required=false) String materialBatch, @RequestParam(value="postingDate", required=false) String postingDate) throws Exception {
    	log.info("process=searchMaterialSupport");
    	MaterialSupportDto materialSupportDto = new MaterialSupportDto();
    	materialSupportDto.setFarmCode(farmCode);
    	materialSupportDto.setCode(materialCode);
    	materialSupportDto.setName(materialName);
    	materialSupportDto.setSuggestName(materialSuggestName);
    	materialSupportDto.setFastCode(materialFastCode);
    	materialSupportDto.setBatch(materialBatch);
    	if(StringUtils.isNotBlank(postingDate)) {
    		materialSupportDto.setPostingDate(DateTimeHelper.toLocalDate(postingDate, DatePatternEnum.DD_MM_YYYY_2.pattern));
    	} else {
    		materialSupportDto.setPostingDate(LocalDate.now());
    	}
    	return materialSupportManager.searchMaterialSupport(materialSupportDto);
    }
	
	@GetMapping("/processOrder/get-by-farmcode")
    @ResponseBody
    public List<ProcessOrderDto> getProcessOrders(@RequestParam(value="farmCode", required=false) String farmCode) throws Exception {
    	log.info("process=getProcessOrders");
    	return processOrderManager.getByFarmCode(farmCode);
    }
	
	@GetMapping("/goodsAttritionSupport/get-process-order")
	@ResponseBody
	public List<ProcessOrderDto> getProcessOrderByPostingDates(@RequestParam(value="postingDate", required=false) String postingDate,@RequestParam(value="stockCode", required=false) String stockCode) throws Exception {
		log.info("process=get process-order-in-goods-attrition-support");
		GoodsIssueDto goodsIssueDto = new GoodsIssueDto();
		goodsIssueDto.setFromStockCode(stockCode);
		goodsIssueDto.setPostingDateSearch(postingDate.trim());
		goodsIssueDto.setType(GoodsIssueTypeEnum.GOODS_ATTRITION_SUPPORT.val);
		return goodsAttritionSupportManager.getProcessOrderInGoodsAttritionSupportByPostingDate(goodsIssueDto);
	}

	@GetMapping("/goodsIssues/get-by-process-order")
    @ResponseBody
    public List<MaterialDetailDto> getMaterialInGoodsIssues(@RequestParam(value="postingDate", required=false) String postingDate, @RequestParam(value="processOrderCode", required=false) String processOrderCode) throws Exception {
    	log.info("process=getMaterialInGoodsIssues");
    	GoodsIssueDto goodsIssueDto = new GoodsIssueDto();
    	goodsIssueDto.setProcessOrderCode(processOrderCode.trim());
    	goodsIssueDto.setPostingDateSearch(postingDate.trim());
    	goodsIssueDto.setType(GoodsIssueTypeEnum.GOODS_ATTRITION_SUPPORT.val);
    	return goodsIssueManager.getMaterialInGoodsIssues(goodsIssueDto);
    }
	
	@GetMapping("/goodsAttritionSupport/get-process-order-codes")
    @ResponseBody
    public List<String> getProcessOrderCodes(@RequestParam(value="postingDate", required=false) String postingDate) throws Exception {
    	log.info("ENTERING 'GET PROCESS_ORDER_CODES IN GOODS_ATTRITION_SUPPORT' METHOD...");
    	return goodsAttritionSupportManager.getProcessOrderCodes(postingDate);
    }
	
	@GetMapping("/goodsAttritionSupport/get-process-order-by-postingDate")
    @ResponseBody
    public List<ProcessOrderDto> getProcessOrderByPostingDate(@RequestParam(value="postingDate", required=false) String postingDate) throws Exception {
    	log.info("ENTERING 'GET PROCESS_ORDER BY POSTINGDATE IN GOODS_ATTRITION_SUPPORT' METHOD...");
    	return goodsAttritionSupportManager.getProcessOrderByPostingDate(postingDate);
    }
	
	@GetMapping("/instock-adjustment-search-material")
    @ResponseBody
    public List<MaterialDetailDto> searchMaterialDetailInstockAdjustment(@RequestParam(value="q", required=false) String name, @RequestParam(value="stockCode", required=false) String stockCode, 
    	@RequestParam(value="type", required=false) String type, @RequestParam(value="postingDate", required=false) String postingDate) throws Exception {
    	log.info("ENTERING 'SEARCH MATERIAL_DETAIL BY NAME' METHOD...");
    	MaterialDetailDto materialDetailDto = new MaterialDetailDto();
    	materialDetailDto.setName(name);
    	materialDetailDto.setStockCode(stockCode);
    	materialDetailDto.setType(type);
    	if(StringUtils.isNotBlank(postingDate)) {
        	materialDetailDto.setPostingDate(DateTimeHelper.toLocalDate(postingDate, DatePatternEnum.DD_MM_YYYY_2.pattern));
    	} else {
        	materialDetailDto.setPostingDate(LocalDate.now());
    	}
    	return instockAdjustmentManager.searchMaterialDetailInstockAdjustment(materialDetailDto);
    }
	
	@GetMapping("/production/get-total-pig-retained")
    @ResponseBody
    public Integer getTotalPigRetainedByPoCode(@RequestParam(value="processOrderCode", required = false) String processOrderCode) {
    	log.debug("ENTERING 'GET TOTAL PIG_RETAINED BY PROCESS_ORDER_CODE' METHOD...");
    	return productionManager.getTotalPigRetainedByPoCode(processOrderCode);
    }
	
	@GetMapping("/material/get-material-stage")
    @ResponseBody
    public List<MaterialDetailDto> getMaterialInstock(@RequestParam(value="stockCode", required=true) String stockCode,
    		@RequestParam(value="unsignName", required=false) String unsignName) throws Exception {
    	log.info("process=get Material Instock By Code");
    	MaterialDetailDto criteria = new MaterialDetailDto();
    	criteria.setStockCode(stockCode);
    	criteria.setUnsignedName(unsignName);
    	return materialDetailManager.searchMaterialInstockStage(criteria);
    }
	
	@GetMapping("/material/get-material-instock-latest")
    @ResponseBody
    public List<MaterialDetailDto> getMaterialsInstockLatest(@RequestParam(value="stockCode", required=true) String stockCode) throws Exception {
    	log.info("process=get Material Instock Latest");
    	return materialDetailManager.getMaterialsInstockLatest(stockCode);
    }
	
	@GetMapping("/material/get-by-purchasing-group")
    @ResponseBody
    public List<MaterialDto> getMaterialsByPurchasingGroup(@RequestParam(value="purchasingGroups", required=true) String purchasingGroups,
    		@RequestParam(value="code", required=true) String code) throws Exception {
    	log.info("process=get Material By Purchasing Groups");
    	if(StringUtils.isBlank(purchasingGroups)) return Collections.emptyList();
    	
    	MaterialDto criteria = new MaterialDto();
    	criteria.setPurchasingGroup(purchasingGroups);
    	criteria.setCode(code);
    	return materialManager.getByPurchasingGroup(criteria);
    }
	
	@GetMapping("/processOrder/get-pig-level-by-barn")
    @ResponseBody
    public List<String> getPigLevelByBarn(@RequestParam(value="barnCode", required=true) String barnCode) throws Exception {
    	log.info("process=get Pig Level By Barn");
    	return processOrderManager.getAllPigLevelByBarnCode(barnCode);
    }
	
	@GetMapping("/goodsAttritionSupport/check")
    @ResponseBody
    public EntityResponse checkGoodsAttrition(@RequestParam(value="postingDate", required=true) String postingDate,
    		@RequestParam(value="poCode", required=true) String poCode,
    		@RequestParam(value="stockCode", required=true) String stockCode) throws Exception {
    	log.info("process=check goods attrition support");
    	GoodsIssueDto criteria = new GoodsIssueDto();
    	
    	LocalDate date = DateTimeHelper.toLocalDate(postingDate, DatePatternEnum.DD_MM_YYYY_2.pattern);
    	criteria.setPostingDate(date);
    	criteria.setProcessOrderCode(poCode);
    	criteria.setStockCode(stockCode);
    	
    	return goodsAttritionSupportManager.checkGoodsAttrition(criteria);
    }

	@GetMapping("/processOrder/checkGA")
    @ResponseBody
    public List<ProcessOrderDto> checkGA(@RequestParam(value="postingDate", required=true) String postingDate,
    		@RequestParam(value="stockCode", required=false) String stockCode) throws Exception {
    	log.info("process=check goods attrition support");
    	LocalDate posting = DateTimeHelper.toLocalDate(postingDate, DatePatternEnum.DD_MM_YYYY_2.pattern);
    	
    	ProcessOrderDto criteria = new ProcessOrderDto();
    	criteria.setPostingDate(posting);
    	if(StringUtils.isNotBlank(stockCode)) {
    		criteria.setStockCode(stockCode);
    	}
    	return processOrderManager.checkGa(criteria);
	}
	
	@GetMapping("/notifications")
	public ResponseEntity<?> searchNotification(@RequestParam(name = "page", required = true) Integer page) {
		log.info("process=searchNotification, page={}", page);
		NotificationDto criteria = NotificationDto.builder()
				.types(Arrays.asList(EventTypeEnum.WEIGHT_NOTE.val, EventTypeEnum.PROCESS_ORDER.val))
				.page(page)
				.size(10)
				.build();
		return ResponseEntity.ok(notificationManager.search(criteria));
	}

	@GetMapping("/notifications/events")
	public ResponseEntity<?> searchNotifyDataList(@RequestParam(name = "page") Integer page) {
		log.info("entering: 'search-notify-data-list' method, page={}", page);
		NotificationDto criteria = NotificationDto.builder()
				.types(Arrays.asList(EventTypeEnum.WEIGHT_NOTE.val, EventTypeEnum.PROCESS_ORDER.val))
				.page(page)
				.size(10)
				.build();

		return ResponseEntity.ok(notificationManager.search(criteria));
	}


	@GetMapping("/notifications/task")
	public ResponseEntity<?> searchTaskNotifications(@RequestParam(name = "page", required = true) Integer page) {
		log.info("process=searchTaskNotification, page={}", page);
		NotificationDto criteria = NotificationDto.builder()
				.types(Collections.singletonList(NotificationTypeEnum.TASK.type))
				.page(page)
				.size(10)
				.build();
		return ResponseEntity.ok(notificationManager.search(criteria));
	}
	
	/**
	 * *********TASK MODULES*********
	 */
	
	@PostMapping("/task/search")
	public ResponseEntity<?> searchTask(@RequestBody TaskDto criteria) {
		log.info("process=searchTask, page={}, criteria={}", criteria);
		EntityResponse response = taskManager.getOrSearch(criteria);
		return ResponseEntity.ok(response.getData());
	}
	
	@PostMapping("/task/viewMode/search")
	public ResponseEntity<?> searchTaskViewMode(@RequestBody TaskDto criteria, HttpServletRequest request) {
		log.info("process=searchTaskViewMode, page={}, criteria={}", criteria);
		Boolean isTaskAdminView = request.isUserInRole("ROLE_TASK_ADMIN_VIEW");
		criteria.setAdminView(isTaskAdminView);
		EntityResponse response = taskManager.searchDataViewMode(criteria);
		return ResponseEntity.ok(response.getData());
	}
	
	@PostMapping("/task/confirm")
	public ResponseEntity<?> confirmTask(@RequestBody TaskDto task) {
		log.info("process=confirmTask, task={}", task);
		
		return ResponseEntity.ok(taskManager.confirmTask(task));
	}
	
	@PostMapping("/task/calendar")
	public ResponseEntity<?> searchTaskCalendar(@RequestBody(required = false) TaskDto criteria, HttpServletRequest request) {
		log.info("process=searchTaskCalendar(), {}", criteria);
		Boolean isTaskAdminView = request.isUserInRole("ROLE_TASK_ADMIN_VIEW");
		criteria.setAdminView(isTaskAdminView);
		EntityResponse response = taskManager.getDataCalendar(criteria);
		return ResponseEntity.ok(response);
	}

	@GetMapping("/home/statistic")
	public ResponseEntity<?> initDataHomeStatistic() {
		log.info("process=load-init-data-home-statistic");
		return ResponseEntity.ok(homeManager.handleDashboard());
	}

	@PostMapping("/task/request-reject-frequency")
	public ResponseEntity<?> handleRequestRejectFrequency(@RequestBody(required = true) TaskDto task) {
		log.info("process=handle-request-reject-frequency, task={}", task);

		return ResponseEntity.ok(taskManager.requestRejectFrequency(task));
	}

	@PostMapping("/task/request-reject-frequency/accept")
	public ResponseEntity<?> handleAcceptRejectFrequency(@RequestBody TaskDto task) {
		log.info("entering 'handle-accept-reject-frequency' method... {}", task);
		return ResponseEntity.ok(taskManager.acceptRejectFrequency(task));
	}

	@PostMapping("/task/addComment")
	public ResponseEntity<?> addComment(@RequestBody(required = true) TaskDto task) {
		log.info("process, add-comment: {} - {}", task.getCode(), task.getCommentContent());
		return ResponseEntity.ok(taskManager.addComment(task));
	}

	@GetMapping("/task/initialAssignees")
	public ResponseEntity<?> getInitialAssignees() {
		log.info("process, get-initial-assignees()...");
		return ResponseEntity.ok(userManager.gets(0, 500));
	}

	@GetMapping("/task/clone")
	public ResponseEntity<?> cloneTask() {
		log.info("entering: 'clone-task' method...");
		return ResponseEntity.ok(taskManager.cloneTask());
	}

	// Vendor
	@GetMapping("/getVendorByCode/{code}")
	public ResponseEntity<?> getVendorByCode(@PathVariable(name = "code", required = true) String vendorCode) {
		log.info("entering: 'get-vendor-by-code', vendorCode={}", vendorCode);
		return ResponseEntity.ok(vendorManager.getByCode(vendorCode));
	}

	@GetMapping("/vendor/syncFromSAP")
	public ResponseEntity<?> handleVendorSyncFromSAP() {
		log.info("entering: 'handle-vendor-sync-from-sap' method...");
		return ResponseEntity.ok(vendorManager.syncFromSAP());
	}

	@PostMapping("/sync-general-ledger")
	public ResponseEntity<?> syncGeneralLedger(@RequestBody GeneralLedgerDto data) {
		log.info("entering: 'sync-general-ledger' method..., data={}", data);
		return ResponseEntity.ok(syncDataManager.syncGL(data));
	}

	// General Ledger
	@PostMapping("/general-ledger/cancel/{id}")
	public ResponseEntity<?> cancelGeneralLedger(@PathVariable(name = "id", required = true) String id) {
		log.info("entering: 'cancel-general-ledger' method...");
		EntityResponse response = new EntityResponse();
		try {
			response = generalLedgerManager.cancel(Long.valueOf(id));
		} catch (NumberFormatException e) {
			response.setCode(EntityResponseCodeEnum.ERROR_500.val);
			response.setMessage("NUMBER_FORMAT_EXCEPTION");
		}
		return ResponseEntity.ok(response);
	}
	
	@GetMapping("/instock/getLatestInstock")
    @ResponseBody
    public InstockDto getLatestInstock(@RequestParam(value="postingDate", required=true) String postingDate,
    		@RequestParam(value="farmName", required=true) String farmName) throws Exception {
    	log.info("process=get instock latest");
    	InstockDto criteria = new InstockDto();
    	criteria.setSize(10);
    	criteria.setPage(0);
    	LocalDate syncDate = DateTimeHelper.toLocalDate(postingDate, DatePatternEnum.DD_MM_YYYY_2.pattern);
		criteria.setSyncDate(syncDate);
		criteria.setFarmName(farmName);
		criteria.setLatestOfDay(true);

		return instockManager.getLatestInstock(criteria);
	}

	@GetMapping("/getRoles")
	public ResponseEntity<?> getAllRoles() {
		log.info("entering: 'GET-ALL-ROLES' method()...");
		return ResponseEntity.ok(roleManager.gets());
	}
}
