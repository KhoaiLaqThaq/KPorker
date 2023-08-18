package com.keysoft.pigfarm.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.keysoft.pigfarm.common.*;
import com.keysoft.pigfarm.common.util.Docx4jUtils;
import com.keysoft.pigfarm.helper.DateTimeHelper;
import com.keysoft.pigfarm.helper.MaterialCodeConvertHelper;
import com.keysoft.pigfarm.integration.EntityResponse;
import com.keysoft.pigfarm.integration.mobile.GoodsIssueJson;
import com.keysoft.pigfarm.manager.*;
import com.keysoft.pigfarm.production.dto.*;
import com.keysoft.pigfarm.report.dto.*;
import com.keysoft.pigfarm.util.UserContext;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.codec.binary.Hex;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.CellUtil;
import org.apache.poi.util.IOUtils;
import org.apache.poi.xssf.usermodel.*;
import org.docx4j.TraversalUtil;
import org.docx4j.dml.wordprocessingDrawing.Inline;
import org.docx4j.finders.RangeFinder;
import org.docx4j.model.datastorage.migration.VariablePrepare;
import org.docx4j.openpackaging.packages.WordprocessingMLPackage;
import org.docx4j.openpackaging.parts.WordprocessingML.BinaryPartAbstractImage;
import org.docx4j.openpackaging.parts.WordprocessingML.MainDocumentPart;
import org.docx4j.wml.Drawing;
import org.docx4j.wml.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Controller;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
@Slf4j
@Controller
public class IOController extends BaseExportController{
	@Autowired
    private GoodsReceiptManager goodsReceiptManager;
	@Autowired
    private GoodsIssueManager goodsIssueManager;
	@Autowired
	private FarmManager farmManager;
	@Autowired
	private Docx4jUtils docx4jUtils;
	@Autowired
	private ProcessOrderManager processOrderManager;
	@Autowired
	private MaterialSupportManager materialSupportManager;
	@Autowired
	private InstockManager instockManager;
	@Autowired
	private PurchaseRequisitionManager purchaseRequisitionManager;
	@Autowired
	private ReportManager reportManager;
	@Autowired
	private StockCountManager stockCountManager;
	@Autowired
	private InstockBaselineManager instockBaselineManager;
	@Autowired
	private EventManager eventManager;
	@Autowired
	ResourceLoader resourceLoader;
	
	@SuppressWarnings({"static-access" })
	@GetMapping("/goodsReceipt/export/{id}")
    public void exportGoodsReceipt(@PathVariable(value="id") Long id, HttpServletRequest request, HttpServletResponse response) {
    	log.info("ENTERING 'EXPORT GOODS_RECEIPT TO WORD' METHOD...");
    	List<Map<String, String>> infoMaterials = new ArrayList<>();
    	if(id != null) {
    		try {
        		GoodsReceiptDto goodsReceipt = goodsReceiptManager.get(id);
        		if(goodsReceipt != null) {
            		WordprocessingMLPackage wmlPackage = docx4jUtils.getTemplate(getTemplatePath(FileExportNameEnum.GOODS_RECEIPT.val));
            		HashMap<String, String> mappings = new HashMap<>();
            		
            		FarmDto farmDto = farmManager.getByFarmCode(goodsReceipt.getStock().getCode());
            		if(farmDto != null) {
            			String stockAddress = farmDto.getAddress() != null ?  farmDto.getAddress() : "";
            			mappings.put(MapKeyExportEnum.TO_STOCK_ADDRESS.key, convertSpecialChar(stockAddress));
            		} else {
            			mappings.put(MapKeyExportEnum.TO_STOCK_ADDRESS.key, "");
            		}
            		
            		String vendor = goodsReceipt.getVendorName() != null ?  goodsReceipt.getVendorName() : "";
            		String stockName = goodsReceipt.getStock().getName() != null ?  goodsReceipt.getStock().getName() : "";
            		String poCode  = goodsReceipt.getPoCode() != null ?  goodsReceipt.getPoCode() : "";
            		
            		mappings.put(MapKeyExportEnum.VENDOR.key, convertSpecialChar(vendor));
        	        mappings.put(MapKeyExportEnum.TO_STOCK_NAME.key, convertSpecialChar(stockName));
        			mappings.put(MapKeyExportEnum.PO_CODE.key, convertSpecialChar(poCode));
        			
        			LocalDate postingDate = goodsReceipt.getPostingDate();
            		mappings.put(MapKeyExportEnum.DAY.key, convertSpecialChar(String.valueOf(postingDate.getDayOfMonth())));
        			mappings.put(MapKeyExportEnum.MONTH.key, convertSpecialChar(String.valueOf(postingDate.getMonthValue())));
        			mappings.put(MapKeyExportEnum.YEAR.key, convertSpecialChar(String.valueOf(postingDate.getYear())));
        			
        			List<BigDecimal> totalQuantities = new ArrayList<>();  // tong so luon
        			List<BigDecimal> totalWeights = new ArrayList<>();  // tong khoi luong
        			if(!CollectionUtils.isEmpty(goodsReceipt.getMaterialDetails())) {
        				AtomicInteger index = new AtomicInteger();
        				goodsReceipt.getMaterialDetails().stream().forEach(item ->{
        					Map<String,String> map = new HashMap<String,String>();
        					map.put(MapKeyExportEnum.MATERIAL_NO.key, String.valueOf(index.getAndIncrement() + 1));
        					map.put(MapKeyExportEnum.MATERIAL_CODE.key, "");
        					map.put(MapKeyExportEnum.MATERIAL_NAME.key, "");
        					map.put(MapKeyExportEnum.MATERIAL_BATCH.key, "");
        					map.put(MapKeyExportEnum.MATERIAL_UNIT.key, "");
        					map.put(MapKeyExportEnum.MATERIAL_QUANTITY.key, "");
        					map.put(MapKeyExportEnum.MATERIAL_WEIGHT.key, "");
        					map.put(MapKeyExportEnum.MATERIAL_NOTE.key, "");
        					
        					if(StringUtils.isNotBlank(item.getCode())) {
        						map.put(MapKeyExportEnum.MATERIAL_CODE.key, MaterialCodeConvertHelper.convertToCodeNumber(item.getCode()));
        					}
        					if(StringUtils.isNotBlank(item.getName())) {
        						map.put(MapKeyExportEnum.MATERIAL_NAME.key, item.getName());
        					}
        					if(StringUtils.isNotBlank(item.getBatch())) {
        						map.put(MapKeyExportEnum.MATERIAL_BATCH.key, item.getBatch());
        					}
        					if(StringUtils.isNotBlank(item.getUnit())) {
        						map.put(MapKeyExportEnum.MATERIAL_UNIT.key, item.getUnit());
        					}
        					if(item.getActuallyImported() != null) {
        						map.put(MapKeyExportEnum.MATERIAL_QUANTITY.key, String.valueOf(item.getActuallyImported()));
        						totalQuantities.add(item.getActuallyImported());
        					}
        					if(item.getGrossWeight() != null) {
        						map.put(MapKeyExportEnum.MATERIAL_WEIGHT.key, String.valueOf(item.getGrossWeight()));
        						totalWeights.add(item.getGrossWeight());
        					}
        					if(StringUtils.isNotBlank(item.getNote())) {
        						map.put(MapKeyExportEnum.MATERIAL_NOTE.key, item.getNote());
        					}
        					infoMaterials.add(map);
        				});
        			}
        			List<Map<String, String>> infoTotals = new ArrayList<>();
        			// tinh tong so luong
        			Map<String,String> infoTotal = new HashMap<String,String>();
        			if(!totalQuantities.isEmpty()) {
        				BigDecimal totalQuantity = totalQuantities.stream().reduce(BigDecimal.ZERO, BigDecimal::add);  // tong so luong 
        				infoTotal.put(MapKeyExportEnum.TOTAL_QUANTITY.key, String.valueOf(totalQuantity));
        			} else {
        				infoTotal.put(MapKeyExportEnum.TOTAL_QUANTITY.key, "");
        			}
        			// tinh tong khoi luong
        			if(!totalWeights.isEmpty()) {
        				BigDecimal totalWeight = totalWeights.stream().reduce(BigDecimal.ZERO, BigDecimal::add);  // tong khoi luong
        				infoTotal.put(MapKeyExportEnum.TOTAL_WEIGHT.key, String.valueOf(totalWeight));
        			} else {
        				infoTotal.put(MapKeyExportEnum.TOTAL_WEIGHT.key, "");
        			}
        			infoTotals.add(infoTotal);
        			
        			VariablePrepare.prepare(wmlPackage);
        			wmlPackage.getMainDocumentPart().variableReplace(mappings);
        			
        			List<Object> tables = docx4jUtils.getAllElementFromObject(wmlPackage.getMainDocumentPart() , Tbl.class);
        			for (Iterator<Object> iterator = tables.iterator(); iterator.hasNext();) {
        				Object tbl = iterator.next();
        				List<?> textElements = docx4jUtils.getAllElementFromObject(tbl, Text.class);
        				for (Object text : textElements) {
        					Text textElement = (Text) text;
        					if (textElement.getValue() != null) {
        						if (textElement.getValue().equals(MapKeyExportEnum.MATERIAL_NO.key)){
        							docx4jUtils.replaceTable(infoMaterials, (Tbl) tbl);
        						} else if(textElement.getValue().equals(MapKeyExportEnum.TOTAL_QUANTITY.key)) {
        							docx4jUtils.replaceTable(infoTotals, (Tbl) tbl);
        						}
        					}
        				}
        			}
        			save(response, wmlPackage, getExportName(FileExportNameEnum.GOODS_RECEIPT.val,goodsReceipt.getTransCode()));
        		} else {
        			log.error("===> ERROR EXPORT GOODS_RECEIPT TO WORD: GOODS_RECEIPT is null");
        		}
    		} catch (Exception e) {
    			log.error("===> ERROR EXPORT GOODS_RECEIPT TO WORD: EXCEPTION: {}", e.getMessage());
			}
    	} else {
    		log.error("===> ERROR EXPORT GOODS_RECEIPT TO WORD: GOODS_RECEIPT_ID is null");
    	}
    }

	@SuppressWarnings({"static-access" })
	@GetMapping("/goodsIssue/export/{id}")
    public void exportGoodsIssue(@PathVariable(value="id") Long id, HttpServletRequest request, HttpServletResponse response) {
		log.debug("ENTERING 'EXPORT GOODS_ISSUE TO WORD' METHOD...");
    	ObjectMapper mapper = new ObjectMapper();
    	List<Map<String, String>> infoMaterials = new ArrayList<>();
    	if(id != null) {
    		try {
    			GoodsIssueDto goodsIssue = goodsIssueManager.get(id);
        		if(goodsIssue != null) {
        			HashMap<String, String> mappings = new HashMap<>();
            		GoodsIssueJson json = convertGoodsIssueToJson(goodsIssue);
            		String jsonData = mapper.writeValueAsString(json);
            		
        			// check xem se su dung template nao, neu phieu xuat co thong tin trai xuat trai nhan thi dùng template phieu dieu chuyen
        			StringBuilder templateName = new StringBuilder();
        			if(StringUtils.isNotBlank(goodsIssue.getFromStockCode()) && StringUtils.isNotBlank(goodsIssue.getToStockCode())) {
        				templateName.append(FileExportNameEnum.GOODS_ISSUE_INTERNAL.val);
        				
        				FarmDto farmI = farmManager.getByFarmCode(goodsIssue.getFromStockCode());
                		if(farmI != null) {
                			String stockName = farmI.getName() != null ?  farmI.getName() : "";
                			mappings.put(MapKeyExportEnum.FROM_STOCK_NAME.key, convertSpecialChar(stockName));
                		} else {
                			mappings.put(MapKeyExportEnum.FROM_STOCK_NAME.key, "");
                		}
                		
                		FarmDto farmR = farmManager.getByFarmCode(goodsIssue.getToStockCode());
                		if(farmR != null) {
                			String stockName = farmR.getName() != null ?  farmR.getName() : "";
                			mappings.put(MapKeyExportEnum.TO_STOCK_NAME.key, convertSpecialChar(stockName));
                		} else {
                			mappings.put(MapKeyExportEnum.TO_STOCK_NAME.key, "");
                		}
        			} else {
        				templateName.append(FileExportNameEnum.GOODS_ISSUE.val);
        				
        				FarmDto farmDto = farmManager.getByFarmCode(goodsIssue.getFromStockCode());
                		if(farmDto != null) {
                			String stockAddress = farmDto.getAddress() != null ?  farmDto.getAddress() : "";
                			String stockName = farmDto.getName() != null ?  farmDto.getName() : "";
                			mappings.put(MapKeyExportEnum.FROM_STOCK_NAME.key, convertSpecialChar(stockName));
                			mappings.put(MapKeyExportEnum.FROM_STOCK_ADDRESS.key, convertSpecialChar(stockAddress));
                		} else {
                			mappings.put(MapKeyExportEnum.FROM_STOCK_NAME.key, "");
                			mappings.put(MapKeyExportEnum.FROM_STOCK_ADDRESS.key, "");
                		}
        			}
        			
        			String bookmarkName = "Bookmark";
            		WordprocessingMLPackage wmlPackage = docx4jUtils.getTemplate(getTemplatePath(templateName.toString()));
            		MainDocumentPart mainDocumentPart = wmlPackage.getMainDocumentPart();
            		Document wmlDoc = (Document) mainDocumentPart.getJaxbElement();
        	        Body body = wmlDoc.getBody();
        	                 // Extract all paragraphs in the body
        	        List<Object> paragraphs = body.getContent();
        	                 // cursor to extract bookmarks and create bookmarks
        	        RangeFinder rt = new RangeFinder("CTBookmark", "CTMarkupRange");
        	        new TraversalUtil(paragraphs, rt);

			         byte[] fileContent =  getQRCodeImage(jsonData, 600, 600);
			         for (CTBookmark bm:rt.getStarts()) {
                         // This can be done on a single bookmark, or all bookmarks can be processed with a map
			            if (bm.getName().equals(bookmarkName)){      
	                         // Read the image and convert it to a byte array, because docx4j can only insert images in a byte array
	                         // wear an inline image
			                BinaryPartAbstractImage imagePart = BinaryPartAbstractImage.createImagePart(wmlPackage, fileContent);
			                
                           // The first four parameters of the createImageInline function I have not found the specific meaning,,,,
                           // The most one is to limit the width of the image, the basis for scaling
			                Inline inline = imagePart.createImageInline(null, null, 0,1, false, 2400);
			                // Get the parent paragraph of the bookmark
			                P p = (P)(bm.getParent());
			                
			                ObjectFactory factory = new ObjectFactory();
                            // The R object is an anonymous complex type, but I don't know the specific meaning. I guess it is necessary to take a look at ooxml.
			                R run = factory.createR();
                            // drawing is understood as a canvas?
			                Drawing drawing = factory.createDrawing();
			                drawing.getAnchorOrInline().add(inline);
			                run.getContent().add(drawing);
			                p.getContent().add(run);
			            }
			        }
            		
            		String customerName = goodsIssue.getCustomerName() != null ?  goodsIssue.getCustomerName() : "";
            		String poCode  = goodsIssue.getPoCode() != null ?  goodsIssue.getPoCode() : "";
            		String doCode  = goodsIssue.getDoCode() != null ?  goodsIssue.getDoCode() : "";
            		String licensePlate  = goodsIssue.getLicensePlate() != null ?  goodsIssue.getLicensePlate() : "";
            		String movementType = "";
            		if(StringUtils.isNotBlank(goodsIssue.getMovementType())) {
            			StringBuilder key = new StringBuilder();
            			key.append("goodsissue.movement.type.").append(goodsIssue.getMovementType());
            			movementType = getText(key.toString(), request.getLocale());
            		}
            		
            		LocalDate postingDate = goodsIssue.getPostingDate();
            		mappings.put(MapKeyExportEnum.DAY.key, convertSpecialChar(String.valueOf(postingDate.getDayOfMonth())));
        			mappings.put(MapKeyExportEnum.MONTH.key, convertSpecialChar(String.valueOf(postingDate.getMonthValue())));
        			mappings.put(MapKeyExportEnum.YEAR.key, convertSpecialChar(String.valueOf(postingDate.getYear())));
            		
            		mappings.put(MapKeyExportEnum.CUSTOMER_NAME.key, convertSpecialChar(customerName));
        			mappings.put(MapKeyExportEnum.PO_CODE.key, convertSpecialChar(poCode));
        			mappings.put(MapKeyExportEnum.DO_CODE.key, convertSpecialChar(doCode));
        			mappings.put(MapKeyExportEnum.MOVEMENT_TYPE.key, convertSpecialChar(movementType));
        			mappings.put(MapKeyExportEnum.LICENSE_PLATE.key, convertSpecialChar(licensePlate));
        			
        			List<BigDecimal> totalQuantities = new ArrayList<>(); //tong so luong
        			List<BigDecimal> totalReqQuantities = new ArrayList<>(); //tong so luong tu phieu yeu cau
        			List<BigDecimal> totalWeights = new ArrayList<>();  // tong trong luong 
        			List<BigDecimal> totalReqWeights = new ArrayList<>(); // tong trong luong tu phieu yeu cau
        			if(!CollectionUtils.isEmpty(goodsIssue.getMaterialDetails())) {
        				AtomicInteger index = new AtomicInteger();
        				goodsIssue.getMaterialDetails().stream().forEach(item ->{
        					Map<String,String> map = new HashMap<String,String>();
        					map.put(MapKeyExportEnum.MATERIAL_NO.key, String.valueOf(index.getAndIncrement() + 1));
        					map.put(MapKeyExportEnum.MATERIAL_CODE.key, "");
        					map.put(MapKeyExportEnum.MATERIAL_NAME.key, "");
        					map.put(MapKeyExportEnum.MATERIAL_BATCH.key, "");
        					map.put(MapKeyExportEnum.MATERIAL_UNIT.key, "");
        					map.put(MapKeyExportEnum.MATERIAL_REQ_QUANTITY.key, "");
        					map.put(MapKeyExportEnum.MATERIAL_QUANTITY.key, "");
        					map.put(MapKeyExportEnum.MATERIAL_WEIGHT.key, "");
        					map.put(MapKeyExportEnum.MATERIAL_REQ_WEIGHT.key, "");
        					map.put(MapKeyExportEnum.MATERIAL_NOTE.key, "");
        					
        					if(StringUtils.isNotBlank(item.getCode())) {
        						map.put(MapKeyExportEnum.MATERIAL_CODE.key, MaterialCodeConvertHelper.convertToCodeNumber(item.getCode()));
        					}
        					if(StringUtils.isNotBlank(item.getName())) {
        						map.put(MapKeyExportEnum.MATERIAL_NAME.key, item.getName());
        					}
        					if(StringUtils.isNotBlank(item.getBatch())) {
        						map.put(MapKeyExportEnum.MATERIAL_BATCH.key, item.getBatch());
        					}
        					if(StringUtils.isNotBlank(item.getUnit())) {
        						map.put(MapKeyExportEnum.MATERIAL_UNIT.key, item.getUnit());
        					}
        					if(item.getQuantity() != null) {
        						map.put(MapKeyExportEnum.MATERIAL_REQ_QUANTITY.key, String.valueOf(item.getQuantity()));
        						totalReqQuantities.add(item.getQuantity());
        					}
        					if(item.getActuallyExported() != null) {
        						map.put(MapKeyExportEnum.MATERIAL_QUANTITY.key, String.valueOf(item.getActuallyExported()));
        						totalQuantities.add(item.getActuallyExported());
        					}
        					if(item.getWeight() != null) {
        						map.put(MapKeyExportEnum.MATERIAL_REQ_WEIGHT.key, String.valueOf(item.getWeight()));
        						totalReqWeights.add(item.getWeight());
        					}
        					if(item.getGrossWeight() != null) {
        						map.put(MapKeyExportEnum.MATERIAL_WEIGHT.key, String.valueOf(item.getGrossWeight()));
        						totalWeights.add(item.getGrossWeight());
        					}
        					if(StringUtils.isNotBlank(item.getNote())) {
        						map.put(MapKeyExportEnum.MATERIAL_NOTE.key, item.getNote());
        					}
        					infoMaterials.add(map);
        				});
        			}
        			List<Map<String, String>> infoTotals = new ArrayList<>();
        			// tinh tong so luong tu phieu yeu cau
        			Map<String,String> infoTotal = new HashMap<String,String>();
        			if(!totalReqQuantities.isEmpty()) {
        				BigDecimal totalReqQuantity = totalReqQuantities.stream().reduce(BigDecimal.ZERO, BigDecimal::add);  // tong so luong 
        				infoTotal.put(MapKeyExportEnum.TOTAL_REQ_QUANTITY.key, String.valueOf(totalReqQuantity));
        			} else {
        				infoTotal.put(MapKeyExportEnum.TOTAL_REQ_QUANTITY.key, "");
        			}
        			// tinh tong so luong
        			if(!totalQuantities.isEmpty()) {
        				BigDecimal totalQuantity = totalQuantities.stream().reduce(BigDecimal.ZERO, BigDecimal::add);  // tong so luong 
        				infoTotal.put(MapKeyExportEnum.TOTAL_QUANTITY.key, String.valueOf(totalQuantity));
        			} else {
        				infoTotal.put(MapKeyExportEnum.TOTAL_QUANTITY.key, "");
        			}
        			// tinh tong khoi luong tu phieu yeu cau
        			if(!totalReqWeights.isEmpty()) {
        				BigDecimal totalReqWeight = totalReqWeights.stream().reduce(BigDecimal.ZERO, BigDecimal::add);  // tong khoi luong
        				infoTotal.put(MapKeyExportEnum.TOTAL_REQ_WEIGHT.key, String.valueOf(totalReqWeight));
        			} else {
        				infoTotal.put(MapKeyExportEnum.TOTAL_REQ_WEIGHT.key, "");
        			}
        			// tinh tong khoi luong
        			if(!totalWeights.isEmpty()) {
        				BigDecimal totalWeight = totalWeights.stream().reduce(BigDecimal.ZERO, BigDecimal::add);  // tong khoi luong
        				infoTotal.put(MapKeyExportEnum.TOTAL_WEIGHT.key, String.valueOf(totalWeight));
        			} else {
        				infoTotal.put(MapKeyExportEnum.TOTAL_WEIGHT.key, "");
        			}
        			infoTotals.add(infoTotal);
        			
        			VariablePrepare.prepare(wmlPackage);
        			wmlPackage.getMainDocumentPart().variableReplace(mappings);
        			
        			List<Object> tables = docx4jUtils.getAllElementFromObject(wmlPackage.getMainDocumentPart() , Tbl.class);
        			for (Iterator<Object> iterator = tables.iterator(); iterator.hasNext();) {
        				Object tbl = iterator.next();
        				List<?> textElements = docx4jUtils.getAllElementFromObject(tbl, Text.class);
        				for (Object text : textElements) {
        					Text textElement = (Text) text;
        					if (textElement.getValue() != null) {
        						if (textElement.getValue().equals(MapKeyExportEnum.MATERIAL_NO.key)){
        							docx4jUtils.replaceTable(infoMaterials, (Tbl) tbl);
        						} else if(textElement.getValue().equals(MapKeyExportEnum.TOTAL_QUANTITY.key)) {
        							docx4jUtils.replaceTable(infoTotals, (Tbl) tbl);
        						}
        					}
        				}
        			}
        			save(response, wmlPackage, getExportName(templateName.toString(),goodsIssue.getTransCode()));
        		} else {
            		log.error("===> ERROR EXPORT GOODS_ISSUE TO WORD: GOODS_ISSUE is null");
        		}
    		} catch (Exception e) {
    			log.error("===> ERROR EXPORT GOODS_ISSUE TO WORD: EXCEPTION: {}", e);
    		}
    	} else {
    		log.error("===> ERROR EXPORT GOODS_ISSUE TO WORD: GOODS_ISSUE_ID is null");
    	}
    	
    }
	
    private static String convertSpecialChar(String convertString) {
		return StringUtils.replace(convertString, "&", "&amp;");
	}
    
    private String createNameFile(String baseName) {
    	log.info("PROCESS: CREATE NAME_FILE");
		DateFormat dateFormat = new SimpleDateFormat(DatePatternEnum.YYYY_MM_DD__HH_MM_SS_1.pattern);
		String dateTimeInfo = dateFormat.format(new Date());
		return baseName.concat(String.format("_%s.xlsx", dateTimeInfo));
	}
    
    /*
     * generate QR_CODE IMAGE
     */
    private static byte[] getQRCodeImage(String text, int width, int height) {
    	log.info("PROCESS: GET QR_CODE IMAGE");
    	try {
			QRCodeWriter qrCodeWriter = new QRCodeWriter();
			BitMatrix bitMatrix = qrCodeWriter.encode(text, BarcodeFormat.QR_CODE, width, height);
			ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
			MatrixToImageWriter.writeToStream(bitMatrix, "png", byteArrayOutputStream);
			return byteArrayOutputStream.toByteArray();
		} catch (Exception e) {
			log.error("===> ERROR GENERATE QR_CODE IMAGE: EXCEPTION: {}", e);
			return null;
		}
	}
    
    /*
     * convert GOODS_ISSUE về JSON để generate QR_CODE
     */
    private GoodsIssueJson convertGoodsIssueToJson(GoodsIssueDto goodsIssue) {
		log.info("PROCESS: CONVERT GOODS_ISSUE TO JSON");
		GoodsIssueJson goodsIssueJson = new GoodsIssueJson();
		ObjectMapper mapper = new ObjectMapper();
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
		try {
			if(StringUtils.isNotBlank(goodsIssue.getPoCode())) {
				goodsIssueJson.setPoCode(goodsIssue.getPoCode());
			} else {
				goodsIssueJson.setPoCode("");
			}
			
			if(StringUtils.isNotBlank(goodsIssue.getDoCode())) {
				goodsIssueJson.setDoCode(goodsIssue.getDoCode());
			} else {
				goodsIssueJson.setDoCode("");
			}
			
		} catch (Exception e) {
			log.error("===> ERROR CONVERT GOODS_ISSUE TO JSON: EXCEPTION: {}", e);
		}
		return goodsIssueJson;
	}

