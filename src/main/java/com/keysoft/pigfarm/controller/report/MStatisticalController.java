package com.keysoft.pigfarm.controller.report;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.keysoft.pigfarm.manager.MStatisticalManager;
import com.keysoft.pigfarm.report.dto.MStatisticalRequest;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/statistical")
public class MStatisticalController {
	
	@Autowired
	private MStatisticalManager mStatisticalManager;
	
	@PostMapping("/material-other")
	public ResponseEntity<?> handleStatisticalMaterial(@RequestBody MStatisticalRequest criteria) {
		log.info("***********CONTROLLER::proccess='handle-statistical-material', {}", criteria);
		
		return ResponseEntity.ok(mStatisticalManager.handleMStatisticalMaterial(criteria));
	}
	
}
