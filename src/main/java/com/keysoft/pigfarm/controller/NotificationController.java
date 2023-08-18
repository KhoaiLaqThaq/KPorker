package com.keysoft.pigfarm.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.keysoft.pigfarm.common.EventTypeEnum;
import com.keysoft.pigfarm.common.NotificationTypeEnum;
import com.keysoft.pigfarm.manager.NotificationManager;
import com.keysoft.pigfarm.production.dto.NotificationDto;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class NotificationController {

	@Autowired
	private NotificationManager notificationManager;
	
	@GetMapping("/notification")
	public ModelAndView getNotification(@RequestParam(value="id", required=true) Long id, HttpServletRequest request) {
		log.debug("get notification");
		NotificationDto noti = notificationManager.get(id);
		
		if(NotificationTypeEnum.PROCESS_ORDER_EVALUTE.type.equals(noti.getType())) {
			return new ModelAndView("redirect:/processOrder/form/byCode?code="+noti.getEventId());
    		
		} else if(NotificationTypeEnum.WEIGHT_NOTE.type.equals(noti.getType())) {
			return new ModelAndView("redirect:/dailyAverageWeight/list?code="+noti.getEventId());
		} else if(NotificationTypeEnum.PROCESS_ORDER_CLOSE.type.equals(noti.getType())) {
			return new ModelAndView("redirect:/processOrder/form/byCode?code="+noti.getEventId());
		}
		return null;
	}
}
