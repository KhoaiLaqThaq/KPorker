package com.keysoft.pigfarm.controller.template;

import com.keysoft.pigfarm.common.SymbolEnum;
import com.keysoft.pigfarm.production.template.FieldDto;
import com.keysoft.pigfarm.production.template.TemplateDto;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

@Slf4j
@RestController
@RequestMapping("/api")
public class RestTemplateController {

//    @PostMapping("/saveTemplate/utf-8")
//    public ResponseEntity

    @PostMapping("/template/utf-8")
    public ResponseEntity<?> handleImportTemplateUTF8(@ModelAttribute TemplateDto templateDto) {
        log.info("entering: 'handleImportTemplateUTF8()' method, template={}", templateDto);
        return ResponseEntity.ok(readFileTemplateUTF8(templateDto.getExcelFile()));
    }

    private TemplateDto readFileTemplateUTF8(MultipartFile excelFile) {
        TemplateDto templateDto = new TemplateDto();
        List<FieldDto> fields = new ArrayList<>();
        int i = 1;
        if (excelFile != null) {
            try {
                XSSFWorkbook workbook = new XSSFWorkbook(excelFile.getInputStream());
                XSSFSheet sheet = workbook.getSheetAt(0);
                while (i <= sheet.getLastRowNum()) {
                    int cellnum = 0;
                    FieldDto field = new FieldDto();
                    /**
                     * The first row will be defined as the columns, therefore we start from two-row
                     */
                    XSSFRow row = sheet.getRow(i++);
                    // label name
                    XSSFCell cellLabelName = row.getCell(cellnum++);
                    String labelNameText = cellLabelName.getStringCellValue();
                    field.setLabelName(labelNameText);
                    // "Nhãn hiển thị" -> "Nhan hien thi" -> "nhan_hien_thi"
                    String fieldName = removeAccent(labelNameText.toLowerCase())
                            .replaceAll(SymbolEnum.SPACE.val, SymbolEnum.UNDERSCORE.val);
                    field.setFieldId(fieldName);
                    field.setFieldName(fieldName);
                    // dataType
                    XSSFCell cellFieldDataType = row.getCell(cellnum++);
                    field.setFieldDataType(cellFieldDataType.getStringCellValue());
                    // maxLength
                    XSSFCell cellFieldMaxLength = row.getCell(cellnum++);
                    if (cellFieldMaxLength != null)
                        field.setFieldMaxLength(
                                StringUtils.isNotBlank(cellFieldMaxLength.getStringCellValue())
                                        ? cellFieldMaxLength.getStringCellValue()
                                        : ""
                        );

                    // add to list object
                    fields.add(field);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        templateDto.setFields(fields);

        return templateDto;
    }

    @PostMapping("/template/bootstrap")
    public ResponseEntity<?> importTemplate(@ModelAttribute TemplateDto template, HttpServletRequest http) {
        log.info("entering: 'import-template()' method..., template={}", template);
        return ResponseEntity.ok(readFileExcelTemplateBootstrap(template.getExcelFile()));
    }

    private TemplateDto readFileExcelTemplateBootstrap(MultipartFile excelFile) {
        log.info("PROCESS: READ FILE EXCEL TEMPLATE");
        TemplateDto templateDtos = new TemplateDto();
        List<FieldDto> fields = new ArrayList<>();
        int i = 1;
        if (excelFile != null) {
            try {
                XSSFWorkbook workbook = new XSSFWorkbook(excelFile.getInputStream());
                XSSFSheet sheet = workbook.getSheetAt(0);
                while (i <= sheet.getLastRowNum()) {
                    int cellnum = 0;
                    FieldDto field = new FieldDto();
                    XSSFRow dataRow = sheet.getRow(i++);
                    //
                    XSSFCell cellGroupClassName = dataRow.getCell(cellnum++);
                    field.setGroupClassName(cellGroupClassName.getStringCellValue());
                    //
                    XSSFCell cellLabelName = dataRow.getCell(cellnum++);
                    field.setLabelName(cellLabelName.getStringCellValue());
                    //
                    XSSFCell cellFieldName = dataRow.getCell(cellnum++);
                    field.setFieldName(cellFieldName.getStringCellValue());
                    //
                    XSSFCell cellFieldDataType = dataRow.getCell(cellnum++);
                    field.setFieldDataType(cellFieldDataType.getStringCellValue());
                    //
                    XSSFCell cellFieldClassName = dataRow.getCell(cellnum++);
                    field.setFieldClassName(cellFieldClassName.getStringCellValue());

                    fields.add(field);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        templateDtos.setFields(fields);

        return templateDtos;
    }

    private String removeAccent(String text) {
        String temp = Normalizer.normalize(text, Normalizer.Form.NFD);
        Pattern pattern = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
        return pattern.matcher(temp)
                .replaceAll("")
                .replaceAll("Đ", "D")
                .replaceAll("đ", "d");
    }

}
