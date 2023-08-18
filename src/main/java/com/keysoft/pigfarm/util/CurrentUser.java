package com.keysoft.pigfarm.util;

import java.util.Collection;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;

@SuppressWarnings("serial")
public class CurrentUser extends User {
	
	public CurrentUser(String username, String password, Collection<? extends GrantedAuthority> authorities) {
		super(username, password, authorities);
	}

	public CurrentUser(String username, String password, Collection<? extends GrantedAuthority> authorities, String realm, String accessToken) {
		super(username, password, authorities);
		this.realm = realm;
		this.accessToken = accessToken;
	}
	
	private String realm;
	private String accessToken;
	
	public String getRealm() {
		return realm;
	}
	
	public void setRealm(String realm) {
		this.realm = realm;
	}
	
	public String getAccessToken() {
		return accessToken;
	}
	
	public void setAccessToken(String accessToken) {
		this.accessToken = accessToken;
	}


}
