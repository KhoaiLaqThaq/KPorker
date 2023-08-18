package com.keysoft.pigfarm.constant;

public enum MailEnum {
	EMAIL_SUPPORT("ITService@mavin-group.com"),
	EMAIL_PASSWORD("Gtwy&*990"),
	EMAIL_SUBJECT("[PockerFloor] Password");
	
	public String val;
	
	private MailEnum(String val) {
		this.val = val;
	}
}
