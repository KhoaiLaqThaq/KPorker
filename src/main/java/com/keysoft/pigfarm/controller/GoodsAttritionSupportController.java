package com.keysoft.pigfarm.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.keysoft.pigfarm.common.DatePatternEnum;
import com.keysoft.pigfarm.common.EntityResponseCodeEnum;
import com.keysoft.pigfarm.common.GoodsAttritionSupportActionEnum;
import com.keysoft.pigfarm.common.GoodsIssueStatusEnum;
import com.keysoft.pigfarm.common.GoodsIssueTypeEnum;
import com.keysoft.pigfarm.common.MaterialTypeEnum;
import com.keysoft.pigfarm.common.StatusEnum;
import com.keysoft.pigfarm.common.TransCodeTypeEnum;
import com.keysoft.pigfarm.helper.DateTimeHelper;
import com.keysoft.pigfarm.integration.EntityResponse;
import com.keysoft.pigfarm.manager.FarmManager;
import com.keysoft.pigfarm.manager.GoodsAttritionSupportManager;
import com.keysoft.pigfarm.manager.GoodsIssueManager;
import com.keysoft.pigfarm.manager.ProcessOrderManager;
import com.keysoft.pigfarm.manager.SyncDataManager;
import com.keysoft.pigfarm.manager.TransCodeManager;
import com.keysoft.pigfarm.production.dto.FarmDto;
import com.keysoft.pigfarm.production.dto.GoodsAttritionSupportDto;
import com.keysoft.pigfarm.production.dto.GoodsIssueDto;
import com.keysoft.pigfarm.production.dto.MaterialDetailDto;
import com.keysoft.pigfarm.production.dto.ProcessOrderDto;
import com.keysoft.pigfarm.production.dto.SearchDto;
import com.keysoft.pigfarm.production.json.SyncResponse;
import com.keysoft.pigfarm.util.UserContext;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class GoodsAttritionSupportController extends BaseController {

	@Autowired
	private GoodsAttritionSupportManager goodsAttritionSupportManager;
	@Autowired
	private TransCodeManager transCodeManager;
	@Autowired
	private ProcessOrderManager processOrderManager;
	@Autowired
	private GoodsIssueManager goodsIssueManager;
	@Autowired
	private FarmManager farmManager;
	@Autowired
	private SyncDataManager syncDataManager;
	
	Map<String, SearchDto> userSearchs = new HashMap<>();
	Map<String, GoodsIssueDto> userInputData = new HashMap<>();
	
	@GetMapping("/goodsAttritionSupport/list")
    public ModelAndView list(HttpServletRequest request) throws Exception {
    	log.debug("ENTERING 'LIST GOODS_ATTRITION_SUPPORT' METHOD...");
    	String userName = request.getUserPrincipal().getName();
		String url = request.getRequestURI();
		if(userSearchs.containsKey(userName)) {
			SearchDto searchDto = userSearchs.get(userName);
			String lastUrl = searchDto.getLatestUrl();
			
			if(lastUrl.equals(url) && searchDto.getSearchGoodsAttrition() != null) {
				return search(searchDto.getSearchGoodsAttrition(), request);
			}
		}
		ModelAndView modelAndView = new ModelAndView("goods-attrition-support-list");
		GoodsAttritionSupportDto criteria = new GoodsAttritionSupportDto();
    	criteria.setSize(appProperties.getDefaultPageSize());
    	criteria.setPage(appProperties.getDefaultPage());
		modelAndView.addObject("page", goodsAttritionSupportManager.search(criteria));
		modelAndView.addObject("criteria", criteria);
        return modelAndView;
    }

    @PostMapping("/goodsAttritionSupport/list")
    public ModelAndView search(@Valid GoodsAttritionSupportDto criteria,  HttpServletRequest request){
    	log.debug("ENTERING 'SEARCH GOODS_ATTRITION_SUPPORT' METHOD...");
		ModelAndView modelAndView = new ModelAndView("goods-attrition-support-list");
		if(criteria != null && criteria.getSize() == null){
			criteria.setSize(appProperties.getDefaultPageSize());
	    	criteria.setPage(appProperties.getDefaultPage());
	    }
		modelAndView.addObject("page", goodsAttritionSupportManager.search(criteria));
		modelAndView.addObject("criteria", criteria);

		String userName = request.getUserPrincipal().getName();
		String url = request.getRequestURI();
		if(userSearchs.containsKey(userName)) {
			SearchDto searchDto = userSearchs.get(userName);
			searchDto.setSearchGoodsAttrition(criteria);
			searchDto.setLatestUrl(url);
			userSearchs.put(userName, searchDto);
		} else {
			SearchDto searchDto = new SearchDto();
			searchDto.setSearchGoodsAttrition(criteria);
			searchDto.setLatestUrl(url);
			userSearchs.put(userName, searchDto);
		}
		
        return modelAndView;
    }
	
    @ModelAttribute
    @GetMapping("/goodsAttritionSupport/form")
    public ModelAndView show(@RequestParam(value="postingDate",required=false)String postingDate,
							 @RequestParam(value="action",required=false) String action,
							 @RequestParam(value="stockCode",required=false)String stockCode,
							 HttpServletRequest request) throws Exception {
    	log.debug("ENTERING 'SHOW GOODS_ATTRITION_SUPPORT' METHOD...");
    	Locale locale = request.getLocale();
    	
    	ModelAndView modelAndView = new ModelAndView("goods-attrition-support-form");
		GoodsIssueDto goodsIssue = new GoodsIssueDto();
		goodsIssue.setTransCode(transCodeManager.getTransCode(TransCodeTypeEnum.GOODS_ATTRITION.val));
		String username = UserContext.getUsername();
		
		GoodsIssueDto dto = null;
		if(userInputData.containsKey(username)) {
			dto = userInputData.get(username);
		}
		List<MaterialDetailDto> materialExistings;
		if(dto != null) {
			materialExistings = dto.getMaterialDetails();
			if(StringUtils.isBlank(materialExistings.get(0).getCode())) {
				materialExistings.remove(0);
			}
			modelAndView.addObject("processOrderSelected", dto.getProcessOrderCode());
			userInputData.remove(username);
		} else {
			materialExistings = new ArrayList<>();
	    	MaterialDetailDto materialDetailDto = new MaterialDetailDto();
	    	materialDetailDto.setType(MaterialTypeEnum.USED.val);
	    	materialExistings.add(materialDetailDto);
		}
    	
		goodsIssue.setCreatedBy(username);
		if(StringUtils.isNotBlank(postingDate)) {
			goodsIssue.setPostingDate(DateTimeHelper.toLocalDate(postingDate, DatePatternEnum.DD_MM_YYYY_2.pattern));
		} 
		if(StringUtils.isNotBlank(action)) {
			goodsIssue.setAction(action);
		} else {
			goodsIssue.setAction(GoodsAttritionSupportActionEnum.NEW.val);
		}
		goodsIssue.setType(GoodsIssueTypeEnum.GOODS_ATTRITION_SUPPORT.val);
		goodsIssue.setStatus(GoodsIssueStatusEnum.CONFIRMED.val);
		
		if(StringUtils.isNotBlank(stockCode) && StringUtils.isNotBlank(postingDate)) {
			ProcessOrderDto processOrderDto = new ProcessOrderDto();
			processOrderDto.setStockCode(stockCode);
			processOrderDto.setPostingDate(DateTimeHelper.toLocalDate(postingDate, DatePatternEnum.DD_MM_YYYY_2.pattern));
			List<ProcessOrderDto> listPo = processOrderManager.gets(processOrderDto);
			if(listPo == null) {
				addError(request, getText("data.notfound", locale));
				return new ModelAndView("redirect:/goodsAttritionSupport/list");
			}
			modelAndView.addObject("processOrders", listPo);
			modelAndView.addObject("farm", farmManager.getByFarmCode(stockCode));
			modelAndView.addObject("stockCode", stockCode);
		} else {
			modelAndView.addObject("processOrders", processOrderManager.gets());
		}
		modelAndView.addObject("goodsIssue", goodsIssue);
		modelAndView.addObject("materialExistings", materialExistings);
        return modelAndView;
    }
    
    @PostMapping("/goodsAttritionSupport/save")
    public String save(GoodsIssueDto goodsIssueDto, BindingResult bindingResult, HttpServletRequest request, HttpServletResponse response) throws Exception {
    	log.debug("ENTERING 'SAVE GOODS_ATTRITION_SUPPORT' METHOD...");
        Locale locale = request.getLocale();
        String postingDate = DateTimeHelper.toDateString(goodsIssueDto.getPostingDate(), DatePatternEnum.DD_MM_YYYY_2.pattern);
        String view = "redirect:/goodsAttritionSupport/form?postingDate=" + postingDate + "&action=" + goodsIssueDto.getAction() + "&stockCode=" + goodsIssueDto.getStock().getCode();
        if (bindingResult.hasErrors()) {
        	addError(request, bindingResult.getAllErrors().toString());
            return view;
        }
        try {
        	if(goodsIssueDto.getAction().equals(GoodsAttritionSupportActionEnum.COPY.val)) {
        		EntityResponse result = goodsIssueManager.copyGoodsAttritionSupport(goodsIssueDto);
        		if(result.getCode().equals(EntityResponseCodeEnum.SUCCESS_200.val)) {
        			addMessage(request, getText("goods.attriton.support.copy.success", locale));
        		} else if(result.getCode().equals(EntityResponseCodeEnum.ERROR_400.val)){
 	        	     addError(request, getText("data.lock.15.minutes", locale));
	  	        } else {
	  	        	  addError(request, result.getMessage());
	  	        }
        		view = "redirect:/goodsAttritionSupport/list";
        	} else {
                goodsIssueDto.setStatus(StatusEnum.CONFIRMED.value);
                EntityResponse result = goodsIssueManager.saveGoodsAttritionSupport(goodsIssueDto);
                if(result.getCode().equals(EntityResponseCodeEnum.SUCCESS_200.val)) {
        			addMessage(request, getText("goodsIssue.attriton.updated", locale));
        		} else if(result.getCode().equals(EntityResponseCodeEnum.ERROR_400.val)){
 	        	    addError(request, getText("data.lock.15.minutes", locale));
	  	        } else {
	  	        	addError(request, result.getMessage());
	  	        	goodsIssueDto.setPostingDateSearch(postingDate);
	  	        	userInputData.put(request.getUserPrincipal().getName(), goodsIssueDto);
	  	        }
        	}
		} catch (Exception e) {
			log.error("===> ERROR SAVE GOODS_ATTRITION_SUPPORT: EXCEPTION: {}" , e);
			addError(request, e.getMessage());
		}
       return view;
    }
    
    @GetMapping("/all/sync-goods-attrition-to-sap")
    public String syncGoodsAttritionDataToSAP(HttpServletRequest request) throws Exception {
    	log.debug("ENTERING 'SYNC DATA GOODS_ATTRITION_SUPPORT TO SAP' METHOD...");
    	Locale locale = request.getLocale();
    	try {
    		SyncResponse syncResponse = syncDataManager.syncGoodsAtritionDataToSAP();
    		if (String.valueOf(HttpStatus.OK.value()).equals(syncResponse.getCode())) {
    			addMessage(request, getText("sync.data.success", locale));
			} else {
				addError(request, syncResponse.getMessage());
			}
		} catch (Exception e) {
			log.error("===> ERROR SYNC DATA GOODS_ATTRITION_SUPPORT TO SAP: EXCEPTION: {}" , e);
			addError(request, e.getMessage());
		}
    	return "redirect:/goodsAttritionSupport/list";
    }

	@ModelAttribute
	@GetMapping("/goodsAttritionSupport/Export/form")
	public ModelAndView show() throws Exception {
		log.debug("ENTERING 'SHOW FORM EXPORT GOODS_ATTRITION_SUPPORT' METHOD...");

		ModelAndView modelAndView = new ModelAndView("goods-attrition-support-export-form");
		GoodsIssueDto goodsIssue = new GoodsIssueDto();
		String username = UserContext.getUsername();
		goodsIssue.setCreatedBy(username);
		goodsIssue.setType(GoodsIssueTypeEnum.GOODS_ATTRITION_SUPPORT.val);
		goodsIssue.setStatus(GoodsIssueStatusEnum.CONFIRMED.val);
		List<FarmDto> farms = farmManager.getFarmByUserName();
		modelAndView.addObject("farms", farms);
		modelAndView.addObject("goodsIssue", goodsIssue);
		return modelAndView;
	}
    
}
