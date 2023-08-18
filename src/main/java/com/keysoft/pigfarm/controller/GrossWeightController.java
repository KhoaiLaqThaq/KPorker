package com.keysoft.pigfarm.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.keysoft.pigfarm.common.FileExportNameEnum;
import com.keysoft.pigfarm.common.MapKeyExportEnum;
import com.keysoft.pigfarm.constant.ModelViewEnum;
import com.keysoft.pigfarm.manager.FarmManager;
import com.keysoft.pigfarm.manager.GrossWeightManager;
import com.keysoft.pigfarm.production.dto.FarmDto;
import com.keysoft.pigfarm.util.GZipHelper;
import com.keysoft.pigfarm.weighing.dto.LanCanDto;
import com.keysoft.pigfarm.weighing.dto.LanCanSetDto;
import com.keysoft.pigfarm.weighing.dto.PhieuCanChiTietDto;
import com.keysoft.pigfarm.weighing.dto.PhieuCanDto;
import com.keysoft.pigfarm.weighing.dto.ReportRequest;

import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;

@Slf4j
@Controller
public class GrossWeightController extends BaseController {
	@Autowired
	private GrossWeightManager grossWeightManager;
	@Autowired
	private FarmManager farmManager;
	@Autowired
	GZipHelper gzipHelper;
	@Autowired
	ResourceLoader resourceLoader;
	
	protected final String TEMPLATE_PATH 	= "templates/";
	protected final String masterReportFileName = "templates/masterReport.jrxml";
	protected final String subReportFileName 	= "templates/subReport.jrxml";
	protected final String sumSubReportFileName = "templates/sumSubReport.jrxml";
	protected final String TEMPLATE_OUTPUT_PATH = "/opt/pigfarm/recycle/";
	protected final String DOCX_EXT			= ".docx";
	protected final String PDF_EXT			= ".pdf";
	protected final String UNDERSCORE		= "_";
	protected final String DOLLAR			= "$";
	protected final String HASHTAG			= "#";
	protected final String OPEN_BRACKET 	= "{";
	protected final String CLOSE_BRACKET	= "}";
	
	
	@GetMapping("/grossWeight/list")
	public ModelAndView list(PhieuCanDto criteria, HttpServletRequest request) {
		log.info("********************CONTROLLER::grossWeight-list*******************");
		ModelAndView modelAndView = new ModelAndView(ModelViewEnum.VIEW_GROSS_WEIGHT_LIST.mav);
		criteria.setPage(appProperties.getDefaultPage());
		criteria.setSize(appProperties.getDefaultPageSize());
		modelAndView.addObject(ModelViewEnum.MODEL_PAGE.mav, grossWeightManager.search(criteria));
		return modelAndView;
	}
	
	@PostMapping("/grossWeight/list")
	public ModelAndView search(@Valid PhieuCanDto criteria) {
		log.info("********************CONTROLLER::grossWeight-search***************");
		ModelAndView modelAndView = new ModelAndView(ModelViewEnum.VIEW_GROSS_WEIGHT_LIST.mav);
		modelAndView.addObject(ModelViewEnum.MODEL_PAGE.mav, grossWeightManager.search(criteria));
		return modelAndView;
	}
	
