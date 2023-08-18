package com.keysoft.pigfarm.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.keysoft.pigfarm.manager.SupportRequireManager;
import com.keysoft.pigfarm.production.dto.SDPItemDto;
import com.keysoft.pigfarm.production.dto.SupportRequireDto;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class SupportRequireController extends BaseController {
	@Autowired
	private SupportRequireManager supportRequireManager;
	
	private final String CATEGORY = "PorkerFloor";

	@GetMapping("/help/form")
	public ModelAndView helpRequireForm(@RequestParam(value="id", required=false) Long id, HttpServletRequest request) throws Exception {
		log.debug("entering 'list' help require form method...");
		SupportRequireDto criteria = new SupportRequireDto();
		ModelAndView modelAndView = new ModelAndView("support-require-form");
		if(id != null) {
			SupportRequireDto form = supportRequireManager.get(id);
			modelAndView.addObject("criteria", form);
			return modelAndView;
		}
		
		List<String> requireType = new ArrayList<>();
		requireType.add("Lỗi Chương Trình");
		requireType.add("Lỗi Người Dùng");
		requireType.add("Hỗ Trợ");
		
		criteria.setCategory(CATEGORY);
		
		modelAndView.addObject("criteria", criteria);
		modelAndView.addObject("requireType", requireType);

		return modelAndView;
	}
	
	@PostMapping("/help/save")
	public String helpRequireSave(SupportRequireDto criteria, HttpServletRequest request) throws Exception {
		log.debug("entering 'list' help require form method...");
		ModelAndView modelAndView = new ModelAndView("support-require-form");
		
		List<String> requireType = new ArrayList<>();
		requireType.add("Lỗi Chương Trình");
		requireType.add("Lỗi Người Dùng");
		requireType.add("Hỗ Trợ");
		
		criteria.setCategory(CATEGORY);
		
		modelAndView.addObject("criteria", criteria);
		modelAndView.addObject("requireType", requireType);

		String response = supportRequireManager.save(criteria);
		addMessage(request, response);

		return "redirect:/help/list";
	}
	
	@GetMapping("/sdpitems")
	public ResponseEntity<?> getSdpItems(@RequestParam(value = "category", required = true) String category, @RequestParam(value = "subcategory", required = false) String subCategory) {
		log.info("---------process=get-sdp items method...");
		SDPItemDto criteria = new SDPItemDto();
		criteria.setCategory(category);
		criteria.setSubCategory(subCategory);
		return ResponseEntity.ok(supportRequireManager.getsSDPItem(criteria));
	}
	
	@GetMapping("/help/list")
	public ModelAndView supportRequireList(HttpServletRequest request) throws Exception {
		log.debug("entering 'list' support require method...");
		SupportRequireDto criteria = new SupportRequireDto();
		criteria.setSize(appProperties.getDefaultPageSize());
		criteria.setPage(appProperties.getDefaultPage());
		ModelAndView modelAndView = new ModelAndView("support-require");

		modelAndView.addObject("page", supportRequireManager.search(criteria));

		return modelAndView;
	}
	
	@PostMapping("/help/list")
	public ModelAndView searchSupportRequireList(@Valid SupportRequireDto criteria) {
		log.debug("entering 'search' support require method..., criteria = {}", criteria);
		if (criteria != null && criteria.getSize() == null) {
			criteria.setSize(appProperties.getDefaultPageSize());
			criteria.setPage(appProperties.getDefaultPage());
		}
		ModelAndView modelAndView = new ModelAndView("support-require");
		modelAndView.addObject("page", supportRequireManager.search(criteria));
		return modelAndView;
	}
}
