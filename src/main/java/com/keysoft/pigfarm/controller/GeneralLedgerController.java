package com.keysoft.pigfarm.controller;

import com.keysoft.pigfarm.common.DatePatternEnum;
import com.keysoft.pigfarm.common.DocCodeEnum;
import com.keysoft.pigfarm.common.EntityResponseCodeEnum;
import com.keysoft.pigfarm.common.GeneralLedgerStatusEnum;
import com.keysoft.pigfarm.constant.ModelViewEnum;
import com.keysoft.pigfarm.integration.EntityResponse;
import com.keysoft.pigfarm.manager.FarmManager;
import com.keysoft.pigfarm.manager.GeneralLedgerManager;
import com.keysoft.pigfarm.manager.VendorManager;
import com.keysoft.pigfarm.production.dto.FarmDto;
import com.keysoft.pigfarm.production.dto.GeneralLedgerDto;
import com.keysoft.pigfarm.production.dto.VendorDto;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Controller;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;

@Slf4j
@Controller
public class GeneralLedgerController extends BaseController {

    @Autowired
    private GeneralLedgerManager generalLedgerManager;
    @Autowired
    private FarmManager farmManager;
    @Autowired
    private VendorManager vendorManager;

    @GetMapping("/general-ledger/list")
    public ModelAndView showList() {
        log.info("process=show-list()");
        ModelAndView mav = new ModelAndView(ModelViewEnum.VIEW_GENERAL_LEDGER_LIST.mav);
        GeneralLedgerDto criteria = new GeneralLedgerDto();
        criteria.setPage(appProperties.getDefaultPage());
        criteria.setSize(appProperties.getDefaultPageSize());
        // Initial Data
        List<FarmDto> farms = farmManager.getAllFarmByUser();
        List<String> listStatus = new ArrayList<>();
        Arrays.asList(GeneralLedgerStatusEnum.values()).forEach(item -> listStatus.add(item.status));

        mav.addObject(ModelViewEnum.MODEL_CRITERIA.mav, criteria)
                .addObject(ModelViewEnum.MODEL_PAGE.mav, generalLedgerManager.search(criteria))
                .addObject("farms", farms)
                .addObject("listStatus", listStatus)
        ;

        return mav;
    }

    @PostMapping("/general-ledger/list")
    public ModelAndView search(@Valid GeneralLedgerDto criteria) {
        log.info("process=search(), criteria={}", criteria);
        ModelAndView mav = new ModelAndView(ModelViewEnum.VIEW_GENERAL_LEDGER_LIST.mav);
        // Initial Data
        List<FarmDto> farms = farmManager.getAllFarmByUser();
        List<String> listStatus = new ArrayList<>();
        Arrays.asList(GeneralLedgerStatusEnum.values()).forEach(item -> listStatus.add(item.status));

        mav.addObject(ModelViewEnum.MODEL_CRITERIA.mav, criteria)
                .addObject(ModelViewEnum.MODEL_PAGE.mav, generalLedgerManager.search(criteria))
                .addObject("farms", farms)
                .addObject("listStatus", listStatus)
        ;

        return mav;
    }

    @GetMapping("/general-ledger/form")
    public ModelAndView showForm(@RequestParam(name = "id", required = false) String id, HttpServletRequest request) {
        log.info("process=show-form()");
        ModelAndView mav = new ModelAndView(ModelViewEnum.VIEW_GENERAL_LEDGER_FORM.mav);
        GeneralLedgerDto generalLedger = new GeneralLedgerDto();
        Locale locale = request.getLocale();
        if (StringUtils.isNotBlank(id)) {
            try {
                generalLedger = generalLedgerManager.get(Long.valueOf(id));
            } catch (NumberFormatException ex) {
                addError(request, getText("param.not.valid", locale));
                mav.setViewName(ModelViewEnum.VIEW_GENERAL_LEDGER_LIST.mav);
            }
        }
        List<String> docCodes = new ArrayList<>();
        Arrays.asList(DocCodeEnum.values()).forEach(item -> docCodes.add(item.code));

        List<FarmDto> farms = farmManager.getAllFarmByUser();
        List<VendorDto> vendors = vendorManager.gets();

        mav.addObject("generalLedger", generalLedger);
        mav.addObject("docCodes", docCodes);
        mav.addObject("farms", farms);
        mav.addObject("vendors", vendors);

        return mav;
    }

    @PostMapping("/general-ledger/form")
    public ModelAndView createOrUpdate(@Valid GeneralLedgerDto generalLedger, HttpServletRequest request) {
        log.info("Entering: 'createOrUpdate' method..., generalLedger={}", generalLedger);
        Locale locale = request.getLocale();
        ModelAndView mav = new ModelAndView(ModelViewEnum.REDIRECT_GENERAL_LEDGER_LIST.mav);
        EntityResponse response = generalLedgerManager.saveOrUpdate(generalLedger);
        if (EntityResponseCodeEnum.SUCCESS_200.val.equals(response.getCode())) {
            addMessage(request, getText("label.generalLedger.action.save.success", locale));
        } else {
            addError(request, getText("label.generalLedger.action.save.failure", locale));
//            addError(request, response.getMessage());
            mav.addObject("generalLedger", generalLedger);
            mav.setViewName(ModelViewEnum.REDIRECT_GENERAL_LEDGER_FORM.mav);
        }
        return mav;
    }

