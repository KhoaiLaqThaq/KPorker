package com.keysoft.pigfarm.controller;

import java.math.BigDecimal;
import java.time.LocalDateTime;
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
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.CollectionUtils;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.keysoft.pigfarm.common.EntityResponseCodeEnum;
import com.keysoft.pigfarm.common.GoodsIssueMovementTypeEnum;
import com.keysoft.pigfarm.common.GoodsIssueStatusEnum;
import com.keysoft.pigfarm.common.GoodsIssueTransTypeEnum;
import com.keysoft.pigfarm.common.GoodsIssueTypeEnum;
import com.keysoft.pigfarm.common.GoodsRequisitionStatusEnum;
import com.keysoft.pigfarm.common.GoodsRequisitionTypeEnum;
import com.keysoft.pigfarm.common.TransCodeTypeEnum;
import com.keysoft.pigfarm.integration.EntityResponse;
import com.keysoft.pigfarm.manager.FarmManager;
import com.keysoft.pigfarm.manager.GoodsIssueManager;
import com.keysoft.pigfarm.manager.GoodsRequisitionManager;
import com.keysoft.pigfarm.manager.MaterialManager;
import com.keysoft.pigfarm.manager.StockManager;
import com.keysoft.pigfarm.manager.TransCodeManager;
import com.keysoft.pigfarm.production.dto.FarmDto;
import com.keysoft.pigfarm.production.dto.GoodsIssueDto;
import com.keysoft.pigfarm.production.dto.GoodsRequisitionDto;
import com.keysoft.pigfarm.production.dto.MaterialDetailDto;
import com.keysoft.pigfarm.production.dto.MaterialDto;
import com.keysoft.pigfarm.production.dto.SearchDto;
import com.keysoft.pigfarm.production.dto.StockDto;
import com.keysoft.pigfarm.util.UserContext;

import lombok.extern.slf4j.Slf4j;

/**
 * Generated by Speed Generator
 * 
 * @author <a href="mailto:ngtrungkien@gmail.com">Kien Nguyen</a>
 */
 @Slf4j
@Controller
public class GoodsIssueController extends BaseController {

	@Autowired
    private GoodsIssueManager goodsIssueManager;
	@Autowired
    private GoodsRequisitionManager goodsRequisitionManager;
	@Autowired
	private StockManager stockManager;
	@Autowired
	private MaterialManager materialManager;
	@Autowired
	private TransCodeManager transCodeManager;
	@Autowired
	private FarmManager farmManager;
	
	Map<String, SearchDto> userSearchs = new HashMap<>();

    @GetMapping("/goodsIssue/list")
    public ModelAndView list(HttpServletRequest request) throws Exception {
    	log.debug("ENTERING 'LIST GOODS_ISSUES' METHOD...");
    	
    	String userName = request.getUserPrincipal().getName();
		String url = request.getRequestURI();
		if(userSearchs.containsKey(userName)) {
			SearchDto searchDto = userSearchs.get(userName);
			String lastUrl = searchDto.getLatestUrl();
			
			if(lastUrl.equals(url) && searchDto.getSearchGI() != null) {
				return search(searchDto.getSearchGI(), request);
			}
		}
		
		ModelAndView modelAndView = new ModelAndView("goodsissue-list");
		GoodsIssueDto criteria = new GoodsIssueDto();
    	criteria.setSize(appProperties.getDefaultPageSize());
    	criteria.setPage(appProperties.getDefaultPage());
    	criteria.setType(GoodsIssueTypeEnum.GOODS_ISSUE.val);
    	List<String> giStatus = new ArrayList<String>();
    	giStatus.add(GoodsIssueStatusEnum.SYCNCHRONIZED.val);
    	giStatus.add(GoodsIssueStatusEnum.CONFIRMED.val);
    	giStatus.add(GoodsIssueStatusEnum.CANCEL.val);
    	modelAndView.addObject("giStatus", giStatus);
    	modelAndView.addObject("giTemplates", goodsIssueManager.getTemplates());
		modelAndView.addObject("page", goodsIssueManager.search(criteria));
		modelAndView.addObject("criteria", criteria);

        return modelAndView;
    }

