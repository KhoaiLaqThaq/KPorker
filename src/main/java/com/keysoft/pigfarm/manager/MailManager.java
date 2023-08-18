package com.keysoft.pigfarm.manager;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.keysoft.pigfarm.constant.MailEnum;
import com.keysoft.pigfarm.production.dto.MailDto;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class MailManager {
	@Autowired
	private JavaMailSender mailSender;
	
	public void sendMail(MailDto mail) {
		log.debug("enter 'sendMail' method");
		MimeMessage mimeMessage = mailSender.createMimeMessage();
		try {
			MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true);
			
			helper.setFrom(MailEnum.EMAIL_SUPPORT.val);
			helper.setSubject(mail.getSubject());
			helper.setTo(mail.getMailTo());
			helper.setText(mail.getMailContent());
			mimeMessage.setContent(mail.getMailContent(), "text/html");
			
			mailSender.send(mimeMessage);
		} catch (MessagingException e) {
			e.printStackTrace();
		}
	}
}
