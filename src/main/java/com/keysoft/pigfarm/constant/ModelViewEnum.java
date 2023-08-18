package com.keysoft.pigfarm.constant;

public enum ModelViewEnum {
	MODEL_PAGE("page"),
	MODEL_CRITERIA("criteria"),
	MODEL_SYSTEM_PARAMETER("systemParameter"),
	MODEL_SYSTEM_PARAMETERS("systemParameters"),
	VIEW_SYSTEM_PARAMETER_LIST("systemParameter-list"),
	VIEW_SYSTEM_PARAMETER_FORM("systemParameter-form"),
	
	MODEL_USER("user"),
	MODEL_USERS("users"),
	MODEL_GROUP("group"),
	MODEL_GROUPS("groups"),
	MODEL_ORGANIZATION("organization"),
	MODEL_ORGANIZATIONS("organizations"),
	MODEL_POSITION("position"),
	MODEL_POSITIONS("positions"),
	MODEL_STAFF("staff"),
	MODEL_STAFFS("staffs"),
	MODEL_ROLE("role"),
	MODEL_ROLES("roles"),

	MODEL_MENUS("menus"),
	MODEL_MENU("menu"),
	MODEL_DEVICE_DISPLAY("deviceDisplay"),
	MODEL_DEVICE_DISPLAYS("deviceDisplays"),
	
	MODEL_TASK("task"),
	MODEL_VENDOR("vendor"),
	
	VIEW_USER_LIST("system/user/user-list"),
	VIEW_USER_FORM("system/user/user-form"),
	VIEW_USER_FORM_INFO("user-form-info"),
	VIEW_USER_FORM_PRIVILEGES("system/user/user-form-privileges"),
	VIEW_GROUP_LIST("system/group/group-list"),
	VIEW_GROUP_FORM("system/group/group-form"),
	VIEW_GROUP_UPDATE("group-update"),
	VIEW_STAFF_LIST("staff-list"),
	VIEW_STAFF_FORM("staff-form"),
	VIEW_USER_ADMIN_LIST("user-admin-list"),
	VIEW_USER_ADMIN_FORM("user-admin-form"),
	VIEW_USER_CHANGE_PW("user-change-password"),
	
	VIEW_ORGANIZATION_LIST("organization-list"),
	VIEW_ORGANIZATION_FORM("organization-form"),
	VIEW_FARM_LIST("farm-list"),
	VIEW_FARM_FORM("farm-form"),
	
	VIEW_GROSS_WEIGHT_LIST("gross-weight-list"),
	VIEW_GROSS_WEIGHT_FORM("gross-weight-form"),
	
	VIEW_BARN_LIST("barn-list"),
	
	
	VIEW_SILO_LIST("silo-list"),
	// purchase
	VIEW_MATERIAL_LIST("material-list"),
	// manufacture
	VIEW_BARN_PLAN_LIST("barn-plan-list"),
	VIEW_BARN_PLAN_FORM("barn-plan-form"),
	VIEW_PROCESS_ORDER_LIST("processorder-list"),
	VIEW_PROCESS_ORDER_FORM("processorder-form"),
	VIEW_DAILY_AVERAGE_WEIGHT_LIST("dailyaverageweight-list"),

	
	VIEW_DASHBOARD_LIST("dashboard"),
	VIEW_CO_LIST("co-list"),
	VIEW_CO_FORM("co-form"),
	VIEW_SO_LIST("so-list"),
	
	VIEW_CHANGE_PASS("change-pass"),
	// view system
	VIEW_SYSTEM_PARAM_LIST("system/system-params/systemparameter-list"),
	VIEW_SYSTEM_PARAM_FORM("system/system-params/systemparameter-form"),
	
	//task
	VIEW_TASK_LIST("/task/task-list"),
	VIEW_TASK_CALENDAR("/task/task-calendar"),
	VIEW_TASK_TABLE("/task/task-table"),
	VIEW_TASK_FORM("/task/form"),
	VIEW_TASK_PREVIEW("/task/task-preview"),

	// view report
	VIEW_REPORT_TASK("/reports/report-task"),

	// view general ledger
	VIEW_GENERAL_LEDGER_LIST("/general-ledger/list"),
	VIEW_GENERAL_LEDGER_FORM("/general-ledger/form"),
	// view vendor
	VIEW_VENDOR_LIST("/master-data/vendor-list"),
	VIEW_VENDOR_PREVIEW_DETAIL("/master-data/vendor-preview-detail"),

	// redirect
	REDIRECT_USER_LIST("redirect:/user/list"),
	REDIRECT_GROUP_LIST("redirect:/group/list"),
	REDIRECT_STAFF_LIST("redirect:/staff/list"),
	REDIRECT_ORGANIZATION_LIST("redirect:/organization/list"),
	REDIRECT_CO_LIST("redirect:/co/list"),
	REDIRECT_SO_LIST("redirect:/so/list"),
	REDIRECT_GENERAL_LEDGER_LIST("redirect:/general-ledger/list"),
	REDIRECT_GENERAL_LEDGER_FORM("redirect:/general-ledger/form")
	;

	public String mav;

	private ModelViewEnum(final String view) {
		mav = view;
	}
}
