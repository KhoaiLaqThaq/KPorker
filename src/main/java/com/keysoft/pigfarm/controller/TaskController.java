package com.keysoft.pigfarm.controller;

import java.io.IOException;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import com.keysoft.pigfarm.common.*;
import com.keysoft.pigfarm.manager.NotificationManager;
import com.keysoft.pigfarm.manager.UserManager;
import com.keysoft.pigfarm.master.dto.UserDto;
import com.keysoft.pigfarm.production.dto.SearchDto;
import com.keysoft.pigfarm.production.dto.TaskEvidenceDto;
import com.keysoft.pigfarm.util.UserContext;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.keysoft.pigfarm.constant.ModelViewEnum;
import com.keysoft.pigfarm.integration.EntityResponse;
import com.keysoft.pigfarm.manager.FarmManager;
import com.keysoft.pigfarm.manager.TaskManager;
import com.keysoft.pigfarm.production.dto.FarmDto;
import com.keysoft.pigfarm.production.dto.TaskDto;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/task")
public class TaskController extends BaseController {
	
	@Autowired
	private TaskManager taskManager;
	@Autowired
	private UserManager userManager;
	@Autowired
	private NotificationManager notificationManager;
	
	@Value("${app.attachment.max-size}")
	private Integer maxSize;

	Map<String, SearchDto> searchDto = new HashMap<>();

	private List<String> taskStatus = Arrays.asList(TaskStatusEnum.ASSIGNED.val, TaskStatusEnum.CONFIRMED.val, TaskStatusEnum.DONE.val, TaskStatusEnum.EDITED.val, TaskStatusEnum.REJECTED.val);

	private final String roleTaskAdminView = "ROLE_TASK_ADMIN_VIEW";

	@GetMapping("/list")
	public ModelAndView showList(HttpServletRequest request) {
		log.info("ENTERING: show-list()");
		ModelAndView mav = new ModelAndView(ModelViewEnum.VIEW_TASK_LIST.mav);
		/*
		 * init data
		 */
		List<String> taskFrequencies = Arrays.asList(TaskFrequencyEnum.ARISE.val, TaskFrequencyEnum.DAY.val, TaskFrequencyEnum.WEEK.val, TaskFrequencyEnum.MONTH.val);

		// check role task admin view
		Boolean isTaskAdminView = request.isUserInRole(roleTaskAdminView);
		if (isTaskAdminView) {
			List<UserDto> users = userManager.getAllUsers();
			mav.addObject("assignees", users);
		}

		TaskDto criteria = new TaskDto();
		criteria.setPage(appProperties.getDefaultPage());
		criteria.setSize(appProperties.getDefaultPageSize());
		criteria.setAdminView(isTaskAdminView);
		EntityResponse response = taskManager.getOrSearch(criteria);

		String username = request.getUserPrincipal().getName();
		String url = request.getRequestURI();
		if (searchDto.containsKey(username)) {
			SearchDto searching = searchDto.get(username);
			String urlLatest = searching.getLatestUrl();
			if (urlLatest.equals(url) && searching.getSearchTask() != null) {
				return searchList(searching.getSearchTask(), request);
			}
		}
		
		mav.addObject(ModelViewEnum.MODEL_CRITERIA.mav, criteria)
			.addObject("page", response.getData())
			.addObject("taskStatus", taskStatus)
			.addObject("taskFrequencies", taskFrequencies);
		return mav;
	}
	
