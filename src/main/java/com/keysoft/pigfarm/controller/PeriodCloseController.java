package com.keysoft.pigfarm.controller;

import java.time.LocalDate;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.keysoft.pigfarm.common.EntityResponseCodeEnum;
import com.keysoft.pigfarm.common.FunctionTypeEnum;
import com.keysoft.pigfarm.helper.DateTimeHelper;
import com.keysoft.pigfarm.integration.EntityResponse;
import com.keysoft.pigfarm.manager.FarmManager;
import com.keysoft.pigfarm.manager.PeriodCloseManager;
import com.keysoft.pigfarm.production.dto.FarmDto;
import com.keysoft.pigfarm.production.dto.PeriodCloseExceptionDto;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class PeriodCloseController extends BaseController {
	@Autowired
	private PeriodCloseManager periodCloseManager;
	@Autowired
	private FarmManager farmManager;
	
	@GetMapping("/periodClose/list")
	public ModelAndView list() throws Exception {
    	log.debug("ENTERING 'LIST PERIOD CLOSE' METHOD...");
    	PeriodCloseExceptionDto criteria = new PeriodCloseExceptionDto();
    	criteria.setFuncType(FunctionTypeEnum.CLOSE_PERIOD.type);
    	
		ModelAndView modelAndView = new ModelAndView("close-period-list");
		modelAndView.addObject("list", periodCloseManager.gets(criteria));
		modelAndView.addObject("funcType", FunctionTypeEnum.CLOSE_PERIOD.type);
		
        return modelAndView;
	}
	
	//đóng kỳ
	@GetMapping("/periodClose")
	public String closePeriod(HttpServletRequest request) throws Exception {
    	log.debug("ENTERING 'CLOSE PERIOD' METHOD...");
    	Locale locale = request.getLocale();
    	EntityResponse response = periodCloseManager.closePeriodAllInstock();
    	
    	String view = "redirect:/periodClose/list";
    	if(response.getCode().equals(EntityResponseCodeEnum.SUCCESS_200.val)) {
    		addMessage(request, getText("closePeriod.success", locale));
    	} else {
    		addError(request, response.getMessage());
    	}
		return view;
	}
	
	@GetMapping("/periodClose/form")
	public ModelAndView createException() throws Exception {
    	log.debug("ENTERING 'CREATE PERIOD CLOSE EXCEPTION' METHOD...");
    	PeriodCloseExceptionDto criteria = new PeriodCloseExceptionDto();
    	criteria.setFuncType(FunctionTypeEnum.CLOSE_PERIOD.type);
    	
    	List<FarmDto> farms = farmManager.getAllFarmByUser();
    	
		ModelAndView modelAndView = new ModelAndView("close-period-form");
		modelAndView.addObject("criteria", criteria);
		modelAndView.addObject("farms", farms);
		
        return modelAndView;
	}
	
	@PostMapping("/periodClose/save")
	public String save(@Valid PeriodCloseExceptionDto criteria, HttpServletRequest request) throws Exception {
    	log.debug("ENTERING 'SAVE PERIOD CLOSE EXCEPTION' METHOD...");
    	Locale locale = request.getLocale();
    	if(StringUtils.isNotBlank(criteria.getPeriodCloseStage())) {
    		List<LocalDate> list = DateTimeHelper.getDatePeriodFromString(criteria.getPeriodCloseStage());
    		criteria.setFromDate(list.get(0));
    		criteria.setToDate(list.get(1));
    	}
    	
    	EntityResponse response = periodCloseManager.save(criteria);
    	
    	String view;
    	if(criteria.getFuncType().equals(FunctionTypeEnum.CLOSE_PERIOD.type)) {
    		view = "redirect:/periodClose/list";
    	} else {
    		view = "redirect:/goodsAttristionClose/list";
    	}
    	
    	if(response.getCode().equals(EntityResponseCodeEnum.SUCCESS_200.val)) {
    		addMessage(request, getText("closePeriod.form.success", locale));
    	} else {
    		addError(request, response.getMessage());
    	}
		return view;
	}
	
	@GetMapping("/periodClose/delete")
	public String delete(@RequestParam(value="id", required=true) Long id,
			@RequestParam(value="funcType", required=true) String funcType, HttpServletRequest request) {
		log.debug("ENTERING 'DELETE PERIOD CLOSE EXCEPTION' METHOD...");
    	Locale locale = request.getLocale();
    	
    	EntityResponse response = periodCloseManager.delete(id);
    	
    	String view;
    	if(funcType.equals(FunctionTypeEnum.CLOSE_PERIOD.type)) {
    		view = "redirect:/periodClose/list";
    	} else {
    		view = "redirect:/goodsAttristionClose/list";
    	}
    	if(response.getCode().equals(EntityResponseCodeEnum.SUCCESS_200.val)) {
    		addMessage(request, getText("closePeriod.delete.success", locale));
    	} else {
    		addError(request, response.getMessage());
    	}
		return view;
		
	}
	
	@GetMapping("/goodsAttristionClose/list")
	public ModelAndView listGoodsAttritionException() throws Exception {
    	log.debug("ENTERING 'LIST GOODS ATTRITION CLOSE EXCEPTION CLOSE' METHOD...");
    	PeriodCloseExceptionDto criteria = new PeriodCloseExceptionDto();
    	criteria.setFuncType(FunctionTypeEnum.CLOSE_GOODSATTRITION.type);
    	
		ModelAndView modelAndView = new ModelAndView("close-attrition-list");
		modelAndView.addObject("list", periodCloseManager.gets(criteria));
		modelAndView.addObject("funcType", FunctionTypeEnum.CLOSE_GOODSATTRITION.type);
		
        return modelAndView;
	}
	
	@GetMapping("/goodsAttristionClose/form")
	public ModelAndView createGoodsAttritionException() throws Exception {
    	log.debug("ENTERING 'CREATE GOODS ATTRITION CLOSE EXCEPTION' METHOD...");
    	PeriodCloseExceptionDto criteria = new PeriodCloseExceptionDto();
    	criteria.setFuncType(FunctionTypeEnum.CLOSE_GOODSATTRITION.type);
    	
    	List<FarmDto> farms = farmManager.getAllFarmByUser();
    	
		ModelAndView modelAndView = new ModelAndView("close-period-form");
		modelAndView.addObject("criteria", criteria);
		modelAndView.addObject("farms", farms);
		
        return modelAndView;
	}
}
