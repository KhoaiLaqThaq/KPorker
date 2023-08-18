package com.keysoft.pigfarm.util;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class JsonHelper {
	public String readFromJsonFile(String filePath) throws IOException {
		log.info("entering readFromJsonFile({})", filePath);
		File resource = new ClassPathResource(filePath).getFile();
		return new String(Files.readAllBytes(resource.toPath()));
	}
}