	@PostMapping("/list")
	public ModelAndView searchList(@Valid TaskDto criteria, HttpServletRequest request) {
		log.info("ENTERING: search-list()");
		ModelAndView mav = new ModelAndView(ModelViewEnum.VIEW_TASK_LIST.mav);
		Boolean isTaskAdminView = request.isUserInRole(roleTaskAdminView);
		/*
		 * init data
		 */
		List<String> taskFrequencies = Arrays.asList(TaskFrequencyEnum.ARISE.val, TaskFrequencyEnum.DAY.val, TaskFrequencyEnum.WEEK.val, TaskFrequencyEnum.MONTH.val);
		if (isTaskAdminView) {
			List<UserDto> users = userManager.getAllUsers();
			mav.addObject("assignees", users);
		}

		criteria.setAdminView(isTaskAdminView);
		EntityResponse response = taskManager.getOrSearch(criteria);

		String username = request.getUserPrincipal().getName();
		String url = request.getRequestURI();
		SearchDto searching = new SearchDto();
		if (searchDto.containsKey(username)) {
			searching = searchDto.get(username);
		}
		searching.setSearchTask(criteria);
		searching.setLatestUrl(url);
		searchDto.put(username, searching);
		
		mav.addObject(ModelViewEnum.MODEL_CRITERIA.mav, criteria)
			.addObject("page", response.getData())
			.addObject("taskStatus", taskStatus)
			.addObject("taskFrequencies", taskFrequencies)
		;
		return mav;
	}
	
	@GetMapping("/calendar")
	public ModelAndView showCalendar() {
		log.info("ENTERING: show-calendar");
		return new ModelAndView(ModelViewEnum.VIEW_TASK_CALENDAR.mav);
	}
	
	@GetMapping("/table")
	public ModelAndView showTable(HttpServletRequest request) {
		log.info("ENTERING: show-calendar");
		ModelAndView mav = new ModelAndView(ModelViewEnum.VIEW_TASK_TABLE.mav);
		Boolean isTaskAdminView = request.isUserInRole(roleTaskAdminView);
		TaskDto criteria = new TaskDto();
		criteria.setPage(appProperties.getDefaultPage());
		criteria.setSize(appProperties.getDefaultPageSize()/2);
		criteria.setAdminView(isTaskAdminView);
		EntityResponse response = taskManager.getDataViewMode(criteria);
		
		mav.addObject(ModelViewEnum.MODEL_CRITERIA.mav, response.getData());
		return mav;
	}

	@SuppressWarnings("unchecked")
	@GetMapping("/form")
	public ModelAndView showForm(@RequestParam(name = "code", required = false) String code, HttpServletRequest request) {
		log.info("ENTERING: showForm()...");
		ModelAndView mav = new ModelAndView(ModelViewEnum.VIEW_TASK_FORM.mav);
		TaskDto task = new TaskDto();

		if (StringUtils.isNotBlank(code)) {
			task =  taskManager.getByCode(code);
			if (task == null) {
				addError(request, getText("label.task.notfound", request.getLocale()));
				mav.setViewName("redirect:/task/form");
			}
		}

		/*
		 * init data
		 */
		List<String> taskFrequencies = Arrays.asList(TaskFrequencyEnum.ARISE.val, TaskFrequencyEnum.DAY.val, TaskFrequencyEnum.WEEK.val, TaskFrequencyEnum.MONTH.val);
		List<String> timeRegexLst = new ArrayList<>();
		Arrays.asList(TimeRegexEnum.values()).stream().forEach(item -> timeRegexLst.add(item.regex));

		PageDto page = userManager.gets(0, 500);

		mav.addObject(ModelViewEnum.MODEL_TASK.mav, task)
			.addObject("taskFrequencies", taskFrequencies)
				.addObject("timeRegexLst", timeRegexLst)
				.addObject("accounts", (List<UserDto>)page.getContent())
		;
		return mav;
	}
	
	@GetMapping("/confirm")
	public ModelAndView showPreview(@RequestParam(name = "code", required = true) String code,
									@RequestParam(name = "status", required = false) String status,
									HttpServletRequest request) {
		log.info("ENTERING: showForm()...");
		ModelAndView mav = new ModelAndView(ModelViewEnum.VIEW_TASK_PREVIEW.mav);
		mav.addObject(ModelViewEnum.MODEL_TASK.mav, new TaskDto());
		TaskDto task = new TaskDto();
		
		if (StringUtils.isNotBlank(code)) {
			task =  taskManager.getByCode(code);
			if (task == null) {
				addError(request, getText("label.task.notfound", request.getLocale()));
				mav.setViewName("redirect:/task/form");
			} else {
				if (StringUtils.isNotBlank(status) && NotificationStatusEnum.UNSEEN.val.equals(status)) notificationManager.updateByTaskCode(code);
			}
		}
		List<String> taskFrequencies = Arrays.asList(TaskFrequencyEnum.ARISE.val, TaskFrequencyEnum.DAY.val, TaskFrequencyEnum.WEEK.val, TaskFrequencyEnum.MONTH.val);
		mav.addObject(ModelViewEnum.MODEL_TASK.mav, task)
			.addObject("taskFrequencies", taskFrequencies);
		return mav;
	}

