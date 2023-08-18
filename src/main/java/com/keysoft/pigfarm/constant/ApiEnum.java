package com.keysoft.pigfarm.constant;

public enum ApiEnum {
	PATH_LOGIN("login"),
	PATH_DASHBOARD("dashboard"),
	PATH_TRANSCODE("get-transcode"),
	
	// ----- MASTER -----//
	PATH_TENANT_GET("tenant-get"),
	PATH_TENANT_GETS("tenant-gets"),
	PATH_TENANT_SEARCH("tenant-search"),
	PATH_TENANT_CREATE("tenant-create"),
	PATH_TENANT_UPDATE("tenant-update"),
	
	PATH_AUTH_BY_USERNAME("auth-by-username"),
	PATH_GET_TOKEN("get-token"),
	PATH_GET_PROFILE("get-profile"),
	PATH_ORG_GETS("org-gets"),
	PATH_ORG_GET("org-get"),
	PATH_ORG_CREATE("org-create"),
	PATH_ORG_UPDATE("org-update"),
	PATH_ORG_SEARCH("org-search"),
	PATH_ORG_GET_IDENTITY_CODE("org-get-identity-code"),
	
	PATH_AREA_GETS("area-gets"),
	PATH_AREA_GET("area-get"),
	PATH_AREA_CREATE("area-create"),
	PATH_AREA_UPDATE("area-update"),
	
	PATH_ENV_GETS("env-gets"),
	PATH_ENV_GET("env-get"),
	PATH_ENV_CREATE("env-create"),
	PATH_ENV_UPDATE("env-update"),
	
	// ----- USER -----//
	
	PATH_ROLE_GETS("role-gets"),
	PATH_ROLE_GET("role-get"),
	PATH_ROLE_BY_GROUP_NAME_GET("role-by-group-name-get"),
	
	PATH_GROUP_GETS("group-gets"),
	PATH_GROUP_GET("group-get"),
	PATH_GROUP_CREATE("group-create"),
	PATH_GROUP_UPDATE("group-update"),
	PATH_GROUP_CREATE_OR_UPDATE("group-create-or-update"),

	PATH_CUST_GETS("cust-gets"),
	PATH_CUST_GET("cust-get"),
	PATH_CUST_CREATE("cust-create"),
	PATH_CUST_UPDATE("cust-update"),
	PATH_CUST_SEARCH("cust-search"),
	PATH_CUST_CHECKCODE("cust-check-code"),
	PATH_CUST_CHECKCODEANDID("cust-check-code-id"),
	PATH_CUST_COUNT_BY_STATUS("cust-count-by-status"),
	
	PATH_EVENT_GET("event-get"),
	PATH_EVENT_GETS("event-gets"),
	PATH_EVENT_CREATE("event-create"),
	PATH_EVENT_UPDATE("event-update"),
	PATH_EVENT_SEARCH("event-search"),
	PATH_EVENT_DAILY_AVG_WEIGHT_UPDATE("event-daily-avg-weight-update"),
	PATH_EVENT_EXPORT("event-export"),
	
	PATH_PROPOSAL_SEARCH("proposal-search"),
	PATH_PROPOSAL_GETS("proposal-gets"),
	PATH_PROPOSAL_GET("proposal-get"),
	PATH_PROPOSAL_CREATE("proposal-create"),
	PATH_PROPOSAL_UPDATE("proposal-update"),
	PATH_CALCULATE_PROPOSAL_ENTRY("calculcate-proposal-entry"),
	
	PATH_SYSTEM_PARAMETER_GET("system-parameter-get"),
	PATH_SYSTEM_PARAMETER_GETS("system-parameter-gets"),
	PATH_SYSTEM_PARAMETER_CREATE("system-parameter-create"),
	PATH_SYSTEM_PARAMETER_UPDATE("system-parameter-update"),
	PATH_SYSTEM_PARAMETER_SEARCH("system-parameter-search"),
	PATH_SYSTEM_PARAMETER_GET_MATERIAL("system-parameter-get-material"),
	PATH_SYSTEM_PARAMETER_GET_BY_PREFIX("system-parameter-get-by-prefix"),
	PATH_SYSTEM_PARAMETER_GET_BY_PARAM_NAME("system-parameter-get-by-param-name"),
	PATH_FARM_GETS("farm-gets"),
	PATH_FARM_GET("farm-get"),
	PATH_FARM_GET_BY_FARMCODE("farm-get-by-farmcode"),
//	PATH_FARM_CREATE("farm-create"),
//	PATH_FARM_UPDATE("farm-update"),
	PATH_FARM_SEARCH("farm-search"),
	PATH_FARM_CHECKCODE("farm-check-code"),
	PATH_FARM_CHECKCODEANDID("farm-check-code-id"),
	PATH_FARM_COUNT_BY_STATUS("farm-count-by-status"),
	PATH_FARM_GETS_BYUSER("farm-gets-byUser"),
	PATH_FARM_GET_BY_USERNAME("farm-get-by-username"),
	PATH_FARM_BY_PLANT_CODE("farm-gets-by-plant-code"),
	PATH_FARM_CODES("get-farm-codes"),
	PATH_FARM_GET_TREE("get-farm-tree"),
	PATH_FARM_PORKER_GETS("farm-porker-gets"),
	