	@GetMapping("/grossWeight/form")
	public ModelAndView form(@RequestParam(name = "id", required = false) String id, HttpServletRequest request) {
		log.info("********************CONTROLLER::grossWeight-form*******************");
		Locale locale = request.getLocale();
		ModelAndView modelAndView = new ModelAndView(ModelViewEnum.VIEW_GROSS_WEIGHT_FORM.mav);
		PhieuCanDto phieuCanDto = new PhieuCanDto();
		List<PhieuCanChiTietDto> phieuCanChiTiets = new ArrayList<PhieuCanChiTietDto>();
		
		try {
			if (StringUtils.isNotBlank(id)) {
				phieuCanDto = grossWeightManager.get(Long.parseLong(id));
				if(phieuCanDto == null) {
		    		addError(request, getText("data.notfound", locale));
					return new ModelAndView("redirect:/grossWeight/list");
				}
				
				phieuCanChiTiets = phieuCanDto.getPhieuCanChiTiets();
				FarmDto farm = farmManager.getByFarmCode(phieuCanDto.getTraiXuat());
				modelAndView.addObject("farm", farm);
			} else {
				List<FarmDto> farms = farmManager.getAllFarmByUser();
				modelAndView.addObject("farms", farms);
			}
		} catch (NumberFormatException e) {
			addError(request, getText("grossWeight.get.errorNumberFormat", locale));
			e.printStackTrace();
		}
		
		modelAndView.addObject("phieuCanChiTiets", phieuCanChiTiets);
		modelAndView.addObject("grossWeight", phieuCanDto);
		return modelAndView;
	}
	
	@PostMapping("/grossWeight/save")
	public String save(PhieuCanDto phieuCanDto, BindingResult bindingResult, HttpServletRequest request) {
		log.info("****************CONTROLLER::save-grossWeight, phieuCan: {}", phieuCanDto);
		Locale locale = request.getLocale();
		String viewName = "redirect:/grossWeight/form";
		List<PhieuCanChiTietDto> phieuCanChiTiets = phieuCanDto.getPhieuCanChiTiets();
		if (phieuCanChiTiets.isEmpty()) {
			addError(request, getText("grossWeight.updated.fail", locale));
			return "redirect:/grossWeight/list";
		}
		PhieuCanDto savePhieuCan = grossWeightManager.save(phieuCanDto);
		if (savePhieuCan != null) {
			addMessage(request, getText("grossWeight.update.success", locale));
			viewName = "redirect:/grossWeight/form?id=" + savePhieuCan.getId();
		} else
			addError(request, getText("grossWeight.updated.fail", locale));
		return viewName;
	}
	