    @PostMapping("/goodsIssue/list")
    public ModelAndView search(@Valid GoodsIssueDto criteria, HttpServletRequest request){
    	log.debug("ENTERING 'SEARCH GOODS_ISSUES' METHOD...");
		ModelAndView modelAndView = new ModelAndView("goodsissue-list");
		if(criteria != null && criteria.getSize() == null){
			criteria.setSize(appProperties.getDefaultPageSize());
	    	criteria.setPage(appProperties.getDefaultPage());
	    }
		List<String> giStatus = new ArrayList<String>();
    	giStatus.add(GoodsIssueStatusEnum.SYCNCHRONIZED.val);
    	giStatus.add(GoodsIssueStatusEnum.CONFIRMED.val);
    	giStatus.add(GoodsIssueStatusEnum.CANCEL.val);
    	modelAndView.addObject("giStatus", giStatus);
		modelAndView.addObject("page", goodsIssueManager.search(criteria));
		modelAndView.addObject("giTemplates", goodsIssueManager.getTemplates());
		modelAndView.addObject("criteria", criteria);
		
		String userName = request.getUserPrincipal().getName();
		String url = request.getRequestURI();
		if(userSearchs.containsKey(userName)) {
			SearchDto searchDto = userSearchs.get(userName);
			searchDto.setSearchGI(criteria);
			searchDto.setLatestUrl(url);
			userSearchs.put(userName, searchDto);
		} else {
			SearchDto searchDto = new SearchDto();
			searchDto.setSearchGI(criteria);
			searchDto.setLatestUrl(url);
			userSearchs.put(userName, searchDto);
		}

        return modelAndView;
    }

	@ModelAttribute
    @GetMapping("/goodsIssue/form")
    public ModelAndView show(@RequestParam (value="grId", required=false) Long grId,@RequestParam (value="id", required=false) Long id, HttpServletRequest request) throws Exception {
		log.debug("ENTERING 'SHOW GOODS_ISSUE' METHOD...");
		Locale locale = request.getLocale();
		
    	ModelAndView modelAndView = new ModelAndView("goodsissue-form");
		GoodsIssueDto goodsIssue = new GoodsIssueDto();
		String username = UserContext.getUsername();
    	List<MaterialDetailDto> materialExistings = new ArrayList<>();
    	goodsIssue.setTransCode(transCodeManager.getTransCode(TransCodeTypeEnum.GOODS_ISSUE.val));
    	List<String> transTypes = new ArrayList<>();
    	Arrays.asList(GoodsIssueMovementTypeEnum.values()).forEach(item -> transTypes.add(item.val));
    	if(id != null) {
    		goodsIssue = goodsIssueManager.get(id);
    		if(goodsIssue == null) {
        		addError(request, getText("data.notfound", locale));
				return new ModelAndView("redirect:/goodsIssue/list");
        	}
    		
    		if(goodsIssue.getType().equals(GoodsIssueTypeEnum.TEMPLATE.val)) {
    			goodsIssue.setTransCode(transCodeManager.getTransCode(TransCodeTypeEnum.GOODS_ISSUE.val));
    		}
    		if(!CollectionUtils.isEmpty(goodsIssue.getMaterialDetails())) {
    			materialExistings = goodsIssue.getMaterialDetails();
    		} else {
    			materialExistings.add(new MaterialDetailDto());
    		}
    	} else {
    		materialExistings.add(new MaterialDetailDto());
    		goodsIssue.setCreatedPerson(username);
    		goodsIssue.setTransCode(transCodeManager.getTransCode(TransCodeTypeEnum.GOODS_ISSUE.val));
    		transTypes.remove(GoodsIssueMovementTypeEnum.GI_FROM_DO.val);
    	}
    	
    	// neu goods requisition id != null => tao form xac nhan xuat kho
    	if(grId != null) {
    		List<MaterialDetailDto> materialDetailExistings = new ArrayList<>();
    		GoodsRequisitionDto goodsRequisition = goodsRequisitionManager.get(grId);
    		if(!CollectionUtils.isEmpty(goodsRequisition.getMaterialDetails())) {
    			goodsRequisition.getMaterialDetails().stream().forEach(item ->{
    				if(item.getRetained().compareTo(BigDecimal.ZERO) == 1) {
    					materialDetailExistings.add(item);
    				}
    			});
    			if(!CollectionUtils.isEmpty(materialDetailExistings)) {
    				materialExistings = materialDetailExistings;
    			} else {
    				materialExistings.add(new MaterialDetailDto());
    			}
    		} else {
    			materialExistings.add(new MaterialDetailDto());
    		}
    		
    		BeanUtils.copyProperties(goodsRequisition, goodsIssue);
    		goodsIssue.setStock(goodsRequisition.getStock());
    		goodsIssue.setTransCode(transCodeManager.getTransCode(TransCodeTypeEnum.GOODS_ISSUE.val));
    		goodsIssue.setId(null);
    		goodsIssue.setCreatedDate(LocalDateTime.now());
    		goodsIssue.setGoodsRequisitionId(grId);
    		transTypes.add(GoodsIssueMovementTypeEnum.GI_FROM_DO.val);
    	}
    	goodsIssue.setMarkDel(false);
    	List<StockDto> stocks = stockManager.gets();
    	List<FarmDto> farms = farmManager.getFarmByUserName();
		modelAndView.addObject("farms", farms);
    	modelAndView.addObject("stocks", stocks);
        modelAndView.addObject("goodsIssue", goodsIssue);
		modelAndView.addObject("materialExistings", materialExistings);
		modelAndView.addObject("transTypes", transTypes);
        return modelAndView;
    }
    
