package com.keysoft.pigfarm.manager;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.keysoft.pigfarm.config.ServiceProperties;
import com.keysoft.pigfarm.constant.ApiEnum;
import com.keysoft.pigfarm.util.RestHelper;
import com.speedfrwk.security.jwt.model.CustomGrantedAuthority;
import com.speedfrwk.security.jwt.model.UserSecurity;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CustomUserDetailsManager implements UserDetailsService {
    @Autowired
    private RestHelper restHelper;
    @Autowired
    private ServiceProperties serviceProperties;

	public UserSecurity loadUserByUsername(String username) throws UsernameNotFoundException {
    	log.info("process=load-user-by-username, username={}", username);
    	
    	// TODO: Using this code for integration
    	ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_AUTH_BY_USERNAME.val), HttpMethod.GET, UserSecurity.class, username);
    	if (HttpStatus.OK.equals(response.getStatusCode())) {
    		UserSecurity user = (UserSecurity)response.getBody();
    		String roles = user.getRoles();
    		log.debug("roles: {}", roles);
    		List<CustomGrantedAuthority> authorities = Arrays.asList(roles.split(",")).stream().map(CustomGrantedAuthority::new).collect(Collectors.toList());
    		log.debug("authorities: {}", authorities);
            return buildUserForAuthentication(user, authorities);
    		
    	} else {
    		throw new UsernameNotFoundException("username not found");
    	}
    	
    	// TODO: using this code for development
    	/*
    	CustomGrantedAuthority authority = new CustomGrantedAuthority("ROLE_ADMIN");
    	List<CustomGrantedAuthority> authorities = new ArrayList<>();
    	authorities.add(authority);
    	UserSecurity user = new UserSecurity("admin", "$2a$10$bH/ssqW8OhkTlIso9/yakubYODUOmh.6m5HEJvcBq3t3VdBh7ebqO", true, authorities);
    	return buildUserForAuthentication(user, authorities);
    	*/
    }

    private UserSecurity buildUserForAuthentication(UserSecurity user, List<CustomGrantedAuthority> authorities) {
    	return new UserSecurity(user.getUsername(), user.getPassword(), user.isEnabled(), authorities);
    }

	public boolean isFirstTimeAccess(String username) {
    	//AppUser appUser = appUserRepository.findByUsernameAndAccountEnabledIsTrueAndPasswordChangedDateIsNull(username);
    	return false;
    }
    
	public boolean isCheckEnable(String username) {
    	//AppUser appUser = appUserRepository.findByUsernameAndAccountEnabledIsFalse(username);
    	return true;
    }
}