	PATH_FARM_USER_CREATE("farm-user-create"),
	PATH_FARM_USER_UPDATE("farm-user-update"),
	PATH_FARM_USER_SEARCH_BY_NAME("farm-user-search-by-name"),
	
	// ----- WAREHOUSE AND PURCHASE  -----//
	PATH_MATERIAL_GETS("material-gets"),
	PATH_MATERIAL_GET("material-get"),
	PATH_MATERIAL_SEARCH("material-search"),
	PATH_MATERIAL_BY_CODE("material-by-code"),
	PATH_MATERIAL_SEARCH_BY_NAME("material-search-by-name"),
	PATH_MATERIAL_SEARCH_MATERIAL_INSTOCK_BY_NAME("material-search-material-instock-by-name"),
	PATH_MATERIAL_SEARCH_MATERIAL_STAGE("material-search-material-stage"),
	PATH_MATERIAL_CREATE("material-create"),
	PATH_MATERIAL_UPDATE("material-update"),
	PATH_MATERIAL_GET_INSTOCK_LATEST("material-get-instock-latest"),
	PATH_MATERIAL_GETS_BY_PURCHASING_GROUP("material-get-by-purchasing-group"),
	
	
	PATH_PLAN_GETS("plan-gets"),
	PATH_PLAN_SEARCH("plan-gets"),
	PATH_PLAN_GET("plan-get"),
	PATH_PLAN_CONFIRM("plan-confirm"),
	
	PATH_BARN_PLAN_GETS("barn-plan-gets"),
	PATH_BARN_PLAN_SEARCH("barn-plan-search"),
	PATH_BARN_PLAN_GET("barn-plan-get"),
	PATH_BARN_PLAN_CONFIRM("barn-plan-confirm"),
	
	
	// ----- WAREHOUSE AND PURCHASE  -----//
	PATH_PLANT_GETS("plant-gets"),
	PATH_PLANT_GET("plant-get"),
	PATH_PLANT_GET_ALL("plant-get-all"),
	
	//----------MANUFACTURE -----------//
	PATH_GOODS_ATTRITION_SEARCH("goods-attritions-search"),
	PATH_GOODS_ATTRITION_GET("goods-attrition"),
	
	PATH_OTHER_COST_SEARCH("other-cost-search"),
	PATH_OTHER_COST_GETS("other-cost-gets"),
	PATH_OTHER_COST_GET("other-cost-get"),
	PATH_OTHER_COST_CREATE("other-cost-create"),
	PATH_OTHER_COST_UPDATE("other-cost-update"),
	
	PATH_PROCESS_ORDER_GETS("process-order-gets"),
	PATH_PROCESS_ORDER_GET("process-order-get"),
	PATH_PROCESS_ORDER_AND_QUOTA_GET("process-order-and-quota-get"),
	PATH_PROCESS_ORDER_SEARCH("process-order-search"),
	PATH_PROCESS_ORDER_BY_CODE("process-order-by-code"),
	PATH_PROCESS_ORDER_CONFIRM("process-order-confirm"),
	PATH_PROCESS_ORDER_CLOSED("process-order-closed"),
	PATH_PROCESS_ORDER_BY_LATEST("process-order-by-latest"),
	PATH_PROCESS_ORDER_BY_CODE_AND_LATEST("process-order-by-code-and-latest"),
	PATH_PROCESS_BY_UNCONFIRM("process-order-by-unconfirm"),
	PATH_PROCESS_ORDER_BY_USERNAME_AND_STATUS("process-order-by-username-and-status"),
	PATH_PROCESS_ORDER_BY_FARMCODE("process-order-by-farmcode"),
	PATH_PROCESS_ORDER_FOR_REPORT_BY_FARMCODE("process-order-for-report-by-farmcode"),
	PATH_PROCESS_ORDER_ALL_FOR_REPORT("process-order-all-for-report"),
	PATH_PROCESS_ORDER_BY_FARMCODE_AND_POSTING_DATE("process-order-by-farmcode-and-postingdate"),
	PATH_PROCESS_ORDER_GET_PIG_LEVEL_BY_BARNCODE("process-order-get-pig-level"),
	PATH_PROCESS_ORDER_GET_CHECK_GA("process-order-get-check-ga"),
	PATH_PROCESS_ORDER_FOR_EXPORT("process-order-export"),
	