	@SuppressWarnings("unchecked")
	@GetMapping("/copy")
	public ModelAndView copyTask(@RequestParam(name = "code", required = true) String code,
								 HttpServletRequest request) {
		log.info("ENTERING: copyTask(), code={}", code);
		ModelAndView mav = new ModelAndView(ModelViewEnum.VIEW_TASK_FORM.mav);
		TaskDto task = new TaskDto();
		if (StringUtils.isNotBlank(code)) {
			task = taskManager.getByCode(code.trim());
			task.setCode("");
			task.setId(null);
			task.setAssigneeUsername(null);
		}
		task.setAction(TaskActionEnum.COPY.action);
		List<String> taskFrequencies = Arrays.asList(TaskFrequencyEnum.ARISE.val, TaskFrequencyEnum.DAY.val, TaskFrequencyEnum.WEEK.val, TaskFrequencyEnum.MONTH.val);

		PageDto page = userManager.gets(0, 500);
		mav.addObject(ModelViewEnum.MODEL_TASK.mav, task)
				.addObject("taskFrequencies", taskFrequencies)
				.addObject("accounts", (List<UserDto>)page.getContent());

		return mav;
	}
	
	@PostMapping("/form")
	public String save(@Valid TaskDto task, HttpServletRequest request) {
		log.info("ENTERING: save={}", task);
		Locale locale = request.getLocale();

		if (task.getId() == null) {
			task.setCreatedByReport(userManager.getMailReportByUserLogin());
		}

		EntityResponse response = taskManager.save(task);
		if (EntityResponseCodeEnum.SUCCESS_200.val.equals(response.getCode())) addMessage(request, getText("message.save.success", locale));
		else addError(request, response.getMessage());
		return "redirect:/task/list";
	}
	
	@PostMapping("/progress")
	@ResponseBody
	public boolean handleUpdateProgress(@Valid TaskDto task) throws IOException {
		log.debug("entering 'handleUpdateProgress' method...");
		Boolean updateProgress = false;
		if (task.getId() != null && StringUtils.isNotBlank(task.getCode())) {
			if (!CollectionUtils.isEmpty(task.getPhotos())) {
				List<TaskEvidenceDto> taskEvidences = new ArrayList<>();
				for (MultipartFile item : task.getPhotos()) {
					/**
					 * Kiem tra kich thuoc file truoc khi -> service
					 */
					if (item.getSize() <= maxSize) {
						try {
							TaskEvidenceDto taskEvidenceDto = new TaskEvidenceDto();
							taskEvidenceDto.setPhotoUrl(Base64.getEncoder().encodeToString(item.getBytes()));
							String fileName = item.getOriginalFilename();
							taskEvidenceDto.setFileName(fileName);
							if (StringUtils.isNotBlank(fileName)) {
								taskEvidenceDto.setFileType(FilenameUtils.getExtension(fileName));
							}
							taskEvidenceDto.setFileSize(item.getSize());
							taskEvidences.add(taskEvidenceDto);
						} catch (IOException e) {
							e.printStackTrace();
						}
					}
				}
				task.setTaskEvidences(taskEvidences);
			}
			EntityResponse response = taskManager.updateProgress(task);
			if (EntityResponseCodeEnum.SUCCESS_200.val.equals(response.getCode())) {
				updateProgress = true;
			}
		}
		return updateProgress;
	}
	
}