    @PostMapping("/goodsIssue/save")
    public String save(@Valid GoodsIssueDto goodsIssueDto, BindingResult bindingResult, HttpServletRequest request, HttpServletResponse response) throws Exception {
    	log.debug("ENTERING 'SAVE GOODS_ISSUE' METHOD...");
        Locale locale = request.getLocale();
        String view = "goodsissue-form";
        if(goodsIssueDto.getId() != null) {
        	 view = "/goodsIssue/form?id=" + goodsIssueDto.getId();
        }
        if (bindingResult.hasErrors()) {
        	addError(request, bindingResult.getAllErrors().toString());
            return view;
        }
        view = "redirect:/goodsIssue/list";	
        try {
            if(StringUtils.isBlank(goodsIssueDto.getTransType())) {
            	goodsIssueDto.setTransType(GoodsIssueTransTypeEnum.GI_OTHER.val);
            }
            if(StringUtils.isBlank(goodsIssueDto.getTransCode())) {
            	goodsIssueDto.setTransCode(transCodeManager.getTransCode(TransCodeTypeEnum.GOODS_ISSUE.val));
            }
            
            if(goodsIssueDto.getStatus().equals(GoodsIssueStatusEnum.CANCEL.val)) {
                EntityResponse result = goodsIssueManager.cancel(goodsIssueDto);
                if(result.getCode().equals(EntityResponseCodeEnum.SUCCESS_200.val)) {
                	addMessage(request, getText("goodsIssue.cancel.success", locale));
                } else if(result.getCode().equals(EntityResponseCodeEnum.ERROR_400.val)){
  	        	  addError(request, getText("data.lock.15.minutes", locale));
	  	        } else {
	  	        	  addError(request, result.getMessage());
	  	        }
            } else {
            	 EntityResponse result = goodsIssueManager.save(goodsIssueDto);
            	 if(result.getCode().equals(EntityResponseCodeEnum.SUCCESS_200.val)) {
                	addMessage(request, getText("goods.issue.updated.success", locale));
            	 } else if(result.getCode().equals(EntityResponseCodeEnum.ERROR_400.val)){
     	        	  addError(request, getText("data.lock.15.minutes", locale));
   	  	         } else {
   	  	        	  addError(request, result.getMessage());
   	  	         }
            }
		} catch (Exception e) {
			log.error("ERROR SAVE GOODS_ISSUE: EXCEPTION: {}", e);
			addError(request, e.getMessage());
		}

       return view;
    }
    
    @GetMapping("/goodsIssue/delete/{id}")
    public String deleteGITemplate(@PathVariable(value="id")Long id,HttpServletRequest request) {
    	log.debug("ENTERING 'DELETE GOODS_ISSUE' METHOD...");
    	Locale locale = request.getLocale();
    	String view = "redirect:/goodsIssue/list";	
    	try {
    		goodsIssueManager.delete(id);
    		addMessage(request, getText("goodsIssue.delete.success", locale));
		} catch (Exception e) {
			log.error("ERROR DELETE GOODS_ISSUE: EXCEPTION: {}", e);
			addError(request, e.getMessage());
		}
    	return view;
    }
    
    //-------------- goods issue requisition ------------//
    @GetMapping("/goodsIssue-Requisition/list")
    public ModelAndView goodsIssueReqs(HttpServletRequest request) throws Exception {
    	log.debug("ENTERING 'LIST GOODS_ISSUE_REQUISITION' METHOD...");
    	
    	String userName = request.getUserPrincipal().getName();
		String url = request.getRequestURI();
		if(userSearchs.containsKey(userName)) {
			SearchDto searchDto = userSearchs.get(userName);
			String lastUrl = searchDto.getLatestUrl();
			
			if(lastUrl.equals(url) && searchDto.getSearchGRequition() != null) {
				return searchGoodsIssueReqs(searchDto.getSearchGRequition(), request);
			}
		}
    	
    	GoodsRequisitionDto criteria = new GoodsRequisitionDto();
    	criteria.setType(GoodsRequisitionTypeEnum.GOODS_ISSUE_REQUISITION.val);
    	criteria.setSize(appProperties.getDefaultPageSize());
    	criteria.setPage(appProperties.getDefaultPage());
		ModelAndView modelAndView = new ModelAndView("goodsissue-requisition-list");
		
		List<String> grStatus = new ArrayList<String>();
    	grStatus.add(GoodsRequisitionStatusEnum.FINISHED.val);
    	grStatus.add(GoodsRequisitionStatusEnum.PROCESSING.val);
    	grStatus.add(GoodsRequisitionStatusEnum.RECEIVED.val);
		
    	modelAndView.addObject("grStatus", grStatus);
		modelAndView.addObject("page", goodsRequisitionManager.gets(criteria));
		modelAndView.addObject("criteria", criteria);
        return modelAndView;
    }
    