	PATH_QUOTA_GETS("quota-gets"),
	PATH_QUOTA_GET("quota-get"),
	PATH_QUOTA_BY_PROCESS_ORDER_CODE("quota-by-process-order-code"),
	PATH_QUOTA_BY_PROCESS_ORDER_CODE_AND_LATEST("quota-by-process-order-code-and-latest"),
	
	PATH_BARN_SEARCH("barn-gets"),
	PATH_BARNS_BY_FARMCODE("barn-gets-by-farmcode"),
	PATH_BARN_BY_CODE_GET("barn-get"),
	
	//----------SILO-----------//
	PATH_SILO_SEARCH("silo-gets"),
	PATH_SILO_GET("silo-get"),
	PATH_SILO_UPDATE("silo-update"),
	PATH_SILO_CREATE("silo-create"),
	
	//----------PURCHASE REQUISITION -----------//
	PATH_PURCHASE_REQUISITION_SEARCH("purchase-requisition-search"),
	PATH_PURCHASE_REQUISITION_GET("purchase-requisition-get"),
	PATH_PURCHASE_REQUISITION_UPDATE("purchase-requisition-update"),
	PATH_PURCHASE_REQUISITION_CREATE("purchase-requisition-create"),
	PATH_PURCHASE_REQUISITION_GET_TEMPLATE("purchase-requisition-get-templates"),
	PATH_PURCHASE_REQUISITION_DELETE("purchase-requisition-delete"),
	PATH_PURCHASE__REQUISITION_REPORT("purchase-requisition-report"),
	PATH_PURCHASE__REQUISITION_OTHER_REPORT("purchase-requisition-other"),
	
	//----------GOODS REQUISITION -----------//
	PATH_GOODS_REQUISITION_SEARCH("goods-requisition-search"),
	PATH_GOODS_REQUISITIONN_GET("goods-requisition-get"),
	PATH_GOODS_REQUISITIONN_DELETE("goods-requisition-delete"),
	
	//----------GOODS ISSUE -----------//
	PATH_GOODS_ISSUE_SEARCH("goods-issue-search"),
	PATH_GOODS_ISSUE_GET("goods-issue-get"),
	PATH_GOODS_ISSUE_UPDATE("goods-issue-update"),
	PATH_GOODS_ISSUE_CREATE("goods-issue-create"),
	PATH_GOODS_ISSUE_GET_TEMPLATE("goods-issue-get-templates"),
	PATH_GOODS_ISSUE_DELETE("goods-issue-delete"),
	PATH_GOODS_ISSUE_CANCEL("goods-issue-cancel"),
	PATH_GOODS_ISSUE_BY_PO_CODE("goods-issue-by-po-code"),
	PATH_GOODS_ISSUE_BY_STOCK_CODE("goods-issue-by-stock-code"),
	PATH_GOODS_ISSUE_GETS("goods-issue-get-by-stock-codes"),
	PATH_GOODS_ISSUE_GET_MATERIALS("goods-issue-get-material"),
	PATH_GOODS_ISSUE_COPY("goods-issue-copy"),
	PATH_GOODS_ISSUE_REPORT("goods-issue-report-by-stock-code"),
	