    //=========EXPORT AND IMPORT MATERIAL============//
    @PostMapping("/materialSupport/import")
    public String importData(@RequestParam(name ="inputImport", required = true) MultipartFile excelFile,HttpServletRequest request) {
    	log.info("ENTERING 'IMPORT DATA MATERIAL_SUPPORT' METHOD...");
		try {
			readFileExcelImportMaterialSupport(excelFile);
			addMessage(request, getText("import.status.success", request.getLocale()));
		} catch (Exception e) {
			log.error("ERROR IMPORT DATA MATERIAL_SUPPORT: EXCEPTION: {}", e);
			addError(request, e.getMessage());
		}
        return "redirect:/material/list";
    }
    
    /*
     * Đọc thông tin file import MATERIAL_SUPPORT
     */
    private void readFileExcelImportMaterialSupport(MultipartFile excelFile) throws Exception {
    	log.info("PROCESS: READ FILE EXCEL IMPORT DATA MATERIAL_SUPPORT");
		List<MaterialSupportDto> materialSupportDtos = new ArrayList<>();
		int i = 1;
		XSSFWorkbook workbook = new XSSFWorkbook(excelFile.getInputStream());
		XSSFSheet worksheet = workbook.getSheetAt(0);
		while (i <= worksheet.getLastRowNum()) {
			MaterialSupportDto materialSupportDto = new MaterialSupportDto();
			XSSFRow dataRow = worksheet.getRow(i++);
			if(dataRow.getCell(0) != null) {
				if(dataRow.getCell(0).getCellType().equals(CellType.STRING)) {
					materialSupportDto.setCode(dataRow.getCell(0).getStringCellValue());
				} else if(dataRow.getCell(0).getCellType().equals(CellType.NUMERIC)) {
					String code = String.format("%.0f", dataRow.getCell(0).getNumericCellValue());
					materialSupportDto.setCode(MaterialCodeConvertHelper.convertToCode18Char(code));
				} 
			}
			if(dataRow.getCell(1) != null) {
				materialSupportDto.setFastCode(dataRow.getCell(1).getStringCellValue());
			}
			if(dataRow.getCell(2) != null) {
				materialSupportDto.setName(dataRow.getCell(2).getStringCellValue());
			}
			if(dataRow.getCell(3) != null) {
				materialSupportDto.setSuggestName(dataRow.getCell(3).getStringCellValue());
			}
			if(dataRow.getCell(4) != null) {
				materialSupportDto.setUnit(dataRow.getCell(4).getStringCellValue());
			}
			if(dataRow.getCell(5) != null) {
				materialSupportDto.setIndustryStandardDescription(dataRow.getCell(5).getStringCellValue());
			}
			if(dataRow.getCell(6) != null) {
				materialSupportDto.setStatus(dataRow.getCell(6).getStringCellValue());
			}
			materialSupportDtos.add(materialSupportDto);
		}
		materialSupportManager.saves(materialSupportDtos);
		workbook.close();
	}
    
