package com.keysoft.pigfarm.util;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStreamReader;
import java.util.zip.GZIPInputStream;
import java.util.zip.GZIPOutputStream;

import org.springframework.stereotype.Component;

@Component
public class GZipHelper {
	
	public byte[] compress(String str) throws Exception {
	    if (str == null || str.length() == 0) {
	        return null;
	    }
	    System.out.println("String length : " + str.length());
	    ByteArrayOutputStream obj=new ByteArrayOutputStream();
	    GZIPOutputStream gzip = new GZIPOutputStream(obj);
	    gzip.write(str.getBytes("UTF-8"));
	    gzip.close();
	    
	    return obj.toByteArray();
	 }
	
	  public String decompress(byte[] str) throws Exception {
	    if (str == null ) {
	        return null;
	    }
	    
	    GZIPInputStream gis = new GZIPInputStream(new ByteArrayInputStream(str));
	    BufferedReader bf = new BufferedReader(new InputStreamReader(gis, "UTF-8"));
	    String outStr = "";
	    String line;
	    while ((line=bf.readLine())!=null) {
	      outStr += line;
	    }
	    System.out.println("Output String lenght : " + outStr.length());
	    return outStr;
	 }
}
