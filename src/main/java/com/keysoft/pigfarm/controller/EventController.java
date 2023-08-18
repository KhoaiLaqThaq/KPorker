package com.keysoft.pigfarm.controller;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.keysoft.pigfarm.common.DatePatternEnum;
import com.keysoft.pigfarm.common.EntityResponseCodeEnum;
import com.keysoft.pigfarm.common.EventCodeEnum;
import com.keysoft.pigfarm.common.EventStatusEnum;
import com.keysoft.pigfarm.common.EventTypeEnum;
import com.keysoft.pigfarm.common.MapKeyEnum;
import com.keysoft.pigfarm.common.PigCullingReasonEnum;
import com.keysoft.pigfarm.common.PigCullingTypeEnum;
import com.keysoft.pigfarm.common.PigProductionReasonEnum;
import com.keysoft.pigfarm.common.PigTypeEnum;
import com.keysoft.pigfarm.common.StatusEnum;
import com.keysoft.pigfarm.common.SymbolEnum;
import com.keysoft.pigfarm.common.TransCodeTypeEnum;
import com.keysoft.pigfarm.common.WeightChartEnum;
import com.keysoft.pigfarm.constant.ModelViewEnum;
import com.keysoft.pigfarm.helper.DateTimeHelper;
import com.keysoft.pigfarm.integration.EntityResponse;
import com.keysoft.pigfarm.manager.EventManager;
import com.keysoft.pigfarm.manager.ProcessOrderManager;
import com.keysoft.pigfarm.manager.ProductionManager;
import com.keysoft.pigfarm.manager.SyncDataManager;
import com.keysoft.pigfarm.manager.SystemParameterManager;
import com.keysoft.pigfarm.manager.TransCodeManager;
import com.keysoft.pigfarm.production.dto.EventDto;
import com.keysoft.pigfarm.production.dto.MaterialDto;
import com.keysoft.pigfarm.production.dto.ProcessOrderDto;
import com.keysoft.pigfarm.production.dto.ProductionDto;
import com.keysoft.pigfarm.production.dto.SystemParameterDto;
import com.keysoft.pigfarm.production.dto.WeightChartDto;
import com.keysoft.pigfarm.production.dto.WeightNoteDto;
import com.keysoft.pigfarm.production.json.SyncResponse;
import com.keysoft.pigfarm.util.UserContext;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class EventController extends BaseController {
	  @Autowired
	  private EventManager eventManager;
	  @Autowired
	  private ProcessOrderManager processOrderManager;
	  @Autowired
	  private ProductionManager productionManager;
	  @Autowired
	  private SyncDataManager syncDataManager;
	  @Autowired
	  private TransCodeManager transCodeManager;
	  @Autowired
	  private SystemParameterManager systemParameterManager;
	  
	//------- PIG_CULLING ---------//
	@GetMapping("/pigCulling/list")
	public ModelAndView list(@RequestParam(name="poCode", required = true) String processOrderCode,HttpServletRequest request) throws Exception {
    	log.debug("ENTERING 'LIST PIG_CULLING' METHOD...");
    	EventDto criteria = new EventDto();
    	List<String> types = new ArrayList<>();
    	types.add(EventCodeEnum.PIG_CULLING.val);
    	types.add(EventCodeEnum.PIG_DEAD.val);
    	criteria.setTypes(types);
    	criteria.setProcessOrderCode(processOrderCode);
    	criteria.setSize(appProperties.getDefaultPageSize());
    	criteria.setPage(appProperties.getDefaultPage());
    	ProcessOrderDto processOrder = processOrderManager.getByCode(processOrderCode);
		ModelAndView modelAndView = new ModelAndView("pigculling-list");
		Integer totalPigRetained = productionManager.getTotalPigRetainedByPoCode(processOrderCode); 
    	modelAndView.addObject("totalPigRetained", totalPigRetained);
		modelAndView.addObject("page", eventManager.search(criteria));
		modelAndView.addObject("processOrder",processOrder);
		modelAndView.addObject("criteria", criteria);
        return modelAndView;
	}
	    
    @PostMapping("/pigCulling/list")
    public ModelAndView search(@Valid EventDto criteria, BindingResult bindingResult){
    	log.debug("ENTERING 'SEARCH PIG_CULLING' METHOD...");
		ModelAndView modelAndView = new ModelAndView("pigculling-list");
		if(criteria != null && criteria.getSize() == null){
			criteria.setSize(appProperties.getDefaultPageSize());
	    	criteria.setPage(appProperties.getDefaultPage());
	    }
		if(StringUtils.isBlank(criteria.getType())) {
			List<String> types = new ArrayList<>();
	    	types.add(EventCodeEnum.PIG_CULLING.val);
	    	types.add(EventCodeEnum.PIG_DEAD.val);
	    	criteria.setTypes(types);
		}
		ProcessOrderDto processOrder = processOrderManager.getByCode(criteria.getProcessOrderCode());
		Integer totalPigRetained = productionManager.getTotalPigRetainedByPoCode(criteria.getProcessOrderCode()); 
    	modelAndView.addObject("totalPigRetained", totalPigRetained);
		modelAndView.addObject("processOrder",processOrder);
		modelAndView.addObject("page", eventManager.search(criteria));
		modelAndView.addObject("criteria", criteria);
        return modelAndView;
    }
	    
	@ModelAttribute
    @GetMapping("/pigCulling/form")
    public ModelAndView show(@RequestParam(name="poCode", required = true) String processOrderCode, @RequestParam(value="id", required=false) Long id, HttpServletRequest request) throws Exception {
		log.debug("ENTERING 'SHOW PIG_CULLING' METHOD...");
		Locale locale = request.getLocale();
    	ModelAndView modelAndView = new ModelAndView("pigculling-form");
    	EventDto event = new EventDto();
    	event.setCode(EventCodeEnum.PIG_CULLING.val);
    	if(id != null) {
    		event = eventManager.get(id);
    		if(event == null) {
        		addError(request, getText("data.notfound", locale));
				return new ModelAndView("redirect:/processOrder/list");
        	}
    	} else {
    		event.setTransCode(transCodeManager.getTransCode(TransCodeTypeEnum.EVENT.val));
    	}
    	event.setProcessOrderCode(processOrderCode);
    	List<String> eventTypes = new ArrayList<String>();
    	Arrays.asList(PigCullingTypeEnum.values()).forEach(item -> eventTypes.add(item.val));
		
		
		modelAndView.addObject("event", event);
		modelAndView.addObject("eventTypes", eventTypes);
		ProcessOrderDto processOrderDto = processOrderManager.getByCode(processOrderCode);
    	if(processOrderDto != null) {
    		StringBuilder pigCullingPattern = new StringBuilder();
    		pigCullingPattern.append(processOrderDto.getPigType()).append(SymbolEnum.DOT.val).append(EventCodeEnum.PIG_CULLING.val);
    		StringBuilder pigDeadPattern = new StringBuilder();
    		pigDeadPattern.append(processOrderDto.getPigType()).append(SymbolEnum.DOT.val).append(EventCodeEnum.PIG_DEAD.val);
    		List<String> paramNames = new ArrayList<>();
    		paramNames.add(pigCullingPattern.toString());
    		paramNames.add(pigDeadPattern.toString());
    		SystemParameterDto systemParameterDto = new SystemParameterDto();
    		systemParameterDto.setParamNames(paramNames);
    		List<MaterialDto> materialDtos = systemParameterManager.getMaterials(systemParameterDto);
    		modelAndView.addObject("materialDtos", materialDtos);
    		modelAndView.addObject("processOrder", processOrderDto);
    	}
		List<String> pigTypes = new ArrayList<>();
    	Arrays.asList(PigTypeEnum.values()).forEach(item -> pigTypes.add(item.val));
    	modelAndView.addObject("pigTypes", pigTypes);
		
    	List<String> reasons = new ArrayList<>();
    	Arrays.asList(PigCullingReasonEnum.values()).forEach(item -> reasons.add(item.val));
    	modelAndView.addObject("reasons", reasons);
    	
        return modelAndView;
    }
	    
    @PostMapping("/pigCulling/save")
    public String save(@Valid EventDto eventDto, BindingResult bindingResult, HttpServletRequest request, HttpServletResponse response) throws Exception {
    	log.debug("ENTERING 'SAVE PIG_CULLING' METHOD...");
        Locale locale = request.getLocale();
        String username = UserContext.getUsername();
        String view = "pigculling-form";
        if(eventDto.getId() != null) {
        	 view = "/pigculling/form?poCode=" + eventDto.getProcessOrderCode() +"&id=" + eventDto.getId();
        	 eventDto.setModifiedBy(username);
        } else {
        	eventDto.setCreatedBy(username);
        }
        if (bindingResult.hasErrors()) {
        	addError(request, bindingResult.getAllErrors().toString());
            return view;
        }
        view = "redirect:/pigCulling/list?poCode=" + eventDto.getProcessOrderCode();
        try {
           Map<String, Object> map = new HashMap<String, Object>();
 	       map.put(MapKeyEnum.PIG_EVENT.key, eventDto.getPigCulling());
 	       eventDto.setContent(map);
 	       eventDto.setStatus(EventStatusEnum.CONFIRMED.val);
 	       
 	      EntityResponse result = eventManager.save(eventDto);
 	      if(eventDto.getId() != null) {
 	    	 if(result.getCode().equals(EntityResponseCodeEnum.SUCCESS_200.val)) {
 	        	  SyncResponse syncResponse = syncDataManager.sendDataToSAP();
 		    	  if (String.valueOf(HttpStatus.OK.value()).equals(syncResponse.getCode())) {
 		    		  	addMessage(request, getText("cancel.success", locale));
 		    	  } else {
 		  				addError(request, syncResponse.getMessage());
 		  		  }
 	          } else if(result.getCode().equals(EntityResponseCodeEnum.ERROR_400.val)){
 	        	  addError(request, getText("data.lock.15.minutes", locale));
 	          } else {
 	        	  addError(request, result.getMessage());
 	          }
 	      } else {
 	    	 if(result.getCode().equals(EntityResponseCodeEnum.SUCCESS_200.val)) {
 	        	  SyncResponse syncResponse = syncDataManager.sendDataToSAP();
 		    	  if (String.valueOf(HttpStatus.OK.value()).equals(syncResponse.getCode())) {
 		    	   		addMessage(request, getText("pigDead.updated", locale));
 		    	  } else {
 		  				addError(request, syncResponse.getMessage());
 		  		  }
 	    	 } else if(result.getCode().equals(EntityResponseCodeEnum.ERROR_400.val)){
	        	  addError(request, getText("data.lock.15.minutes", locale));
	         } else {
	        	  addError(request, result.getMessage());
	         }
 	      }
		} catch (Exception e) {
			log.error("==> ERROR SAVE PIG_CULLING: EXCEPTION: {}", e);
			addError(request, e.getMessage());
		}

        return view;
    }
    //------- PIG_CULLING ---------//
	    
	    
    //------- WEIGHT NOTE ---------//
    @GetMapping("/dailyAverageWeight/list")
    public ModelAndView listAverageWeight(@RequestParam("code") String processOrderCode, HttpServletRequest request) throws Exception {
    	log.debug("ENTERING 'LIST WEIGHT_NOTE' METHOD...");
    	
		ModelAndView modelAndView = new ModelAndView("dailyaverageweight-list");
		EventDto criteria = new EventDto();
		criteria.setProcessOrderCode(processOrderCode);
		criteria.setType(EventTypeEnum.WEIGHT_NOTE.val);
		criteria.setSize(appProperties.getDefaultPageSize());
    	criteria.setPage(appProperties.getDefaultPage());
    	Integer totalPigRetained = productionManager.getTotalPigRetainedByPoCode(processOrderCode); 
    	modelAndView.addObject("totalPigRetained", totalPigRetained);
    	modelAndView.addObject("page", eventManager.search(criteria));
    	modelAndView.addObject("prOrder", processOrderCode);
    	modelAndView.addObject("processOrder", processOrderManager.getByCode(processOrderCode));
        return modelAndView;
    }
    
    @PostMapping("/dailyAverageWeight/list")
    public ModelAndView searchAverageWeight(
    		@Valid EventDto criteria, BindingResult bindingResult, 
    		@RequestParam("fromDate") String fromDate,
    		@RequestParam("toDate") String toDate, 
    		@RequestParam("prOrder") String prOrder
    ){
    	log.debug("ENTERING 'SEARCH WEIGHT_NOTE' METHOD...");
		ModelAndView modelAndView = new ModelAndView(
				ModelViewEnum.VIEW_DAILY_AVERAGE_WEIGHT_LIST.mav
					.concat(SymbolEnum.QUESTION_MARK.val)
					.concat("code=")
					.concat(prOrder)
			);
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss");
		if(StringUtils.isNotBlank(fromDate)) {
			criteria.setDisplaySearchFromDate(fromDate);
		}
		if(StringUtils.isNotBlank(toDate)) {
			criteria.setDisplaySearchToDate(toDate);
		}
		
		criteria.setProcessOrderCode(prOrder);
		criteria.setType(EventTypeEnum.WEIGHT_NOTE.val);
		Integer totalPigRetained = productionManager.getTotalPigRetainedByPoCode(prOrder); 
    	modelAndView.addObject("totalPigRetained", totalPigRetained);
		modelAndView.addObject("processOrder", processOrderManager.getByCode(prOrder));
		modelAndView.addObject("page", eventManager.search(criteria));
		modelAndView.addObject("criteria", criteria);
        return modelAndView;
    }
	    
    @ModelAttribute
    @GetMapping("/dailyAverageWeight/form")
    public ModelAndView showAverageWeight(@RequestParam (value="id", required=false) Long id, @RequestParam("code") String processOrderCode, HttpServletRequest request) throws Exception {
    	log.debug("ENTERING 'SHOW WEIGHT_NOTE' METHOD...");
    	Locale locale = request.getLocale();
    	
    	ModelAndView modelAndView = new ModelAndView("dailyaverageweight-form");
    	EventDto event = new EventDto();
    	List<WeightChartDto> weightChartExistings = new ArrayList<>();
    	
    	if(id != null) {
    		event = eventManager.get(id);
    		if(event == null) {
        		addError(request, getText("data.notfound", locale));
				return new ModelAndView("redirect:/processOrder/list");
        	}
    		if(event.getContent() != null) {
    			try {
	    			ObjectMapper mapper = new ObjectMapper();
	    			String contentJson = mapper.writeValueAsString(event.getContent().get(MapKeyEnum.WEIGHT_NOTE.key));
	    			WeightNoteDto weightNoteDto = mapper.readValue(contentJson, WeightNoteDto.class);
	    			event.setWeightNote(weightNoteDto);
	    			if(!weightNoteDto.getWeightCharts().isEmpty()) {
	    				weightChartExistings = weightNoteDto.getWeightCharts();
	    			} else {
	    				weightChartExistings.add(new WeightChartDto());
	    			}
				} catch (JsonProcessingException e) {
					log.error("ERROR CONVERT JSONPROCESSINGEXCEPTION: EXCEPTION: {}", e);
				}
    		}
    	} else {
    		weightChartExistings.add(new WeightChartDto());
    		event.setTransCode(transCodeManager.getTransCode(TransCodeTypeEnum.EVENT.val));
    	}
    	event.setProcessOrderCode(processOrderCode);
    	modelAndView.addObject("processOrder", processOrderManager.getByCode(processOrderCode));
    	modelAndView.addObject("event", event);
    	modelAndView.addObject("weightChartExistings", weightChartExistings);
        return modelAndView;
    }
	    
	@PostMapping("/dailyAverageWeight/save")
    public String saveDailyAvgWeight(@Valid EventDto eventDto, BindingResult bindingResult, HttpServletRequest request, HttpServletResponse response) throws Exception {
		log.debug("ENTERING 'SAVE WEIGHT_NOTE' METHOD...");
        Locale locale = request.getLocale();
        String username = UserContext.getUsername();
        String view = "dailyaverageweight-form";
        if(eventDto.getId() != null) {
        	 view = "/dailyAverageWeight/form?id=" + eventDto.getId();
        	 eventDto.setModifiedBy(username);
        } else {
        	eventDto.setCreatedBy(username);
        }
        if (bindingResult.hasErrors()) {
        	addError(request, bindingResult.getAllErrors().toString());
            return view;
        }
       Map<String, Object> map = new HashMap<String, Object>();
       WeightNoteDto weightNoteDto = eventDto.getWeightNote();
       List<WeightChartDto> weightCharts = new ArrayList<>();
       if(!weightNoteDto.getWeightCharts().isEmpty()) {
    	   weightNoteDto.getWeightCharts().stream().forEach(item ->{
    		   if(item.getRange() != null && item.getQuantity() > 0) {
    			   weightCharts.add(item);
    		   }
    	   });
    	   weightNoteDto.setWeightCharts(weightCharts);
       }
       map.put(MapKeyEnum.WEIGHT_NOTE.key, weightNoteDto);
       eventDto.setContent(map);
       eventDto.setCode(EventCodeEnum.WEIGHT_NOTE.val);
       eventDto.setType(EventTypeEnum.WEIGHT_NOTE.val);
       eventDto.setStatus(StatusEnum.CONFIRMED.value);
       
       LocalDate postingDate = DateTimeHelper.toLocalDate(eventDto.getStage(), DatePatternEnum.DD_MM_YYYY_1.pattern);
       eventDto.setPostingDate(postingDate);
       
       EntityResponse result = eventManager.saveDailyAvgWeight(eventDto);
       if(String.valueOf(HttpStatus.OK.value()).equals(result.getCode())) {
    	   addMessage(request, getText("dailyAverageWeight.updated", locale));
       } else {
    	   addError(request, result.getMessage());
       }
       view = "redirect:/dailyAverageWeight/list?code=" + eventDto.getProcessOrderCode();
       return view;
    }
    
    //api lấy chi tiết eventDto
    @GetMapping("/dailyAverageWeight/detail/{eventId}")
    @ResponseBody
    public EventDto getDailyAverangeWeightDetail(@PathVariable(value="eventId", required=false) String eventId) {
    	Long id = Long.parseLong(eventId);
		return eventManager.get(id);
    }
    
    //api số lượng heo tồn trong production theo poCode
    @GetMapping("/production/totalPigRetained/{poCode}")
    @ResponseBody
    public int getProductionDetail(@PathVariable(value="poCode", required=false) String poCode) {
		return productionManager.getTotalPigRetainedByPoCode(poCode);
    }
    
    //api số lượng heo tồn trong production theo poCode
    @GetMapping("/production/totalPigRetained")
    @ResponseBody
    public int getProductionDetailByDate(@RequestParam(name="poCode", required=true) String poCode,
    									@RequestParam(name="stage", required=true) String stage) {
    	ProductionDto criteria = new ProductionDto();
    	criteria.setProcessOrderCode(poCode);
    	criteria.setSearchPostingDate(stage);
    	return productionManager.getTotalPigRetainedByPoCodeAndDate(criteria);
    }
    
    //------- WEIGHT NOTE ---------//
    
    
    //Nhap kho heo
    @GetMapping("/pigProduction/list")
    public ModelAndView listPigProduct(@RequestParam(name="poCode", required = true) String processOrderCode,HttpServletRequest request) throws Exception {
    	log.debug("ENTERING 'LIST FINISH_PRODUCT' METHOD...");
    	EventDto criteria = new EventDto();
    	ProcessOrderDto processOrder = processOrderManager.getByCode(processOrderCode);
    	criteria.setCode(EventCodeEnum.FINISH_PRODUCT.val);
    	criteria.setProcessOrderCode(processOrderCode);
    	criteria.setSize(appProperties.getDefaultPageSize());
    	criteria.setPage(appProperties.getDefaultPage());
		ModelAndView modelAndView = new ModelAndView("pigproduction-list");
		Integer totalPigRetained = productionManager.getTotalPigRetainedByPoCode(processOrderCode); 
    	modelAndView.addObject("totalPigRetained", totalPigRetained);
		modelAndView.addObject("processOrder",processOrder);
		modelAndView.addObject("page", eventManager.search(criteria));
		modelAndView.addObject("criteria", criteria);

        return modelAndView;
    }
	    
    @PostMapping("/pigProduction/list")
    public ModelAndView searchListPigProduct(@Valid EventDto criteria,@RequestParam(name="poCode", required = true) String processOrderCode,BindingResult bindingResult) throws Exception {
    	log.debug("ENTERING 'SEARCH FINISH_PRODUCT' METHOD...");
    	criteria.setCode(EventCodeEnum.FINISH_PRODUCT.val);
    	criteria.setProcessOrderCode(processOrderCode);
    	if(criteria.getSize() == null){
			criteria.setSize(appProperties.getDefaultPageSize());
	    	criteria.setPage(appProperties.getDefaultPage());
	    }
    	
    	ProcessOrderDto processOrder = processOrderManager.getByCode(processOrderCode);
    	
		ModelAndView modelAndView = new ModelAndView("pigproduction-list");
		Integer totalPigRetained = productionManager.getTotalPigRetainedByPoCode(processOrderCode); 
    	modelAndView.addObject("totalPigRetained", totalPigRetained);
		modelAndView.addObject("processOrder",processOrder);
		modelAndView.addObject("page", eventManager.search(criteria));
		modelAndView.addObject("criteria", criteria);
        return modelAndView;
    }
    
    @ModelAttribute
    @GetMapping("/pigProduction/form")
    public ModelAndView showForm(@RequestParam(name="poCode", required = true) String processOrderCode, @RequestParam(value="id", required=false) Long id, HttpServletRequest request) throws Exception {
    	log.debug("ENTERING 'SHOW FINISH_PRODUCT' METHOD...");
    	Locale locale = request.getLocale();
    	
    	ModelAndView modelAndView = new ModelAndView("pigproduction-form");
    	EventDto event = new EventDto();
    	event.setCode(EventCodeEnum.FINISH_PRODUCT.val);
    	if(id != null) {
    		event = eventManager.get(id);
    		if(event == null) {
        		addError(request, getText("data.notfound", locale));
				return new ModelAndView("redirect:/processOrder/list");
        	}
    	} else {
    		event.setTransCode(transCodeManager.getTransCode(TransCodeTypeEnum.EVENT.val));
    	}
    	
    	ProcessOrderDto processOrderDto = processOrderManager.getByCode(processOrderCode);
    	if(processOrderDto != null) {
    		StringBuilder paramName = new StringBuilder();
    		paramName.append(processOrderDto.getPigType()).append(SymbolEnum.DOT.val).append(EventCodeEnum.FINISH_PRODUCT.val);
    		List<String> paramNames = new ArrayList<>();
    		paramNames.add(paramName.toString());
    		SystemParameterDto systemParameterDto = new SystemParameterDto();
    		systemParameterDto.setParamNames(paramNames);
    		List<MaterialDto> materialDtos = systemParameterManager.getMaterials(systemParameterDto);
    		modelAndView.addObject("materialDtos", materialDtos);
    		modelAndView.addObject("processOrder", processOrderDto);
    	}
    	
    	List<String> reasons = new ArrayList<>();
    	Arrays.asList(PigProductionReasonEnum.values()).forEach(item -> reasons.add(item.val));
    	
    	StringBuilder reasonStr = new StringBuilder();
		for(String s : reasons) {
			reasonStr = reasonStr.append(s).append(SymbolEnum.COMMA.val);
		}
		modelAndView.addObject("reasonsStr", reasonStr);
    	
    	event.setProcessOrderCode(processOrderCode);	   
    	modelAndView.addObject("event", event);
    	List<String> pigTypes = new ArrayList<>();
    	Arrays.asList(PigTypeEnum.values()).forEach(item -> pigTypes.add(item.val));
    	modelAndView.addObject("pigTypes", pigTypes);
    	List<String> weightCharts = new ArrayList<>();
    	Arrays.asList(WeightChartEnum.values()).forEach(item -> weightCharts.add(item.val));
    	modelAndView.addObject("weightCharts", weightCharts);
    	modelAndView.addObject("reasons", reasons);
		
        return modelAndView;
    }
    
    @PostMapping("/pigProduction/save")
    public String savePigProudct(@Valid EventDto eventDto, BindingResult bindingResult, HttpServletRequest request, HttpServletResponse response) throws Exception {
    	log.debug("ENTERING 'SAVE FINISH_PRODUCT' METHOD...");
        Locale locale = request.getLocale();
        String username = UserContext.getUsername();
        String view = "pigculling-form";
        if(eventDto.getId() != null) {
        	 view = "/pigProduction/form?poCode=" + eventDto.getProcessOrderCode() +"&id=" + eventDto.getId();
        	 eventDto.setModifiedBy(username);
        } else {
        	eventDto.setCreatedBy(username);
        }
        if (bindingResult.hasErrors()) {
        	addError(request, bindingResult.getAllErrors().toString());
            return view;
        }
        try {
           Map<String, Object> map = new HashMap<String, Object>();
 	       map.put(MapKeyEnum.PIG_EVENT.key, eventDto.getPigProd());
 	       eventDto.setContent(map);
 	       eventDto.setStatus(EventStatusEnum.CONFIRMED.val);
 	       eventDto.setType(EventTypeEnum.FINISH_PRODUCT.val);
 	       EntityResponse result = eventManager.save(eventDto);
           if(eventDto.getId() != null) {
   	    	 if(result.getCode().equals(EntityResponseCodeEnum.SUCCESS_200.val)) {
   	        	  SyncResponse syncResponse = syncDataManager.sendDataToSAP();
   		    	  if (String.valueOf(HttpStatus.OK.value()).equals(syncResponse.getCode())) {
   		    		  	addMessage(request, getText("cancel.success", locale));
   		    	  } else {
   		  				addError(request, syncResponse.getMessage());
   		  		  }
   	    	 } else if(result.getCode().equals(EntityResponseCodeEnum.ERROR_400.val)){
	        	  addError(request, getText("data.lock.15.minutes", locale));
	         } else {
	        	  addError(request, result.getMessage());
	         }
   	      } else {
   	    	 if(result.getCode().equals(EntityResponseCodeEnum.SUCCESS_200.val)) {
   	    		  SyncResponse syncResponse = syncDataManager.sendDataToSAP();
	  	    	  if (String.valueOf(HttpStatus.OK.value()).equals(syncResponse.getCode())) {
	  	    		  addMessage(request, getText("pigProduction.updated", locale));
	  	    	  } else {
	  	  			  addError(request, syncResponse.getMessage());
	  	  		  }
   	    	 } else if(result.getCode().equals(EntityResponseCodeEnum.ERROR_400.val)){
	        	  addError(request, getText("data.lock.15.minutes", locale));
	         } else {
	        	  addError(request, result.getMessage());
	         }
   	      }
		} catch (Exception e) {
			log.error("===> ERROR SAVE FINISH_PRODUCT: EXCEPTION: {}", e);
			addError(request, getText("pigProduction.updated.failed", locale));
		}
        view = "redirect:/pigProduction/list?poCode=" + eventDto.getProcessOrderCode();
        return view;
    }
	    
}