	//----------GOODS ATTRITION SUPPORT -----------//
	PATH_GOODS_ATTRITION_SUPPORT_SEARCH("goods-attrition-support-search"),
	PATH_GOODS_ATTRITION_SUPPORT_GET("goods-attrition-support-get"),
	PATH_GOODS_ATTRITION_SUPPORT_UPDATE("goods-attrition-support-update"),
	PATH_GOODS_ATTRITION_SUPPORT_CREATE("goods-attrition-support-create"),
	PATH_GOODS_ATTRITION_SUPPORT_GET_PROCESS_ORDERS("goods-attrition-support-get-process-orders"),
	PATH_GOODS_ATTRITION_SUPPORT_GET_PROCESS_ORDER_CODES("goods-attrition-support-get-process-order-codes"),
	PATH_GOODS_ATTRITION_SUPPORT_GET_PROCESS_ORDER_BY_POSTINGDATE("goods-attrition-support-get-process-order-by-posting-date"),
	PATH_GOODS_ATTRITION_SUPPORT_CHECK("goods-attrition-support-check"),
	
	
	//----------MATERIAL SUPPORT -----------//
	PATH_MATERIAL_SUPPORT_GETS("material-suppport-gets"),
	PATH_MATERIAL_SUPPORT_UPDATE("material-suppport-update"),
	PATH_MATERIAL_SUPPORT_CREATE("material-suppport-create"),
	PATH_MATERIAL_SUPPORT_SEARCH("material-suppport-search"),
	PATH_MATERIAL_TOOL_SEARCH("material-tool-search"),
	PATH_MATERIAL_SUPPORT_CREATES("material-suppport-creates"),
	PATH_MATERIAL_FOR_TOOL_CREATE("material-for-tool-create"),
	PATH_MATERIAL_FOR_TOOL_DELETE("material-for-tool-delete"),
	PATH_MATERIAL_CHECKALL_FOR_TOOL_SAVE("material-for-tool-checkAll"),
	
	//------------PHIEU CAN------------//
	PATH_PHIEUCAN_SEARCH("phieucan-search"),
	PATH_PHIEUCAN_GET("phieucan-get"),
	PATH_PHIEUCAN_CREATE("phieucan-create"),
	PATH_PHIEUCAN_DELETE("phieucan-delete"),
	PATH_PHIEUCAN_UPDATE("phieucan-update"),
	
	PATH_PHIEUCANCHITIET_GET("phieucanchitiet-get"),
	PATH_PHIEUCANCHITIET_DELETE("phieucanchitiet-delete"),
	
	//----------GOODS RECEIPT -----------//
	PATH_GOODS_RECEIPT_SEARCH("goods-receipt-search"),
	PATH_GOODS_RECEIPT_GET("goods-receipt-get"),
	PATH_GOODS_RECEIPT_UPDATE("goods-receipt-update"),
	PATH_GOODS_RECEIPT_CANCEL("goods-receipt-cancel"),
	PATH_GOODS_RECEIPT_CREATE("goods-receipt-create"),
	PATH_GOODS_RECEIPT_GET_TEMPLATE("goods-receipt-get-templates"),
	PATH_GOODS_RECEIPT_DELETE("goods-receipt-delete"),
	
	//----------STOCK -----------//
	PATH_STOCK_GETS("stock-gets"),
	
	//----------MANUFACTURE -----------//
	PATH_USER_GETS("user-gets"),
	PATH_USER_CHECK_USERNAME("user-check-username"),
	PATH_USER_CHECK_EMAIL("user-check-email"),
	PATH_USER_CHECK_PASSWORD("user-check-password"),
	PATH_USER_GET("user-get"),
	PATH_USER_CREATE("user-create"),
	PATH_USER_UPDATE("user-update"),
	PATH_USER_MAIL_REPORT("user-mail-report"),
	PATH_USER_INFO_CREATE("user-info-create"),
	PATH_USER_INFO_UPDATE("user-info-update"),
	PATH_USER_PRIVILEGES_CREATE("user-privileges-create"),
	PATH_USER_PRIVILEGES_UPDATE("user-privileges-update"),
	PATH_USER_ADMIN_GET("user-admin-get"),
	PATH_USER_ADMIN_CREATE("user-admin-create"),
	PATH_USER_ADMIN_UPDATE("user-admin-update"),
	PATH_USER_GET_PROFILE_ID("user-get-profile-id"),
	PATH_USER_PROFILE_GET("user-profile-get"),
	PATH_USER_RESET_PASSWORD("user-resetpw"),
	PATH_USER_CHANGE_PASSWORD("user-changepw"),
	PATH_GET_ALL_USERS("user-get-all"),
	
	
	//-----------------pigEntry-------------//
	PATH_PIG_ENTRY_CREATE("pig-entry-create"),
	PATH_PIG_ENTRY_UPDATE("pig-entry-update"),
	PATH_PIG_ENTRY_CANCEL("pig-entry-cancel"),
	PATH_PIG_ENTRY_SEARCH("pig-entry-search"),
	PATH_PIG_ENTRY_GET("pig-entry-get"),
	PATH_PIG_ENTRY_GET_BY_POCODE("pig-entry-get-by-po"),
	
