package com.keysoft.pigfarm.controller.report;

import com.keysoft.pigfarm.common.PageDto;
import com.keysoft.pigfarm.constant.ModelViewEnum;
import com.keysoft.pigfarm.controller.BaseController;
import com.keysoft.pigfarm.manager.ReportManager;
import com.keysoft.pigfarm.manager.UserManager;
import com.keysoft.pigfarm.master.dto.UserDto;
import com.keysoft.pigfarm.report.dto.ReportTaskDto;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("/report")
public class ReportTaskController extends BaseController {

    @Autowired
    private UserManager userManager;

    @GetMapping("/task")
    public ModelAndView getReportTask() {
        log.info("process='get-report-task()...'");
        ModelAndView mav = new ModelAndView(ModelViewEnum.VIEW_REPORT_TASK.mav);
        List<ReportTaskDto> reportData = new ArrayList<>();
        PageDto pageUser = userManager.gets(0, 500);
        @SuppressWarnings("unchecked")
        List<UserDto> users = (List<UserDto>) pageUser.getContent();

        mav.addObject(ModelViewEnum.MODEL_CRITERIA.mav, new ReportTaskDto());
        mav.addObject("reportData", reportData)
			.addObject("assignees", users);
        return mav;
    }

}
