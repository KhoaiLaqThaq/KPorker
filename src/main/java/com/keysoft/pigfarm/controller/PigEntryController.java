package com.keysoft.pigfarm.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.keysoft.pigfarm.common.EntityResponseCodeEnum;
import com.keysoft.pigfarm.common.EventStatusEnum;
import com.keysoft.pigfarm.common.SystemParamEnum;
import com.keysoft.pigfarm.common.TransCodeTypeEnum;
import com.keysoft.pigfarm.integration.EntityResponse;
import com.keysoft.pigfarm.manager.FarmManager;
import com.keysoft.pigfarm.manager.PigEntryManager;
import com.keysoft.pigfarm.manager.ProcessOrderManager;
import com.keysoft.pigfarm.manager.SystemParameterManager;
import com.keysoft.pigfarm.manager.TransCodeManager;
import com.keysoft.pigfarm.production.dto.FarmDto;
import com.keysoft.pigfarm.production.dto.MaterialDto;
import com.keysoft.pigfarm.production.dto.PigEntryDto;
import com.keysoft.pigfarm.production.dto.ProcessOrderDto;

import lombok.extern.slf4j.Slf4j;

/**
 * Generated by Speed Generator
 * 
 * @author <a href="mailto:ngtrungkien@gmail.com">Kien Nguyen</a>
 */
 @Slf4j
@Controller
public class PigEntryController extends BaseController {

	@Autowired
    private PigEntryManager pigEntryManager;
	@Autowired
	private FarmManager farmManager;
	@Autowired
	private ProcessOrderManager processOrderManager;
	@Autowired
	private TransCodeManager transCodeManager;
	@Autowired
	private SystemParameterManager systemParameterManager;

    @GetMapping("/pigEntry/list")
    public ModelAndView list(HttpServletRequest request, @RequestParam (value="code", required=true) String code) throws Exception {
    	log.debug("ENTERING 'LIST PIG_ENTRY' METHOD...");
    	ModelAndView modelAndView = new ModelAndView("pigentry-list");
    	PigEntryDto criteria = new PigEntryDto();
    	ProcessOrderDto processOrder = processOrderManager.getByCode(code);
    	criteria.setProcessOrderCode(code);
    	criteria.setPage(appProperties.getDefaultPage());
    	criteria.setSize(appProperties.getDefaultPageSize());
    	modelAndView.addObject("processOrder" , processOrder);
		modelAndView.addObject("page", pigEntryManager.search(criteria));
		modelAndView.addObject("criteria",criteria);
        return modelAndView;
    }
    
    @PostMapping("/pigEntry/list")
    public ModelAndView search(@Valid PigEntryDto criteria, BindingResult bindingResult, @RequestParam (value="code", required=true) String code){
    	log.debug("ENTERING 'SEARCH PIG_ENTRY' METHOD...");
		ModelAndView modelAndView = new ModelAndView("pigentry-list");
		criteria.setSize(appProperties.getDefaultPageSize());
		criteria.setPage(appProperties.getDefaultPage());
		modelAndView.addObject("page", pigEntryManager.search(criteria));
		modelAndView.addObject("criteria", criteria);
        return modelAndView;
    }
    
    @ModelAttribute
    @GetMapping("/pigEntry/form")
    public ModelAndView show(@RequestParam (value="id", required=false) Long id,@RequestParam (value="code", required=true) String code, HttpServletRequest request) throws Exception {
    	log.debug("ENTERING 'SHOW PIG_ENTRY' METHOD...");
    	Locale locale = request.getLocale();
    	
    	ModelAndView modelAndView = new ModelAndView("pigentry-form");
    	PigEntryDto pigEntry = new PigEntryDto();
    	pigEntry.setProcessOrderCode(code);
    	if(id != null) {
    		pigEntry = pigEntryManager.get(id);
    		if(pigEntry == null) {
        		addError(request, getText("data.notfound", locale));
				return new ModelAndView("redirect:/processOrder/list");
        	}
    	} else {
    		pigEntry.setTransCode(transCodeManager.getTransCode(TransCodeTypeEnum.PIG_ENTRY.val));
    		pigEntry.setStatus(EventStatusEnum.CONFIRMED.val);
    	}
    	ProcessOrderDto processOrder = processOrderManager.getByCode(code) ;
    	FarmDto receiveFarm = processOrder.getBarn().getFarm();
    	List<FarmDto> listSourceFarm = farmManager.gets();
    	List<FarmDto> listSourceFarmFilter = filterFarm(listSourceFarm);
    	
		List<MaterialDto> materialDtos = systemParameterManager.getByPrefixs(SystemParamEnum.MAPPING_MATERIAL_CODE_PIG_ENTRY_PREFIX.param);
		modelAndView.addObject("materialDtos", materialDtos);
    	
		modelAndView.addObject("pigEntry", pigEntry);
		modelAndView.addObject("sourceFarms", listSourceFarmFilter);
		modelAndView.addObject("receiveFarm", receiveFarm);
		modelAndView.addObject("processOrder", processOrder);
        return modelAndView;
    }