	/*--------------- production -------------*/
	PATH_PRODUCTION_BY_PROCESS_ORDER_CODE("production-by-process-order-code"),
	PATH_PRODUCTION_GET_PIG_RETAINED("production-get-total-pig-retained"),
	PATH_PRODUCTION_GET_PIG_RETAINED_BY_DATE("production-get-total-pig-retained-by-date"),
	
	
	/*--------------- Sync Data -------------*/
	PATH_SYNC_ALL_MASTER_DATA_FROM_SAP("sync-all-master-data-from-sap"),
	PATH_SYNC_ALL_DATA_TO_SAP("sync-all-data-to-sap"),
	PATH_SYNC_GL_DATA_TO_SAP("sync-gl-data-to-sap"),
	PATH_SYNC_FINISH_PRODUCTION_DATA_TO_SAP("sync-finish-production-data-to-sap"),
	PATH_SYNC_GOODS_ATTRITION_DATA_TO_SAP("sync-goods-attrition-data-to-sap"),
	PATH_SYNC_SALES_DATA_FROM_SAP("sync-sales-data-from-sap"),
	
	/*--------------- instock data -------------*/
	PATH_INSTOCK_GETS("instock-gets"),
	PATH_INSTOCK_GET("instock-get"),
	PATH_INSTOCK_IMPORT("instock-import"),
	PATH_INSTOCK_GETS_BY_LATEST("instock-gets-by-latest"),
	PATH_INSTOCK_GET_LATEST("instock-get-latest"),
	
	/*--------------- sales data -------------*/
	PATH_SALES_GETS("sales-gets"),
	PATH_SALES_GET("sales-get"),
	PATH_SALES_EXPORT("sale-export"),
	
	/*--------------- instock baseline data -------------*/
	PATH_INSTOCK_BASELINE_GETS("instock-baseline-gets"),
	PATH_INSTOCK_BASELINE_GET("instock-baseline-get"),
	
	/*--------------- stock-count -------------*/
	PATH_STOCK_COUNT_SEARCH("stock-count-search"),
	PATH_STOCK_COUNT_GET("stock-count-get"),
	
	//----------INSTOCK_ADJUSTMENT -----------//
	PATH_INSTOCK_ADJUSTMENT_SEARCH("instock-adjustment-search"),
	PATH_INSTOCK_ADJUSTMENT_GET("instock-adjustment-get"),
	PATH_INSTOCK_ADJUSTMENT_UPDATE("instock-adjustment-update"),
	PATH_INSTOCK_ADJUSTMENT_CANCEL("instock-adjustment-cancel"),
	PATH_INSTOCK_ADJUSTMENT_CREATE("instock-adjustment-create"),
	PATH_INSTOCK_ADJUSTMENT_SEARCH_MATERIAL("instock-adjustment-search-material"),
	
	
	/*--------------- report-----------------*/
	PATH_REPORT_DAILY_TOTAL_STOCK_WEIGHT("daily-total-stock-weight"),
	PATH_REPORT_STOCK_DAY("report-stockDay"),
	PATH_REPORT_INSTOCK("report-instock"),
	PATH_REPORT_DAILY_AVERAGE_WEIGHT("report-daily-average-weight"),
	PATH_REPORT_DEAD_RATE("report-dead-rate"),
	PATH_REPORT_FCR("report-fcr"),
	PATH_REPORT_ADG("report-adg"),
	PATH_REPORT_LIST_MATERIAL_GA("report-list-material-GA"),
	PATH_REPORT_LIST_GOODS_RECEIPT("report-list-goods-receipt"),
	PATH_REPORT_DAY_DETAIL("report-day-detail"),
	PATH_REPORT_FARM_ANALYST_SEARCH("report-farm-analyst-search"),
	PATH_REPORT_FARM_ANALYST_SEARCH_PIG_LEVEL("report-farm-analyst-pig-level"),
	PATH_REPORT_INSTOCK_PIG("report-instock-pig"),
	PATH_REPORT_WEIGHT_COMPARE("report-weight-compare"),
	PATH_REPORT_WEIGHT_COMPARE_BY_PIGLEVEL("report-weight-compare-by-pig-level"),
	PATH_REPORT_PROD_ESTIMATE("report-prod-estimate"),
	PATH_REPORT_PROD_ESTIMATE_BY_LEVEL("report-prod-estimate-by-level"),
	PATH_REPORT_PROD_RESULT("report-prod-result"),
	PATH_REPORT_PROD_RESULT_BY_LEVEL("report-prod-result-by-level"),
	PATH_REPORT_SALE_ESTIMATE("report-sale-estimate"),
	PATH_REPORT_DAY_GRGA("report-day-grga"),
	PATH_REPORT_DATA_INVEST("report-data-invest"),
	PATH_REPORT_TASK("report-task"),
	PATH_REPORT_TASK_EXPORT("report-task-export"),

