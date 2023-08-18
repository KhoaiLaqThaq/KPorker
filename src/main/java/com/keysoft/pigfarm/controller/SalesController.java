package com.keysoft.pigfarm.controller;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.apache.commons.lang3.StringUtils;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.keysoft.pigfarm.helper.DateTimeHelper;
import com.keysoft.pigfarm.manager.SalesManager;
import com.keysoft.pigfarm.production.dto.SalesDto;
import com.keysoft.pigfarm.production.json.SyncResponse;
import com.keysoft.pigfarm.util.ExcelHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class SalesController extends BaseController{
	@Autowired
	private SalesManager salesManager;
	@Autowired
	private ExcelHelper excelHelper;
	
	@GetMapping("/sales/list")
    public ModelAndView sales(HttpServletRequest request) throws Exception {
    	log.debug("ENTERING 'LIST SALES' METHOD...");
		ModelAndView modelAndView = new ModelAndView("sales-list");
		SalesDto criteria = new SalesDto();
    	criteria.setSize(appProperties.getDefaultPageSize());
    	criteria.setPage(appProperties.getDefaultPage());
		modelAndView.addObject("page", salesManager.gets(criteria));
		modelAndView.addObject("criteria", criteria);
        return modelAndView;
    }
	    
    @PostMapping("/sales/list")
    public ModelAndView searchSales(@Valid SalesDto criteria, BindingResult bindingResult){
    	log.debug("ENTERING 'SEARCH SALES' METHOD...");
		ModelAndView modelAndView = new ModelAndView("sales-list");
		if(criteria != null && criteria.getSize() == null){
			criteria.setSize(appProperties.getDefaultPageSize());
	    	criteria.setPage(appProperties.getDefaultPage());
	    }
		
		if(criteria != null && StringUtils.isNotBlank(criteria.getPostingDateSearch())) {
			List<LocalDate> listDateSearch = DateTimeHelper.getDatePeriodFromString(criteria.getPostingDateSearch());
			criteria.setRecordDateSearchPeriod(listDateSearch);
		}
		
		modelAndView.addObject("page", salesManager.gets(criteria));
		modelAndView.addObject("criteria", criteria);
        return modelAndView;
    }
    
    @GetMapping("/sales/sync-from-sap")
    public String synncFromSAP(HttpServletRequest request) throws Exception {
    	log.debug("ENTERING 'SYNC_SALES_DATA_FROM_SAP' METHOD...");
    	Locale locale = request.getLocale();
    	try {
    		SyncResponse syncResponse = salesManager.syncFromSAP();
    		if (String.valueOf(HttpStatus.OK.value()).equals(syncResponse.getCode())) {
    			addMessage(request, getText("sync.master.data.success", locale));
			} else {
				addError(request, syncResponse.getMessage());
			}
    		
		} catch (Exception e) {
			log.error("ERROR SYNC_SALES_DATA_FROM_SAP: EXCEPTION: {}", e);
			addError(request, e.getMessage());
		}
    	return "redirect:/sales/list";
    }	
		
	@ModelAttribute
    @GetMapping("/sales/form")
    public ModelAndView showForm(@RequestParam (value="id", required=false) Long id, HttpServletRequest request) throws Exception {
		log.debug("ENTERING 'SHOW SALES' METHOD...");
		Locale locale = request.getLocale();
		
    	ModelAndView modelAndView = new ModelAndView("sales-form");
    	SalesDto salesDto = new SalesDto();
    	if(id != null) {
    		salesDto = salesManager.get(id);
    		if(salesDto == null) {
        		addError(request, getText("data.notfound", locale));
        		return new ModelAndView("redirect:/sales/list");
        	}
    	} else {
    		modelAndView.setViewName("redirect:/instock/list");
    		addError(request, getText("instock.notfound", locale));
    	}
        modelAndView.addObject("sales", salesDto);

        return modelAndView;
    }
	
	@GetMapping("/sales/export-excel")
	public void exportToExcel(@RequestParam(name ="stockName", required = false) String stockName,
								@RequestParam(name ="processOrder", required = false) String processOrder,
								@RequestParam(name ="fromDate", required = false) String fromDate,
							  	@RequestParam(name ="toDate", required = false) String toDate,
								HttpServletResponse response) throws IOException {
		log.debug("entering 'export excel' method...");
		SalesDto criteria = new SalesDto();
		if (StringUtils.isNotBlank(stockName)) criteria.setStockName(stockName);
		if (StringUtils.isNotBlank(processOrder)) criteria.setProcessOrderCode(processOrder);
		if (StringUtils.isNotBlank(fromDate)) criteria.setFromDate(fromDate);
		if (StringUtils.isNotBlank(toDate)) criteria.setToDate(toDate);

		List<SalesDto> list = salesManager.getsToExport(criteria);
		
		XSSFWorkbook workbook = new XSSFWorkbook();
    	try {
    		XSSFSheet sheet = workbook.createSheet("Sales");
    		
    		excelHelper.writeHeaderLine(sheet, workbook,"STT", "Trại", "Ngày xuất", "Mã heo", "Mã lô", "Số lượng", "Trọng lượng", "Lệnh sản xuất");
    		int rowCount = 1;
            CellStyle style = workbook.createCellStyle();
            XSSFFont font = workbook.createFont();
            font.setFontHeight(14);
            style.setFont(font);
            
            for(SalesDto e : list) {
            	Row row = sheet.createRow(rowCount++);
                int columnCount = 0;
                
                excelHelper.createCell(sheet, row, columnCount++, rowCount-1, style);
                excelHelper.createCell(sheet, row, columnCount++, e.getStock().getCode(), style);
                excelHelper.createCell(sheet, row, columnCount++, e.getDisplayPostingDate(), style);
                excelHelper.createCell(sheet, row, columnCount++, e.getMaterialCode(), style);
                excelHelper.createCell(sheet, row, columnCount++, e.getBatch(), style);
                excelHelper.createCell(sheet, row, columnCount++, e.getQuantity().toString(), style);
                excelHelper.createCell(sheet, row, columnCount++, e.getWeight().toString(), style);
                excelHelper.createCell(sheet, row, columnCount++, e.getProcessOrderCode(), style);
            }
            
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"saleReport.xlsx\"");
            response.flushBuffer();			
			workbook.write(response.getOutputStream());
			response.getOutputStream().flush();
			response.getOutputStream().close();
            
    	} catch (Exception e) {
    		e.printStackTrace();
    	} finally {
			workbook.close();
		}
	}
}
