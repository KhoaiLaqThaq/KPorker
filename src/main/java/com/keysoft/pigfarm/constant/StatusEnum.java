package com.keysoft.pigfarm.constant;

public enum StatusEnum {
	Active("0"), 
    InActive("1");
    
	
    // ...

    private String status;

    private StatusEnum(String status) {
        this.status = status;
    }

    public String getStatus() {
        return status;
    }
}
