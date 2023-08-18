//package com.keysoft.pigfarm.filter;
//
//import java.io.IOException;
//import java.security.Principal;
//import java.util.ArrayList;
//import java.util.Arrays;
//import java.util.List;
//
//import javax.servlet.Filter;
//import javax.servlet.FilterChain;
//import javax.servlet.ServletException;
//import javax.servlet.ServletRequest;
//import javax.servlet.ServletResponse;
//import javax.servlet.http.HttpServletRequest;
//
//import com.keysoft.pigfarm.common.EventTypeEnum;
//import lombok.extern.slf4j.Slf4j;
//import org.apache.commons.lang3.StringUtils;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Component;
//
//import com.keysoft.pigfarm.common.PageDto;
//import com.keysoft.pigfarm.helper.DateTimeHelper;
//import com.keysoft.pigfarm.manager.NotificationManager;
//import com.keysoft.pigfarm.production.dto.NotificationDto;
//
//@Slf4j
//@Component
//public class NotifyFilter implements Filter{
//	@Autowired
//	private NotificationManager notifyManager;
//
//	@Override
//	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
//			throws IOException, ServletException {
//
//		try {
//			HttpServletRequest req = (HttpServletRequest) request;
//			Principal principal = req.getUserPrincipal();
//			if(principal != null) {
//				String userName = req.getUserPrincipal().getName();
//				if(StringUtils.isNotBlank(userName)) {
//					NotificationDto criteria = NotificationDto.builder()
//							.types(Arrays.asList(EventTypeEnum.WEIGHT_NOTE.val, EventTypeEnum.PROCESS_ORDER.val))
//								.size(10)
//								.page(0)
//								.build();
//					PageDto page = notifyManager.search(criteria);
//					request.setAttribute("notifications", page);
//				}
//			}
//		} catch (Exception e) {
//			System.out.println(e.getMessage());
//
//		} finally {
//			chain.doFilter(request, response);
//		}
//	}
//
//}