	@GetMapping("/grossWeight/export/{id}")
	public void exportDocxToPdf(@PathVariable(value = "id") Long id, HttpServletRequest request, HttpServletResponse response) {
		log.info("************CONTROLLER::exportDocxToPdf**************");
		InputStream masterTemplateStream = null;
		// create Map to set parameter for jasper template
		Map<String, Object> parameters = new HashMap<String, Object>();
		List<LanCanDto> lanCans = new ArrayList<>();
		List<LanCanSetDto> lanCanSets = new ArrayList<>();
		ReportRequest reportRequest = new ReportRequest();
		StringBuilder templateName = new StringBuilder();
		templateName.append(FileExportNameEnum.GROSS_WEIGHT.val);
		if (id != null) {
			try {
				PhieuCanDto phieuCan = grossWeightManager.get(id);
				reportRequest.setSoPhieuXk(phieuCan.getSoPhieuXk());
				reportRequest.setTenKh(phieuCan.getTenKh());
				reportRequest.setDiaChi(phieuCan.getDiaChi());
				reportRequest.setTraiXuat(phieuCan.getTraiXuat());
				reportRequest.setBienSoXe(phieuCan.getSoXe());
				reportRequest.setPhieuCanSo(phieuCan.getSoPhieuNum().toString());
				// generate QRCode
				String jsonData 	= generateTemplateQRCode(phieuCan);
				String fileContent	= generateQRCodeImage(jsonData);
				log.info("fileContent, {}", fileContent);
				parameters.put("contentToEncode", fileContent);
				parameters.put("logoPath", resourceLoader.getResource("classpath:templates/logo.png").getURL().getPath());
				List<PhieuCanChiTietDto> phieuCanChiTiets = phieuCan.getPhieuCanChiTiets();
				if (phieuCanChiTiets != null) {
					AtomicInteger index = new AtomicInteger();
					Integer sumAmount = 0;
					Integer sumWeigh = 0;
					Integer sumGiamTru = 0;
					Integer sumHeoCai = 0;

					List<String> materialSet = new ArrayList<String>();
					Map<String, PhieuCanChiTietDto> phieuCanDetailMap = new HashMap<String, PhieuCanChiTietDto>();
					for (PhieuCanChiTietDto item : phieuCanChiTiets) {
						String[] materials = item.getLoaiHang().split("_");
						String materialCode = materials[0];
						String materialName = materials[1];
						if (materialSet.contains(item.getLoaiHang())) {
							PhieuCanChiTietDto detailValue = phieuCanDetailMap.get(materialCode);
							if (detailValue != null) {
								detailValue.setSoLuong(item.getSoLuong() + detailValue.getSoLuong());
								detailValue.setTlCan(item.getTlCan() + detailValue.getTlCan());
								detailValue.setTlGiamTru(item.getTlGiamTru() + detailValue.getTlGiamTru());
								detailValue.setSlHeoCai(item.getSlHeoCai() + detailValue.getSlHeoCai());

								phieuCanDetailMap.put(materialCode, detailValue);
							}
						} else {
							phieuCanDetailMap.put(materialCode, item);
							materialSet.add(item.getLoaiHang());
						}
						LanCanDto lanCan = new LanCanDto();
						lanCan.setId(String.valueOf(index.getAndIncrement() + 1));
						lanCan.setTenhanghoa(materialName);
						lanCan.setDvt(item.getDvt());
						lanCan.setSoluong(item.getSoLuong());
						lanCan.setKhoiluong(item.getTlCan());
						lanCan.setTlGiamtru(item.getTlGiamTru());
						lanCan.setTrangthai(item.getTrangThai());
						lanCan.setSlHeocai(item.getSlHeoCai());

						// plus summary
						sumAmount += item.getSoLuong();
						sumWeigh += item.getTlCan();
						sumGiamTru += item.getTlGiamTru();
						sumHeoCai += item.getSlHeoCai();
						lanCans.add(lanCan);
					}
					reportRequest.setLanCans(lanCans);
					AtomicInteger count = new AtomicInteger();
					phieuCanDetailMap.forEach((key, value) -> {
						String[] materials = value.getLoaiHang().split("_");
						String materialName = materials[1];
						LanCanSetDto lanCanSet = new LanCanSetDto();
						lanCanSet.setIdSet(String.valueOf(count.getAndIncrement() + 1));
						lanCanSet.setTenhanghoaSet(materialName);
						lanCanSet.setChuongSet(value.getTenChuong());
						lanCanSet.setSoluongSet(value.getSoLuong());
						lanCanSet.setKhoiluongSet(value.getTlCan());
						lanCanSet.setTrangthaiSet(value.getTrangThai());
						lanCanSet.setTlGiamtruSet(value.getTlGiamTru());
						lanCanSet.setSlHeocaiSet(value.getSlHeoCai());

						lanCanSets.add(lanCanSet);
					});
					reportRequest.setLanCanSets(lanCanSets);
					// set summary pig
					log.info("*************set summary pig");
					parameters.put(MapKeyExportEnum.TOTAL_AMOUNT.key, sumAmount);
					parameters.put(MapKeyExportEnum.TOTAL_WEIGH.key, sumWeigh);
					parameters.put(MapKeyExportEnum.TOTAL_GIAMTRU.key, sumGiamTru);
					parameters.put(MapKeyExportEnum.TOTAL_HEOCAI.key, sumHeoCai);
				}
				log.info("*******************set jasper report ");
				masterTemplateStream = resourceLoader.getResource("classpath:templates/masterReport.jrxml").getInputStream();
				String subTemplatePath = resourceLoader.getResource("classpath:templates/subReport.jrxml").getURL().getPath();
				String sumSubTemplatePath = resourceLoader.getResource("classpath:templates/sumSubReport.jrxml").getURL().getPath();
				log.info("*********set path successful!");
				JasperReport jasperMasterReport = JasperCompileManager.compileReport(masterTemplateStream);
				JasperReport jasperSubReport 	= JasperCompileManager.compileReport(subTemplatePath);
				JasperReport jasperSumSubReport = JasperCompileManager.compileReport(sumSubTemplatePath);

				parameters.put("subreportParameter", 	jasperSubReport);
				parameters.put("sumSubreportParameter", jasperSumSubReport);
				log.info("*************set jasper subreport success************");
				JRBeanCollectionDataSource jrBeanCollectionDataSource = new JRBeanCollectionDataSource(List.of(reportRequest));
				JasperPrint jasperPrint = JasperFillManager.fillReport(jasperMasterReport, parameters, jrBeanCollectionDataSource);
				String outputFileName = getExportName(templateName.toString(), phieuCan.getSoPhieu());
				String outputPath = TEMPLATE_OUTPUT_PATH + outputFileName;
				log.info("****************outputFileName: {},outputPath: {}", outputFileName, outputPath);
				JasperExportManager.exportReportToPdfFile(jasperPrint, outputPath);
				System.out.println("Exported Done");

				InputStream inputStream = new FileInputStream(new File(outputPath));
				response.setHeader("Content-Disposition", "attachment; filename=\"" + outputFileName + "\"");
				response.setContentType("application/pdf");
				IOUtils.copy(inputStream, response.getOutputStream());
				response.flushBuffer();
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				try {
					masterTemplateStream.close();
				} catch (IOException io) {
					io.printStackTrace();
				}
			}
		}
	}
	
	
	private String generateTemplateQRCode(PhieuCanDto phieuCan) {
		log.info("******************process::generated_Template_QRCode************");
		StringBuilder templateJson = new StringBuilder();
		try {
			if (phieuCan != null) {
				templateJson.append(phieuCan.getSoPhieuXk());
				templateJson.append(DOLLAR);
				templateJson.append(phieuCan.getSoPhieuNum());
				templateJson.append(DOLLAR);
				templateJson.append(phieuCan.getSoXe());
				phieuCan.getPhieuCanChiTiets().stream().forEach(detail -> {
					templateJson.append(OPEN_BRACKET);
					String[] materials = detail.getLoaiHang().split("_");
					String materialName = "Not found product";
					if (materials[0] != null) {
						materialName = materials[0];
					}
					templateJson.append(materialName);
					templateJson.append(HASHTAG);
					templateJson.append(detail.getChuong());
					templateJson.append(HASHTAG);
					templateJson.append(detail.getSoLuong());
					templateJson.append(HASHTAG);
					templateJson.append(detail.getTlCan());
					templateJson.append(HASHTAG);
					templateJson.append(detail.getTrangThai());
					templateJson.append(HASHTAG);
					templateJson.append(detail.getTlGiamTru());
					templateJson.append(HASHTAG);
					templateJson.append(detail.getSlHeoCai());
					templateJson.append(CLOSE_BRACKET);
				});
				log.info("generate template qrcode successful!");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return templateJson.toString();
	}
	
	private String generateQRCodeImage(String text) {
		log.info("*******generateQRCodeImage");
		try {
			byte[] textContent = gzipHelper.compress(text);
			return Base64.getEncoder().encodeToString(textContent);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	protected String getTemplatePath(String nameTemplate) {
		log.info("Entering getTemplatePath("+ nameTemplate +")...");
		
		StringBuilder builder = new StringBuilder();
		builder.append(TEMPLATE_PATH).append(nameTemplate).append(DOCX_EXT);
		return builder.toString();
	}
	
	protected String getExportName(String nameTemplate, String transCode) {
		log.info("Entering getExportName("+ transCode +")...");
		
		StringBuilder builder = new StringBuilder();
		builder.append(nameTemplate).append(UNDERSCORE).append(transCode).append(PDF_EXT);
		return builder.toString();
	}
	
	@GetMapping("/phieuCanChiTiet/{id}")
	@ResponseBody
	public PhieuCanChiTietDto getPhieuCanChiTiet(@PathVariable(required = true) Long id) {
		log.info("******************CONTROLLER::get-phieuCanChiTiet, id={}", id);
		
		return grossWeightManager.getPhieuCanChiTietByID(id);
	}
}