    @PostMapping ("/goodsIssue-Requisition/list")
    public ModelAndView searchGoodsIssueReqs(@Valid GoodsRequisitionDto criteria,HttpServletRequest request) throws Exception {
    	log.debug("ENTERING 'SEARCH GOODS_ISSUE_REQUISITION' METHOD...");
    	
    	ModelAndView modelAndView = new ModelAndView("goodsissue-requisition-list");
    	if(criteria != null && criteria.getSize() == null){
			criteria.setSize(appProperties.getDefaultPageSize());
	    	criteria.setPage(appProperties.getDefaultPage());
	    }
    	
    	List<String> grStatus = new ArrayList<String>();
    	grStatus.add(GoodsRequisitionStatusEnum.FINISHED.val);
    	grStatus.add(GoodsRequisitionStatusEnum.PROCESSING.val);
    	grStatus.add(GoodsRequisitionStatusEnum.RECEIVED.val);
		
    	modelAndView.addObject("grStatus", grStatus);
		modelAndView.addObject("page", goodsRequisitionManager.gets(criteria));
		modelAndView.addObject("criteria", criteria);

		String userName = request.getUserPrincipal().getName();
		String url = request.getRequestURI();
		if(userSearchs.containsKey(userName)) {
			SearchDto searchDto = userSearchs.get(userName);
			searchDto.setSearchGRequition(criteria);
			searchDto.setLatestUrl(url);
			userSearchs.put(userName, searchDto);
		} else {
			SearchDto searchDto = new SearchDto();
			searchDto.setSearchGRequition(criteria);
			searchDto.setLatestUrl(url);
			userSearchs.put(userName, searchDto);
		}
		
        return modelAndView;
    }
    
	@ModelAttribute
    @GetMapping("/goodsIssue-Requisition/form")
    public ModelAndView showDetail(@RequestParam (value="id", required=false) Long id, HttpServletRequest request) throws Exception {
    	log.debug("ENTERING 'SHOW GOODS_ISSUE_REQUISITION' METHOD...");
    	Locale locale = request.getLocale();
    	
    	ModelAndView modelAndView = new ModelAndView("goodsissue-requisition-form");
    	GoodsRequisitionDto goodsRequisition = new GoodsRequisitionDto();
    	List<MaterialDetailDto> materialExistings = new ArrayList<>();
    	if(id != null) {
    		goodsRequisition = goodsRequisitionManager.get(id);
    		if(goodsRequisition == null) {
        		addError(request, getText("data.notfound", locale));
				return new ModelAndView("redirect:/goodsIssue-Requisition/list");
        	}
    		
    		if(!CollectionUtils.isEmpty(goodsRequisition.getMaterialDetails())) {
    			materialExistings = goodsRequisition.getMaterialDetails();
    		}
    	} 
    	List<MaterialDto> materials = materialManager.gets();
    	List<StockDto> stocks = stockManager.gets();	
		modelAndView.addObject("stocks", stocks);
		modelAndView.addObject("materialExistings", materialExistings);
		modelAndView.addObject("materials", materials);
        modelAndView.addObject("goodsIssue", goodsRequisition);
		modelAndView.addObject("materials", materialExistings);

        return modelAndView;
    }
    
    @GetMapping("/goodsIssue-Requisition/delete/{id}")
    public String deleteGoodsRequisition(@PathVariable(value="id")Long id,HttpServletRequest request) {
    	log.debug("ENTERING 'DELETE GOODS_ISSUE_REQUISITION' METHOD...");
    	Locale locale = request.getLocale();
    	String view = "redirect:/goodsIssue-Requisition/list";	
    	try {
    		goodsRequisitionManager.delete(id);
    		addMessage(request, getText("goodsIssue.requisition.delete.success", locale));
		} catch (Exception e) {
			log.error("ERROR DELETE GOODS_ISSUE_REQUISITION: EXCEPTION: {}", e);
			addError(request, e.getMessage());
		}
    	return view;
    }
}