	/*-----------------statistical---------------------------*/
	PATH_STATISTICAL_MATERIAL("statistical-material"),
	
	//----------Support Require----------//
	PATH_SUPPORT_REQUIRE_CREATE("support-require-create"),
	PATH_SDP_ITEM_GETS("sdp-item-gets"),
	PATH_SUPPORT_REQUIRE_GETS("support-require-gets"),
	PATH_SUPPORT_REQUIRE_GET("support-require-get"),
	
	//----------Notification----------//
	PATH_NOTIFICATION_GETS("notification-gets"),
	PATH_NOTIFICATION_GET("notification-get"),
	PATH_NOTIFICATION_SEARCH("notification-search"),
	PATH_NOTIFICATION_UPDATE_BY_TASK_CODE("notification-update-by-taskCode"),

	//----------Period Close Exception----------//
	PATH_PERIOD_CLOSE_EXCEPTION_GETS("period-close-exception-get"),
	PATH_PERIOD_CLOSE_EXCEPTION("period-close-exception"),
	PATH_PERIOD_CLOSE_EXCEPTION_CREATE("period-close-exception-create"),
	PATH_PERIOD_CLOSE_EXCEPTION_DELETE("period-close-exception-delete"),
	
	/*
	 * Document File
	 */
	PATH_DOCUMENT_FILE_GET("document-file-get"),
	
	/*
	 * Document Type
	 */
	PATH_DOCUMENT_TYPE_SEARCH("document-type-search"),
	PATH_DOCUMENT_TYPE_GET("document-type-get"),
	PATH_DOCUMENT_TYPE_GET_ACTIVE("document-type-get-active"),
	PATH_DOCUMENT_TYPE_GET_EXISTED("document-type-get-existed"),
	PATH_DOCUMENT_TYPE_CREATE("document-type-save"),
	PATH_DOCUMENT_TYPE_UPDATE("document-type-update"),
	
	/*
	 * Document
	 */
	PATH_DOCUMENT_SEARCH("document-search"),
	PATH_DOCUMENT_GET("document-get"),
	PATH_DOCUMENT_CREATE("document-save"),
	PATH_DOCUMENT_UPDATE("document-update"),
	
	/*
	 * Task
	 */
	PATH_TASK_SEARCH("task-search"),
	PATH_TASK_CONFIRM("task-confirm"),
	PATH_TASK_SAVE("task-save"),
	PATH_TASK_GET("task-get"),
	PATH_TASK_UPDATE_PROGRESS("task-update-progress"),
	PATH_TASK_NOTIFICATION("task-send-notification"),
	PATH_TASK_VIEW_MODE("task-view-mode"),
	PATH_TASK_VIEW_MODE_SEARCH("task-view-mode-search"),
	PATH_TASK_CALENDAR("task-calendar"),
	PATH_TASK_REQUEST_TO_REJECT_FREQUENCY("task-request-to-reject-frequency"),
	PATH_TASK_ACCEPT_TO_REJECT_FREQUENCY("task-accept-to-reject-frequency"),
	PATH_TASK_ADD_COMMENT("task-add-comment"),
	PATH_TASK_CLONE("task-clone"),

	// GENERAL LEDGER
	PATH_GENERAL_LEDGER_SEARCH("general-ledger-search"),
	PATH_GENERAL_LEDGER_EXPORT("general-ledger-export"),
	PATH_GENERAL_LEDGER_CANCEL("general-ledger-cancel"),
	PATH_GENERAL_LEDGER_GET("general-ledger-get"),
	PATH_GENERAL_LEDGER_SAVE_OR_UPDATE("general-ledger-save-or-update"),
	PATH_GENERAL_LEDGER_SAVE_AND_SYNC("general-ledger-save-and-sync"),

	// VENDOR
	PATH_VENDOR_SEARCH("vendor-search"),
	PATH_VENDOR_GETS("vendor-gets"),
	PATH_VENDOR_SYNC_FROM_SAP("vendor-sync-from-sap"),
	PATH_VENDOR_GET_BY_CODE("vendor-get-by-code")
	;
	
	public String val;
	
	private ApiEnum(String val) {
		this.val = val;
	}
}
