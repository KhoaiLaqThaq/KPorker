package com.keysoft.pigfarm.controller;

import java.util.ArrayList;
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

import com.keysoft.pigfarm.common.GoodsIssueTypeEnum;
import com.keysoft.pigfarm.common.MapKeyEnum;
import com.keysoft.pigfarm.common.PageDto;
import com.keysoft.pigfarm.common.StatusEnum;
import com.keysoft.pigfarm.common.TransCodeTypeEnum;
import com.keysoft.pigfarm.constant.ModelViewEnum;
import com.keysoft.pigfarm.helper.DateTimeHelper;
import com.keysoft.pigfarm.integration.EntityResponse;
import com.keysoft.pigfarm.manager.GoodsIssueManager;
import com.keysoft.pigfarm.manager.ProcessOrderManager;
import com.keysoft.pigfarm.manager.ProductionManager;
import com.keysoft.pigfarm.manager.QuotaManager;
import com.keysoft.pigfarm.manager.TransCodeManager;
import com.keysoft.pigfarm.production.dto.GoodsIssueDto;
import com.keysoft.pigfarm.production.dto.MaterialDto;
import com.keysoft.pigfarm.production.dto.ProcessOrderDto;
import com.keysoft.pigfarm.production.dto.QuotaDto;
import com.keysoft.pigfarm.production.dto.StockDto;
import com.keysoft.pigfarm.util.UserContext;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class GoodsAttritionController extends BaseController {
	@Autowired
	private GoodsIssueManager goodsIssueManager;
	@Autowired
	private ProcessOrderManager processOrderManager;
	@Autowired
	private QuotaManager quotaManager;
	@Autowired
	private TransCodeManager transCodeManager;
	@Autowired
	private ProductionManager productionManager;
	
	@GetMapping("/goodsAttrition/list")
	public ModelAndView list(@RequestParam(name="poCode", required = true) String processOrderCode, HttpServletRequest request) throws Exception {
		log.debug("process='list' method...");
		ModelAndView modelAndView = new ModelAndView("event-list");
		GoodsIssueDto criteria = new GoodsIssueDto();
		criteria.setType(GoodsIssueTypeEnum.GOODS_ATTRITION.val);
		criteria.setProcessOrderCode(processOrderCode);
		criteria.setSize(appProperties.getDefaultPageSize());
		criteria.setPage(appProperties.getDefaultPage());
		HashMap<String, String> goodsAttritionStatus = new HashMap<>();
		goodsAttritionStatus.put(StatusEnum.CONFIRMED.name(),StatusEnum.CONFIRMED.value);
		goodsAttritionStatus.put(StatusEnum.UNCONFIRMED.name(),StatusEnum.UNCONFIRMED.value);
		
		PageDto page = goodsIssueManager.search(criteria);
		ProcessOrderDto processOrder = processOrderManager.getByCode(processOrderCode);
		Integer totalPigRetained = productionManager.getTotalPigRetainedByPoCode(processOrderCode); 
    	modelAndView.addObject("totalPigRetained", totalPigRetained);
		modelAndView.addObject("status", goodsAttritionStatus);
		modelAndView.addObject("processOrder", processOrder);
		modelAndView.addObject("criteria", criteria);
		modelAndView.addObject(ModelViewEnum.MODEL_PAGE.mav, page);
		
		return modelAndView;
	}
	
	@PostMapping("/goodsAttrition/list")
    public ModelAndView search(@RequestParam(name="poCode", required = true) String processOrderCode,@Valid GoodsIssueDto criteria, BindingResult bindingResult){
    	log.debug("entering 'search' method...");
    	criteria.setPoCode(null);
		ModelAndView modelAndView = new ModelAndView("event-list");
		
		criteria.setPostingDateSearchPeriod(DateTimeHelper.getDatePeriodFromString(criteria.getPostingDateSearch()));
		criteria.setType(GoodsIssueTypeEnum.GOODS_ATTRITION.val);
		HashMap<String, String> goodsAttritionStatus = new HashMap<>();
		goodsAttritionStatus.put(StatusEnum.CONFIRMED.name(),StatusEnum.CONFIRMED.value);
		goodsAttritionStatus.put(StatusEnum.UNCONFIRMED.name(),StatusEnum.UNCONFIRMED.value);
		
		ProcessOrderDto processOrder = processOrderManager.getByCode(criteria.getProcessOrderCode());
		Integer totalPigRetained = productionManager.getTotalPigRetainedByPoCode(processOrderCode); 
    	modelAndView.addObject("totalPigRetained", totalPigRetained);
		modelAndView.addObject("status", goodsAttritionStatus);
		modelAndView.addObject("processOrder", processOrder);
		modelAndView.addObject("page", goodsIssueManager.search(criteria));
		modelAndView.addObject("criteria", criteria);
        return modelAndView;
    }
	
	@SuppressWarnings("unchecked")
	@GetMapping("/goodsAttrition/form")
	public ModelAndView show(@RequestParam(name="poCode", required = true) String processOrderCode, HttpServletRequest request, @RequestParam(value="id", required=false) Long id) throws Exception {
		log.debug("entering 'show' method...");
		Locale locale = request.getLocale();
		
		ModelAndView modelAndView = new ModelAndView("event-form");
		GoodsIssueDto goodsIssue = new GoodsIssueDto();
		String username = UserContext.getUsername();
		List<MaterialDto> materialExistings = new ArrayList<>();
		StockDto stock = new StockDto();
		ProcessOrderDto processOrder = processOrderManager.getProcessOrderAndQuota(processOrderCode);
		if (id != null) {
			goodsIssue = goodsIssueManager.get(id);
			if(goodsIssue == null) {
	    		addError(request, getText("data.notfound", locale));
				return new ModelAndView("redirect:/processOrder/list");
	    	}
			
			if(goodsIssue.getContent() != null) {
    			materialExistings = (List<MaterialDto>) goodsIssue.getContent().get(MapKeyEnum.MATERIALS.key);
    		} else {
    			materialExistings.add(new MaterialDto());
    		}
			stock = goodsIssue.getStock();
		} else {
			if(processOrder.getMaterials() != null && !processOrder.getMaterials().isEmpty()) {
    			materialExistings = processOrder.getMaterials();
    		} else {
    			materialExistings.add(new MaterialDto());
    		}
			goodsIssue.setTransCode(transCodeManager.getTransCode(TransCodeTypeEnum.GOODS_ATTRITION.val));
			goodsIssue.setProcessOrderCode(processOrder.getCode());
			goodsIssue.setType(GoodsIssueTypeEnum.GOODS_ATTRITION.val);
			goodsIssue.setUsername(username);
			goodsIssue.setProduction(processOrder.getProduction());
			stock.setCode(processOrder.getBarn().getFarm().getCode());
			stock.setName(processOrder.getBarn().getFarm().getName());
			
		}
		modelAndView.addObject("processOrder", processOrder);
		modelAndView.addObject("stock", stock);
		modelAndView.addObject("materialExistings", materialExistings);
		modelAndView.addObject("goodsIssue", goodsIssue);
		return modelAndView;
	}
	
	@PostMapping("/goodsAttrition/save")
	public String save(@ModelAttribute("goodsIssue") GoodsIssueDto goodsIssue, BindingResult bindingResult, HttpServletRequest req, HttpServletResponse res) throws Exception {
		log.info("process='save' method, {}", goodsIssue);	
		Locale locale = req.getLocale();
		String view = "redirect:/goodsAttrition/list?poCode="+ goodsIssue.getProcessOrderCode();
		if (bindingResult.hasErrors()) {
			addError(req, bindingResult.getAllErrors().toString());
			return view;
		}
		Map<String, Object> map = new HashMap<String, Object>();
		List<MaterialDto> materials = new ArrayList<MaterialDto>();
		goodsIssue.getMaterials().stream().forEach(item -> {
			if(item != null && StringUtils.isNotBlank(item.getCode()) && item.getActuallyExported() != null) {
      		   materials.add(item);
      	   }
		});
		if(materials.isEmpty()) {
			addError(req, getText("goodsIssue.attriton.failed", locale));
			return view;
		}
		map.put(MapKeyEnum.MATERIALS.key, materials);
		// set lại material loại bỏ các phần tử bị null
		goodsIssue.setMaterials(materials);
		goodsIssue.setContent(map);
		goodsIssue.setStatus(StatusEnum.CONFIRMED.value);
		EntityResponse result = goodsIssueManager.save(goodsIssue);
        if(String.valueOf(HttpStatus.OK.value()).equals(result.getCode())) {
        	addMessage(req, getText("goods.issue.updated.success", locale));
        } else {
        	addError(req, result.getMessage());
        }
		return view;
	}

	@PostMapping("/quota/processOrderCode/{code}")
    @ResponseBody
    public List<QuotaDto> searchBypoCodeAndLatest(@PathVariable(required = true) String code) {
    	log.info("process=search-by-poCode-latest...");
    	return quotaManager.getByProcessOrderCodeAndLatest(code);
    }
	
}
