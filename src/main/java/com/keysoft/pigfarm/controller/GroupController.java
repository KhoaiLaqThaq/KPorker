package com.keysoft.pigfarm.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import com.keysoft.pigfarm.common.EntityResponseCodeEnum;
import com.keysoft.pigfarm.integration.EntityResponse;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.keysoft.pigfarm.constant.ModelViewEnum;
import com.keysoft.pigfarm.manager.GroupManager;
import com.keysoft.pigfarm.manager.RoleManager;
import com.keysoft.pigfarm.master.dto.GroupDto;
import com.keysoft.pigfarm.master.dto.RoleDto;

import lombok.extern.slf4j.Slf4j;

/**
 * Generated by Speed Generator
 * 
 * @author <a href="mailto:ngtrungkien@gmail.com">Kien Nguyen</a>
 */
@Slf4j
@Controller
public class GroupController extends BaseController {
	@Autowired
    private GroupManager groupManager;
    @Autowired
    private RoleManager roleManager;
	@GetMapping("/group/list")
    public ModelAndView list() {
    	log.debug("entering 'list' method...");
    	ModelAndView modelAndView = new ModelAndView(ModelViewEnum.VIEW_GROUP_LIST.mav);
		modelAndView.addObject("groups", groupManager.gets());
		log.info("List<GroupDto>: {}", groupManager.gets());
		return modelAndView;
    }

  
	@PostMapping("/group/list")
    public ModelAndView search(@Valid GroupDto group, BindingResult bindingResult) {
    	log.debug("entering 'search' method...");
		ModelAndView modelAndView = new ModelAndView(ModelViewEnum.VIEW_GROUP_LIST.mav);
		modelAndView.addObject("groups", groupManager.search(group));

        return modelAndView;
    }
    
   
	@GetMapping("/group/form*")
    public ModelAndView show(@RequestParam(name = "id", required = false) String id) {
    	log.debug("entering 'show' method...");
    	ModelAndView modelAndView = new ModelAndView(ModelViewEnum.VIEW_GROUP_FORM.mav);
    	GroupDto groupDto = new GroupDto();
    	List<RoleDto> roles = roleManager.gets();
    	
		if (StringUtils.isNotBlank(id)) {
			groupDto = groupManager.get(id);
			List<RoleDto> selectedRoles = groupDto.getRoles();
			roles.stream().forEach(r ->	r.setSelected(selectedRoles.stream().anyMatch(s -> s.getName().equals(r.getName()))));
		} else {
			groupDto.setEnabled(true);
		}
    	
    	modelAndView.addObject("group", groupDto);
    	modelAndView.addObject("roles", roles);
        return modelAndView;
    }

	@GetMapping("/group/form/newDesign")
	public ModelAndView showFormNewDesign(@RequestParam(name = "id", required = false) String id) {
		log.info("entering: 'show-form-new-design' method()...");
		ModelAndView mav = new ModelAndView("/system/group/group-form-new-design");
		GroupDto criteria = new GroupDto();
		mav.addObject("group", criteria)
				.addObject("roles", roleManager.gets());
		return mav;
	}

	@PostMapping("/group/form/newDesign")
	public String saveOrUpdate(@Valid GroupDto groupDto, HttpServletRequest request) {
		log.info("entering: 'saveOrUpdate' method()..., group={}", groupDto);
		EntityResponse response =  groupManager.saveOrUpdate(groupDto);
		if (response.getCode().equals(EntityResponseCodeEnum.SUCCESS_200.val)) {
			addMessage(request, getText(ModelViewEnum.VIEW_GROUP_UPDATE.mav, request.getLocale()));
		} else {
			addError(request, "Loi khong xac dinh");
		}
		return "redirect:/group/list";
	}

	@PostMapping("/group/save")
    public String save(@Valid GroupDto group, BindingResult bindingResult, HttpServletRequest request, HttpServletResponse response) {
        log.debug("process=save group {}...", group);
        String view = ModelViewEnum.VIEW_GROUP_FORM.mav;
        if (bindingResult.hasErrors()) {
        	addError(request, bindingResult.getAllErrors().toString());
            return view;
        }
        try {
        	groupManager.save(group);
            addMessage(request, getText(ModelViewEnum.VIEW_GROUP_UPDATE.mav, request.getLocale()));
		} catch (Exception e) {
			e.printStackTrace();
			addError(request, "Loi khong xac dinh");
		}
        view = "redirect:/group/list";

        return view;
    }
    
}