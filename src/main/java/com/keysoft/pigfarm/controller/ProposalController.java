package com.keysoft.pigfarm.controller;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.keysoft.pigfarm.common.DatePatternEnum;
import com.keysoft.pigfarm.common.EventStatusEnum;
import com.keysoft.pigfarm.common.MapKeyEnum;
import com.keysoft.pigfarm.common.ProposalStatusEnum;
import com.keysoft.pigfarm.common.ProposalTypeEnum;
import com.keysoft.pigfarm.common.TransCodeTypeEnum;
import com.keysoft.pigfarm.helper.DateTimeHelper;
import com.keysoft.pigfarm.integration.EntityResponse;
import com.keysoft.pigfarm.manager.FarmManager;
import com.keysoft.pigfarm.manager.PigEntryManager;
import com.keysoft.pigfarm.manager.ProcessOrderManager;
import com.keysoft.pigfarm.manager.ProductionManager;
import com.keysoft.pigfarm.manager.ProposalManager;
import com.keysoft.pigfarm.manager.TransCodeManager;
import com.keysoft.pigfarm.production.dto.ContentProposalDto;
import com.keysoft.pigfarm.production.dto.PigEntryDto;
import com.keysoft.pigfarm.production.dto.ProcessOrderDto;
import com.keysoft.pigfarm.production.dto.ProposalDto;
import com.keysoft.pigfarm.production.dto.ProposalEntryDto;
import com.keysoft.pigfarm.util.UserContext;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ProposalController extends BaseController{
	  @Autowired
	  private ProcessOrderManager processOrderManager;
	  @Autowired 
	  private ProposalManager proposalManager;
	  @Autowired
	  private ProductionManager productionManager;
	  @Autowired
	  private TransCodeManager transCodeManager;
	  @Autowired
	  private PigEntryManager pigEntryManager;
	  @Autowired
	  private FarmManager farmManager;
	  
      @GetMapping("/proposal/list")
      public ModelAndView list(@RequestParam(name="poCode", required = true) String processOrderCode,HttpServletRequest request) throws Exception {
	    	log.debug("ENTERING 'LIST PROPOSAL' METHOD...");
			ModelAndView modelAndView = new ModelAndView("proposal-list");
			ProposalDto criteria = new ProposalDto();
	    	criteria.setSize(appProperties.getDefaultPageSize());
	    	criteria.setPage(appProperties.getDefaultPage());
	    	criteria.setProcessOrderCode(processOrderCode);
	    	ProcessOrderDto processOrder = processOrderManager.getByCode(processOrderCode);
	    	Integer totalPigRetained = productionManager.getTotalPigRetainedByPoCode(processOrderCode); 
	    	modelAndView.addObject("totalPigRetained", totalPigRetained);
	    	modelAndView.addObject("processOrder", processOrder);
			modelAndView.addObject("page", proposalManager.search(criteria));
			modelAndView.addObject("criteria", criteria);
	        return modelAndView;
      }

      @PostMapping("/proposal/list")
      public ModelAndView search(@Valid ProposalDto criteria, BindingResult bindingResult){
	    	log.debug("ENTERING 'SEARCH PROPOSAL' METHOD...");
			ModelAndView modelAndView = new ModelAndView("proposal-list");
			if(criteria != null && criteria.getSize() == null){
				criteria.setSize(appProperties.getDefaultPageSize());
		    	criteria.setPage(appProperties.getDefaultPage());
		    }
			ProcessOrderDto processOrder = processOrderManager.getByCode(criteria.getProcessOrderCode());
			Integer totalPigRetained = productionManager.getTotalPigRetainedByPoCode(criteria.getProcessOrderCode()); 
	    	modelAndView.addObject("totalPigRetained", totalPigRetained);
	    	modelAndView.addObject("processOrder", processOrder);
			modelAndView.addObject("page", proposalManager.search(criteria));
			modelAndView.addObject("criteria", criteria);
	
	        return modelAndView;
      }
      
      @ModelAttribute
      @GetMapping("/proposal/form")
      public ModelAndView show(@RequestParam (value="id", required=false) Long id, @RequestParam("poCode") String processOrderCode, HttpServletRequest request) throws Exception {
	    	log.debug("ENTERING 'SHOW PROPOSAL' METHOD...");
	    	Locale locale = request.getLocale();
	    	
	      	ModelAndView modelAndView = new ModelAndView("proposal-form");
	      	ProposalDto proposal = new ProposalDto();
	      	List<ContentProposalDto> contentProposalExistings = new ArrayList<>();
	      	ProcessOrderDto processOrder = processOrderManager.getByCode(processOrderCode);
	      	
	      	if(id != null) {
	      		proposal = proposalManager.get(id);
	      		if(proposal == null) {
	        		addError(request, getText("data.notfound", locale));
	        		return new ModelAndView("redirect:/processOrder/list");
	        	}
	      		
	      		if(proposal.getContent() != null) {
	      			try {
	  	    			ObjectMapper mapper = new ObjectMapper();
	  	    			String contentJson = mapper.writeValueAsString(proposal.getContent().get(MapKeyEnum.WEIGHT_CHART.key));
	  	    			contentProposalExistings = mapper.readValue(contentJson, new TypeReference<List<ContentProposalDto>>() {});
	  				} catch (JsonProcessingException e) {
	  					log.error("ERROR JSONPROCESSEXCEPTION: EXCEPTION: {}", e);
	  				}
	      		}
	      	} else {
	      		contentProposalExistings.add(new ContentProposalDto());
	      		proposal.setTransCode(transCodeManager.getTransCode(TransCodeTypeEnum.PROPOSAL.val));
	      		proposal.setProcessOrderCode(processOrderCode);
	      		proposal.setPigType(processOrder.getPigType());
	      		proposal.setStatus(ProposalStatusEnum.UNCONFIRMED.val);

				ProposalEntryDto proposalEntry = proposalManager.calculateEntryProposal(processOrderCode);
	    		proposal.setEntryQuantity(proposalEntry.getEntryQuantity());
	    		proposal.setAvgEntryWeight(proposalEntry.getAvgEntryWeight());
	    		proposal.setPigRetained(productionManager.getTotalPigRetainedByPoCode(processOrderCode));
	    		
	    		proposal.setTotalProposal(0);
	    		proposal.setAvgProposalWeight(BigDecimal.ZERO);
	    		proposal.setRecordDate(LocalDate.now());
	    		
	      	}
	      	List<String> types = new ArrayList<String>();
	    	Arrays.asList(ProposalTypeEnum.values()).forEach(item -> types.add(item.val));
	    	modelAndView.addObject("types", types);
	    	modelAndView.addObject("processOrder", processOrder);
	    	modelAndView.addObject("farm", processOrder.getBarn().getFarm());
	      	modelAndView.addObject("proposal", proposal);
	      	modelAndView.addObject("contentProposalExistings", contentProposalExistings);
            return modelAndView;
      }
  	    
  	@PostMapping("/proposal/save")
    public String saveDailyAvgWeight(@Valid ProposalDto proposalDto, BindingResult bindingResult, HttpServletRequest request, HttpServletResponse response) throws Exception {
  		log.debug("ENTERING 'SAVE PROPOSAL' METHOD...");
          Locale locale = request.getLocale();
          String username = UserContext.getUsername();
          String view = "redirect:/proposal/list?poCode=" + proposalDto.getProcessOrderCode();
          if(proposalDto.getId() != null) {
          	  proposalDto.setModifiedBy(username);
          } else {
        	  proposalDto.setCreatedBy(username);
          }
          if (bindingResult.hasErrors()) {
          	addError(request, bindingResult.getAllErrors().toString());
              return view;
          }
          
         EntityResponse result = proposalManager.save(proposalDto);
         if(String.valueOf(HttpStatus.OK.value()).equals(result.getCode())) {
        	 addMessage(request, getText("proposal.updated.success", locale));
         } else {
         	addError(request, result.getMessage());
         }
         
         return view;
    }
  	
  	@PostMapping("/proposal/confirm")
  	public String confirm(@Valid ProposalDto proposalDto, HttpServletRequest request) {
  		Locale locale = request.getLocale();
        String username = UserContext.getUsername();
        String view = "redirect:/proposal/list?poCode=" + proposalDto.getProcessOrderCode();
        proposalDto.setModifiedBy(username);
        proposalDto.setStatus(ProposalStatusEnum.APPROVE.val);
        
       EntityResponse result = proposalManager.save(proposalDto);
       if(String.valueOf(HttpStatus.OK.value()).equals(result.getCode())) {
      	 addMessage(request, getText("proposal.updated.success", locale));
       } else {
       	addError(request, result.getMessage());
       }
       
       return view;
  	}
  	
  	@PostMapping("/proposal/cancel")
  	public String cancel(@Valid ProposalDto proposalDto, HttpServletRequest request) {
  		Locale locale = request.getLocale();
  		String username = UserContext.getUsername();
  		String view = "redirect:/proposal/list?poCode=" + proposalDto.getProcessOrderCode();
  		proposalDto.setModifiedBy(username);
  		proposalDto.setStatus(ProposalStatusEnum.CANCEL.val);
        
  		EntityResponse result = proposalManager.save(proposalDto);
  		if(String.valueOf(HttpStatus.OK.value()).equals(result.getCode())) {
  			addMessage(request, getText("proposal.updated.success", locale));
  		} else {
  			addError(request, result.getMessage());
  		}
       
  		return view;
  	}
  	
  	@GetMapping("/proposal/confirm/list")
    public ModelAndView listConfirm(HttpServletRequest request) throws Exception {
    	log.debug("ENTERING 'LIST PROPOSAL' METHOD...");
		ModelAndView modelAndView = new ModelAndView("proposal-all-list");
		ProposalDto criteria = new ProposalDto();
		String username = UserContext.getUsername();
		criteria.setUsername(username);
		
    	criteria.setSize(appProperties.getDefaultPageSize());
    	criteria.setPage(appProperties.getDefaultPage());
		modelAndView.addObject("page", proposalManager.search(criteria));
		modelAndView.addObject("criteria", criteria);
		modelAndView.addObject("farmCodes", farmManager.getAllFarmByUser());
        return modelAndView;
    }

    @PostMapping("/proposal/confirm/list")
    public ModelAndView searchConfirm(@Valid ProposalDto criteria, BindingResult bindingResult){
    	log.debug("ENTERING 'SEARCH PROPOSAL' METHOD...");
		ModelAndView modelAndView = new ModelAndView("proposal-all-list");
		if(criteria != null && criteria.getSize() == null){
			criteria.setSize(appProperties.getDefaultPageSize());
	    	criteria.setPage(appProperties.getDefaultPage());
	    }
		modelAndView.addObject("page", proposalManager.search(criteria));
		modelAndView.addObject("criteria", criteria);
		modelAndView.addObject("farmCodes", farmManager.getAllFarmByUser());

        return modelAndView;
    }
}