    @PostMapping("/pigEntry/save")
    public String save(PigEntryDto pigEntryDto, BindingResult bindingResult, HttpServletRequest request, HttpServletResponse response) throws Exception {
    	log.debug("ENTERING 'SAVE PIG_ENTRY' METHOD...");
        Locale locale = request.getLocale();
        String view = "pigentry-form";
        if (bindingResult.hasErrors()) {
        	addError(request, bindingResult.getAllErrors().toString());
            return view;
        }
        try {
        	EntityResponse result = pigEntryManager.save(pigEntryDto);
        	if(pigEntryDto.getId() != null) {
        		 if(result.getCode().equals(EntityResponseCodeEnum.SUCCESS_200.val)) {
        			addMessage(request, getText("pigEntry.updated", locale));
        		 } else if(result.getCode().equals(EntityResponseCodeEnum.ERROR_400.val)){
            	     addError(request, getText("data.lock.15.minutes", request.getLocale()));
     	         } else {
     	        	  addError(request, result.getMessage());
     	         }
		    } else {
		    	if(result.getCode().equals(EntityResponseCodeEnum.SUCCESS_200.val)) {
	            	addMessage(request, getText("pigEntry.updated", locale));
		    	} else if(result.getCode().equals(EntityResponseCodeEnum.ERROR_400.val)){
           	     	addError(request, getText("data.lock.15.minutes", request.getLocale()));
    	        } else {
    	        	addError(request, result.getMessage());
    	        }
		    }
		} catch (Exception e) {
			log.error("ERROR SAVE PIG_ENTRY: EXCEPTION: {}", e);
			addError(request, e.getMessage());
		}
        view = "redirect:/pigEntry/list?code="+pigEntryDto.getProcessOrderCode();

        return view;
    }
    
    @PostMapping("/pigEntry/cancel")
    public String cancel(PigEntryDto pigEntryDto, BindingResult bindingResult, HttpServletRequest request, HttpServletResponse response) throws Exception {
    	log.debug("ENTERING 'CANCEL PIG_ENTRY' METHOD...");
        Locale locale = request.getLocale();
        String view = "pigentry-form";
        if (bindingResult.hasErrors()) {
        	addError(request, bindingResult.getAllErrors().toString());
            return view;
        }
        try {
        	EntityResponse result = pigEntryManager.cancel(pigEntryDto);
        	if(pigEntryDto.getId() != null) {
        		 if(result.getCode().equals(EntityResponseCodeEnum.SUCCESS_200.val)) {
        			addMessage(request, getText("cancel.success", locale));
        		 } else if(result.getCode().equals(EntityResponseCodeEnum.ERROR_400.val)){
            	     addError(request, getText("data.lock.15.minutes", request.getLocale()));
     	         } else {
     	        	  addError(request, result.getMessage());
     	         }
		    }
		} catch (Exception e) {
			log.error("ERROR CANCEL PIG_ENTRY: EXCEPTION: {}", e);
			addError(request, e.getMessage());
		}
        view = "redirect:/pigEntry/list?code="+pigEntryDto.getProcessOrderCode();

        return view;
    }
    
    private List<FarmDto> filterFarm(List<FarmDto> farms) {
    	List<FarmDto> list = new ArrayList<>();
    	
    	farms.stream().forEach(f -> {
    		String code = f.getCode();
    		String prefix = code.substring(0,1);
    		if(prefix.equals("8")) {
    			list.add(f);
    		}
    	});
    	
    	return list;
    }
    
}