    @PostMapping("/general-ledger/saveAndSync")
    public ModelAndView saveAndSyncToERP(@Valid GeneralLedgerDto generalLedger, HttpServletRequest request) {
        log.info("entering: 'saveAndSyncToERP' method..., generalLedger={}", generalLedger);
        Locale locale = request.getLocale();
        ModelAndView mav = new ModelAndView(ModelViewEnum.REDIRECT_GENERAL_LEDGER_LIST.mav);

        EntityResponse response = generalLedgerManager.saveAndSync(generalLedger);
        if (EntityResponseCodeEnum.SUCCESS_200.val.equals(response.getCode())) {
            addMessage(request, getText("message.saveAndSync.success", locale));
        } else {
            addError(request, getText("message.saveAndSync.fail", locale));
            mav.setViewName(ModelViewEnum.REDIRECT_GENERAL_LEDGER_FORM.mav);
        }
        return mav;
    }

    @GetMapping("/general-ledger/export")
    public void eventToExportExcel(@RequestParam(name = "farmCode", required = false) String farmCode,
                                   @RequestParam(name = "status", required = false) String status,
                                   @RequestParam(name = "docNum", required = false) String docNum,
                                   @RequestParam(name = "fromDate", required = false) String fromDate,
                                   @RequestParam(name = "toDate", required = false) String toDate,
                                   HttpServletRequest request, HttpServletResponse response) throws IOException {
        log.info("entering: 'event-to-export-excel' method...");
        Locale locale = request.getLocale();
        Integer sumCell = 14;
        String[] headerText = {
                getText("report.instock.title.no", locale), getText("farm.code", locale),
                getText("farm.name", locale),
                getText("doc.code", locale), getText("doc.num", locale),
                getText("doc.symbol", locale), getText("doc.postingDate", locale),
                getText("doc.date", locale), getText("generalLedger.amount", locale),
                getText("generalLedger.vendor.code", locale), getText("generalLedger.vendor.name", locale),
                getText("generalLedger.description", locale), getText("doc.FI", locale),
                getText("label.task.status", locale)
        };
        XSSFWorkbook workbook = new XSSFWorkbook();
        try {
            XSSFSheet sheet = workbook.createSheet("HACH TOAN CHI PHI");
            writeHeader(sheet, sumCell, headerText);
            GeneralLedgerDto criteria = new GeneralLedgerDto();
            if (StringUtils.isNotBlank(farmCode)) criteria.setSearchFarmCode(farmCode.trim());
            if (StringUtils.isNotBlank(docNum)) criteria.setDocNum(docNum.trim());
            if (StringUtils.isNotBlank(status)) criteria.setStatus(status.trim());
            if (StringUtils.isNotBlank(fromDate)) criteria.setSearchFromDateStr(fromDate.trim());
            if (StringUtils.isNotBlank(toDate)) criteria.setSearchToDateStr(toDate.trim());

            List<GeneralLedgerDto> generalLedgers = generalLedgerManager.searchAll(criteria);
            writeExcelFile(sheet, generalLedgers, request);
            String fileLocation = createNameFile(getText("generalLedger.export.title", locale));
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileLocation + "\"");
            response.flushBuffer();
            workbook.write(response.getOutputStream());
            response.getOutputStream().flush();
        } finally {
            workbook.close();
            response.getOutputStream().close();
        }

    }

    private void writeExcelFile(XSSFSheet sheet, List<GeneralLedgerDto> generalLedgers, HttpServletRequest request) {
        Integer rowNum = 1;
        Integer countNo = 1;
        if (!CollectionUtils.isEmpty(generalLedgers)) {
            for (GeneralLedgerDto gl:generalLedgers) {
                Row row = sheet.createRow(rowNum++);
                Integer column = 0;
                Cell cell = row.createCell(column++);
                cell.setCellValue(countNo);
                cell = row.createCell(column++);

                cell.setCellValue(gl.getFarm() != null ? gl.getFarm().getCode() : "");
                cell = row.createCell(column++);

                cell.setCellValue(gl.getFarm() != null ? gl.getFarm().getName() : "");
                cell = row.createCell(column++);

                cell.setCellValue(gl.getDocCode());
                cell = row.createCell(column++);

                cell.setCellValue(gl.getDocNum());
                cell = row.createCell(column++);

                cell.setCellValue(gl.getDocSymbol());
                cell = row.createCell(column++);

                cell.setCellValue(gl.getDisplayPostingDate());
                cell = row.createCell(column++);

                cell.setCellValue(gl.getDisplayDocDate());
                cell = row.createCell(column++);

                cell.setCellValue(gl.getAmount() != null ? gl.getAmount().intValue() : 0);
                cell = row.createCell(column++);

                cell.setCellValue(gl.getVendor() != null ? gl.getVendor().getCode() : "");
                cell = row.createCell(column++);

                cell.setCellValue(gl.getVendor() != null ? gl.getVendor().getName() : "");
                cell = row.createCell(column++);

                cell.setCellValue(gl.getDescription());
                cell = row.createCell(column++);

                cell.setCellValue(gl.getFiDoc());
                cell = row.createCell(column++);

                cell.setCellValue(getText("generalLedger.status." + gl.getStatus(), request.getLocale()));
                cell = row.createCell(column++);

                countNo++;
            }
        }
    }

    private void writeHeader(XSSFSheet sheet, Integer sumCell, String[] headerText) {
        log.info("PROCESS: WRITE HEADER FILE EXCEL");
        Row headerRow = sheet.createRow(0);
        for (int i = 0; i < sumCell; i++) {
            headerRow.createCell(i).setCellValue(headerText[i]);
        }
    }

    private String createNameFile(String baseName) {
        log.info("PROCESS: CREATE NAME_FILE");
        DateFormat dateFormat = new SimpleDateFormat(DatePatternEnum.YYYY_MM_DD__HH_MM_SS_1.pattern);
        String dateTimeInfo = dateFormat.format(new Date());
        return baseName.concat(String.format("_%s.xlsx", dateTimeInfo));
    }
}
