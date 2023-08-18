package com.keysoft.pigfarm.controller.template;

import com.keysoft.pigfarm.manager.TemplateManager;
import com.keysoft.pigfarm.production.template.FieldDto;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.validation.Valid;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("/template")
public class TemplateController {

    @Autowired
    private TemplateManager templateManager;

    @GetMapping("/bootstrap")
    public ModelAndView showImportForm() {

        return new ModelAndView("/template/import");
    }

    @GetMapping("/utf-8")
    public ModelAndView showImportUTF8TemplateForm() {

        return new ModelAndView("/template/utf-8");
    }

}