    @GetMapping("/materialSupport/export")
    public void exportMaterialSupport(HttpServletRequest request, HttpServletResponse response) throws IOException{
    	log.info("ENTERING 'EXPORT MATERIAL_SUPPORT' METHOD...");
    	
    	Integer sumCell = 7;
		String[] headerText = {
				getText("export.material.code", request.getLocale()),getText("export.fast.code", request.getLocale()),
				getText("export.material.name", request.getLocale()), getText("export.material.suggest.name", request.getLocale()),
				getText("export.material.unit", request.getLocale()),getText("export.material.suggest.unit", request.getLocale()),
				getText("export.material.status", request.getLocale())
				};
		
		XSSFWorkbook workbook = new XSSFWorkbook();
		try {
			XSSFSheet sheet = workbook.createSheet("MATERIAL");
			writeHeader(sheet, sumCell, headerText);
			List<MaterialSupportDto> materialSupportDtos = materialSupportManager.gets();
			writeMaterialSupports(sheet, materialSupportDtos);
			String fileLocation = createNameFile(getText("export.material.support", request.getLocale()));
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
    
    /*
     * ghi thông tin MATERIAL_SUPPORT ra file EXCEL
     */
    private void writeMaterialSupports(XSSFSheet sheet, List<MaterialSupportDto> materialSupportDtos) {
    	log.info("PROCESS: WRITE MATERIAL_SUPPORTS TO FILE");
		Integer rowNum = 1;
		if(materialSupportDtos != null && !materialSupportDtos.isEmpty()) {
			for(MaterialSupportDto item : materialSupportDtos) {
				Row row = sheet.createRow(rowNum++);
				Integer column = 0;
				Cell cell = row.createCell(column++);
				cell.setCellValue(item.getCode() != null ? MaterialCodeConvertHelper.convertToCodeNumber(item.getCode()) : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getFastCode() != null ? item.getFastCode() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getName() != null ? item.getName() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getSuggestName() != null ? item.getSuggestName() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getUnit() != null ? item.getUnit() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getIndustryStandardDescription() != null ? item.getIndustryStandardDescription() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.isSelected() ? MaterialSupportStatusEnum.ENABLED.val : MaterialSupportStatusEnum.DISABLED.val);
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
	
	private void writeHeader(XSSFSheet sheet, Integer sumCell, List<String> headerText) {
		log.info("PROCESS: WRITE HEADER FILE EXCEL");
		Row headerRow = sheet.createRow(0);
		for (int i = 0; i < sumCell; i++) {
			headerRow.createCell(i).setCellValue(headerText.get(i));
		}
	}
	
	private void writeHeaderForReportFarmAnalyst(XSSFSheet sheet, Integer sumCell, String[] headerText) {
		log.info("PROCESS: WRITE HEADER FILE EXCEL");
		Row headerRow = sheet.createRow(1);
		for (int i = 0; i < sumCell; i++) {
			headerRow.createCell(i).setCellValue(headerText[i]);
		}
	}
	//=========EXPORT AND IMPORT MATERIAL============//
	
	
	//=========EXPORT FORM AND TOOL============//
    @PostMapping("/goodsAttritionSupport/export")
    public void exportGoodsAttrition(@Valid GoodsIssueDto goodsIssue,HttpServletRequest request, HttpServletResponse response) throws IOException{
    	log.info("ENTERING 'EXPORT GOODS_ATTRITION' METHOD...");
    	
    	Integer sumCell = 9;
		String[] headerText = {
				getText("export.process.order.code", request.getLocale()), getText("export.material.code", request.getLocale()),
				getText("export.posting.date", request.getLocale()), getText("export.plant", request.getLocale()),
				getText("export.farm.code", request.getLocale()),getText("export.material.quantity", request.getLocale()),
				getText("export.material.unit", request.getLocale()),getText("export.material.batch", request.getLocale()),
				getText("export.barn.code", request.getLocale()),
				};
		
		XSSFWorkbook workbook = new XSSFWorkbook();
		try {
			XSSFSheet sheet = writeHeaderGoodsAttrition(workbook, sumCell, headerText, request);
			List<ItemExportDto> itemExportDtos = getGoodsIssues(goodsIssue);
			writeGoodsAttritions(sheet, itemExportDtos);
			String fileLocation = createNameFile(getText("export.goods.attrition", request.getLocale()));
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
    
    /*
     * lấy thông tin chi tiết GOODS_ISSUE để EXPORT FILE
     */
    private List<ItemExportDto> getGoodsIssues(GoodsIssueDto goodsIssue) {
		log.info("PROCESS: GET GOODS_ISSUE, GOODS_ISSUE: {}", goodsIssue);
		ObjectMapper mapper = new ObjectMapper();
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
		List<GoodsIssueDto> goodsIssueDtos = goodsIssueManager.getGoodsIssues(goodsIssue);
		List<ItemExportDto> itemExportDtos = new ArrayList<>();
		if(goodsIssueDtos != null && !goodsIssueDtos.isEmpty()) {
			goodsIssueDtos.stream().forEach(item ->{
				String postingDate = DateTimeFormatter.ofPattern(DatePatternEnum.YYYYMMDD.pattern).format(item.getPostingDate());
				String[] arr = StringUtils.split(item.getStock().getCode(), SymbolEnum.DOT.val);
				ProcessOrderDto processOrderDto = processOrderManager.getByCode(item.getProcessOrderCode());
				
				if(!CollectionUtils.isEmpty(item.getMaterialDetails())) {
					item.getMaterialDetails().stream().forEach(material ->{
						ItemExportDto itemExport = new ItemExportDto();
						itemExport.setProcessOrderCode(processOrderDto.getCode());
						itemExport.setMaterialCode(MaterialCodeConvertHelper.convertToCodeNumber(material.getCode()));
						itemExport.setPostingDate(postingDate);
						itemExport.setPlant(arr[0]);
						itemExport.setFarmCode(arr[1]);
						itemExport.setQuantity(material.getActuallyExported());
						itemExport.setUnit(material.getUnit());
						itemExport.setBatch(material.getBatch());
						itemExport.setBarnCode(processOrderDto.getBatch());
						itemExportDtos.add(itemExport);
					});
				}
			});
		}
		return itemExportDtos;
	}
	
    private XSSFSheet writeHeaderGoodsAttrition(XSSFWorkbook workbook, Integer sumCell, String[] headerText, HttpServletRequest request) {
    	log.info("PROCESS: WRITE HEADER GOODS_ATTRITION_SUPPORT");
    	XSSFSheet sheet = workbook.createSheet("GOODS_ISSUE");
    	Row row = sheet.createRow(1);
    	
	    CellStyle styleTitle = workbook.createCellStyle();
	    Font font = workbook.createFont();
        font.setColor(IndexedColors.RED.getIndex());
        styleTitle.setFont(font);
        
	    Cell cellTitle = row.createCell(3);
	    cellTitle.setCellValue(getText("export.title", request.getLocale()));
	    cellTitle.setCellStyle(styleTitle);
	    
		Row headerRow = sheet.createRow(2);
		for (int i = 0; i < sumCell; i++) {
			Cell cell = headerRow.createCell(i);
			cell.setCellValue(headerText[i]);
			cell.setCellStyle(styleTitle);
		}
		return sheet;
	}
    
	private void writeGoodsAttritions(XSSFSheet sheet, List<ItemExportDto> itemExportDtos) {
		log.info("PROCESS: WRITE GOODS_ATTRITION_SUPPORT TO FILE");
		Integer rowNum = 3;
		if(itemExportDtos != null && !itemExportDtos.isEmpty()) {
			for(ItemExportDto item : itemExportDtos) {
				Row row = sheet.createRow(rowNum++);
				Integer column = 0;
				Cell cell = row.createCell(column++);
				cell.setCellValue(item.getProcessOrderCode() != null ? item.getProcessOrderCode() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getMaterialCode() != null ? item.getMaterialCode() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getPostingDate() != null ? item.getPostingDate() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getPlant() != null ? item.getPlant() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getFarmCode() != null ? item.getFarmCode() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getQuantity() != null ? item.getQuantity().doubleValue() : 0);
				cell = row.createCell(column++);
				cell.setCellValue(item.getUnit() != null ? item.getUnit() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getBatch() != null ? item.getBatch() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getBarnCode() != null ? item.getBarnCode() : "");
			}
		}
	}
	
	@GetMapping("/goodsAttritionSupport/stockCode/export")
    public void exportGoodsAttritionByStockCode(@RequestParam(name = "stockCode") String stockCode, @RequestParam(name = "postingDate") String postingDate,
    		HttpServletRequest request, HttpServletResponse response) throws IOException{
    	log.info("ENTERING 'EXPORT GOODS_ATTRITION' METHOD...");
    	
		XSSFWorkbook workbook = new XSSFWorkbook();
		try {
			XSSFSheet sheet = workbook.createSheet("GOODS_ISSUE");
			
			LocalDate posting = DateTimeHelper.toLocalDate(postingDate, DatePatternEnum.DD_MM_YYYY_2.pattern);
			
			GoodsIssueDto criteria = new GoodsIssueDto();
			criteria.setStockCode(stockCode);
			criteria.setPostingDate(posting);	
			
			GoodsIssueDto itemExportDtos = goodsIssueManager.getGoodsIssuesReport(criteria);
			writeGoodsAtritionsReport(sheet, itemExportDtos, workbook);
			
			Resource sourceFile = new ClassPathResource("templates/logo.png");
			InputStream logo = sourceFile.getInputStream();
			byte[] inputImageBytes = IOUtils.toByteArray(logo);
			
			int logoPigture = workbook.addPicture(inputImageBytes, Workbook.PICTURE_TYPE_PNG);
			XSSFDrawing drawing = (XSSFDrawing) sheet.createDrawingPatriarch();
			XSSFClientAnchor logoAnchor = new XSSFClientAnchor();
			logoAnchor.setCol1(0);
			logoAnchor.setCol2(1);
			logoAnchor.setRow1(0);
			logoAnchor.setRow2(2);
			drawing.createPicture(logoAnchor, logoPigture);
			
			String fileLocation = createNameFile(getText("export.goods.attrition", request.getLocale()));
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
	
	private void writeGoodsAtritionsReport(XSSFSheet sheet, GoodsIssueDto item, XSSFWorkbook workbook) {
		if(item == null) return;
		
		Font boldFont = workbook.createFont();
		boldFont.setBold(true);
		XSSFCellStyle boldStyle = workbook.createCellStyle();
		boldStyle.setFont(boldFont);
		
		Font boldHeaderFont = workbook.createFont();
		boldHeaderFont.setBold(true);
		boldHeaderFont.setFontHeight((short) 300);
		XSSFCellStyle boldHeaderStyle = workbook.createCellStyle();
		boldHeaderStyle.setFont(boldHeaderFont);
		
		XSSFCellStyle borderStyle = workbook.createCellStyle();
		borderStyle.setBorderTop(BorderStyle.THIN);
		borderStyle.setBorderBottom(BorderStyle.THIN);
		borderStyle.setBorderLeft(BorderStyle.THIN);
		borderStyle.setBorderRight(BorderStyle.THIN);
		borderStyle.setWrapText(true);		
		
		XSSFCellStyle borderBoldStyle = workbook.createCellStyle();
		borderBoldStyle.setBorderTop(BorderStyle.THIN);
		borderBoldStyle.setBorderBottom(BorderStyle.THIN);
		borderBoldStyle.setBorderLeft(BorderStyle.THIN);
		borderBoldStyle.setBorderRight(BorderStyle.THIN);
		borderBoldStyle.setWrapText(true);
		borderBoldStyle.setFont(boldFont);
		
		Integer rowNum = 0;
		Row row = sheet.createRow(rowNum);
		row.setHeight((short) 1000);
		Cell cell = row.createCell(1);
		cell.setCellValue("CÔNG TY CP CHĂN NUÔI MAVIN");
		cell.setCellStyle(boldStyle);
		
		rowNum++;
		row = sheet.createRow(rowNum);
		cell = row.createCell(1);
		cell.setCellValue("Trại: "+ item.getStock().getName());
		cell.setCellStyle(boldStyle);
		
		cell = row.createCell(7);
		StringBuilder builder = new StringBuilder();
		builder = builder.append("Ngày ").append(item.getPostingDate().getDayOfMonth()).append(" tháng ").append(item.getPostingDate().getMonthValue()).
				append(" năm ").append(item.getPostingDate().getYear());
		
		cell.setCellValue(builder.toString());
		cell.setCellStyle(boldStyle);
		
		rowNum++;
		row = sheet.createRow(rowNum);
		row.setHeight((short) 600);
		cell = row.createCell(0);
		cell.setCellValue("SỔ XUẤT THUỐC, CÁM VÀ VẬT TƯ");
		cell.setCellStyle(boldHeaderStyle);
		CellUtil.setAlignment(cell, HorizontalAlignment.CENTER);
		CellUtil.setVerticalAlignment(cell, VerticalAlignment.CENTER);
		sheet.addMergedRegion(new CellRangeAddress(row.getRowNum(),  row.getRowNum(), 0, 8));
		
		rowNum++;
		row = sheet.createRow(rowNum);
		cell = row.createCell(0);
		cell.setCellValue("STT");
		cell.setCellStyle(borderBoldStyle);
		CellUtil.setAlignment(cell, HorizontalAlignment.CENTER);
		CellUtil.setVerticalAlignment(cell, VerticalAlignment.CENTER);
		cell = row.createCell(1);
		cell.setCellValue("Vật tư Kỹ thuật đề nghị");
		cell.setCellStyle(borderBoldStyle);
		CellUtil.setAlignment(cell, HorizontalAlignment.CENTER);
		CellUtil.setVerticalAlignment(cell, VerticalAlignment.CENTER);
		cell = row.createCell(2);
		cell.setCellValue("Mã VT");
		cell.setCellStyle(borderBoldStyle);
		CellUtil.setAlignment(cell, HorizontalAlignment.CENTER);
		CellUtil.setVerticalAlignment(cell, VerticalAlignment.CENTER);
		cell = row.createCell(3);
		cell.setCellValue("ĐVT");
		cell.setCellStyle(borderBoldStyle);
		CellUtil.setAlignment(cell, HorizontalAlignment.CENTER);
		CellUtil.setVerticalAlignment(cell, VerticalAlignment.CENTER);
		cell = row.createCell(4);
		cell.setCellValue("Số lượng");
		cell.setCellStyle(borderBoldStyle);
		cell = row.createCell(5);
		cell.setCellStyle(borderBoldStyle);
		sheet.addMergedRegion(new CellRangeAddress(rowNum,  rowNum, 4, 5));
		CellUtil.setAlignment(cell, HorizontalAlignment.CENTER);
		CellUtil.setVerticalAlignment(cell, VerticalAlignment.CENTER);
		
		cell = row.createCell(6);
		cell.setCellValue("Xuất cho (chuồng)");
		cell.setCellStyle(borderBoldStyle);
		CellUtil.setAlignment(cell, HorizontalAlignment.CENTER);
		CellUtil.setVerticalAlignment(cell, VerticalAlignment.CENTER);
		cell = row.createCell(7);
		cell.setCellValue("Người nhận");
		cell.setCellStyle(borderBoldStyle);
		CellUtil.setAlignment(cell, HorizontalAlignment.CENTER);
		CellUtil.setVerticalAlignment(cell, VerticalAlignment.CENTER);
		cell = row.createCell(8);
		cell.setCellValue("số bao");
		cell.setCellStyle(borderBoldStyle);
		CellUtil.setAlignment(cell, HorizontalAlignment.CENTER);
		CellUtil.setVerticalAlignment(cell, VerticalAlignment.CENTER);
		
		rowNum++;
		row = sheet.createRow(rowNum);
		cell = row.createCell(0);
		cell.setCellStyle(borderBoldStyle);
		cell = row.createCell(1);
		cell.setCellStyle(borderBoldStyle);
		cell = row.createCell(2);
		cell.setCellStyle(borderBoldStyle);
		cell = row.createCell(3);
		cell.setCellStyle(borderBoldStyle);
		sheet.addMergedRegion(new CellRangeAddress(rowNum-1,  rowNum, 0, 0));
		sheet.addMergedRegion(new CellRangeAddress(rowNum-1,  rowNum, 1, 1));
		sheet.addMergedRegion(new CellRangeAddress(rowNum-1,  rowNum, 2, 2));
		sheet.addMergedRegion(new CellRangeAddress(rowNum-1,  rowNum, 3, 3));
		cell = row.createCell(4);
		cell.setCellValue("Đề nghị");
		cell.setCellStyle(borderBoldStyle);
		CellUtil.setAlignment(cell, HorizontalAlignment.CENTER);
		CellUtil.setVerticalAlignment(cell, VerticalAlignment.CENTER);
		cell = row.createCell(5);
		cell.setCellValue("Thực Xuất");
		cell.setCellStyle(borderBoldStyle);
		CellUtil.setAlignment(cell, HorizontalAlignment.CENTER);
		CellUtil.setVerticalAlignment(cell, VerticalAlignment.CENTER);
		cell = row.createCell(6);
		cell.setCellStyle(borderBoldStyle);
		cell = row.createCell(7);
		cell.setCellStyle(borderBoldStyle);
		cell = row.createCell(8);
		cell.setCellStyle(borderBoldStyle);
		sheet.addMergedRegion(new CellRangeAddress(rowNum-1,  rowNum, 6, 6));
		sheet.addMergedRegion(new CellRangeAddress(rowNum-1,  rowNum, 7, 7));
		sheet.addMergedRegion(new CellRangeAddress(rowNum-1,  rowNum, 8, 8));
		rowNum++;
		row = sheet.createRow(rowNum);
		
		
		if(!CollectionUtils.isEmpty(item.getMaterialDetails())) {
			int stt = 0;
			for(MaterialDetailDto ma : item.getMaterialDetails()) {
				stt++;
				row = sheet.createRow(rowNum++);
				Integer column = 0;
				cell = row.createCell(column++);
				cell.setCellValue(stt);
				cell.setCellStyle(borderStyle);
				CellUtil.setAlignment(cell, HorizontalAlignment.CENTER);
				CellUtil.setVerticalAlignment(cell, VerticalAlignment.CENTER);
				cell = row.createCell(column++);
				cell.setCellValue(ma.getName() != null ? ma.getName() : "");
				cell.setCellStyle(borderStyle);
				CellUtil.setAlignment(cell, HorizontalAlignment.CENTER);
				CellUtil.setVerticalAlignment(cell, VerticalAlignment.CENTER);
				cell = row.createCell(column++);
				cell.setCellValue(ma.getCode() != null ? ma.getCode() : "");
				cell.setCellStyle(borderStyle);
				CellUtil.setAlignment(cell, HorizontalAlignment.CENTER);
				CellUtil.setVerticalAlignment(cell, VerticalAlignment.CENTER);
				cell = row.createCell(column++);
				cell.setCellValue(ma.getUnit() != null ? ma.getUnit() : "");
				cell.setCellStyle(borderStyle);
				CellUtil.setAlignment(cell, HorizontalAlignment.CENTER);
				CellUtil.setVerticalAlignment(cell, VerticalAlignment.CENTER);
				cell = row.createCell(column++);
				cell.setCellValue("");
				cell.setCellStyle(borderStyle);
				CellUtil.setAlignment(cell, HorizontalAlignment.CENTER);
				CellUtil.setVerticalAlignment(cell, VerticalAlignment.CENTER);
				cell = row.createCell(column++);
				cell.setCellValue(ma.getActuallyExported() != null ? ma.getActuallyExported().doubleValue() : 0);
				cell.setCellStyle(borderStyle);
				CellUtil.setAlignment(cell, HorizontalAlignment.CENTER);
				CellUtil.setVerticalAlignment(cell, VerticalAlignment.CENTER);
				cell = row.createCell(column++);
				cell.setCellValue(ma.getBarnName() != null ? ma.getBarnName() : "");
				cell.setCellStyle(borderStyle);
				CellUtil.setAlignment(cell, HorizontalAlignment.CENTER);
				CellUtil.setVerticalAlignment(cell, VerticalAlignment.CENTER);
				cell = row.createCell(column++);
				cell.setCellValue("");
				cell.setCellStyle(borderStyle);
				CellUtil.setAlignment(cell, HorizontalAlignment.CENTER);
				CellUtil.setVerticalAlignment(cell, VerticalAlignment.CENTER);
				cell = row.createCell(column++);
				cell.setCellValue("");
				cell.setCellStyle(borderStyle);
				CellUtil.setAlignment(cell, HorizontalAlignment.CENTER);
				CellUtil.setVerticalAlignment(cell, VerticalAlignment.CENTER);
			}
		}
		
		rowNum++;
		row = sheet.createRow(rowNum);
		cell = row.createCell(1);
		cell.setCellValue("Thống kê");
		cell.setCellStyle(boldStyle);
		CellUtil.setAlignment(cell, HorizontalAlignment.CENTER);
		
		cell = row.createCell(4);
		cell.setCellValue("Kỹ thuật");
		cell.setCellStyle(boldStyle);
		CellUtil.setAlignment(cell, HorizontalAlignment.CENTER);
		
		cell = row.createCell(7);
		cell.setCellValue("Quản lí trại");
		cell.setCellStyle(boldStyle);
		CellUtil.setAlignment(cell, HorizontalAlignment.CENTER);
		
		rowNum++;
		row = sheet.createRow(rowNum);
		cell = row.createCell(1);
		cell.setCellValue("(Ký, Họ tên)");
		CellUtil.setAlignment(cell, HorizontalAlignment.CENTER);
		
		cell = row.createCell(4);
		cell.setCellValue("(Ký, Họ tên)");
		CellUtil.setAlignment(cell, HorizontalAlignment.CENTER);
		
		cell = row.createCell(7);
		cell.setCellValue("(Ký, Họ tên)");
		CellUtil.setAlignment(cell, HorizontalAlignment.CENTER);
		
		sheet.setColumnWidth(0, 12*256);
		sheet.setColumnWidth(1, 25*256);
		sheet.setColumnWidth(2, 18*256);
		sheet.setColumnWidth(3, 7*256);
		sheet.setColumnWidth(4, 10*256);
		sheet.setColumnWidth(5, 10*256);
		sheet.setColumnWidth(6, 15*256);
		sheet.setColumnWidth(7, 15*256);
		sheet.setColumnWidth(8, 15*256);
		
		sheet.getPrintSetup().setLandscape(true);
		sheet.getPrintSetup().setPaperSize(XSSFPrintSetup.A4_PAPERSIZE); 
		sheet.setRepeatingRows(CellRangeAddress.valueOf("4:5"));
		
	}
	//=========EXPORT FORM AND TOOLL============//
	
	//=========EXPORT GOODS_RECEIPT_TO_EXCEL_FILE==============//
	@GetMapping("/goodsReceipt/export-excel/{id}")
    public void exportGoodsReceiptToExcelFile(@PathVariable(value="id") Long id, HttpServletRequest request, HttpServletResponse response) throws IOException{
		log.info("ENTERING 'EXPORT GOODS_RECEIPT TO EXCEL' METHOD...");
    	
    	Integer sumCell = 21;
    	String[] headerText = {
    			getText("export.from.plant", request.getLocale()),getText("export.from.farm.code", request.getLocale()),
				getText("export.to.plant", request.getLocale()),getText("export.to.farm.code", request.getLocale()),
				getText("goodsreceipt.poCode", request.getLocale()),getText("goodsreceipt.doCode", request.getLocale()),
				getText("goodsreceipt.vendor", request.getLocale()),getText("goodsreceipt.vendorName", request.getLocale()),
				getText("goodsreceipt.postingDate", request.getLocale()),getText("goodsissue.typeTransaction", request.getLocale()),
				
				getText("purchaserequisition.materialCode", request.getLocale()),getText("purchaserequisition.materialName", request.getLocale()),
				getText("purchaserequisition.batch", request.getLocale()),getText("purchaserequisition.quantity", request.getLocale()),
				getText("purchaserequisition.unit", request.getLocale()),getText("goodsissue.grossweight", request.getLocale()),
				getText("goodsissue.weightUnit", request.getLocale()),getText("material.type", request.getLocale()),
				getText("purchaserequisition.manufacturedDate", request.getLocale()),getText("purchaserequisition.expiredDate", request.getLocale()),
				getText("purchaserequisition.note", request.getLocale()),
				};
		
		XSSFWorkbook workbook = new XSSFWorkbook();
		try {
			XSSFSheet sheet = workbook.createSheet("GOODS_RECEIPT");
			writeHeader(sheet, sumCell, headerText);
			List<ItemExportDto> itemExportDtos = getGoodsReceipt(id,request);
			writeGoodsReceipt(sheet, itemExportDtos);
			String fileLocation = createNameFile(getText("export.goods.receipt", request.getLocale()));
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
	
	/*
	 * lấy thông tin chi tiết GOODS_RECEIPT để EXPORT FILE
	 */
	private List<ItemExportDto> getGoodsReceipt(Long id, HttpServletRequest request) {
		log.info("PROCESS: GET GOODS_RECEIPT, GOODS_RECEIPT_ID: {}", id);
		ObjectMapper mapper = new ObjectMapper();
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
		
		List<ItemExportDto> itemExportDtos = new ArrayList<>();
		GoodsReceiptDto goodsReceipt = goodsReceiptManager.get(id);
		if(goodsReceipt != null) {
			String[] arrR = StringUtils.split(goodsReceipt.getToStockCode(), SymbolEnum.DOT.val);
			
			StringBuilder fromPlant = new StringBuilder();
			StringBuilder fromFarmCode = new StringBuilder();
			if(StringUtils.isNotBlank(goodsReceipt.getFromStockCode())) {
				String[] arrI = StringUtils.split(goodsReceipt.getFromStockCode(), SymbolEnum.DOT.val);
				fromPlant.append(arrI[0]);
				fromFarmCode.append(arrI[1]);
			}
			String toPlant = arrR[0];
			String toFarmCode = arrR[1];
			String poCode = goodsReceipt.getPoCode();
			String doCode = goodsReceipt.getDoCode();
			String vendor = goodsReceipt.getVendor();
			String vendorName = goodsReceipt.getVendorName();
			String postingDate = DateTimeHelper.toDateString(goodsReceipt.getPostingDate(), DatePatternEnum.YYYYMMDD.pattern);
			String transType = getText("goodsreceipt.movement.type." + goodsReceipt.getMovementType(), request.getLocale());
			
			if(!CollectionUtils.isEmpty(goodsReceipt.getMaterialDetails())) {
				goodsReceipt.getMaterialDetails().stream().forEach(item ->{
					ItemExportDto itemExport = new ItemExportDto();
					itemExport.setFromPlant(fromPlant.toString());
					itemExport.setFromFarmCode(fromFarmCode.toString());
					itemExport.setToPlant(toPlant);
					itemExport.setToFarmCode(toFarmCode);
					itemExport.setPoCode(poCode);
					itemExport.setDoCode(doCode);
					itemExport.setVendor(vendor);
					itemExport.setVendorName(vendorName);
					itemExport.setPostingDate(postingDate);
					itemExport.setTransType(transType);
					
					itemExport.setMaterialCode(MaterialCodeConvertHelper.convertToCodeNumber(item.getCode()));
					itemExport.setMaterialName(item.getName());
					itemExport.setBatch(item.getBatch());
					itemExport.setQuantity(item.getActuallyImported());
					itemExport.setUnit(item.getUnit());
					if(item.getGrossWeight() != null) {
						itemExport.setGrossWeight(item.getGrossWeight());
					} else {
						itemExport.setGrossWeight(BigDecimal.ZERO);
					}
					
					itemExport.setWeightUnit(item.getWeightUnit());
					itemExport.setMaterialType(getText("material.type." + item.getType(), request.getLocale()));
					
					if(item.getManufacturedDate() != null) {
						itemExport.setManufacturedDate(DateTimeHelper.toDateString(item.getManufacturedDate(), DatePatternEnum.YYYYMMDD.pattern));
					} else {
						itemExport.setManufacturedDate("");
					}
					
					if(item.getExpiredDate() != null) {
						itemExport.setExpiredDate(DateTimeHelper.toDateString(item.getExpiredDate(), DatePatternEnum.YYYYMMDD.pattern));
					} else {
						itemExport.setExpiredDate("");
					}
					itemExport.setNote(item.getNote());
					
					itemExportDtos.add(itemExport);
				});
			}
		}	
		return itemExportDtos;
	}
	
	private void writeGoodsReceipt(XSSFSheet sheet, List<ItemExportDto> itemExportDtos) {
		log.info("PROCESS: WRITE GOODS_RECEIPT TO FILE");
		Integer rowNum = 1;
		if(itemExportDtos != null && !itemExportDtos.isEmpty()) {
			for(ItemExportDto item : itemExportDtos) {
				Row row = sheet.createRow(rowNum++);
				Integer column = 0;
				Cell cell = row.createCell(column++);
				cell.setCellValue(item.getFromPlant() != null ? item.getFromPlant() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getFromFarmCode() != null ? item.getFromFarmCode() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getToPlant() != null ? item.getToPlant() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getToFarmCode() != null ? item.getToFarmCode() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getPoCode() != null ? item.getPoCode() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getDoCode() != null ? item.getDoCode() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getVendor() != null ? item.getVendor() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getVendorName() != null ? item.getVendorName() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getPostingDate() != null ? item.getPostingDate() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getTransType() != null ? item.getTransType() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getMaterialCode() != null ? item.getMaterialCode() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getMaterialName() != null ? item.getMaterialName() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getBatch() != null ? item.getBatch() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getQuantity() != null ? item.getQuantity().doubleValue() : 0);
				cell = row.createCell(column++);
				cell.setCellValue(item.getUnit() != null ? item.getUnit() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getGrossWeight() != null ? item.getGrossWeight().doubleValue() : 0);
				cell = row.createCell(column++);
				cell.setCellValue(item.getWeightUnit() != null ? item.getWeightUnit() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getMaterialType() != null ? item.getMaterialType() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getManufacturedDate() != null ? item.getManufacturedDate() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getExpiredDate() != null ? item.getExpiredDate() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getNote() != null ? item.getNote() : "");
			}
		}
	}
	//=========EXPORT GOODS_RECEIPT_TO_EXCEL_FILE==============//
	
	//=========EXPORT GOODS_ISSUE_TO_EXCEL_FILE==============//
	@GetMapping("/goodsIssue/export-excel/{id}")
    public void exportGoodsIssueToExcelFile(@PathVariable(value="id") Long id, HttpServletRequest request, HttpServletResponse response) throws IOException{
		log.info("ENTERING 'EXPORT GOODS_ISSUE TO EXCEL' METHOD...");
    	
    	Integer sumCell = 20;
    	String[] headerText = {
    			getText("export.from.plant", request.getLocale()),getText("export.from.farm.code", request.getLocale()),
				getText("export.to.plant", request.getLocale()),getText("export.to.farm.code", request.getLocale()),
				getText("goodsreceipt.poCode", request.getLocale()),getText("goodsreceipt.doCode", request.getLocale()),
				getText("goodsissue.customerCode", request.getLocale()),getText("goodsissue.customerName", request.getLocale()),
				getText("goodsreceipt.postingDate", request.getLocale()),getText("goodsissue.typeTransaction", request.getLocale()),
				getText("goodsissue.licensePlate", request.getLocale()),
				
				getText("purchaserequisition.materialCode", request.getLocale()),getText("purchaserequisition.materialName", request.getLocale()),
				getText("purchaserequisition.batch", request.getLocale()),getText("purchaserequisition.quantity", request.getLocale()),
				getText("purchaserequisition.unit", request.getLocale()),getText("goodsissue.grossweight", request.getLocale()),
				getText("goodsissue.weightUnit", request.getLocale()),
				getText("purchaserequisition.manufacturedDate", request.getLocale()),getText("purchaserequisition.expiredDate", request.getLocale()),
				};
		
		XSSFWorkbook workbook = new XSSFWorkbook();
		try {
			XSSFSheet sheet = workbook.createSheet("GOODS_ISSUE");
			writeHeader(sheet, sumCell, headerText);
			List<ItemExportDto> itemExportDtos = getGoodsIssue(id,request);
			writeGoodsIssue(sheet, itemExportDtos);
			String fileLocation = createNameFile(getText("export.goods.issue", request.getLocale()));
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
	
	/*
	 * lấy thông tin chi tiết GOODS_ISSUE để EXPORT FILE
	 */
	private List<ItemExportDto> getGoodsIssue(Long id, HttpServletRequest request) {
		log.info("PROCESS: GET GOODS_ISSUE, GOODS_ISSUE_ID: {}", id);
		ObjectMapper mapper = new ObjectMapper();
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
		
		List<ItemExportDto> itemExportDtos = new ArrayList<>();
		GoodsIssueDto goodsIssue = goodsIssueManager.get(id);
		if(goodsIssue != null) {
			String[] arrI = StringUtils.split(goodsIssue.getFromStockCode(), SymbolEnum.DOT.val);
			
			StringBuilder toPlant = new StringBuilder();
			StringBuilder toFarmCode = new StringBuilder();
			if(StringUtils.isNotBlank(goodsIssue.getToStockCode())) {
				String[] arrR = StringUtils.split(goodsIssue.getToStockCode(), SymbolEnum.DOT.val);
				toPlant.append(arrR[0]);
				toFarmCode.append(arrR[1]);
			}
			String fromPlant = arrI[0];
			String fromFarmCode = arrI[1];
			String poCode = goodsIssue.getPoCode();
			String doCode = goodsIssue.getDoCode();
			String customer = goodsIssue.getCustomer();
			String customerName = goodsIssue.getCustomerName();
			String postingDate = DateTimeHelper.toDateString(goodsIssue.getPostingDate(), DatePatternEnum.YYYYMMDD.pattern);
			String transType = getText("goodsissue.movement.type." + goodsIssue.getMovementType(), request.getLocale());
			String licensePlate = goodsIssue.getLicensePlate();
			
			if(!CollectionUtils.isEmpty(goodsIssue.getMaterialDetails())) {
				goodsIssue.getMaterialDetails().stream().forEach(item ->{
					ItemExportDto itemExport = new ItemExportDto();
					itemExport.setFromPlant(fromPlant);
					itemExport.setFromFarmCode(fromFarmCode);
					itemExport.setToPlant(toPlant.toString());
					itemExport.setToFarmCode(toFarmCode.toString());
					itemExport.setPoCode(poCode);
					itemExport.setDoCode(doCode);
					itemExport.setCustomer(customer);
					itemExport.setCustomerName(customerName);
					itemExport.setPostingDate(postingDate);
					itemExport.setTransType(transType);
					itemExport.setLicensePlate(licensePlate);
					
					itemExport.setMaterialCode(MaterialCodeConvertHelper.convertToCodeNumber(item.getCode()));
					itemExport.setMaterialName(item.getName());
					itemExport.setBatch(item.getBatch());
					itemExport.setQuantity(item.getActuallyExported());
					itemExport.setUnit(item.getUnit());
					if(item.getGrossWeight() != null) {
						itemExport.setGrossWeight(item.getGrossWeight());
					} else {
						itemExport.setGrossWeight(BigDecimal.ZERO);
					}
					
					itemExport.setWeightUnit(item.getWeightUnit());
					
					if(item.getManufacturedDate() != null) {
						itemExport.setManufacturedDate(DateTimeHelper.toDateString(item.getManufacturedDate(), DatePatternEnum.YYYYMMDD.pattern));
					} else {
						itemExport.setManufacturedDate("");
					}
					
					if(item.getExpiredDate() != null) {
						itemExport.setExpiredDate(DateTimeHelper.toDateString(item.getExpiredDate(), DatePatternEnum.YYYYMMDD.pattern));
					} else {
						itemExport.setExpiredDate("");
					}
					
					itemExportDtos.add(itemExport);
				});
			}
		}	
		return itemExportDtos;
	}
	
	private void writeGoodsIssue(XSSFSheet sheet, List<ItemExportDto> itemExportDtos) {
		log.info("PROCESS: WRITE GOODS_ISSUE TO FILE");
		Integer rowNum = 1;
		if(itemExportDtos != null && !itemExportDtos.isEmpty()) {
			for(ItemExportDto item : itemExportDtos) {
				Row row = sheet.createRow(rowNum++);
				Integer column = 0;
				Cell cell = row.createCell(column++);
				cell.setCellValue(item.getFromPlant() != null ? item.getFromPlant() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getFromFarmCode() != null ? item.getFromFarmCode() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getToPlant() != null ? item.getToPlant() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getToFarmCode() != null ? item.getToFarmCode() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getPoCode() != null ? item.getPoCode() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getDoCode() != null ? item.getDoCode() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getCustomer() != null ? item.getCustomer() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getCustomerName() != null ? item.getCustomerName() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getPostingDate() != null ? item.getPostingDate() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getTransType() != null ? item.getTransType() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getLicensePlate() != null ? item.getLicensePlate() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getMaterialCode() != null ? item.getMaterialCode() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getMaterialName() != null ? item.getMaterialName() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getBatch() != null ? item.getBatch() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getQuantity() != null ? item.getQuantity().doubleValue() : 0);
				cell = row.createCell(column++);
				cell.setCellValue(item.getUnit() != null ? item.getUnit() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getGrossWeight() != null ? item.getGrossWeight().doubleValue() : 0);
				cell = row.createCell(column++);
				cell.setCellValue(item.getWeightUnit() != null ? item.getWeightUnit() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getManufacturedDate() != null ? item.getManufacturedDate() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getExpiredDate() != null ? item.getExpiredDate() : "");
			}
		}
	}
	//=========EXPORT GOODS_RECEIPT_TO_EXCEL_FILE==============//
	
	//=========EXPORT REPORT_NXT_TO_EXCEL_FILE==============//
	@GetMapping("/report/instock-export-excel")
	public void exportReportInstock(@RequestParam(name ="stockCode", required = true) String stockCode
									, @RequestParam(name = "fromDate", required = true) String fromDate
									, @RequestParam(name = "toDate", required = true) String toDate
									, @RequestParam(name = "purchasingGroups", required = true) String purchasingGroups
									, HttpServletRequest request, HttpServletResponse response) throws Exception {
		log.info("***********CONTROLLER::processing=export-report-instock...");
		Integer sumCell = 9;
		String[] headerText = {
				getText("report.instock.title.no", request.getLocale()), getText("report.instock.title.materialCode", request.getLocale()),
				getText("report.instock.title.materialName", request.getLocale()), getText("report.instock.title.unit", request.getLocale()),
				getText("report.instock.title.amountEarlyStage", request.getLocale()), getText("report.instock.title.amountGR", request.getLocale()),
				getText("report.instock.title.amountGA", request.getLocale()), getText("report.instock.title.amountGI", request.getLocale()),
				getText("report.instock.title.amountFinalStage", request.getLocale())
		};
		XSSFWorkbook workbook = new XSSFWorkbook();
		try {
			XSSFSheet sheet = workbook.createSheet("REPORT_NXT");
			writeHeader(sheet, sumCell, headerText);
			ReportInstockDto criteria = ReportInstockDto.builder()
					.stockCode(stockCode)
					.fromDate(fromDate)
					.toDate(toDate)
					.purchasingGroups(purchasingGroups)
					.build();
			List<ReportInstockDto> reportInstocks = reportManager.handleReportInstock(criteria);
			writeReportInstock(sheet, reportInstocks);
			String fileLocation = createNameFile(getText("export.reportInstock", request.getLocale()));
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
	
	public void writeReportInstock(XSSFSheet sheet, List<ReportInstockDto> reportInstocks) {
		Integer rowNum = 1;
		Integer countNo = 1;
		if (reportInstocks != null && !reportInstocks.isEmpty()) {
			for (ReportInstockDto item : reportInstocks) {
				Row row = sheet.createRow(rowNum++);
				Integer column = 0;
				Cell cell = row.createCell(column++);
				cell.setCellValue(countNo);
				cell = row.createCell(column++);
				cell.setCellValue(item.getMaterialCode() != null ? item.getMaterialCode() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getMaterialName() != null ? item.getMaterialName() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getUnit() != null ? item.getUnit() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getAmountEarlyStage().doubleValue());
				cell = row.createCell(column++);
				cell.setCellValue(item.getAmountGR().doubleValue());
				cell = row.createCell(column++);
				cell.setCellValue(item.getAmountGA().doubleValue());
				cell = row.createCell(column++);
				cell.setCellValue(item.getAmountGI().doubleValue());
				cell = row.createCell(column++);
				cell.setCellValue(item.getAmountFinalStage().doubleValue());
				countNo++;
			}
		}
	}
	
	/*
	 * EXPORT Report-daily-average-weight
	 */
	@GetMapping("/report/daily-average-weight-export-excel")
	public void exportReportDailyAverageWeight(@RequestParam(name = "farmCodesStr") String farmCodesStr, @RequestParam(name = "stage") String stage,
			@RequestParam(name = "barnCodesStr") String barnCodesStr, @RequestParam(name = "weightRangesStr") String weightRangesStr,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		log.info("**********CONTROLLER::processing=export-report-daily-average-weight");
		Integer sumCell = 10;
		String[] headerText = {
			getText("report.table.th.processOrder", request.getLocale()),
			getText("processOrder.pigType", request.getLocale()),
			getText("report.table.th.chuong", request.getLocale()),
			getText("report.dailyaverageweight.table.th.bieuheo", request.getLocale()),
			getText("report.dailyaverageweight.table.th.amount", request.getLocale()),
			getText("report.dailyaverageweight.table.th.weigh", request.getLocale()),
			getText("report.dailyaverageweight.table.th.avgWeight", request.getLocale()),
			getText("report.dailyaverageweight.table.th.amount", request.getLocale()),
			getText("report.dailyaverageweight.table.th.weigh", request.getLocale()),
			getText("report.dailyaverageweight.table.th.avgWeight", request.getLocale()),
		};
		
		XSSFWorkbook workbook = new XSSFWorkbook();
		
		XSSFCellStyle normalStyle = workbook.createCellStyle();
		normalStyle.setBorderTop(BorderStyle.THIN);
		normalStyle.setBorderBottom(BorderStyle.THIN);
		normalStyle.setBorderLeft(BorderStyle.THIN);
		normalStyle.setBorderRight(BorderStyle.THIN);
		
		XSSFCellStyle hightlightStyle = workbook.createCellStyle();
		hightlightStyle.setBorderTop(BorderStyle.THIN);
		hightlightStyle.setBorderBottom(BorderStyle.THIN);
		hightlightStyle.setBorderLeft(BorderStyle.THIN);
		hightlightStyle.setBorderRight(BorderStyle.THIN);
		hightlightStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());  
		hightlightStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND); 
        
        String rgbS = "FFFF00";
        byte[] rgbB = Hex.decodeHex(rgbS);
        XSSFColor color = new XSSFColor(rgbB, null);
        
        XSSFCellStyle warnStyle = workbook.createCellStyle();
        warnStyle.setBorderTop(BorderStyle.THIN);
        warnStyle.setBorderBottom(BorderStyle.THIN);
        warnStyle.setBorderLeft(BorderStyle.THIN);
        warnStyle.setBorderRight(BorderStyle.THIN);
        warnStyle.setFillForegroundColor(color);  
        warnStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND); 
        
		try {
			XSSFSheet sheet = workbook.createSheet();
			writeHeader(sheet, sumCell, headerText);
			EventDto criteria = new EventDto();
			if(StringUtils.isNotBlank(farmCodesStr)){
				String[] temp = farmCodesStr.split(SymbolEnum.COMMA.val);
				List<String> farmCodes = new ArrayList<>(Arrays.asList(temp));
				criteria.setFarmCodes(farmCodes);
			}
			
			if(StringUtils.isNotBlank(barnCodesStr)){
				String[] temp = barnCodesStr.split(SymbolEnum.COMMA.val);
				List<String> barnCodes = new ArrayList<>(Arrays.asList(temp));
				criteria.setBarnCodes(barnCodes);
			}
			
			if(StringUtils.isNotBlank(weightRangesStr)){
				String[] temp = weightRangesStr.split(SymbolEnum.COMMA.val);
				List<String> weightRanges = new ArrayList<>(Arrays.asList(temp));
				criteria.setWeightRange(weightRanges);
			}
			
			criteria.setStage(stage);
			
			ReportWeightNoteDto report = reportManager.handleReportDailyAverageWeight(criteria);
			writeReportDailyAverageWeight(sheet, report, normalStyle, hightlightStyle, warnStyle);
			String fileLocation = createNameFile(getText("export.reportDailyAverageWeight", request.getLocale()));
			response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
			response.setHeader(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileLocation + "\"");
			response.flushBuffer();			
			workbook.write(response.getOutputStream());
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} finally {
			workbook.close();
		}
	}

	public void writeReportDailyAverageWeight(XSSFSheet sheet, ReportWeightNoteDto report, XSSFCellStyle... style) {
		Integer rowNum = 1;
		Integer countNum = 1;
		if (report != null) {
			if (report.getWeightNotes() != null) {
				Row row = null;
				Cell cell = null;
//				Integer column = 0;
				for (WeightNoteDailyDto note : report.getWeightNotes()) {
					//list lưu thông tin các cell merge
					List<Integer> cell1s = new ArrayList<>();
					List<Integer> cell2s = new ArrayList<>();
					List<Integer> cell3s = new ArrayList<>();
					
					if(note.getWeightCharts() == null) {
						List<Integer> cells = new ArrayList<>();
						cells.add(rowNum);
						
						row = sheet.createRow(rowNum++);
						
						Integer column = 0;
						cell = row.createCell(column++);
						cell.setCellValue(note.getProcessOrderCode());
						cell.setCellStyle(style[1]);
						
						cell = row.createCell(column++);
						cell.setCellValue(note.getPigType());
						cell.setCellStyle(style[1]);
						
						cell = row.createCell(column++);
						cell.setCellValue(note.getBarnName());
						cell.setCellStyle(style[1]);
						
						cells.add(column);
						cell = row.createCell(column++);
						cell.setCellStyle(style[2]);
						
						cell = row.createCell(column++);
						cell.setCellStyle(style[2]);
						
						cell = row.createCell(column++);
						cell.setCellStyle(style[2]);
						
						cell = row.createCell(column++);
						cell.setCellStyle(style[2]);
						
						cells.add(column);
						sheet.addMergedRegion(new CellRangeAddress(cells.get(0), cells.get(0), cells.get(1), cells.get(2)));
						
						countNum++;
						
					} else {
						//first row
						cell1s.add(rowNum);
						cell2s.add(rowNum);
						cell3s.add(rowNum);
						
						//last row
						cell1s.add(rowNum+ note.getWeightCharts().size() +1);
						cell2s.add(rowNum+ note.getWeightCharts().size() +1);
						cell3s.add(rowNum+ note.getWeightCharts().size() +1);
						
						row = sheet.createRow(rowNum++);
						
						Integer column = 0;
						cell1s.add(column);
						cell = row.createCell(column++);
						cell.setCellValue(note.getProcessOrderCode());
						cell.setCellStyle(style[1]);
						
						cell2s.add(column);
						cell = row.createCell(column++);
						cell.setCellValue(note.getPigType());
						cell.setCellStyle(style[1]);
						
						cell3s.add(column);
						cell = row.createCell(column++);
						cell.setCellValue(note.getBarnName());
						cell.setCellStyle(style[1]);
						
						cell = row.createCell(column++);
						cell.setCellValue("");
						cell.setCellStyle(style[1]);
						
						cell = row.createCell(column++);
						cell.setCellValue(note.getCreatedDateEarly());
						cell.setCellStyle(style[1]);
						
						cell = row.createCell(column++);
						cell.setCellValue("");
						cell.setCellStyle(style[1]);
						
						cell = row.createCell(column++);
						cell.setCellValue("");
						cell.setCellStyle(style[1]);
						
						sheet.addMergedRegion(new CellRangeAddress(row.getRowNum(), row.getRowNum() , cell.getColumnIndex()-2, cell.getColumnIndex()));
						
						cell = row.createCell(column++);
						cell.setCellValue(note.getCreatedDateLatest());
						cell.setCellStyle(style[1]);
						
						cell = row.createCell(column++);
						cell.setCellValue("");
						cell.setCellStyle(style[1]);
						
						cell = row.createCell(column++);
						cell.setCellValue("");
						cell.setCellStyle(style[1]);
						
						sheet.addMergedRegion(new CellRangeAddress(row.getRowNum(), row.getRowNum(), cell.getColumnIndex()-2, cell.getColumnIndex()));
						
						//new row
						row = sheet.createRow(rowNum++);
						column = 0;
						
						cell = row.createCell(column++);
						cell.setCellValue(note.getProcessOrderCode());
						cell.setCellStyle(style[1]);
						
						cell = row.createCell(column++);
						cell.setCellValue(note.getPigType());
						cell.setCellStyle(style[1]);
						
						cell = row.createCell(column++);
						cell.setCellValue(note.getBarnName());
						cell.setCellStyle(style[1]);
						
						cell = row.createCell(column++);
						cell.setCellValue(note.getSumQuantityEarly() != null ? note.getSumQuantityEarly().intValue() : 0);
						cell.setCellStyle(style[1]);
						
						cell = row.createCell(column++);
						cell.setCellValue(note.getSumWeightEarly() != null ?note.getSumWeightEarly().intValue() : 0);
						cell.setCellStyle(style[1]);
						
						cell = row.createCell(column++);
						if(note.getSumQuantityEarly() != null && note.getSumQuantityEarly().compareTo(new BigDecimal(0)) > 0) {
							BigDecimal avg = note.getSumWeightEarly().divide(note.getSumQuantityEarly(),2, RoundingMode.HALF_EVEN);
							cell.setCellValue(avg.doubleValue());
						} else {
							cell.setCellValue(0);
						}
						cell.setCellStyle(style[1]);
						
						cell = row.createCell(column++);
						cell.setCellValue(note.getSumQuantityLatest() != null ? note.getSumQuantityLatest().intValue() : 0);
						cell.setCellStyle(style[1]);
						
						cell = row.createCell(column++);
						cell.setCellValue(note.getSumWeightLatest() != null ?note.getSumWeightLatest().intValue() : 0);
						cell.setCellStyle(style[1]);
						
						cell = row.createCell(column++);
						if(note.getSumQuantityLatest() != null && note.getSumQuantityLatest().compareTo(new BigDecimal(0)) > 0) {
							BigDecimal avg = note.getSumWeightLatest().divide(note.getSumQuantityLatest(),2, RoundingMode.HALF_EVEN);
							cell.setCellValue(avg.doubleValue());
						} else {
							cell.setCellValue(0);
						}
						cell.setCellStyle(style[1]);
						
						countNum++;
						
						for (WeightChartDailyDto chart : note.getWeightCharts()){
							row = sheet.createRow(rowNum++);
							column = 0;
							cell = row.createCell(column++);
							cell.setCellValue(note.getProcessOrderCode());
							cell.setCellStyle(style[0]);
							
							cell = row.createCell(column++);
							cell.setCellValue(note.getPigType());
							cell.setCellStyle(style[0]);
							
							cell = row.createCell(column++);
							cell.setCellValue(note.getBarnName());
							cell.setCellStyle(style[0]);
							
							cell = row.createCell(column++);
							cell.setCellValue(chart.getRange());
							cell.setCellStyle(style[0]);
							
							cell = row.createCell(column++);
							cell.setCellValue(chart.getQuantityEarly() != null ? chart.getQuantityEarly() : 0);
							cell.setCellStyle(style[0]);
							
							cell = row.createCell(column++);
							cell.setCellValue(chart.getWeightEarly() != null ? chart.getWeightEarly() : 0);
							cell.setCellStyle(style[0]);
							
							cell = row.createCell(column++);
							if(chart.getQuantityEarly() != null && chart.getQuantityEarly() != 0) {
								cell.setCellValue(chart.getWeightEarly()/chart.getQuantityEarly());
							} else {
								cell.setCellValue(0);
							}
							cell.setCellStyle(style[0]);
							
							cell = row.createCell(column++);
							cell.setCellValue(chart.getQuantityLatest() != null ? chart.getQuantityLatest() : 0);
							cell.setCellStyle(style[0]);
							
							cell = row.createCell(column++);
							cell.setCellValue(chart.getWeightLatest() != null ? chart.getWeightLatest() : 0);
							cell.setCellStyle(style[0]);
							
							cell = row.createCell(column++);
							if(chart.getQuantityLatest() != null && chart.getQuantityLatest() != 0) {
								cell.setCellValue(chart.getWeightLatest()/chart.getQuantityLatest());
							} else {
								cell.setCellValue(0);
							}
							cell.setCellStyle(style[0]);
							countNum++;
						}
						
						sheet.addMergedRegion(new CellRangeAddress(cell1s.get(0), cell1s.get(1), cell1s.get(2), cell1s.get(2)));
						sheet.addMergedRegion(new CellRangeAddress(cell2s.get(0), cell2s.get(1), cell2s.get(2), cell2s.get(2)));
						sheet.addMergedRegion(new CellRangeAddress(cell3s.get(0), cell3s.get(1), cell3s.get(2), cell3s.get(2)));
					}
				}
				row = sheet.createRow(rowNum);
				cell = row.createCell(0);
				cell.setCellValue("Tổng");
				cell = row.createCell(4);
				cell.setCellValue(report.getTotalQuantityEarly() != null ? report.getTotalQuantityEarly().doubleValue() : 0);
				cell = row.createCell(5);
				cell.setCellValue(report.getTotalWeightEarly() != null ? report.getTotalWeightEarly().doubleValue() : 0);
				cell = row.createCell(7);
				cell.setCellValue(report.getTotalQuantityLatest() != null ? report.getTotalQuantityLatest().doubleValue() : 0);
				cell = row.createCell(8);
				cell.setCellValue(report.getTotalWeightLatest() != null ? report.getTotalWeightLatest().doubleValue() : 0);
				
				
				row = sheet.createRow(rowNum + 1);
				cell = row.createCell(0);
				cell.setCellValue("Trung bình");
				cell = row.createCell(4);
				cell.setCellValue("");
				cell = row.createCell(5);
				cell.setCellValue(report.getTotalAvgWeightEarly() != null ? report.getTotalAvgWeightEarly().doubleValue() : 0);
				cell = row.createCell(8);
				cell.setCellValue(report.getTotalAvgWeightLatest() != null ? report.getTotalAvgWeightLatest().doubleValue() : 0);
			}
		}
	}
	
	private void changeBackGroundColor(Cell cell) {
		CellStyle cellStyle = cell.getCellStyle();
	    if(cellStyle == null) {
	        cellStyle = cell.getSheet().getWorkbook().createCellStyle();
	    }
	    cellStyle.setFillForegroundColor(IndexedColors.LIGHT_BLUE.getIndex());
	    cellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
	    cell.setCellStyle(cellStyle);
	}
		

	/*
	 * EXPORT report-deadRate
	 */
	@GetMapping("/report/deadRate-export-excel")
	public void exportReportDeadRate(@RequestParam(name ="stockCode", required = true) String stockCode
			, @RequestParam(name = "stage", required = true) String stage
			, HttpServletRequest request, HttpServletResponse response) throws Exception {
		log.info("*********CONTROLLER:process=export-report-deadRate, stockCode={}", stockCode);
		Locale locale = request.getLocale();
		Integer sumCell = 6;
		String[] headerText = {
				getText("report.table.th.STT", locale),
				getText("report.table.th.processOrder", locale),
				getText("report.table.th.chuong", locale),
				getText("report.table.th.slNhap", locale),
				getText("report.table.th.slChet", locale),
				getText("report.table.th.tlChet", locale),
		};
		
		XSSFWorkbook workbook = new XSSFWorkbook();
		try {
			XSSFSheet sheet = workbook.createSheet();
			writeHeader(sheet, sumCell, headerText);
			ReportDeadRateDto criteria = new ReportDeadRateDto();
			criteria.setStockCode(stockCode);
			criteria.setStage(stage);
			ResponseResultDto result = reportManager.handleReportDeadRate(criteria);
			writeReportDeadRate(sheet, result);
			String fileLocation = createNameFile(getText("export.reportDeadRate", request.getLocale()));
			response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
			response.setHeader(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileLocation + "\"");
			response.flushBuffer();
			workbook.write(response.getOutputStream());
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} finally {
			workbook.close();
		}
	}
	
	public void writeReportDeadRate(XSSFSheet sheet, ResponseResultDto result) {
		if (result != null && result.getResults() != null) {
			ObjectMapper objectMapper = new ObjectMapper();
			List<ReportDeadRateDto> deadRates = 
					objectMapper.convertValue(result.getResults(), new TypeReference<List<ReportDeadRateDto>>() {});
			AtomicInteger no = new AtomicInteger();
			deadRates.stream().forEach(deadRate -> {
				Row row = sheet.createRow(no.getAndIncrement() + 1);
				Integer column = 0;
				Cell cell = row.createCell(column++);
				cell.setCellValue(no.get());
				cell = row.createCell(column++);
				cell.setCellValue(deadRate.getProcessOrderCode());
				cell = row.createCell(column++);
				cell.setCellValue(deadRate.getBarnName());
				cell = row.createCell(column++);
				cell.setCellValue(deadRate.getTotalPig() != null ? deadRate.getTotalPig() : 0);
				cell = row.createCell(column++);
				cell.setCellValue(deadRate.getTotalPigDead() != null ? deadRate.getTotalPigDead().doubleValue() : 0);
				cell = row.createCell(column++);
				cell.setCellValue(deadRate.getRate() != null ? deadRate.getRate().doubleValue() : 0);
				
			});
		}
	}
	
	/*
	 * EXPORT REPORT FCR
	 */
	@GetMapping("/report/fcr-export-excel")
	public void exportReportFRC(@RequestParam(name = "stockCode", required = true) String stockCode
			, @RequestParam(name = "poCode", required = true) String poCode
			, @RequestParam(name = "stage", required = true) String stage
			, HttpServletRequest request, HttpServletResponse response) throws Exception {
		log.info("*********CONTROLLER:process=export-report-fcr, stockCode={}, stage={}", stockCode, stage);
		Locale locale = request.getLocale();
		Integer sumCell = 12;
		String[] headerText = {
				getText("report.table.th.STT", locale),
				getText("report.table.th.processOrder", locale),
				getText("report.table.th.slEarlyStage", locale),
				getText("report.table.th.tlEarlyStage", locale),
				getText("report.table.th.averageEarlyStage", locale),
				getText("report.table.th.slFinalStage", locale),
				getText("report.table.th.tlFinalStage", locale),
				getText("report.table.th.averageFinalStage", locale),
				getText("report.table.th.sumAmountFeedUsed", locale),
				getText("report.table.th.fcr.reality", locale),
				getText("report.table.th.fcr.standard", locale),
				getText("report.table.th.fcr.range", locale)
		};
		
		XSSFWorkbook workBook = new XSSFWorkbook();
		try {
			XSSFSheet sheet = workBook.createSheet();
			writeHeader(sheet, sumCell, headerText);
			ReportFCRDto criteria = new ReportFCRDto();
			criteria.setStockCode(stockCode);
			criteria.setPoCode(poCode);
			criteria.setStage(stage);
			List<ReportFCRDto> fcrLst = reportManager.handleReportFcr(criteria);
			writeReportFCR(sheet, fcrLst);
			String fileLocation = createNameFile(getText("export.reportFcr", request.getLocale()));
			response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
			response.setHeader(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileLocation + "\"");
			response.flushBuffer();
			workBook.write(response.getOutputStream());
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} finally {
			workBook.close();
		}
	}
	
	public void writeReportFCR(XSSFSheet sheet, List<ReportFCRDto> fcrLst) {
		Integer rowNum = 1;
		Integer countNo = 1;
		if (fcrLst != null) {
			for (ReportFCRDto fcr : fcrLst) {
				Row row = sheet.createRow(rowNum++);
				Integer column = 0;
				Cell cell = row.createCell(column++);
				cell.setCellValue(countNo);
				cell = row.createCell(column++);
				cell.setCellValue(fcr.getPoCode());
				
				cell = row.createCell(column++);
				cell.setCellValue(fcr.getAmountEarlyPig());
				cell = row.createCell(column++);
				cell.setCellValue(fcr.getAmountEarlyWeight()!= null ? fcr.getAmountEarlyWeight().doubleValue() : 0);
				cell = row.createCell(column++);
				cell.setCellValue(fcr.getAverageEarly() != null ? fcr.getAverageEarly().doubleValue() : 0);
				
				cell = row.createCell(column++);
				cell.setCellValue(fcr.getAmountFinalPig());
				cell = row.createCell(column++);
				cell.setCellValue(fcr.getAmountFinalWeight() != null ? fcr.getAmountFinalWeight().doubleValue() : 0);
				cell = row.createCell(column++);
				cell.setCellValue(fcr.getAverageFinal() != null ? fcr.getAverageFinal().doubleValue() : 0);
				
				cell = row.createCell(column++);
				cell.setCellValue(fcr.getSumAmountFeed() != null ? fcr.getSumAmountFeed().doubleValue() : 0);
				cell = row.createCell(column++);
				cell.setCellValue(fcr.getFcrReality() != null ? fcr.getFcrReality().doubleValue() : 0);
				cell = row.createCell(column++);
				cell.setCellValue(fcr.getFcrStandard() != null ? fcr.getFcrStandard().doubleValue() : 0);
				cell = row.createCell(column++);
				cell.setCellValue(fcr.getFcrRange() != null ? fcr.getFcrRange().doubleValue() : 0);
				countNo++;
			}
		}
	}
	
	/*
	 * EXPORT REPORT ADG
	 */
	@GetMapping("/report/adg-export-excel")
	public void exportReportADG(@RequestParam(name = "stockCode", required = true) String stockCode
			, @RequestParam(name = "poCode", required = true) String poCode
			, @RequestParam(name = "stage", required = true) String stage
			, HttpServletRequest request, HttpServletResponse response) throws Exception {
		log.info("***********CONTROLLER:process=export-report-adg, stockCode={}, stage={}", stockCode, stage);
		Locale locale = request.getLocale();
		Integer sumCell = 10;
		String[] headerText = {
				getText("report.table.th.processOrder", locale),
				getText("report.table.createDate", locale),
				getText("report.table.th.slEarlyStage", locale),
				getText("report.table.th.tlEarlyStage", locale),
				getText("report.table.th.averageEarlyStage", locale),
				getText("report.table.dateChoose", locale),
				getText("report.table.th.slFinalStage", locale),
				getText("report.table.th.tlFinalStage", locale),
				getText("report.table.th.averageFinalStage", locale),
				getText("report.table.th.adg", locale)
		};
		
		XSSFWorkbook workBook = new XSSFWorkbook();
		try {
			XSSFSheet sheet = workBook.createSheet();
			writeHeader(sheet, sumCell, headerText);
			ReportADGDto criteria = new ReportADGDto();
			criteria.setStockCode(stockCode);
			criteria.setPoCode(poCode);
			criteria.setStage(stage);
			List<ReportADGDto> adgLst = reportManager.handleReportADG(criteria);
			writeReportADG(sheet, adgLst);
			String fileLocation = createNameFile(getText("export.reportAdg", request.getLocale()));
			response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
			response.setHeader(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileLocation + "\"");
			response.flushBuffer();
			workBook.write(response.getOutputStream());
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} finally {
			workBook.close();
		}
	}
	
	public void writeReportADG(XSSFSheet sheet, List<ReportADGDto> adgLst) {
		Integer rowNum = 1;
		if (adgLst != null) {
			for (ReportADGDto adg : adgLst) {
				Row row = sheet.createRow(rowNum++);
				Integer column = 0;
				Cell cell = row.createCell(column++);
				cell.setCellValue(adg.getPoCode());
				cell = row.createCell(column++);
				cell.setCellValue(adg.getFromDate());
				cell = row.createCell(column++);
				cell.setCellValue(adg.getAmountEarlyPig());
				cell = row.createCell(column++);
				cell.setCellValue(adg.getAmountEarlyWeight() != null ? adg.getAmountEarlyWeight().doubleValue() : 0);
				cell = row.createCell(column++);
				cell.setCellValue(adg.getAverageEarly() != null ? adg.getAverageEarly().doubleValue() : 0);
				cell = row.createCell(column++);
				cell.setCellValue(adg.getToDate());
				cell = row.createCell(column++);
				cell.setCellValue(adg.getAmountFinalPig());
				cell = row.createCell(column++);
				cell.setCellValue(adg.getAmountFinalWeight() != null ? adg.getAmountFinalWeight().doubleValue() : 0);
				cell = row.createCell(column++);
				cell.setCellValue(adg.getAverageFinal() != null ? adg.getAverageFinal().doubleValue() : 0);
				cell = row.createCell(column++);
				cell.setCellValue(adg.getAdgIndex() != null ? adg.getAdgIndex().doubleValue() : 0);
			}
		}
	}
	
	
	//======== IMPORT INSTOCK ===================//
	@PostMapping("/instock/import")
    public String importDataInstock (@RequestParam(name ="inputImport", required = true) MultipartFile excelFile, @RequestParam(name ="stockCode", required = true) String stockCode, HttpServletRequest request) {
    	log.info("ENTERING 'IMPORT DATA INSTOCK' METHOD...");
    	log.debug("=====> LOG CHECK DEBUG: IMPORT INSTOCK - USER_NAME: {} - STOCK_CODE: {}", UserContext.getUsername(), stockCode);
		try {
			EntityResponse result = readFileExcelImportInstock(excelFile,stockCode);
			if(result.getCode().equals(EntityResponseCodeEnum.SUCCESS_200.val)) {
				addMessage(request, getText("import.status.success", request.getLocale()));
			} else if(result.getCode().equals(EntityResponseCodeEnum.ERROR_400.val)){
        	     addError(request, getText("data.lock.15.minutes", request.getLocale()));
 	        } else {
 	        	  addError(request, result.getMessage());
 	        }
		} catch (Exception e) {
			log.error("ERROR IMPORT DATA INSTOCK: EXCEPTION: {}", e);
			addError(request, e.getMessage());
		}
        return "redirect:/instock/list";
    }
    
	/*
	 * Đọc file excel và lưu thông tin đã đọc vào DB
	 */
    private EntityResponse readFileExcelImportInstock(MultipartFile excelFile, String stockCode) throws Exception {
    	log.info("PROCESS: 'READ FILE EXCEL IMPORT INSTOCK' METHOD...");
		List<MaterialDetailDto> materialDetailDtos = new ArrayList<>();
		int i = 1;
		XSSFWorkbook workbook = new XSSFWorkbook(excelFile.getInputStream());
		XSSFSheet worksheet = workbook.getSheetAt(0);
		while (i <= worksheet.getLastRowNum()) {
			MaterialDetailDto materialDetailDto = new MaterialDetailDto();
			XSSFRow dataRow = worksheet.getRow(i++);
			
			if(dataRow.getCell(3) != null) {
				try {
					if(dataRow.getCell(3).getCellType().equals(CellType.STRING)) {
						materialDetailDto.setCode(dataRow.getCell(3).getStringCellValue());
					} else if(dataRow.getCell(3).getCellType().equals(CellType.NUMERIC)) {
						String code = String.format("%.0f", dataRow.getCell(3).getNumericCellValue());
						materialDetailDto.setCode(MaterialCodeConvertHelper.convertToCode18Char(code));
					}
				} catch (Exception e) {
					log.error("ERROR - Exception when read file column CODE: {}", e);
					materialDetailDto.setCode(null);
					continue;
				}
			}
			
			if(dataRow.getCell(4) != null) {
				try {
					if(dataRow.getCell(4).getCellType().equals(CellType.STRING)) {
						materialDetailDto.setName(dataRow.getCell(4).getStringCellValue());
					} else if(dataRow.getCell(4).getCellType().equals(CellType.NUMERIC)) {
						String name = String.format("%.0f", dataRow.getCell(4).getNumericCellValue());
						materialDetailDto.setName(name);
					}
				} catch (Exception e) {
					log.error("ERROR - Exception when read file column NAME: {}", e);
					materialDetailDto.setName(null);
					continue;
				}
			}
			
			if(dataRow.getCell(5) != null) {
				try {
					if(dataRow.getCell(5).getCellType().equals(CellType.STRING)) {
						materialDetailDto.setBatch(dataRow.getCell(5).getStringCellValue());
					} else if(dataRow.getCell(5).getCellType().equals(CellType.NUMERIC)) {
						String batch = String.format("%.0f", dataRow.getCell(5).getNumericCellValue());
						materialDetailDto.setBatch(batch);
					}
				} catch (Exception e) {
					log.error("ERROR - Exception when read file column BATCH: {}", e);
					materialDetailDto.setBatch(null);
					continue;
				}
			}
			
			if(dataRow.getCell(6) != null) {
				try {
					if(dataRow.getCell(6).getCellType().equals(CellType.STRING)) {
						String quantity = dataRow.getCell(6).getStringCellValue();
						materialDetailDto.setQuantity(new BigDecimal(quantity));
					} else if(dataRow.getCell(6).getCellType().equals(CellType.NUMERIC)) {
						materialDetailDto.setQuantity(BigDecimal.valueOf(dataRow.getCell(6).getNumericCellValue()));
					}
				} catch (Exception e) {
					log.error("ERROR - Exception when read file column QUANTITY: {}", e);
					materialDetailDto.setQuantity(BigDecimal.ZERO);
					continue;
				}
			}
			
			if(dataRow.getCell(7) != null) {
				try {
					if(dataRow.getCell(7).getCellType().equals(CellType.STRING)) {
						materialDetailDto.setUnit(dataRow.getCell(7).getStringCellValue());
						log.error("ERROR - Exception when read file column UNIT: {}", materialDetailDto.getUnit());
					} else if(dataRow.getCell(7).getCellType().equals(CellType.NUMERIC)) {
						String unit = String.format("%.0f", dataRow.getCell(7).getNumericCellValue());
						materialDetailDto.setUnit(unit);
					}
				} catch (Exception e) {
					log.error("ERROR - Exception when read file column UNIT: {}", e);
					materialDetailDto.setUnit(null);
					continue;
				}
			}
			
			if(dataRow.getCell(9) != null) {
				try {
					if(dataRow.getCell(9).getCellType().equals(CellType.STRING)) {
						materialDetailDto.setExpiredDateStr(dataRow.getCell(9).getStringCellValue());
					} else if(dataRow.getCell(9).getCellType().equals(CellType.NUMERIC)) {
						String date = String.format("%.0f", dataRow.getCell(9).getNumericCellValue());
						materialDetailDto.setExpiredDateStr(date);
					}
				} catch (Exception e) {
					log.error("ERROR - Exception when read file column ExpiredDate: {}", e);
					materialDetailDto.setExpiredDateStr(null);
					continue;
				}
			}
			
			if(dataRow.getCell(8) != null) {
				try {
					if(dataRow.getCell(8).getCellType().equals(CellType.STRING)) {
						materialDetailDto.setManufacturedDateStr(dataRow.getCell(8).getStringCellValue());
					} else if(dataRow.getCell(8).getCellType().equals(CellType.NUMERIC)) {
						String date = String.format("%.0f", dataRow.getCell(8).getNumericCellValue());
						materialDetailDto.setManufacturedDateStr(date);
					}
				} catch (Exception e) {
					log.error("ERROR - Exception when read file column ManufacturedDate: {}", e);
					materialDetailDto.setManufacturedDateStr(null);
					continue;
				}
			}
			materialDetailDtos.add(materialDetailDto);
		}
		
		InstockDto instockDto = new InstockDto();
		instockDto.setMaterialDetails(materialDetailDtos);
		instockDto.setStockCode(stockCode);
		EntityResponse result = instockManager.importInstock(instockDto);
		workbook.close();
		return result;
	}
    //======== IMPORT INSTOCK ===================//

    //=========EXPORT INSTOCK==============//
  	@GetMapping("/instock/Export/{id}")
    public void exportInstock(@PathVariable(value="id") Long id, HttpServletRequest request, HttpServletResponse response) throws IOException{
  		log.info("ENTERING 'EXPORT INSTOCK' METHOD...");
      	
      	Integer sumCell = 10;
      	String[] headerText = {
  				getText("export.plant", request.getLocale()),getText("export.farm.code", request.getLocale()),
  				getText("export.sync.date",request.getLocale()), getText("export.material.code", request.getLocale()),
  				getText("export.material.name", request.getLocale()),getText("export.material.batch", request.getLocale()),
  				getText("export.material.quantity", request.getLocale()),getText("export.material.unit", request.getLocale()),
  				getText("export.material.manufacturedDate", request.getLocale()),getText("export.material.expiredDate", request.getLocale()),
  				};
  		
  		XSSFWorkbook workbook = new XSSFWorkbook();
  		try {
  			XSSFSheet sheet = workbook.createSheet("INSTOCK");
  			writeHeader(sheet, sumCell, headerText);
  			List<ItemExportDto> itemExportDtos = getMaterialInInstocks(id);
  			writeInstocks(sheet, itemExportDtos);
  			String fileLocation = createNameFile(getText("export.instock", request.getLocale()));
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
  	
  	/*
  	 * lấy thông tin INSTOCK LATEST = TRUE để ghi ra file excel
  	 */
  	private List<ItemExportDto> getMaterialInInstocks(Long id) {
  		log.info("PROCESS: GET MATERIAL INSTOCK LATEST");
  		ObjectMapper mapper = new ObjectMapper();
  		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
  		InstockDto instockDto = instockManager.get(id);
  		List<ItemExportDto> itemExportDtos = new ArrayList<>();
  		if(instockDto != null) {
			String syncDate = DateTimeFormatter.ofPattern(DatePatternEnum.YYYYMMDD.pattern).format(instockDto.getSyncDate());
			String[] arr = StringUtils.split(instockDto.getStock().getCode(), SymbolEnum.DOT.val);
			
			if(!CollectionUtils.isEmpty(instockDto.getMaterialDetails())) {
				instockDto.getMaterialDetails().stream().forEach(material ->{
					ItemExportDto itemExport = new ItemExportDto();
					itemExport.setPlant(arr[0]);
					itemExport.setFarmCode(arr[1]);
					itemExport.setSyncDate(syncDate);
					itemExport.setMaterialCode(MaterialCodeConvertHelper.convertToCodeNumber(material.getCode()));
					itemExport.setMaterialName(material.getName());
					itemExport.setBatch(material.getBatch());
					itemExport.setQuantity(material.getQuantity());
					itemExport.setUnit(material.getUnit());
					if(material.getManufacturedDate() != null) {
						itemExport.setManufacturedDate(DateTimeHelper.toDateString(material.getManufacturedDate(), DatePatternEnum.YYYYMMDD.pattern));
					} else {
						itemExport.setManufacturedDate("");
					}
					if(material.getExpiredDate() != null) {
						itemExport.setExpiredDate(DateTimeHelper.toDateString(material.getExpiredDate(), DatePatternEnum.YYYYMMDD.pattern));
					} else {
						itemExport.setExpiredDate("");
					}
					itemExportDtos.add(itemExport);
				});
			}
  		}
  		return itemExportDtos;
  	}
  	
  	/*
  	 * ghi thông tin INSTOCK ra file excel
  	 */
  	private void writeInstocks(XSSFSheet sheet, List<ItemExportDto> itemExportDtos) {
  		log.info("PROCESS: WRITE INSTOCK");
  		Integer rowNum = 1;
  		if(itemExportDtos != null && !itemExportDtos.isEmpty()) {
  			for(ItemExportDto item : itemExportDtos) {
  				Row row = sheet.createRow(rowNum++);
  				Integer column = 0;
  				Cell cell = row.createCell(column++);
  				cell.setCellValue(item.getPlant() != null ? item.getPlant() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getFarmCode() != null ? item.getFarmCode() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getSyncDate() != null ? item.getSyncDate() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getMaterialCode() != null ? item.getMaterialCode() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getMaterialName() != null ? item.getMaterialName() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getBatch() != null ? item.getBatch() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getQuantity() != null ? item.getQuantity().doubleValue() : 0);
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getUnit() != null ? item.getUnit() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getManufacturedDate() != null ? item.getManufacturedDate() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getExpiredDate() != null ? item.getExpiredDate() : "");
  			}
  		}
  	}
    //=========EXPORT INSTOCK==============//
  	
    //======== EXPORT STOCK_COUNT ============//
    @GetMapping("/stockCount/Export/{id}")
    public void exportStockCount(@PathVariable(value="id") Long id, HttpServletRequest request, HttpServletResponse response) throws IOException{
		log.info("ENTERING 'EXPORT STOCKCOUNT' METHOD...");
    	
    	Integer sumCell = 10;
    	String[] headerText = {
				getText("export.plant", request.getLocale()),getText("export.farm.code", request.getLocale()),
				getText("export.sync.date",request.getLocale()), getText("export.material.code", request.getLocale()),
				getText("export.material.name", request.getLocale()),getText("export.material.batch", request.getLocale()),
				getText("export.material.quantity", request.getLocale()),getText("export.material.unit", request.getLocale()),
				getText("export.material.manufacturedDate", request.getLocale()),getText("export.material.expiredDate", request.getLocale()),
				};
		
		XSSFWorkbook workbook = new XSSFWorkbook();
		try {
			XSSFSheet sheet = workbook.createSheet("STOCKCOUNT");
			writeHeader(sheet, sumCell, headerText);
			List<ItemExportDto> itemExportDtos = getMaterialInStockCount(id);
			writeInstocks(sheet, itemExportDtos);
			String fileLocation = createNameFile(getText("export.stock.count", request.getLocale()));
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
	
    /*
     * lấy thông tin tồn kho từ SAP để export ra file excel
     */
	private List<ItemExportDto> getMaterialInStockCount(Long id) {
		log.info("PROCESS: GET MATERIAL IN STOCK_COUNT, STOCK_COUNT_ID: {}", id);
		StockCountDto stockCountDto = stockCountManager.get(id);
		List<ItemExportDto> itemExportDtos = new ArrayList<>();
		if(stockCountDto != null) {
			String syncDate = DateTimeFormatter.ofPattern(DatePatternEnum.YYYYMMDD.pattern).format(stockCountDto.getPostingDate());
			String[] arr = StringUtils.split(stockCountDto.getStock().getCode(), SymbolEnum.DOT.val);
			if(!CollectionUtils.isEmpty(stockCountDto.getMaterialDetails())) {
				stockCountDto.getMaterialDetails().stream().forEach(material ->{
					ItemExportDto itemExport = new ItemExportDto();
					itemExport.setPlant(arr[0]);
					itemExport.setFarmCode(arr[1]);
					itemExport.setSyncDate(syncDate);
					itemExport.setMaterialCode(MaterialCodeConvertHelper.convertToCodeNumber(material.getCode()));
					itemExport.setMaterialName(material.getName());
					itemExport.setBatch(material.getBatch());
					itemExport.setQuantity(material.getQuantity());
					itemExport.setUnit(material.getUnit());
					if(material.getManufacturedDate() != null) {
						itemExport.setManufacturedDate(DateTimeHelper.toDateString(material.getManufacturedDate(), DatePatternEnum.YYYYMMDD.pattern));
					} else {
						itemExport.setManufacturedDate("");
					}
					if(material.getExpiredDate() != null) {
						itemExport.setExpiredDate(DateTimeHelper.toDateString(material.getExpiredDate(), DatePatternEnum.YYYYMMDD.pattern));
					} else {
						itemExport.setExpiredDate("");
					}
					itemExportDtos.add(itemExport);
				});
			}
		}
		
		return itemExportDtos;
	}
    //======== EXPORT STOCK_COUNT ============//
	
	//=========EXPORT PURCHASE_REQUISITION==============//
	@GetMapping("/purchaseRequisition/Export/{id}/{prType}")
    public void exportPurchaseRequisition(@PathVariable(value="id") Long id, @PathVariable(value="prType") String prType, HttpServletRequest request, HttpServletResponse response) throws IOException{
		log.info("ENTERING 'EXPORT PURCHASE_REQUISITION' METHOD...");
    	
    	Integer sumCellPurchaseRequisitonTypeWeek = 13;
    	String[] headerTextPurchaseRequisitonTypeWeek = {
			getText("export.plant", request.getLocale()),getText("export.farm.code", request.getLocale()),
			getText("export.material.code", request.getLocale()),getText("export.material.name", request.getLocale()),
			getText("export.pr.material.retained", request.getLocale()),getText("export.material.quantity", request.getLocale()),
			getText("export.material.unit", request.getLocale()),getText("export.material.deliveryDate", request.getLocale()),
			getText("export.pr.material.description", request.getLocale()),getText("export.pr.material.note", request.getLocale()),
			getText("purchaserequisition.prType", request.getLocale()),
			getText("purchaserequisition.type", request.getLocale()),getText("purchaserequisition.createdDate", request.getLocale())
		};

		Integer sumCellPurchaseRequisitonTypeMonth = 16;
		String[] headerTextPurchaseRequisitonTypeMonth = {
				getText("export.plant", request.getLocale()),getText("export.farm.code", request.getLocale()),
				getText("export.material.code", request.getLocale()),getText("export.material.name", request.getLocale()),
				getText("export.pr.material.amountEarlyStage", request.getLocale()),getText("export.pr.material.amountGoodsReceipt", request.getLocale()),
				getText("export.pr.material.amountGoodsIssue", request.getLocale()),getText("export.pr.material.amountFinalStage", request.getLocale()),
				getText("export.material.quantity", request.getLocale()),getText("export.material.unit", request.getLocale()),
				getText("export.material.deliveryDate", request.getLocale()),getText("export.pr.material.description", request.getLocale()),
				getText("export.pr.material.note", request.getLocale()),getText("purchaserequisition.prType", request.getLocale()),
				getText("purchaserequisition.type", request.getLocale()),getText("purchaserequisition.createdDate", request.getLocale())
		};

		XSSFWorkbook workbook = new XSSFWorkbook();
		try {
			XSSFSheet sheet = workbook.createSheet("PURCHASE_REQUISITION");
			List<ItemExportDto> itemExportDtos = getPurchaseRequisition(id,request);
			if(prType.equals(PrTypeEnum.Z1.val)) {
				writeHeader(sheet, sumCellPurchaseRequisitonTypeWeek, headerTextPurchaseRequisitonTypeWeek);
				writePurchaseRequisitionTypeWeek(sheet, itemExportDtos);
	    	} else {
	    		writeHeader(sheet, sumCellPurchaseRequisitonTypeMonth, headerTextPurchaseRequisitonTypeMonth);
	    		writePurchaseRequisitionTypeMonth(sheet, itemExportDtos);
	    	}
			String fileLocation = createNameFile(getText("export.purchase.requisition", request.getLocale()));
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
	
	/*
	 * Lấy thông tin PURCHASE_REQUISITION để export ra file excel
	 */
	private List<ItemExportDto> getPurchaseRequisition(Long id, HttpServletRequest request) {
		log.info("PROCESS: GET PURCHASE_REQUISITION, PURCHASE_REQUISITION_ID: {}", id);
		List<ItemExportDto> itemExportDtos = new ArrayList<>();
		PurchaseRequisitionDto purchaseRequisition = purchaseRequisitionManager.get(id);
		try {
			if(purchaseRequisition != null) {
				String[] arr = StringUtils.split(purchaseRequisition.getStock().getCode(), SymbolEnum.DOT.val);
				if(!CollectionUtils.isEmpty(purchaseRequisition.getMaterialDetails())) {
					String createdDate = DateTimeHelper.toDateTimeString(purchaseRequisition.getCreatedDate(), DatePatternEnum.YYYYMMDD.pattern);
					purchaseRequisition.getMaterialDetails().stream().forEach(material ->{
						ItemExportDto itemExport = new ItemExportDto();
						itemExport.setPlant(arr[0]);
						itemExport.setFarmCode(arr[1]);
						itemExport.setMaterialCode(MaterialCodeConvertHelper.convertToCodeNumber(material.getCode()));
						itemExport.setMaterialName(material.getName());
						itemExport.setQuantity(material.getQuantity());
						itemExport.setUnit(material.getUnit());
						if(material.getRetained() != null) {
							itemExport.setRetained(material.getRetained());
						}
						if(material.getAmountEarlyStage() != null) {
							itemExport.setAmountEarlyStage(material.getAmountEarlyStage());
						}
						if(material.getAmountGoodsReceipt() != null) {
							itemExport.setAmountGoodsReceipt(material.getAmountGoodsReceipt());
						}
						if(material.getAmountGoodsIssue() != null) {
							itemExport.setAmountGoodsIssue(material.getAmountGoodsIssue());
						}
						if(material.getAmountFinalStage() != null) {
							itemExport.setAmountFinalStage(material.getAmountFinalStage());
						}
						itemExport.setMaterialDesc(material.getDescription());
						itemExport.setMaterialNote(material.getNote());
						
						if(material.getDeliveryDate() != null) {
							itemExport.setDeliveryDate(DateTimeHelper.toDateString(material.getDeliveryDate(), DatePatternEnum.YYYYMMDD.pattern));
						} else {
							itemExport.setDeliveryDate("");
						}
						itemExport.setPrType(getText("purchaserequisition.prType." + purchaseRequisition.getPrType(), request.getLocale()));
						itemExport.setType(getText("purchase.requisition.type." + purchaseRequisition.getType(), request.getLocale()));
						itemExport.setCreatedDate(createdDate);
						
						itemExportDtos.add(itemExport);
					});
				}
			}
		} catch (Exception e) {
			log.info("ERROR GET PURCHASE_REQUISITION: EXCEPTION: {}",e);
		}
		
		return itemExportDtos;
	}
	
	/*
	 * Ghi thông tin PURCHASE_REQUISITION TYPE WEEK ra file excel
	 */
	private void writePurchaseRequisitionTypeWeek(XSSFSheet sheet, List<ItemExportDto> itemExportDtos) {
		log.info("PROCESS: WRITE PURCHASE_REQUISITION TYPE WEEK");
		Integer rowNum = 1;
		if(itemExportDtos != null && !itemExportDtos.isEmpty()) {
			for(ItemExportDto item : itemExportDtos) {
				Row row = sheet.createRow(rowNum++);
				Integer column = 0;
				Cell cell = row.createCell(column++);
				cell.setCellValue(item.getPlant() != null ? item.getPlant() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getFarmCode() != null ? item.getFarmCode() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getMaterialCode() != null ? item.getMaterialCode() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getMaterialName() != null ? item.getMaterialName() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getRetained() != null ? item.getRetained().doubleValue() : 0);
				cell = row.createCell(column++);
				cell.setCellValue(item.getQuantity() != null ? item.getQuantity().doubleValue() : 0);
				cell = row.createCell(column++);
				cell.setCellValue(item.getUnit() != null ? item.getUnit() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getDeliveryDate() != null ? item.getDeliveryDate() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getMaterialDesc() != null ? item.getMaterialDesc() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getMaterialNote() != null ? item.getMaterialNote() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getPrType() != null ? item.getPrType() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getType() != null ? item.getType() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getCreatedDate() != null ? item.getCreatedDate() : "");
			}
		}
	}
	
	/*
	 * Ghi thông tin PURCHASE_REQUISITION TYPE MONTH ra file excel
	 */
	private void writePurchaseRequisitionTypeMonth(XSSFSheet sheet, List<ItemExportDto> itemExportDtos) {
		log.info("PROCESS: WRITE PURCHASE_REQUISITION TYPE MONTH");
		Integer rowNum = 1;
		if(itemExportDtos != null && !itemExportDtos.isEmpty()) {
			for(ItemExportDto item : itemExportDtos) {
				Row row = sheet.createRow(rowNum++);
				Integer column = 0;
				Cell cell = row.createCell(column++);
				cell.setCellValue(item.getPlant() != null ? item.getPlant() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getFarmCode() != null ? item.getFarmCode() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getMaterialCode() != null ? item.getMaterialCode() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getMaterialName() != null ? item.getMaterialName() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getAmountEarlyStage() != null ? item.getAmountEarlyStage().doubleValue() : 0);
				cell = row.createCell(column++);
				cell.setCellValue(item.getAmountGoodsReceipt() != null ? item.getAmountGoodsReceipt().doubleValue() : 0);
				cell = row.createCell(column++);
				cell.setCellValue(item.getAmountGoodsIssue() != null ? item.getAmountGoodsIssue().doubleValue() : 0);
				cell = row.createCell(column++);
				cell.setCellValue(item.getAmountFinalStage() != null ? item.getAmountFinalStage().doubleValue() : 0);
				cell = row.createCell(column++);
				cell.setCellValue(item.getQuantity() != null ? item.getQuantity().doubleValue() : 0);
				cell = row.createCell(column++);
				cell.setCellValue(item.getUnit() != null ? item.getUnit() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getDeliveryDate() != null ? item.getDeliveryDate() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getMaterialDesc() != null ? item.getMaterialDesc() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getMaterialNote() != null ? item.getMaterialNote() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getPrType() != null ? item.getPrType() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getType() != null ? item.getType() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getCreatedDate() != null ? item.getCreatedDate() : "");
			}
		}
	}
	//=========EXPORT PURCHASE_REQUISITION==============//
	
	/*
	 * Export report list material GA
	 */
	@SuppressWarnings("unchecked")
	@GetMapping("/report/listMaterialGA-export-excel")
	public void exportReportListMaterialGA(@RequestParam(name="stockCode", required = true) String stockCode, @RequestParam(name ="fromDate", required = true)String fromDate,
			@RequestParam(name ="toDate", required = true)String toDate
			, @RequestParam(name = "purchasingGroups", required = true) String purchasingGroups
			, HttpServletRequest request, HttpServletResponse response) throws Exception {
		log.info("******CONTROLLER:process=export-report-list-material-GA");
		Locale locale = request.getLocale();
		Integer sumCell = 11;
		String[] headerText = {
				getText("materialDetail.postingDate", locale), getText("material.code", locale),
				getText("material.name", locale), getText("material.batch", locale), 
				getText("material.dvt", locale),
				getText("material.amount", locale), getText("goodsIssue.fromStockCode", locale),
				getText("goodsIssue.toStockCode", locale), getText("goodsIssue.type", locale),
				getText("report.table.th.processOrder", locale), getText("goodsissue.barnCode", locale)
		};
		
		XSSFWorkbook workbook = new XSSFWorkbook();
		try {
			XSSFSheet sheet = workbook.createSheet("REPORT_LIST_MATERIAL_GA");
			writeHeader(sheet, sumCell, headerText);
			MaterialDetailDto criteria = new MaterialDetailDto();
			criteria.setStockCode(stockCode);
			criteria.setFromDate(fromDate);
			criteria.setToDate(toDate);
			criteria.setPurchasingGroups(purchasingGroups);
			List<MaterialDetailDto> materialDetails = new ArrayList<>();
			EntityResponse entityResponse = reportManager.handleReportListMaterialGA(criteria);
			if (entityResponse.getCode().equals(EntityResponseCodeEnum.SUCCESS_200.val)) {
				ObjectMapper mapper = new ObjectMapper();
				mapper.registerModule(new JavaTimeModule());
				mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
				materialDetails = mapper.convertValue(entityResponse.getData(), new TypeReference<List<MaterialDetailDto>>() {});
			}
			
			writeReportListMaterialGA(sheet, materialDetails);
			String fileLocation = createNameFile(getText("export.reportListMaterialGA", request.getLocale()));
			response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
			response.setHeader(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileLocation + "\"");
			response.flushBuffer();			
			workbook.write(response.getOutputStream());
			response.getOutputStream().flush();
		} finally {
			workbook.close();
		}
	}
	
	public void writeReportListMaterialGA(XSSFSheet sheet, List<MaterialDetailDto> materialDetails) {
		Integer rowNum = 1;
		if (materialDetails != null ) {
			for (MaterialDetailDto item: materialDetails) {
				Row row = sheet.createRow(rowNum++);
				Integer column = 0;
				Cell cell = row.createCell(column++);
				if(item.getPostingDate() != null) {
					String dateStr = DateTimeFormatter.ofPattern("dd-MM-yyyy").format(item.getPostingDate());
					cell.setCellValue(dateStr);
				} else {
					cell.setCellValue("");
				}
				
				cell = row.createCell(column++);
				cell.setCellValue(item.getCode());
				cell = row.createCell(column++);
				cell.setCellValue(item.getName());
				cell = row.createCell(column++);
				cell.setCellValue(StringUtils.isNotBlank(item.getBatch()) ? item.getBatch() : "");
				cell = row.createCell(column++);
				cell.setCellValue(item.getUnit());
				cell = row.createCell(column++);
				cell.setCellValue(item.getActuallyExported().doubleValue());
				cell = row.createCell(column++);
				cell.setCellValue(item.getFromStockCode());
				cell = row.createCell(column++);
				cell.setCellValue(item.getToStockCode());
				cell = row.createCell(column++);
				cell.setCellValue(item.getRecordTypeName());
				cell = row.createCell(column++);
				cell.setCellValue(item.getPoCode());
				cell = row.createCell(column++);
				cell.setCellValue(item.getBarnCode());
			}
		}
	}

	@GetMapping("/instock-baseline/Export/{id}")
    public void exportInstockBaseline(@PathVariable(value="id") Long id, HttpServletRequest request, HttpServletResponse response) throws IOException{
  		log.info("ENTERING 'EXPORT INSTOCK_BASELINE' METHOD...");
      	
      	Integer sumCell = 10;
      	String[] headerText = {
  				getText("export.plant", request.getLocale()),getText("export.farm.code", request.getLocale()),
  				getText("export.sync.date",request.getLocale()), getText("export.material.code", request.getLocale()),
  				getText("export.material.name", request.getLocale()),getText("export.material.batch", request.getLocale()),
  				getText("export.material.quantity", request.getLocale()),getText("export.material.unit", request.getLocale()),
  				getText("export.material.manufacturedDate", request.getLocale()),getText("export.material.expiredDate", request.getLocale()),
  				};
  		
  		XSSFWorkbook workbook = new XSSFWorkbook();
  		try {
  			XSSFSheet sheet = workbook.createSheet("INSTOCK_BASELINE");
  			writeHeader(sheet, sumCell, headerText);
  			List<ItemExportDto> itemExportDtos = getMaterialInInstockBaselines(id);
  			writeInstockBaselines(sheet, itemExportDtos);
  			String fileLocation = createNameFile(getText("export.instock.baseline", request.getLocale()));
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
  	
  	/*
  	 * lấy thông tin INSTOCK_BASELINE LATEST = TRUE để ghi ra file excel
  	 */
  	private List<ItemExportDto> getMaterialInInstockBaselines(Long id) {
  		log.info("PROCESS: GET MATERIAL INSTOCK_BASELINE LATEST");
  		ObjectMapper mapper = new ObjectMapper();
  		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
  		InstockBaselineDto instockBaselineDto = instockBaselineManager.get(id);
  		List<ItemExportDto> itemExportDtos = new ArrayList<>();
  		if(instockBaselineDto != null) {
			String syncDate = DateTimeFormatter.ofPattern(DatePatternEnum.YYYYMMDD.pattern).format(instockBaselineDto.getSyncDate());
			String[] arr = StringUtils.split(instockBaselineDto.getStock().getCode(), SymbolEnum.DOT.val);
			
			if(!CollectionUtils.isEmpty(instockBaselineDto.getMaterialDetails())) {
				instockBaselineDto.getMaterialDetails().stream().forEach(material ->{
					ItemExportDto itemExport = new ItemExportDto();
					itemExport.setPlant(arr[0]);
					itemExport.setFarmCode(arr[1]);
					itemExport.setSyncDate(syncDate);
					itemExport.setMaterialCode(MaterialCodeConvertHelper.convertToCodeNumber(material.getCode()));
					itemExport.setMaterialName(material.getName());
					itemExport.setBatch(material.getBatch());
					itemExport.setQuantity(material.getQuantity());
					itemExport.setUnit(material.getUnit());
					if(material.getManufacturedDate() != null) {
						itemExport.setManufacturedDate(DateTimeHelper.toDateString(material.getManufacturedDate(), DatePatternEnum.YYYYMMDD.pattern));
					} else {
						itemExport.setManufacturedDate("");
					}
					if(material.getExpiredDate() != null) {
						itemExport.setExpiredDate(DateTimeHelper.toDateString(material.getExpiredDate(), DatePatternEnum.YYYYMMDD.pattern));
					} else {
						itemExport.setExpiredDate("");
					}
					itemExportDtos.add(itemExport);
				});
			}
  		}
  		return itemExportDtos;
  	}
  	
  	/*
  	 * ghi thông tin INSTOCK_BASELINE ra file excel
  	 */
  	private void writeInstockBaselines(XSSFSheet sheet, List<ItemExportDto> itemExportDtos) {
  		log.info("PROCESS: WRITE INSTOCK_BASELINE");
  		Integer rowNum = 1;
  		if(itemExportDtos != null && !itemExportDtos.isEmpty()) {
  			for(ItemExportDto item : itemExportDtos) {
  				Row row = sheet.createRow(rowNum++);
  				Integer column = 0;
  				Cell cell = row.createCell(column++);
  				cell.setCellValue(item.getPlant() != null ? item.getPlant() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getFarmCode() != null ? item.getFarmCode() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getSyncDate() != null ? item.getSyncDate() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getMaterialCode() != null ? item.getMaterialCode() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getMaterialName() != null ? item.getMaterialName() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getBatch() != null ? item.getBatch() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getQuantity() != null ? item.getQuantity().doubleValue() : 0);
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getUnit() != null ? item.getUnit() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getManufacturedDate() != null ? item.getManufacturedDate() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getExpiredDate() != null ? item.getExpiredDate() : "");
  			}
  		}
  	}
  	
  	/*
	 * Export report day detail
	 */
  	@GetMapping("/report/dayDetail")
  	public void exportReportDayDetail(
  			@RequestParam(name = "stockCode", required = true) String stockCode, 
  			@RequestParam(name = "startDate", required = true) String startDate,
  			@RequestParam(name = "endDate", required = true) String endDate,
  			@RequestParam(name = "poCode", required = false) String poCode , 
  			HttpServletRequest request, HttpServletResponse response
  	) throws Exception {
  		log.info("******CONTROLLER:process=export-report-list-material-GA");
		Locale locale = request.getLocale();
		Integer sumCell = 23;
		String[] headerText = {
				getText("report.table.th.reportDate", locale), getText("report.table.th.processOrder", locale),
				getText("processOrder.pigType", locale),
				getText("report.table.th.chuong", locale), getText("report.table.createDate", locale),
				getText("report.table.th.title.receiveFarm", locale), getText("report.table.th.title.amount.import", locale),
				getText("report.table.th.title.weight.import", locale), getText("report.table.th.title.average.import", locale),
				getText("report.table.th.title.amountEarlyStage", locale), getText("report.table.th.title.amountGoodsReceipt", locale),
				getText("report.table.th.title.pigDead", locale), getText("report.table.th.title.accumulatedDead", locale), 
				getText("report.table.th.title.deadRatio", locale), getText("report.table.th.title.material.type", locale),
				getText("report.table.th.title.sales", locale), getText("report.table.th.title.amountGIDoCode", locale), 
				getText("report.table.th.title.amountGIPOCode", locale), getText("report.table.th.title.amountFinalStage", locale),
				getText("report.table.th.title.feedinDay", locale), getText("report.table.th.title.feedinPig", locale),
				getText("report.table.th.title.feedinPigStandard", locale), getText("report.table.th.title.feedinPigStandardDiff", locale)
		};
		
		XSSFWorkbook workbook = new XSSFWorkbook();
		try {
			XSSFSheet sheet = workbook.createSheet("Bao_cao_chi_tiet_ngay");
			writeHeader(sheet, sumCell, headerText);
			ReportDayDetailDto criteria = new ReportDayDetailDto();
			criteria.setStockCode(stockCode);
			criteria.setProcessOrderCode(poCode);
			criteria.setStartDateStr(startDate);
			criteria.setEndDateStr(endDate);
			EntityResponse entityResponse = reportManager.handleReportDayDetail(criteria);
			
			if(entityResponse.getData() != null) {
				ObjectMapper mapper = new ObjectMapper();
				mapper.registerModule(new JavaTimeModule());
				mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
				List<ReportDayDetailDto> rpDayDetails = mapper.convertValue(entityResponse.getData(), new TypeReference<List<ReportDayDetailDto>>() {});
				if (rpDayDetails!= null && !rpDayDetails.isEmpty())
					writeReportDayDetail(sheet, rpDayDetails);
				String fileLocation = createNameFile(getText("export.reportDayDetail", request.getLocale()));
				response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
				response.setHeader(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileLocation + "\"");
				response.flushBuffer();			
				workbook.write(response.getOutputStream());
				response.getOutputStream().flush();
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		finally {
			response.getOutputStream().close();
			workbook.close();
		}
  	}
  	
  	public void writeReportDayDetail(XSSFSheet sheet, List<ReportDayDetailDto> rpDayDetails) throws Exception {
  		Integer rowNum = 1;
  		for (ReportDayDetailDto item : rpDayDetails) {
  			Row row = sheet.createRow(rowNum++);
  			Integer column = 0;
  			Cell cell = row.createCell(column++);
  			cell.setCellValue(item.getDisplayReportDate());
  			cell = row.createCell(column++);
  			cell.setCellValue(item.getPoCode());
  			cell = row.createCell(column++);
  			cell.setCellValue(item.getPigType());
  			cell = row.createCell(column++);
  			cell.setCellValue(item.getBarnCode());
  			cell = row.createCell(column++);
  			cell.setCellValue(item.getDisplayReceiveDate());
  			cell = row.createCell(column++);
  			cell.setCellValue(item.getFromStockName());
  			cell = row.createCell(column++);
  			cell.setCellValue(item.getImportedAmount() != null ? item.getImportedAmount() : 0);
  			cell = row.createCell(column++);
  			cell.setCellValue(item.getImportedWeight() != null ? item.getImportedWeight().floatValue() : 0);
  			cell = row.createCell(column++);
  			cell.setCellValue(item.getImportedAverage() != null ? item.getImportedAverage().floatValue() : 0);
  			cell = row.createCell(column++);
  			cell.setCellValue(item.getSumAmountEarly() != null ? item.getSumAmountEarly() : 0);
  			cell = row.createCell(column++);
  			cell.setCellValue(item.getAmountPigEntry() != null ? item.getAmountPigEntry() : 0);
  			cell = row.createCell(column++);
  			cell.setCellValue(item.getSumAmountPigDead() != null ? item.getSumAmountPigDead().floatValue() : 0);
  			cell = row.createCell(column++);
  			cell.setCellValue(item.getAccumulatedDead() != null ? item.getAccumulatedDead() : 0);
  			cell = row.createCell(column++);
  			cell.setCellValue(item.getDeadRatio() != null ? item.getDeadRatio().floatValue() : 0);
  			cell = row.createCell(column++);
  			cell.setCellValue(item.getSumAmountPigCulling() != null ? item.getSumAmountPigCulling().floatValue() : 0);
  			cell = row.createCell(column++);
  			cell.setCellValue(item.getAmountSales() != null ? item.getAmountSales().floatValue() : 0);
  			cell = row.createCell(column++);
  			cell.setCellValue(item.getAmountGIDoCode() != null ? item.getAmountGIDoCode().floatValue() : 0);
  			cell = row.createCell(column++);
  			cell.setCellValue(item.getAmountGIPOCode() != null ? item.getAmountGIPOCode().floatValue() : 0);
  			cell = row.createCell(column++);
  			cell.setCellValue(item.getSumAmountFinal() != null ? item.getSumAmountFinal().floatValue() : 0);
  			cell = row.createCell(column++);
  			cell.setCellValue(item.getSumAmountFeed() != null ? item.getSumAmountFeed().floatValue() : 0);
  			cell = row.createCell(column++);
  			cell.setCellValue(item.getFeedInPig() != null ? item.getFeedInPig().floatValue() : 0);
  			cell = row.createCell(column++);
  			cell.setCellValue(item.getFeedInPigStandard() != null ? item.getFeedInPigStandard().floatValue() : 0);
  			cell = row.createCell(column++);
  			cell.setCellValue(item.getFeedInPigDiff());
  		}
  	}
  	
  	/*
  	 * Export report list goodsReceipt
  	 */
  	@GetMapping("/report/listGoodsReceipt-export-excel")
  	public void exportReportListGoodsReceipt(
  			@RequestParam(name = "stockCode", required = true) String stockCode
  			, @RequestParam(name = "purchasingGroupCode", required = true) String purchasingGroupCode
  			, @RequestParam(name = "fromDate", required = true) String fromDate
  			, @RequestParam(name = "toDate", required = true) String toDate
  			, HttpServletRequest request, HttpServletResponse response) throws Exception {
  		log.info("*************CONTROLLER::process='handle-export-report-list-goods-receipt'");
  		Locale locale = request.getLocale();
  		Integer sumCell = 9;
  		String[] headerText = {
  				getText("materialDetail.postingDate", locale), getText("material.code", locale),
  				getText("material.name", locale), getText("material.batch", locale), 
  				getText("material.dvt", locale),
  				getText("material.amount", locale), getText("goodsIssue.type", locale),
  				getText("goodsReceipt.stockCode", locale), getText("goodsReceipt.fromStockCode", locale)
  		};
  		
  		XSSFWorkbook workbook = new XSSFWorkbook();
  		try {
			XSSFSheet sheet = workbook.createSheet("Bao_cao_ke_nhap_vat_tu");
			writeHeader(sheet, sumCell, headerText);
			ReportGoodsReceiptDto criteria = new ReportGoodsReceiptDto();
			criteria.setStockCode(stockCode);
			criteria.setPurchasingGroups(purchasingGroupCode);
			criteria.setFromDate(fromDate);
			criteria.setToDate(toDate);
			List<ReportGoodsReceiptDto> reportGoodsReceipt = new ArrayList<>();
			EntityResponse entityResponse = reportManager.handleReportListGoodsReceipt(criteria);
			if (entityResponse.getCode().equals(EntityResponseCodeEnum.SUCCESS_200.val)) {
				ObjectMapper mapper = new ObjectMapper();
				mapper.registerModule(new JavaTimeModule());
				mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
				reportGoodsReceipt = mapper.convertValue(entityResponse.getData(), new TypeReference<List<ReportGoodsReceiptDto>>() {});
			}
			writeReportGoodsReceipt(sheet, reportGoodsReceipt);
			String fileLocation = createNameFile(getText("export.reportListGoodsReceipt", request.getLocale()));
			response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
			response.setHeader(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileLocation + "\"");
			response.flushBuffer();			
			workbook.write(response.getOutputStream());
			response.getOutputStream().flush();
		} finally {
			response.getOutputStream().close();
			workbook.close();
		}
  		
  	}
  	
  	public void writeReportGoodsReceipt(XSSFSheet sheet, List<ReportGoodsReceiptDto> reportGoodsReceipts) {
  		Integer rowNum = 1;
  		for(ReportGoodsReceiptDto item : reportGoodsReceipts) {
  			Row row = sheet.createRow(rowNum++);
  			Integer column = 0;
  			Cell cell = row.createCell(column++);
  			if(item.getPostingDate() != null) {
				String dateStr = DateTimeFormatter.ofPattern("dd-MM-yyyy").format(item.getPostingDate());
				cell.setCellValue(dateStr);
			} else {
				cell.setCellValue("");
			}
  			cell = row.createCell(column++);
  			cell.setCellValue(item.getMaterialCode());
  			cell = row.createCell(column++);
  			cell.setCellValue(item.getMaterialName());
  			cell = row.createCell(column++);
  			cell.setCellValue(StringUtils.isNotBlank(item.getBatch()) ? item.getBatch() : "");
  			cell = row.createCell(column++);
  			cell.setCellValue(item.getUnit());
  			cell = row.createCell(column++);
  			cell.setCellValue(item.getAmount() != null ? item.getAmount().floatValue() : 0);
  			cell = row.createCell(column++);
  			cell.setCellValue(item.getType());
  			cell = row.createCell(column++);
  			cell.setCellValue(item.getStockCode());
  			cell = row.createCell(column++);
  			cell.setCellValue(item.getFromStockCode());
  		}
  	}
  	
  	/*
  	 * Export report farm analyst
  	 */
  	@GetMapping("/report/farm-analyst-export-excel")
  	public void exportReportFarmAnalyst(@RequestParam(name = "stockCode", required = true) String stockCode
  			, @RequestParam(name = "stage", required = true) String stage
  			, @RequestParam(name = "poCode", required = true) String poCode
  			, HttpServletRequest request, HttpServletResponse response) throws Exception {
  		log.info("*************CONTROLLER::process='handle-export-report-Farm-Analyst'");
  		Locale locale = request.getLocale();
  		Integer sumCell = 12;
  		ReportFarmAnalystDto criteria = new ReportFarmAnalystDto();
  		criteria.setStockCode(stockCode);
  		criteria.setStage(stage);
  		criteria.setProcessOrderCode(poCode);
  		
  		ReportFarmAnalystDto farmAnalyst = reportManager.handleReportFarmAnalyst(criteria);
  		
  		List<String> headerTextCommon = generateHeaderTextInfoCommonForReportFarmAnalyst(request, farmAnalyst);
  		String[] headerText = {
  				getText("report.table.th.title.feedDay", locale), getText("report.table.th.title.sumFeed", locale),
  				getText("report.table.th.title.sumFeedStandard", locale), getText("report.table.th.title.pigRetained", locale),
  				getText("report.table.th.title.feedInDay", locale), getText("report.table.th.title.feedInDayStandard", locale),
  				getText("report.table.th.title.amountDead", locale), getText("report.table.th.title.deadRate", locale),
  				getText("report.table.th.title", locale),
  				getText("report.table.th.title.weighInPigStandard", locale), getText("report.table.th.title.entryDate", locale),
  		};
  		
  		
  		
  		XSSFWorkbook workbook = new XSSFWorkbook();
  		try {
			XSSFSheet sheet = workbook.createSheet("Bao_cao_phan_tich_tien_trinh_san_xuat");
			writeHeader(sheet, sumCell, headerTextCommon);
			writeHeaderForReportFarmAnalyst(sheet, sumCell - 2, headerText);
			
			writeReportFarmAnalyst(sheet, farmAnalyst);
			String fileLocation = createNameFile(getText("export.reportFarmAnalyst", request.getLocale()));
			response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
			response.setHeader(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileLocation + "\"");
			response.flushBuffer();			
			workbook.write(response.getOutputStream());
			response.getOutputStream().flush();
		} catch (Exception e) {
			System.out.println(e.getMessage());			
			
		} finally {
			response.getOutputStream().close();
			workbook.close();
		}
  		
  	}
  	

  	/*
  	 * Export report farm analyst by pigLevel
  	 */
  	@GetMapping("/report/farm-analyst-by-pigLevel-export-excel")
  	public void exportReportFarmAnalystByPigLevel(@RequestParam(name = "stockCode", required = true) String stockCode
  			, @RequestParam(name = "stage", required = true) String stage
  			, @RequestParam(name = "pigLevel", required = true) String pigLevel
  			, HttpServletRequest request, HttpServletResponse response) throws Exception {
  		log.info("*************CONTROLLER::process='handle-export-report-Farm-Analyst'");
  		Locale locale = request.getLocale();
  		Integer sumCell = 12;
  		ReportFarmAnalystDto criteria = new ReportFarmAnalystDto();
  		criteria.setStockCode(stockCode);
  		criteria.setStage(stage);
  		criteria.setPigLevel(pigLevel);
  		
  		ReportFarmAnalystDto farmAnalyst = reportManager.handleReportFarmAnalystByPigLevel(criteria);
  		
  		List<String> headerTextCommon = generateHeaderTextInfoCommonForReportFarmAnalyst(request, farmAnalyst);
  		String[] headerText = {
  				getText("report.table.th.title.feedDay", locale), getText("report.table.th.title.sumFeed", locale),
  				getText("report.table.th.title.sumFeedStandard", locale), getText("report.table.th.title.pigRetained", locale),
  				getText("report.table.th.title.feedInDay", locale), getText("report.table.th.title.feedInDayStandard", locale),
  				getText("report.table.th.title.amountDead", locale), getText("report.table.th.title.deadRate", locale),
  				getText("report.table.th.title", locale),
  				getText("report.table.th.title.weighInPigStandard", locale), getText("report.table.th.title.entryDate", locale),
  		};
  		
  		XSSFWorkbook workbook = new XSSFWorkbook();
  		try {
			XSSFSheet sheet = workbook.createSheet("Bao_cao_phan_tich_tien_trinh_san_xuat");
			writeHeader(sheet, sumCell, headerTextCommon);
			writeHeaderForReportFarmAnalyst(sheet, sumCell - 1, headerText);
			
			writeReportFarmAnalyst(sheet, farmAnalyst);
			String fileLocation = createNameFile(getText("export.reportFarmAnalyst", request.getLocale()));
			response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
			response.setHeader(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileLocation + "\"");
			response.flushBuffer();			
			workbook.write(response.getOutputStream());
			response.getOutputStream().flush();
		} finally {
			response.getOutputStream().close();
			workbook.close();
		}
  		
  	}
  	
  	public List<String> generateHeaderTextInfoCommonForReportFarmAnalyst(HttpServletRequest request, ReportFarmAnalystDto farmAnalyst) throws Exception {
  		Locale locale = request.getLocale();
  		List<String> headerText = new ArrayList<String>();
  		headerText.add(getText("report.table.th.sourceFarm", locale));
  		headerText.add(farmAnalyst.getSourceFarmName());
  		headerText.add(getText("report.table.th.title.amount", locale));
  		headerText.add(farmAnalyst.getSumAmount().toString());
  		headerText.add(getText("report.table.th.title.tlHeo", locale));
  		headerText.add(farmAnalyst.getSumWeight().toString());
  		headerText.add(getText("report.table.th.title.average", locale));
  		headerText.add(farmAnalyst.getAverageWeight().toString());
  		headerText.add(getText("dailyAverageWeight.avgWeight", locale));
  		headerText.add(getText("report.table.th.title.entryDate", locale));
  		headerText.add(farmAnalyst.getDisplayEntryDate());
  		headerText.add(getText("report.table.th.title.currentWeek", locale));
  		headerText.add(getText("dailyAverageWeight.avgWeight", locale));
  		return headerText;
  	}
  	
  	public void writeReportFarmAnalyst(XSSFSheet sheet, ReportFarmAnalystDto farmAnalyst) {
  		Integer rowNum = 2;
  		if (farmAnalyst != null) {
  			if (farmAnalyst.getSubFarmAnalysts() != null) {
  				for (SubFarmAnalystDto item : farmAnalyst.getSubFarmAnalysts()) {
  					Row row = sheet.createRow(rowNum++);
  					Integer column = 0;
  					Cell cell = row.createCell(column++);
  					cell.setCellValue(item.getFeedDay());
  					cell = row.createCell(column++);
  					cell.setCellValue(item.getSumAmountFeed() != null ? item.getSumAmountFeed().floatValue() : 0);
  					cell = row.createCell(column++);
  					cell.setCellValue(item.getSumStandardAmountFeed() != null ? item.getSumStandardAmountFeed().floatValue() : 0);
  					cell = row.createCell(column++);
  					cell.setCellValue(item.getPigRetained());
  					cell = row.createCell(column++);
  					cell.setCellValue(item.getFeedInPig() != null ? item.getFeedInPig().floatValue() : 0);
  					cell = row.createCell(column++);
  					cell.setCellValue(item.getStandardFeedInPig() != null ? item.getStandardFeedInPig().floatValue() : 0);
  					cell = row.createCell(column++);
  					cell.setCellValue(item.getAmountDead() != null ? item.getAmountDead().floatValue() : 0);
  					cell = row.createCell(column++);
  					cell.setCellValue(item.getDeadRate() != null ? item.getDeadRate().floatValue() : 0);
  					cell = row.createCell(column++);
  					cell.setCellValue(item.getAvgWeightEstimate() != null ? item.getAvgWeightEstimate().floatValue() : 0);
  					cell = row.createCell(column++);
  					cell.setCellValue(item.getStandardAverageWeightInPig() != null ? item.getStandardAverageWeightInPig().floatValue() : 0);
  					cell = row.createCell(column++);
  					cell.setCellValue(item.getDisplayEntryDate());
  					cell = row.createCell(column++);
  					cell.setCellValue(item.getWeekOfYear());
  					cell = row.createCell(column++);
  					cell.setCellValue(item.getAvgWeightEstimate() != null ? item.getAvgWeightEstimate().floatValue() : 0);
  				}
  			}
  		}
  	}
  	
  //=========EXPORT REPORT_TỒN ĐẦU HEO_TO_EXCEL_FILE==============//
  	@SuppressWarnings("unchecked")
	@GetMapping("/report/instock-pig-export-excel")
  	public void exportReportInstockPig(@RequestParam(name ="stockCodes", required = true) String stockCodes
  									, @RequestParam(name = "fromDate", required = true) String fromDate
  									, @RequestParam(name = "toDate", required = true) String toDate
  									, @RequestParam(name = "barnCodes", required = false) String barnCodes
  									, HttpServletRequest request, HttpServletResponse response) throws Exception {
  		log.info("***********CONTROLLER::processing=export-report-instock-pig...");
  		Integer sumCell = 13;
  		String[] headerText = {
  				getText("report.instock.title.no", request.getLocale()), getText("processOrder.code", request.getLocale()),
  				getText("processOrder.pigType", request.getLocale()),
  				getText("processOrder.barn.code", request.getLocale()), getText("barn.farmCode", request.getLocale()),
  				getText("report.table.th.slEarlyStage", request.getLocale()), getText("report.table.th.slNhap", request.getLocale()),
  				getText("report.table.th.slChet", request.getLocale()), getText("report.table.th.slLoai", request.getLocale()),
  				getText("report.table.th.slBan", request.getLocale()), getText("report.table.th.slDieuChuyen", request.getLocale()),
  				getText("report.table.th.slChuyenLenh", request.getLocale()), getText("report.table.th.slFinalStage", request.getLocale())
  		};
  		XSSFWorkbook workbook = new XSSFWorkbook();
  		try {
  			XSSFSheet sheet = workbook.createSheet("REPORT_NXT");
  			writeHeader(sheet, sumCell, headerText);
  			ReportInstockPigDto criteria = new ReportInstockPigDto();
  			criteria.setFarmCodeString(stockCodes);
  			criteria.setFromDate(fromDate);
  			criteria.setToDate(toDate);
  			criteria.setBarnCodeStr(barnCodes);
  			ReportInstockPigSummaryDto reportInstockPig = new ReportInstockPigSummaryDto();
  			EntityResponse entityResponse = reportManager.handleReportInstockPig(criteria);
  			if (entityResponse.getCode().equals(EntityResponseCodeEnum.SUCCESS_200.val)) {
  				ObjectMapper mapper = new ObjectMapper();
  				reportInstockPig = mapper.convertValue(entityResponse.getData(), ReportInstockPigSummaryDto.class);
  			}
  			writeReportInstockPig(sheet, reportInstockPig);
  			String fileLocation = createNameFile(getText("export.reportInstock", request.getLocale()));
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
  	
  	public void writeReportInstockPig(XSSFSheet sheet, ReportInstockPigSummaryDto reportInstockPig) {
  		Integer rowNum = 1;
  		Integer countNo = 1;
  		
  		Row row = sheet.createRow(rowNum++);
  		Cell cell = row.createCell(0);
  		cell.setCellValue("Tổng");
  		cell = row.createCell(5);
		cell.setCellValue(reportInstockPig.getTotalAmountEarlyStage() != null ? reportInstockPig.getTotalAmountEarlyStage().doubleValue() : 0);
		cell = row.createCell(6);
		cell.setCellValue(reportInstockPig.getTotalAmountEntry() != null ? reportInstockPig.getTotalAmountEntry().doubleValue() : 0);
		cell = row.createCell(7);
		cell.setCellValue(reportInstockPig.getTotalAmountDead() != null ? reportInstockPig.getTotalAmountDead().doubleValue() : 0);
		cell = row.createCell(8);
		cell.setCellValue(reportInstockPig.getTotalAmountCulling() != null ? reportInstockPig.getTotalAmountCulling().doubleValue() : 0);
		cell = row.createCell(9);
		cell.setCellValue(reportInstockPig.getTotalAmountSell() != null ? reportInstockPig.getTotalAmountSell().doubleValue() : 0);
		cell = row.createCell(10);
		cell.setCellValue(reportInstockPig.getTotalAmountIssue() != null ? reportInstockPig.getTotalAmountIssue().doubleValue() : 0);
		cell = row.createCell(11);
		cell.setCellValue(reportInstockPig.getTotalAmountIssueInFarm() != null ? reportInstockPig.getTotalAmountIssueInFarm().doubleValue() : 0);
		cell = row.createCell(12);
		cell.setCellValue(reportInstockPig.getTotalAmountFinalStage() != null ? reportInstockPig.getTotalAmountFinalStage().doubleValue() : 0);
		
  		if (reportInstockPig.getListItem() != null && !reportInstockPig.getListItem().isEmpty()) {
  			for (ReportInstockPigDto item : reportInstockPig.getListItem()) {
  				row = sheet.createRow(rowNum++);
  				Integer column = 0;
  				cell = row.createCell(column++);
  				cell.setCellValue(countNo);
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getProcessOrderCode() != null ? item.getProcessOrderCode() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getPigType() != null ? item.getPigType() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getBarnCode() != null ? item.getBarnCode() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getFarmName() != null ? item.getFarmName() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getAmountEarlyStage().doubleValue());
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getAmountEntry().doubleValue());
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getAmountDead().doubleValue());
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getAmountCulling().doubleValue());
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getAmountSell().doubleValue());
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getAmountIssue().doubleValue());
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getAmountIssueInFarm().doubleValue());
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getAmountFinalStage().doubleValue());
  				countNo++;
  			}
  		}
  	}
  	
  	//=========EXPORT REPORT_SO SÁNH TRỌNG LƯỢNG_TO_EXCEL_FILE==============//
  	@GetMapping("/report/weight-compare-export-excel")
  	public void exportReportWeightCompare(@RequestParam(name ="stockCodes", required = true) String stockCodes
  									, @RequestParam(name = "stage", required = true) String stage
  									, @RequestParam(name = "barnCodes", required = false) String barnCodes
  									, HttpServletRequest request, HttpServletResponse response) throws Exception {
  		log.info("***********CONTROLLER::processing=export-report-weight-compare...");
  		Integer sumCell = 13;
  		String[] headerText = {
  				getText("report.instock.title.no", request.getLocale()), getText("processOrder.code", request.getLocale()),
  				getText("processOrder.pigType", request.getLocale()),
  				getText("barn.farmCode", request.getLocale()), getText("goodsissue.batch", request.getLocale()), 
  				getText("processOrder.barn.code", request.getLocale()), getText("report.table.th.slTon", request.getLocale()),
  				getText("report.table.th.title.entryDate", request.getLocale()), getText("report.table.th.title.feedDay", request.getLocale()),
  				getText("report.table.th.dayAge", request.getLocale()), getText("report.table.th.tlTieuchuan", request.getLocale()),
  				getText("report.table.th.tlUoctinh", request.getLocale()), getText("report.table.th.diffAmount", request.getLocale()),
  		};
  		XSSFWorkbook workbook = new XSSFWorkbook();
  		try {
  			XSSFSheet sheet = workbook.createSheet("REPORT_WEIGHT_COMPARE");
  			writeHeader(sheet, sumCell, headerText);
  			ReportWeightCompareDto criteria = new ReportWeightCompareDto();
  			criteria.setFarmCodeString(stockCodes);
  			criteria.setStage(stage);
  			criteria.setBarnCodeStr(barnCodes);
  			List<ReportWeightCompareDto> report = reportManager.handleReportWeightCompare(criteria);
  			writeReportWeightCompare(sheet, report);
  			String fileLocation = createNameFile(getText("report.export", request.getLocale()));
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
  	
  	public void writeReportWeightCompare(XSSFSheet sheet, List<ReportWeightCompareDto> report) {
  		Integer rowNum = 1;
  		Integer countNo = 1;
  		if (report != null && !report.isEmpty()) {
  			for (ReportWeightCompareDto item : report) {
  				Row row = sheet.createRow(rowNum++);
  				Integer column = 0;
  				Cell cell = row.createCell(column++);
  				cell.setCellValue(countNo);
  				
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getProcessOrderCode() != null ? item.getProcessOrderCode() : "");
  				
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getPigType() != null ? item.getPigType() : "");
  				
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getFarmCode() != null ? item.getFarmCode() : "");
  				
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getBatch()!= null ? item.getBatch() : "");
  				
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getBarnCode() != null ? item.getBarnCode() : "");
  				
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getAmountStage().doubleValue());
  				
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getDisplayEntryDate() != null ? item.getDisplayEntryDate() : "");
  				
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getDayFeeds().intValue());
  				
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getAgeDay().doubleValue());
  				
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getStandardWeight().doubleValue());
  				
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getEstimateWeight().doubleValue());
  				
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getDiffAmount().doubleValue());
  				
  				countNo++;
  			}
  		}
  	}
  	
  //=========EXPORT REPORT_SO SÁNH TRỌNG LƯỢNG_THEO_LỨA_HEO_TO_EXCEL_FILE==============//
  	@GetMapping("/report/weight-compare-export-excel-by-pig-level")
  	public void exportReportWeightCompareByPigLevel(@RequestParam(name ="stockCodes", required = true) String stockCodes
  									, @RequestParam(name = "stage", required = true) String stage
  									, @RequestParam(name = "barnCodes", required = false) String barnCodes
  									, HttpServletRequest request, HttpServletResponse response) throws Exception {
  		log.info("***********CONTROLLER::processing=export-report-weight-compare-by-pig-level...");
  		Integer sumCell = 13;
  		String[] headerText = {
  				getText("report.instock.title.no", request.getLocale()), "LỨa Heo",
  				getText("processOrder.code", request.getLocale()),
  				getText("processOrder.pigType", request.getLocale()), getText("barn.farmCode", request.getLocale()),
  				getText("processOrder.barn.code", request.getLocale()), getText("report.table.th.slTon", request.getLocale()),
  				getText("report.table.th.title.entryDate", request.getLocale()), getText("report.table.th.title.feedDay", request.getLocale()),
  				getText("report.table.th.dayAge", request.getLocale()), getText("report.table.th.tlTieuchuan", request.getLocale()),
  				getText("report.table.th.tlUoctinh", request.getLocale()), getText("report.table.th.diffAmount", request.getLocale()),
  		};
  		XSSFWorkbook workbook = new XSSFWorkbook();
  		try {
  			XSSFSheet sheet = workbook.createSheet("REPORT_WEIGHT_COMPARE");
  			writeHeader(sheet, sumCell, headerText);
  			ReportWeightCompareDto criteria = new ReportWeightCompareDto();
  			criteria.setFarmCodeString(stockCodes);
  			criteria.setStage(stage);
  			criteria.setBarnCodeStr(barnCodes);
  			List<ReportWeightCompareDto> report = reportManager.handleReportWeightCompareByPigLevel(criteria);
  			writeReportWeightCompareByPigLevel(sheet, report);
  			String fileLocation = createNameFile(getText("report.export", request.getLocale()));
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
  	
  	public void writeReportWeightCompareByPigLevel(XSSFSheet sheet, List<ReportWeightCompareDto> report) {
  		Integer rowNum = 1;
  		Integer countNo = 1;
  		if (report != null && !report.isEmpty()) {
  			for (ReportWeightCompareDto item : report) {
  				Row row = sheet.createRow(rowNum++);
  				Integer column = 0;
  				Cell cell = row.createCell(column++);
  				cell.setCellValue(countNo);
  				
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getPigLevel() != null ? item.getPigLevel() : "");
  				
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getProcessOrderCode() != null ? item.getProcessOrderCode() : "");
  				
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getPigType() != null ? item.getPigType() : "");
  				
  				
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getFarmCode() != null ? item.getFarmCode() : "");
  				
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getBarnCode() != null ? item.getBarnCode() : "");
  				
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getAmountStage().doubleValue());
  				
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getDisplayEntryDate() != null ? item.getDisplayEntryDate() : "");
  				
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getDayFeeds().intValue());
  				
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getAgeDay().doubleValue());
  				
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getStandardWeight().doubleValue());
  				
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getEstimateWeight().doubleValue());
  				
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getDiffAmount().doubleValue());
  				
  				countNo++;
  			}
  		}
  	}
  	
  	
  	//=========EXPORT REPORT_DỰ KIẾN NĂNG SUẤT_TO_EXCEL_FILE==============//
  	@GetMapping("/report/prod-estimate-export-excel")
  	public void exportReportProdEstimate(@RequestParam(name ="stockCodes", required = true) String stockCodes
  									, @RequestParam(name = "stage", required = true) String stage
  									, @RequestParam(name = "barnCodes", required = false) String barnCodes
  									, @RequestParam(name = "type", required = false) String type
  									, @RequestParam(name = "poCode", required = false) String poCode
  									, HttpServletRequest request, HttpServletResponse response) throws Exception {
  		log.info("***********CONTROLLER::processing=export-report-productivity-estimate...");
  		Boolean checkTypeLevel = false;
  		if(StringUtils.isNotBlank(type)) {
  			checkTypeLevel = true;
  		}
  		Integer sumCell;
  		if(checkTypeLevel) {
  			sumCell = 30;
  			String[] headerText = {
  	  				getText("report.instock.title.no", request.getLocale()), "Lứa heo", 
  	  				getText("processOrder.code", request.getLocale()), getText("processOrder.pigType", request.getLocale()),
  	  				getText("barn.farmCode", request.getLocale()), getText("processOrder.barn.code", request.getLocale()), 
  	  				getText("report.table.th.sourceFarm", request.getLocale()), getText("report.table.th.title.entryDate", request.getLocale()), 
  	  				getText("report.table.th.slNhap", request.getLocale()), getText("report.table.th.culling7Days", request.getLocale()), 
  	  				getText("report.table.th.totalEntryVolumn", request.getLocale()), getText("report.table.th.avgEntryVolumn", request.getLocale()), 
  	  				getText("report.table.th.title.feedDay", request.getLocale()), getText("report.table.th.dayAge", request.getLocale()),
  	  				getText("report.table.th.sumAmountFeedUsed", request.getLocale()), getText("report.table.th.pigQuantityEstimate", request.getLocale()), 
  	  				getText("report.table.th.tlUoctinh", request.getLocale()), getText("report.table.th.averageVolumnEstimate", request.getLocale()), 
  	  				getText("report.table.th.slDieuChuyen", request.getLocale()), getText("report.table.th.tlDieuchuyen", request.getLocale()), 
  	  				getText("report.table.th.slBan", request.getLocale()), getText("report.table.th.tlBan", request.getLocale()), 
  	  				getText("report.table.th.avgVolumnEstimate", request.getLocale()), "Trọng lượng tiêu chuẩn", 
  	  				getText("report.table.th.slChet", request.getLocale()), 
  	  				getText("report.table.th.tlChet", request.getLocale()), getText("report.table.th.fcr.estimate", request.getLocale()), 
  	  				getText("report.table.th.fcr.standard", request.getLocale()), getText("report.table.th.fcr.range", request.getLocale()), 
  	  				getText("report.table.th.adg", request.getLocale())
  	  		};
  	  		XSSFWorkbook workbook = new XSSFWorkbook();
  	  		try {
  	  			XSSFSheet sheet = workbook.createSheet("REPORT_PROD_ESTIMATE");
  	  			writeHeader(sheet, sumCell, headerText);
  	  			ReportProdEstimateDto criteria = new ReportProdEstimateDto();
  	  			criteria.setFarmCodeString(stockCodes);
  	  			criteria.setStage(stage);
  	  			criteria.setBarnCodeStr(barnCodes);
  	  			List<ReportProdEstimateDto> report = reportManager.handleReportProdEstimateByLevel(criteria);
  	  			writeReportProdEstimate(sheet, report, true);
  	  			String fileLocation = createNameFile(getText("report.export", request.getLocale()));
  	  			response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
  	  			response.setHeader(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileLocation + "\"");
  	  			response.flushBuffer();			
  	  			workbook.write(response.getOutputStream());
  	  			response.getOutputStream().flush();
  	  		} catch (Exception e) {
  	  			log.error("PROCESS EXPORT EXCEL: PROD ESTIMATE ERROR: "+e.getMessage());
  	  			
  	  		} finally {
  	  			workbook.close();
  	  			response.getOutputStream().close();
  	  		}
  	  		
  		} else {
  			sumCell = 28;
  			String[] headerText = {
  	  				getText("report.instock.title.no", request.getLocale()), getText("processOrder.code", request.getLocale()),
  	  				getText("processOrder.pigType", request.getLocale()),
  	  				getText("barn.farmCode", request.getLocale()), getText("processOrder.barn.code", request.getLocale()), 
  	  				getText("report.table.th.sourceFarm", request.getLocale()), getText("report.table.th.title.entryDate", request.getLocale()), 
  	  				getText("report.table.th.slNhap", request.getLocale()), getText("report.table.th.culling7Days", request.getLocale()), 
  	  				getText("report.table.th.totalEntryVolumn", request.getLocale()), getText("report.table.th.avgEntryVolumn", request.getLocale()), 
  	  				getText("report.table.th.title.feedDay", request.getLocale()), getText("report.table.th.dayAge", request.getLocale()),
  	  				getText("report.table.th.sumAmountFeedUsed", request.getLocale()), getText("report.table.th.pigQuantityEstimate", request.getLocale()), 
  	  				getText("report.table.th.tlUoctinh", request.getLocale()), getText("report.table.th.averageVolumnEstimate", request.getLocale()), 
  	  				getText("report.table.th.slDieuChuyen", request.getLocale()), getText("report.table.th.tlDieuchuyen", request.getLocale()), 
  	  				getText("report.table.th.slBan", request.getLocale()), getText("report.table.th.tlBan", request.getLocale()), 
  	  				getText("report.table.th.avgVolumnEstimate", request.getLocale()), getText("report.table.th.slChet", request.getLocale()), 
  	  				getText("report.table.th.tlChet", request.getLocale()), getText("report.table.th.fcr.estimate", request.getLocale()), 
  	  				getText("report.table.th.fcr.standard", request.getLocale()), getText("report.table.th.fcr.range", request.getLocale()), 
  	  				getText("report.table.th.adg", request.getLocale())
  	  		};
  	  		XSSFWorkbook workbook = new XSSFWorkbook();
  	  		try {
  	  			XSSFSheet sheet = workbook.createSheet("REPORT_PROD_ESTIMATE");
  	  			writeHeader(sheet, sumCell, headerText);
  	  			ReportProdEstimateDto criteria = new ReportProdEstimateDto();
  	  			criteria.setFarmCodeString(stockCodes);
  	  			criteria.setStage(stage);
  	  			criteria.setBarnCodeStr(barnCodes);
  	  		criteria.setProcessOrderCode(poCode);
  	  			List<ReportProdEstimateDto> report = reportManager.handleReportProdEstimate(criteria);
  	  			writeReportProdEstimate(sheet, report, false);
  	  			String fileLocation = createNameFile(getText("report.export", request.getLocale()));
  	  			response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
  	  			response.setHeader(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileLocation + "\"");
  	  			response.flushBuffer();			
  	  			workbook.write(response.getOutputStream());
  	  			response.getOutputStream().flush();
  	  		} catch (Exception e) {
  	  			log.error("PROCESS EXPORT EXCEL: PROD ESTIMATE ERROR: "+e.getMessage());
  	  			
  	  		} finally {
  	  			workbook.close();
  	  			response.getOutputStream().close();
  	  		}
  		}
  		
  	}
  	
  	public void writeReportProdEstimate(XSSFSheet sheet, List<ReportProdEstimateDto> report, Boolean typeLevel) {
  		Integer rowNum = 1;
  		Integer countNo = 1;
  		if (report != null && !report.isEmpty()) {
  			for (ReportProdEstimateDto item : report) {
  				try {
  					Row row = sheet.createRow(rowNum++);
  	  				Integer column = 0;
  	  				Cell cell = row.createCell(column++);
  	  				cell.setCellValue(countNo);
  	  				
  	  				if(typeLevel) {
  	  					cell = row.createCell(column++);
  	  	  				cell.setCellValue(item.getProcessOrderCode() != null ? item.getPigLevel() : "");
  	  	  				cell = row.createCell(column++);
  		  				cell.setCellValue(item.getProcessOrderCode() != null ? item.getProcessOrderCode() : "");
  	  				} else {
  	  					cell = row.createCell(column++);
  	  	  				cell.setCellValue(item.getProcessOrderCode() != null ? item.getProcessOrderCode() : "");
  	  				}
  	  				
	  	  			cell = row.createCell(column++);
	  				cell.setCellValue(item.getPigType() != null ? item.getPigType() : "");
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getFarmCode() != null ? item.getFarmCode() : "");
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getBarnCode() != null ? item.getBarnCode() : "");
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getSourceEntry() != null ? item.getSourceEntry() : "");
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getDisplayEntryDate()!= null ? item.getDisplayEntryDate() : "");
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getEntryQuantity() != null ? item.getEntryQuantity().intValue() : 0);
  	  				cell = row.createCell(column++);
	  				cell.setCellValue(item.getCulling7DayAmount() != null ? item.getCulling7DayAmount().intValue() : 0);
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getEntryVolumn() != null ? item.getEntryVolumn().doubleValue() : 0);
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getAverageEntryVolumn() != null ? item.getAverageEntryVolumn().doubleValue() : 0);
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getDayFeeds() != null ? item.getDayFeeds().intValue() : 0);
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getAgeDay() != null ? item.getAgeDay().intValue() : 0);
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getFeedTotal() != null ? item.getFeedTotal().doubleValue() : 0);
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getPigEstimate() != null ? item.getPigEstimate().intValue() : 0);
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getTotalVolumnEstimate() != null ? item.getTotalVolumnEstimate().doubleValue() : 0);
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getAverageVolumnEstimate() != null ? item.getAverageVolumnEstimate().doubleValue() : 0);
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getIssueQuantity() != null ? item.getIssueQuantity().intValue() : 0);
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getIssueVolumn() != null ? item.getIssueVolumn().doubleValue() : 0);
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getSoldQuantity() != null ? item.getSoldQuantity().intValue() : 0);
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getSoldVolumn() != null ? item.getSoldVolumn().doubleValue() : 0);
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getAverageVolumn() != null ? item.getAverageVolumn().doubleValue() : 0);
  	  				if(typeLevel) {
	  	  				cell = row.createCell(column++);
	  	  				cell.setCellValue(item.getStandardWeight() != null ? item.getStandardWeight().doubleValue() :  0);
  	  				}
  	  				
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getDeadQuantity() != null ? item.getDeadQuantity().intValue() : 0);
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getDeadRatio() != null ? item.getDeadRatio().doubleValue() : 0);
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getFcrEstimate() != null ? item.getFcrEstimate().doubleValue() : 0);
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getFcrStandard() != null ? item.getFcrStandard().doubleValue() : 0);
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getFcrDiff() != null ? item.getFcrDiff().doubleValue() : 0);
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getAdg() != null ? item.getAdg().doubleValue() : 0);

  	  				countNo++;
  				} catch (Exception e) {
  					continue;
  				}
  				
  			}
  		}
  	}
  	
  	//=========EXPORT REPORT_KẾT QUẢ NĂNG SUẤT_TO_EXCEL_FILE==============//
  	@GetMapping("/report/prod-result-export-excel")
  	public void exportReportProdResult(@RequestParam(name ="stockCodes", required = true) String stockCodes
  									, @RequestParam(name = "fromDate", required = true) String fromDate
  									, @RequestParam(name = "toDate", required = true) String toDate
  									, @RequestParam(name = "barnCodes", required = false) String barnCodes
  									, @RequestParam(name = "type", required = false) String type
  									, HttpServletRequest request, HttpServletResponse response) throws Exception {
  		log.info("***********CONTROLLER::processing=export-report-productivity-result...");
  		Boolean checkTypeLevel = false;
  		if(StringUtils.isNotBlank(type)) {
  			checkTypeLevel = true;
  		}
  		
  		Integer sumCell = 23;
  		if(checkTypeLevel) {
  			String[] headerText = {
  	  				getText("report.instock.title.no", request.getLocale()), "Lứa Heo",
  	  				getText("processOrder.code", request.getLocale()), getText("processOrder.pigType", request.getLocale()),
  	  				getText("barn.farmCode", request.getLocale()), getText("processOrder.barn.code", request.getLocale()), 
  	  				getText("report.table.th.sourceFarm", request.getLocale()), getText("report.table.th.title.entryDate", request.getLocale()), 
  	  				getText("report.table.th.slNhap", request.getLocale()), getText("report.table.th.totalEntryVolumn", request.getLocale()), 
  	  				getText("report.table.th.avgEntryVolumn", request.getLocale()), getText("report.table.th.emptyPigDate", request.getLocale()), 
  	  				getText("report.table.th.title.feedDay", request.getLocale()), getText("report.table.th.exportQuantity", request.getLocale()), 
  	  				getText("report.table.th.exportVolumn", request.getLocale()), getText("report.table.th.avgExportVolumn", request.getLocale()), 
  	  				getText("report.table.th.slChet", request.getLocale()), getText("report.table.th.tlChet", request.getLocale()), 
  	  				getText("report.table.th.sumAmountFeedUsed", request.getLocale()), 
  	  				getText("report.table.th.fcr.reality", request.getLocale()), getText("report.table.th.fcr.standard", request.getLocale()), 
  	  				getText("report.table.th.fcr.range", request.getLocale()), getText("report.table.th.adg", request.getLocale())
  	  		};
  	  		XSSFWorkbook workbook = new XSSFWorkbook();
  	  		try {
  	  			XSSFSheet sheet = workbook.createSheet("REPORT_PROD_RESULT");
  	  			writeHeader(sheet, sumCell, headerText);
  	  			ReportProdResultDto criteria = new ReportProdResultDto();
  	  			criteria.setFarmCodeString(stockCodes);
  	  			criteria.setFromDate(fromDate);
				criteria.setToDate(toDate);
  	  			criteria.setBarnCodeStr(barnCodes);
  	  			List<ReportProdResultDto> report = reportManager.handleReportProdResultByLevel(criteria);
				if (!report.isEmpty())
  	  				writeReportProdResult(sheet, report, true);
  	  			String fileLocation = createNameFile(getText("report.export", request.getLocale()));
  	  			response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
  	  			response.setHeader(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileLocation + "\"");
  	  			response.flushBuffer();			
  	  			workbook.write(response.getOutputStream());
  	  			response.getOutputStream().flush();
  	  		} finally {
  	  			workbook.close();
  	  			response.getOutputStream().close();
  	  		}
  	  		
  		} else {
  			sumCell = 22;
  			String[] headerText = {
  	  				getText("report.instock.title.no", request.getLocale()), getText("processOrder.code", request.getLocale()),
  	  				getText("processOrder.pigType", request.getLocale()),
  	  				getText("barn.farmCode", request.getLocale()), getText("processOrder.barn.code", request.getLocale()), 
  	  				getText("report.table.th.sourceFarm", request.getLocale()), getText("report.table.th.title.entryDate", request.getLocale()), 
  	  				getText("report.table.th.slNhap", request.getLocale()), getText("report.table.th.totalEntryVolumn", request.getLocale()), 
  	  				getText("report.table.th.avgEntryVolumn", request.getLocale()), getText("report.table.th.emptyPigDate", request.getLocale()), 
  	  				getText("report.table.th.title.feedDay", request.getLocale()), getText("report.table.th.exportQuantity", request.getLocale()), 
  	  				getText("report.table.th.exportVolumn", request.getLocale()), getText("report.table.th.avgExportVolumn", request.getLocale()), 
  	  				getText("report.table.th.slChet", request.getLocale()), getText("report.table.th.tlChet", request.getLocale()), 
  	  				getText("report.table.th.sumAmountFeedUsed", request.getLocale()),
  	  				getText("report.table.th.fcr.reality", request.getLocale()), getText("report.table.th.fcr.standard", request.getLocale()), 
  	  				getText("report.table.th.fcr.range", request.getLocale()), getText("report.table.th.adg", request.getLocale())
  	  		};
  	  		XSSFWorkbook workbook = new XSSFWorkbook();
  	  		try {
  	  			XSSFSheet sheet = workbook.createSheet("REPORT_PROD_RESULT");
  	  			writeHeader(sheet, sumCell, headerText);
  	  			ReportProdResultDto criteria = new ReportProdResultDto();
  	  			criteria.setFarmCodeString(stockCodes);
				criteria.setFromDate(fromDate);
				criteria.setToDate(toDate);
  	  			criteria.setBarnCodeStr(barnCodes);
  	  			List<ReportProdResultDto> report = reportManager.handleReportProdResult(criteria);
				if (!report.isEmpty())
  	  				writeReportProdResult(sheet, report, false);
  	  			String fileLocation = createNameFile(getText("report.export", request.getLocale()));
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
  		
  	}
  	
  	public void writeReportProdResult(XSSFSheet sheet, List<ReportProdResultDto> report, Boolean typeLevel) {
  		Integer rowNum = 1;
  		Integer countNo = 1;
  		if (report != null && !report.isEmpty()) {
  			for (ReportProdResultDto item : report) {
  				try {
  					Row row = sheet.createRow(rowNum++);
  	  				Integer column = 0;
  	  				Cell cell = row.createCell(column++);
  	  				cell.setCellValue(countNo);
  	  				
  	  				if(typeLevel) {
  	  					cell = row.createCell(column++);
	  	  				cell.setCellValue(item.getPigLevel() != null ? item.getPigLevel() : "");
	  	  				cell = row.createCell(column++);
	  	  				cell.setCellValue(item.getProcessOrderCode() != null ? item.getProcessOrderCode() : "");

  	  				} else {
  	  					cell = row.createCell(column++);
  	  	  				cell.setCellValue(item.getProcessOrderCode() != null ? item.getProcessOrderCode() : "");
  	  				}
  	  				
	  	  			cell = row.createCell(column++);
	  				cell.setCellValue(item.getPigType() != null ? item.getPigType() : "");
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getFarmName() != null ? item.getFarmName() : "");
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getBarnCode() != null ? item.getBarnCode() : "");
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getSourceEntry() != null ? item.getSourceEntry() : "");
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getDisplayEntryDate()!= null ? item.getDisplayEntryDate() : "");
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getEntryQuantity().intValue());
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getEntryVolumn().doubleValue());
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getAverageEntryVolumn().doubleValue());
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getDisplayEmptyDate()!= null ? item.getDisplayEmptyDate() : "");
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getDayFeeds().intValue());
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getExportQuantity().intValue());
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getExportVolumn().doubleValue());
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getAvgExportVolumn().doubleValue());
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getDeadQuantity().intValue());
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getDeadRatio().doubleValue());
					cell = row.createCell(column++);
  	  				cell.setCellValue(item.getFeedTotal().doubleValue());
  	  				
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getFcrReality().doubleValue());
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getFcrStandard()!= null ? item.getFcrStandard().doubleValue() : 0);
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getFcrDiff().doubleValue());
  	  				cell = row.createCell(column++);
  	  				cell.setCellValue(item.getAdg().doubleValue());

  	  				countNo++;
  				} catch (Exception e) {
  					continue;
  				}
  				
  			}
  		}
  	}
  	
  //=========EXPORT REPORT_DANH SÁCH HEO THẢI LOẠI_TO_EXCEL_FILE==============//
  	@GetMapping("/report/pig-culling-export-excel")
  	public void exportReportPigCulling(@RequestParam(name ="poCode", required = true) String poCode
  									, HttpServletRequest request, HttpServletResponse response) throws Exception {
  		log.info("***********CONTROLLER::processing=export-report-pig-culling...");
  		Integer sumCell = 9;
  		String[] headerText = {
  				getText("report.instock.title.no", request.getLocale()),
  				getText("event.transCode", request.getLocale()), getText("pigdead.material", request.getLocale()), 
  				getText("pigdead.quantity", request.getLocale()), getText("pigdead.weight", request.getLocale()),
  				getText("dailyAverageWeight.avgWeight", request.getLocale()), getText("pigdead.reason", request.getLocale()),
  				getText("pigdead.posting.date", request.getLocale()), getText("pigdead.status", request.getLocale())
  		};
  		XSSFWorkbook workbook = new XSSFWorkbook();
  		try {
  			XSSFSheet sheet = workbook.createSheet("DANH SACH HEO THAI LOAI");
  			writeHeader(sheet, sumCell, headerText);
  			EventDto criteria = new EventDto();
  			List<String> types = new ArrayList<>();
  	    	types.add(EventCodeEnum.PIG_CULLING.val);
  	    	types.add(EventCodeEnum.PIG_DEAD.val);
  	    	criteria.setTypes(types);
  	    	criteria.setProcessOrderCode(poCode);
  	    	criteria.setSize(1000);
  	    	criteria.setPage(0);
  	    	
  	    	List<EventDto> report = eventManager.getExport(criteria);
  			writeReportPigCulling(sheet, report, request);
  			String fileLocation = createNameFile(getText("report.export", request.getLocale()));
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
  	
  	public void writeReportPigCulling(XSSFSheet sheet, List<EventDto> report, HttpServletRequest request) {
  		Integer rowNum = 1;
  		Integer countNo = 1;
  		if (!CollectionUtils.isEmpty(report)) {
  			for (EventDto item : report) {
  				boolean checkZero = false;
  				
  				Row row = sheet.createRow(rowNum++);
  				Integer column = 0;
  				Cell cell = row.createCell(column++);
  				cell.setCellValue(countNo);
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getTransCode() != null ? item.getTransCode() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getMaterialCode() != null ? item.getMaterialCode() : "");
  				cell = row.createCell(column++);
  				if(item.getQuantity() != null) {
  					cell.setCellValue(item.getQuantity().intValue());
  				} else {
  					cell.setCellValue(0);
  					checkZero = true;
  				}
  				cell = row.createCell(column++);
  				
  				if(item.getPigCulling() != null && item.getPigCulling().getWeight() != null) {
  					cell.setCellValue(item.getPigCulling().getWeight().floatValue());
  				} else {
  					cell.setCellValue(0);
					checkZero = true;
				}
				cell = row.createCell(column++);
				
				if(checkZero) {
					cell.setCellValue(0);
				} else {
					BigDecimal avgWeight = item.getPigCulling().getWeight().divide(new BigDecimal(item.getQuantity().intValue()),2, RoundingMode.HALF_UP);
	  				cell.setCellValue(avgWeight.floatValue());
				}
  				
  				cell = row.createCell(column++);
  				
  				cell.setCellValue(item.getPigCulling().getReason());
  				cell = row.createCell(column++);
  				
  				cell.setCellValue(item.getDisplayPostingDate() != null ? item.getDisplayPostingDate() : "");
  				cell = row.createCell(column++);
  				
  				if(StringUtils.isNotBlank(item.getStatus())){
  					String keyName = "purchase.requisition.status."+item.getStatus();
  					cell.setCellValue(getText(keyName, request.getLocale()));
  					
  				} else {
  					cell.setCellValue("");
  				}
  				
  				countNo++;
  			}
  		}
  	}
  	
  //=========EXPORT REPORT_CHI_TIẾT_NXT_THEO_NGÀY_TO_EXCEL_FILE==============//
  	@GetMapping("/report/day-detail-grga-export-excel")
  	public void exportReportDayDetailGRGA(@RequestParam(name ="farmCode", required = true) String farmCode
  									, @RequestParam(name = "fromDate", required = true) String fromDate
									, @RequestParam(name = "toDate", required = true) String toDate
  									, @RequestParam(name = "purchaseGroups", required = true) String purchaseGroups
  									, HttpServletRequest request, HttpServletResponse response) throws Exception {
  		log.info("***********CONTROLLER::processing=export-report-day-detail-grga...");
  		
  		XSSFWorkbook workbook = new XSSFWorkbook();
  		try {
  			XSSFSheet sheet = workbook.createSheet("REPORT_DAY_DETAIL_GRGA");
  			
  			ReportDayGRGADto criteria = new ReportDayGRGADto();
  			criteria.setFarmCode(farmCode);
  			criteria.setFromDate(fromDate);
			criteria.setToDate(toDate);
  			String[] arrays = purchaseGroups.split(",");
  			List<String> purchaseGroupsList = Arrays.asList(arrays);
  			criteria.setPurchaseGroups(purchaseGroupsList);
  			
  			List<ReportDayGRGADto> report = reportManager.handleReportDayGRGA(criteria);
  			List<DayDetailDto> list = report.get(0).getListDdays();
  			
  			List<String> daysStr = new ArrayList<>();
  			list.stream().forEach(d -> {
  				String dateDisplay = DateTimeHelper.toDateString(d.getRecordDate(), DatePatternEnum.DD_MM_YYYY_1.pattern);
  				daysStr.add(dateDisplay);
  			});
  			
  			writeHeaderReportDayDetailGRGA(sheet, daysStr, request);
  			writeReportDayDetailGEGA(sheet, report);
  			String fileLocation = createNameFile(getText("report.export", request.getLocale()));
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
  	
  	private void writeHeaderReportDayDetailGRGA(XSSFSheet sheet, List<String> displayPostingDates, HttpServletRequest request) {
		log.info("PROCESS: WRITE HEADER FOR REPORT DAY DETAIL GRGA FILE EXCEL");
		Row headerRow1 = sheet.createRow(0);
		Row headerRow2 = sheet.createRow(1);
		int i = 0;
		headerRow1.createCell(i).setCellValue(getText("material.code", request.getLocale()));
		sheet.addMergedRegion(new CellRangeAddress(0, 1, i, i));
		i++;
		headerRow1.createCell(i).setCellValue(getText("material.name", request.getLocale()));
		sheet.addMergedRegion(new CellRangeAddress(0, 1, i, i));
		i++;
		headerRow1.createCell(i).setCellValue(getText("material.dvt", request.getLocale()));
		sheet.addMergedRegion(new CellRangeAddress(0, 1, i, i));
		i++;
		headerRow1.createCell(i).setCellValue(getText("material.amountEarlyStage", request.getLocale()));
		sheet.addMergedRegion(new CellRangeAddress(0, 1, i, i));
		for(String d : displayPostingDates) {
			i++;
			int firstItemColumn = i;
			headerRow1.createCell(i).setCellValue(d);
			i++;
			headerRow1.createCell(i);
			i++;
			headerRow1.createCell(i);
			sheet.addMergedRegion(new CellRangeAddress(0, 0, firstItemColumn, i));
		}
		i++;
		int firstTotalColumn = i;
		headerRow1.createCell(i).setCellValue(getText("report.table.th.total", request.getLocale()));
		i++;
		headerRow1.createCell(i);
		i++;
		headerRow1.createCell(i);
		sheet.addMergedRegion(new CellRangeAddress(0, 0, firstTotalColumn, i));
		
		i = 3;
		for(String d : displayPostingDates) {
			i++;
			headerRow2.createCell(i).setCellValue(getText("report.table.th.title.amountGoodsReceipt", request.getLocale()));
			i++;
			headerRow2.createCell(i).setCellValue(getText("report.table.th.title.amountGoodsIssue", request.getLocale()));
			i++;
			headerRow2.createCell(i).setCellValue(getText("report.table.th.title.amountGoodsReceiptEstimate", request.getLocale()));
		}
		i++;
		headerRow2.createCell(i).setCellValue(getText("report.table.th.title.total.amountGoodsReceipt", request.getLocale()));
		i++;
		headerRow2.createCell(i).setCellValue(getText("report.table.th.title.total.amountGoodsIssue", request.getLocale()));
		i++;
		headerRow2.createCell(i).setCellValue(getText("report.table.th.title.amountFinalStage", request.getLocale()));
	}
  	
  	public void writeReportDayDetailGEGA(XSSFSheet sheet, List<ReportDayGRGADto> report) {
  		Integer rowNum = 2;
  		Integer countNo = 1;
  		if (!CollectionUtils.isEmpty(report)) {
  			for (ReportDayGRGADto item : report) {
  				Row row = sheet.createRow(rowNum++);
  				Integer column = 0;
  				Cell cell = row.createCell(column++);
  				cell.setCellValue(item.getMaterialCode() != null ? item.getMaterialCode() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getMaterialName() != null ? item.getMaterialName() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getMaterialUnit() != null ? item.getMaterialUnit() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getEarlyQuantity() != null ? item.getEarlyQuantity().intValue() : 0);

				for(DayDetailDto d : item.getListDdays()) {
  					cell = row.createCell(column++);
  	  				cell.setCellValue(d.getReceiptQuantity() != null ? d.getReceiptQuantity().intValue() : 0);
  	  				cell = row.createCell(column++);
	  				cell.setCellValue(d.getIssueQuantity() != null ? d.getIssueQuantity().intValue() : 0);
	  				cell = row.createCell(column++);
  	  				cell.setCellValue(d.getReceiptEstimate() != null ? d.getReceiptEstimate().intValue() : 0);
  				}
  				
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getTotalReceiptQuantity() != null ? item.getTotalReceiptQuantity().intValue() : 0);
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getTotalIssueQuantity() != null ? item.getTotalIssueQuantity().intValue() : 0);
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getFinalQuantity() != null ? item.getFinalQuantity().intValue() : 0);
  				
  				countNo++;
  			}
  		}
  	}
  	
  	//=========EXPORT REPORT_BÁO CÁO TRA SOÁT_TO_EXCEL_FILE==============//
  	@GetMapping("/report/data-invest-export-excel")
  	public void exportReportDataInvest(@RequestParam(name ="stockCodes", required = true) String stockCodes
									, @RequestParam(name = "stage", required = true) String stage
  									, HttpServletRequest request, HttpServletResponse response) throws Exception {
  		log.info("***********CONTROLLER::processing=export-report-data-invest...");
  		Integer sumCell = 10;
  		String[] headerText = {
  				getText("report.instock.title.no", request.getLocale()),getText("processOrder.code", request.getLocale()),
  				"Chuồng", getText("barn.farmCode", request.getLocale()), 
  				getText("processOrder.startDate", request.getLocale()), getText("processOrder.nearest.goods_attrition", request.getLocale()), 
  				getText("enter.label.evaluateAmount", request.getLocale()), getText("processOrder.nearest.WeightNote", request.getLocale()),
  				"Lệnh Trước", "Lứa Heo"
  		};
  		
  		XSSFWorkbook workbook = new XSSFWorkbook();
  		try {
  			XSSFSheet sheet = workbook.createSheet("DANH SACH TRA SOAT DU LIEU");
  			writeHeader(sheet, sumCell, headerText);
  			DataInvestDto criteria = new DataInvestDto();
  			criteria.setFarmCodeString(stockCodes);
  			criteria.setStage(stage);
  	    	
  	    	List<DataInvestDto> report = reportManager.handleReportDataInvest(criteria);
  	    	writeReportDataInvest(sheet, report, request);
  			String fileLocation = createNameFile(getText("report.export", request.getLocale()));
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
  	
  	public void writeReportDataInvest(XSSFSheet sheet, List<DataInvestDto> report, HttpServletRequest request) {
  		Integer rowNum = 1;
  		Integer countNo = 1;
  		if (!CollectionUtils.isEmpty(report)) {
  			for (DataInvestDto item : report) {
  				Row row = sheet.createRow(rowNum++);
  				Integer column = 0;
  				Cell cell = row.createCell(column++);
  				cell.setCellValue(countNo);
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getProcessOrderCode() != null ? item.getProcessOrderCode() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getBarnName() != null ? item.getBarnName() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getFarmName()  != null ? item.getFarmName() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getDisplayStartDate());
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getDisplayNearestGA());
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getEvaluteAmount().floatValue());
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getDisplayNearesrWeightNote());
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getEarlyProcessOrder());
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getPigLevel());
  				cell = row.createCell(column++);
  				
  				countNo++;
  			}
  		}
  	}
  	
  	//=========EXPORT REPORT_DANH SÁCH LỆNH_SX_TO_EXCEL_FILE==============//
  	@GetMapping("/report/processOrder")
  	public void exportReportProcessOrder(@RequestParam(name ="poCode", required = false) String poCode, @RequestParam(name ="barn", required = false) String barn,
  										@RequestParam(name ="searchFromDate", required = false) String searchFromDate, @RequestParam(name ="searchToDate", required = false) String searchToDate,
  										@RequestParam(name ="searchFromCloseDate", required = false) String searchFromCloseDate, @RequestParam(name ="searchToCloseDate", required = false) String searchToCloseDate,
									   @RequestParam(name ="status", required = false) String status, @RequestParam(name ="closeDate", required = false) String closeDate, HttpServletRequest request, HttpServletResponse response) throws Exception {
  		log.info("***********CONTROLLER::processing=export-report-process-order...");
  		Integer sumCell = 11;
  		String[] headerText = {
  				getText("report.instock.title.no", request.getLocale()), getText("processOrder.code", request.getLocale()),
  				getText("processOrder.barnCode", request.getLocale()), getText("processOrder.quantity.sap", request.getLocale()), 
  				getText("processOrder.realQuantity", request.getLocale()), getText("processOrder.pigType", request.getLocale()), 
  				getText("processOrder.startDate.sap", request.getLocale()), getText("processOrder.endDate.sap", request.getLocale()),
  				getText("processOrder.closeDate.app", request.getLocale()), getText("processOrder.batch", request.getLocale()),
  				getText("processOrder.status", request.getLocale())
  		};
  		XSSFWorkbook workbook = new XSSFWorkbook();
  		try {
  			XSSFSheet sheet = workbook.createSheet("DANH SACH LSX");
  			writeHeader(sheet, sumCell, headerText);
  			ProcessOrderDto criteria = new ProcessOrderDto();
  			if(StringUtils.isNotBlank(poCode)){
  				criteria.setCode(poCode);
  			}
  			
  			if(StringUtils.isNotBlank(barn)){
  				criteria.setBarnCode(barn);
  			}
  			
  			if(StringUtils.isNotBlank(searchFromDate)) criteria.setSearchFromDate(searchFromDate);
			if (StringUtils.isNotBlank(searchToDate)) criteria.setSearchToDate(searchToDate);
			
			if(StringUtils.isNotBlank(searchFromCloseDate)) criteria.setSearchCloseFromDate(searchFromCloseDate);
			if (StringUtils.isNotBlank(searchToCloseDate)) criteria.setSearchCloseToDate(searchToCloseDate);
  			
  			if(StringUtils.isNotBlank(status)){
  				String[] list = status.split(SymbolEnum.COMMA.val);
  				List<String> statuses = Arrays.asList(list);
  				criteria.setStatuses(statuses);
  			}
  	    	
  	    	List<ProcessOrderDto> report = processOrderManager.getProcessOrderForExport(criteria);
  	    	writeReportProcessOrder(sheet, report, request);
  			String fileLocation = createNameFile(getText("report.export", request.getLocale()));
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
  	
  	public void writeReportProcessOrder(XSSFSheet sheet, List<ProcessOrderDto> report, HttpServletRequest request) {
  		Integer rowNum = 1;
  		Integer countNo = 1;
  		if (!CollectionUtils.isEmpty(report)) {
  			for (ProcessOrderDto item : report) {
  				Row row = sheet.createRow(rowNum++);
  				Integer column = 0;
  				Cell cell = row.createCell(column++);
  				cell.setCellValue(countNo);
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getCode() != null ? item.getCode() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getBarn().getCode() != null ? item.getBarn().getCode() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getQuantity() != null ? item.getQuantity().intValue() : 0);
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getRealQuantity() != null ? item.getRealQuantity().intValue() : 0);
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getPigType() != null ? item.getPigType() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getStartDateDisplay() != null ? item.getStartDateDisplay() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getEndDateDisplay() != null ? item.getEndDateDisplay() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getClosedDateDisplay() != null ? item.getClosedDateDisplay() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getBatch() != null ? item.getBatch() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getStatus() != null ? item.getStatus() : "");
  				cell = row.createCell(column++);
  				
  				countNo++;
  			}
  		}
  	}
  	
  	@GetMapping("/farm/export")
  	public void exportFarm(HttpServletRequest request, HttpServletResponse response) throws Exception {
  		log.info("***********CONTROLLER::processing=export-farm...");
  		Integer sumCell = 6;
  		String[] headerText = {
  				getText("report.instock.title.no", request.getLocale()), getText("farm.code", request.getLocale()),
  				getText("farm.name", request.getLocale()), getText("farm.address", request.getLocale()), 
  				getText("farm.totalPig", request.getLocale()), getText("farm.pig.dead", request.getLocale())
  		};
  		
  		XSSFWorkbook workbook = new XSSFWorkbook();
  		try {
  			XSSFSheet sheet = workbook.createSheet("DANH SACH TRAI");
  			writeHeader(sheet, sumCell, headerText);
  			FarmDto criteria = new FarmDto();
  			criteria.setPorkerFarm(true);
  			criteria.setPage(0);
  			criteria.setSize(1000);
  			
  			ObjectMapper mapper = new ObjectMapper();
  			
  			List<FarmDto> report =  mapper.convertValue(farmManager.search(criteria).getContent(), new TypeReference<List<FarmDto>>(){});
  			
  			writeExportFarm(sheet, report, request);
  			String fileLocation = createNameFile(getText("report.export", request.getLocale()));
  			response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
  			response.setHeader(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileLocation + "\"");
  			response.flushBuffer();			
  			workbook.write(response.getOutputStream());
  			response.getOutputStream().flush();
  		} catch (Exception e) {
  			System.out.println(e);
  		} finally {
  			workbook.close();
  			response.getOutputStream().close();
  		}
  	}
  	
  	public void writeExportFarm(XSSFSheet sheet, List<FarmDto> report, HttpServletRequest request) {
  		Integer rowNum = 1;
  		Integer countNo = 1;
  		if (!CollectionUtils.isEmpty(report)) {
  			for (FarmDto item : report) {
  				Row row = sheet.createRow(rowNum++);
  				Integer column = 0;
  				Cell cell = row.createCell(column++);
  				cell.setCellValue(countNo);
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getCode() != null ? item.getCode() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getName() != null ? item.getName() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getAddress() != null ? item.getAddress() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getTotalPigRetained() != null ? item.getTotalPigRetained() : 0);
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getTotalPigDead() != null ? item.getTotalPigDead() : 0);
  				
  				countNo++;
  			}
  		}
  	}
  	
  	@GetMapping("/pigProduction/export")
  	public void exportPigProduction(@RequestParam(name ="poCode", required = false) String poCode, HttpServletRequest request, HttpServletResponse response) throws Exception {
  		log.info("***********CONTROLLER::processing=export-pigProduction");
  		Integer sumCell = 9;
  		String[] headerText = {
  				getText("report.instock.title.no", request.getLocale()), getText("pigprod.processOrderCode", request.getLocale()),
  				getText("event.transCode", request.getLocale()), getText("pigdead.reason", request.getLocale()), 
  				getText("pigprod.quantity", request.getLocale()), getText("pigdead.weight", request.getLocale()),
  				getText("dailyAverageWeight.avgWeight", request.getLocale()), getText("pigdead.posting.date", request.getLocale()),
  				getText("pigprod.status", request.getLocale())
  		};
  		
  		XSSFWorkbook workbook = new XSSFWorkbook();
  		try {
  			XSSFSheet sheet = workbook.createSheet("DANH SACH HEO THANH PHAM");
  			writeHeader(sheet, sumCell, headerText);
  			EventDto criteria = new EventDto();
  			criteria.setCode(EventCodeEnum.FINISH_PRODUCT.val);
  	    	criteria.setProcessOrderCode(poCode);
  			criteria.setPage(0);
  			criteria.setSize(1000);
  			
  			List<EventDto> report =  eventManager.getExport(criteria);
  			
  			writeExportPigProduction(sheet, report, poCode, request);
  			String fileLocation = createNameFile(getText("report.export", request.getLocale()));
  			response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
  			response.setHeader(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileLocation + "\"");
  			response.flushBuffer();			
  			workbook.write(response.getOutputStream());
  			response.getOutputStream().flush();
  		} catch (Exception e) {
  			System.out.println(e);
  		} finally {
  			workbook.close();
  			response.getOutputStream().close();
  		}
  	}
  	
  	public void writeExportPigProduction(XSSFSheet sheet, List<EventDto> report, String poCode, HttpServletRequest request) {
  		Integer rowNum = 1;
  		Integer countNo = 1;
  		if (!CollectionUtils.isEmpty(report)) {
  			for (EventDto item : report) {
  				boolean checkZero = false;
  				
  				Row row = sheet.createRow(rowNum++);
  				Integer column = 0;
  				Cell cell = row.createCell(column++);
  				cell.setCellValue(countNo);
  				cell = row.createCell(column++);
  				cell.setCellValue(poCode);
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getTransCode() != null ? item.getTransCode() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getPigProd().getReason() != null ? item.getPigProd().getReason() : "");
  				cell = row.createCell(column++);
  				if(item.getQuantity() != null && item.getQuantity().compareTo(new BigDecimal(0)) != 0) {
  					cell.setCellValue(item.getQuantity().intValue());
  					
  				} else {
  					cell.setCellValue(0);
  					checkZero = true;
  				}
  				cell = row.createCell(column++);
  				if(item.getPigProd() != null && item.getPigProd().getWeight() != null) {
  					cell.setCellValue(item.getPigProd().getWeight().doubleValue());
  				} else {
  					cell.setCellValue(0);
  					checkZero = true;
  				}
  				cell = row.createCell(column++);
  				if(checkZero) {
  					cell.setCellValue(0);
  				} else {
  					BigDecimal avg = item.getPigProd().getWeight().divide(item.getQuantity(), 2, RoundingMode.HALF_UP);
  					cell.setCellValue(avg.doubleValue());
  				}
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getDisplayPostingDate() != null ? item.getDisplayPostingDate() : "");
  				cell = row.createCell(column++);
  				cell.setCellValue(item.getStatus() != null ? item.getStatus() : "");
  				
  				countNo++;
  			}
  		}
  	}

	@GetMapping("/report/task/export")
	public void exportReportTaskToExcelFile(@RequestParam(name = "taskTitle", required = false) String taskTitle,
											@RequestParam(name = "assigneeUsername", required = false) String assigneeUsername,
											@RequestParam(name = "fromDate", required = true) String fromDate,
											@RequestParam(name = "toDate", required = true) String toDate,
											HttpServletRequest request, HttpServletResponse response) throws IOException {
		  log.info("entering: 'export-report-task-to-excel-file' method...");
		  Locale locale = request.getLocale();
		  Integer sumCell = 9;
		  String[] headerText = {
				  getText("report.instock.title.no", locale), getText("task.table.th.title", locale),
				  getText("task.table.th.deadline", locale),
				  getText("task.status.confirm.yet", locale), getText("task.status.todo", locale),
				  getText("task.status.overdue", locale), getText("task.status.overdue.cause", locale),
				  getText("task.status.done", locale), getText("task.status.rejected.farm", locale),
				  getText("task.status.rejected.cause", locale)
		  };
		  XSSFWorkbook workbook = new XSSFWorkbook();
		  String roleTaskAdminView = "ROLE_TASK_ADMIN_VIEW";

		  try {
			  XSSFSheet sheet = workbook.createSheet("DANH SACH CONG VIEC");
			  writeHeader(sheet, sumCell, headerText);
			  ReportTaskDto criteria = new ReportTaskDto();
			  criteria.setSearchFromDate(fromDate);
			  criteria.setSearchToDate(toDate);
			  criteria.setTaskTitle(taskTitle);
			  criteria.setAssigneeUsername(assigneeUsername);
			  criteria.setAdminView(request.isUserInRole(roleTaskAdminView));

			  List<ReportTaskDto> reports = reportManager.handleExportReportTask(criteria);
			  writeReportTask(sheet, reports);
			  String fileLocation = createNameFile("BAO_CAO_CONG_VIEC");
			  response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
			  response.setHeader(HttpHeaders.CONTENT_DISPOSITION, setContentDisposition(fileLocation));
			  response.flushBuffer();
			  workbook.write(response.getOutputStream());
			  response.getOutputStream().flush();
		  } catch (Exception e) {
			  throw new RuntimeException(e);
		  } finally {
			  workbook.close();
			  response.getOutputStream().close();
		  }
	}

	private void writeReportTask(XSSFSheet sheet, List<ReportTaskDto> reports) throws Exception {
		  int rowNum = 1;
		  int countNo = 1;
		  if (!CollectionUtils.isEmpty(reports)) {
			  for (ReportTaskDto report:reports) {
				  if (report.getDataRowNumber() != null) {
					  List keyOverdues = List.of(report.getOverdues().keySet());
					  List valueOverdues = List.of(report.getOverdues().values());

					  List keyRejects = List.of(report.getRejects().keySet());
					  List valueRejects = List.of(report.getRejects().values());
					  for (int i = 0; i < report.getDataRowNumber(); i++) {
						  Row row = sheet.createRow(rowNum++);
						  int column = 0;
						  Cell cell = row.createCell(column++);

						  if (i == 0) {
							  // STT
							  cell.setCellValue(countNo);
							  cell = row.createCell(column++);
							  // task title
							  cell.setCellValue(report.getTaskTitle());
							  cell = row.createCell(column++);
							  cell.setCellValue(report.getDeadline());
							  cell = row.createCell(column++);
						  } else {
							  // STT
							  cell.setCellValue("");
							  cell = row.createCell(column++);
							  // task title
							  cell.setCellValue("");
							  cell = row.createCell(column++);
							  // deadline
							  cell.setCellValue("");
							  cell = row.createCell(column++);
						  }

						  // assigned
						  cell.setCellValue(report.getAssigned() != null && report.getAssigned().size() > i ? report.getAssigned().get(i) : "");
						  cell = row.createCell(column++);

						  // todos
						  cell.setCellValue(report.getTodos() != null && report.getTodos().size() > i ? report.getTodos().get(i) : "");
						  cell = row.createCell(column++);

						  // overdue + causeOverdue
						  Map<String, String> overdues = report.getOverdues();
						  if (!overdues.isEmpty()) {
							  // assignee
							  String assigneeOverdue = "";
							  try {
								  assigneeOverdue = keyOverdues.get(i).toString();
							  } catch (IndexOutOfBoundsException ex) {
								  assigneeOverdue = "";
							  }
							  cell.setCellValue(assigneeOverdue);
							  cell = row.createCell(column++);

							  // nguyen nhan cham tien do
							  String causeOverdue = "";
							  try {
								  causeOverdue = valueOverdues.get(i).toString();
							  } catch (IndexOutOfBoundsException ex) {
								  causeOverdue = "";
							  }
							  cell.setCellValue(causeOverdue);
							  cell = row.createCell(column++);
						  } else {
							  // assginee
							  cell.setCellValue("");
							  cell = row.createCell(column++);
							  // nguyen nhan cham tien do
							  cell.setCellValue("");
							  cell = row.createCell(column++);
						  }

						  // dones
						  cell.setCellValue(report.getDones() != null && report.getDones().size() > i ? report.getDones().get(i) : "");
						  cell = row.createCell(column++);

						  // reject + causeReject
						  Map<String, String> rejects = report.getRejects();
						  if (!rejects.isEmpty()) {
							  // assignee
							  String assigneeRejected = "";
							  try {
								  assigneeRejected = keyRejects.get(i).toString();
							  } catch (IndexOutOfBoundsException ex) {
								  assigneeRejected = "";
							  }
							  cell.setCellValue(assigneeRejected);
							  cell = row.createCell(column++);

							  // nguyen nhan cham tien do
							  String causeReject = "";
							  try {
								  causeReject = valueRejects.get(i).toString();
							  } catch (IndexOutOfBoundsException ex) {
								  causeReject = "";
							  }
							  cell.setCellValue(causeReject);
							  cell = row.createCell(column++);
						  } else {
							  // reject
							  cell.setCellValue("");
							  cell = row.createCell(column++);
							  // nguyen nhan tu choi
							  cell.setCellValue("");
							  cell = row.createCell(column++);
						  }
					  }
					  // increase row
					  countNo++;
				  }
			  }
		  }
	}

	private String setContentDisposition(String name) {
		return "attachment; filename=\"" + name + "\"";
	}
}
