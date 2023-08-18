package com.keysoft.pigfarm.config;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;
import org.keycloak.jose.jws.JWSInput;
import org.keycloak.representations.AccessToken;
import org.keycloak.representations.AccessToken.Access;
import org.keycloak.representations.AccessTokenResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Component;

import com.keysoft.pigfarm.constant.ApiEnum;
import com.keysoft.pigfarm.util.CurrentUser;
import com.keysoft.pigfarm.util.RestHelper;
import com.speedfrwk.security.jwt.model.AuthenticationRequest;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class CustomAuthenticationProvider implements AuthenticationProvider {

	@Autowired
	private ServiceProperties serviceProperties;
	
	@Autowired
	private RestHelper restHelper;

	@Override
	public Authentication authenticate(Authentication authentication) throws AuthenticationException {
		log.info("Entering authenticate()...");
		
        String name = authentication.getName();
        String password = authentication.getCredentials().toString();
        
        AuthenticationRequest authenticationRequest = new AuthenticationRequest();
        authenticationRequest.setUsername(name);
        authenticationRequest.setPassword(password);
        
        ResponseEntity<?> res = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_LOGIN.val), HttpMethod.POST, authenticationRequest, AccessTokenResponse.class);
        AccessTokenResponse accessResponse = (AccessTokenResponse)res.getBody();
        
        if (StringUtils.isNotBlank(accessResponse.getError())) {
        	throw new BadCredentialsException("Username or Password not correct.");
        }
        
        String realm = (String)accessResponse.getOtherClaims().get("realm");
        log.debug("realm: {}", realm);
        String token = accessResponse.getToken();
        log.debug("token: {}", token);
        AccessToken accessToken = new AccessToken();
        try {
            JWSInput input = new JWSInput(token);
            accessToken = input.readJsonContent(AccessToken.class);
        } catch (Exception e) {
            e.printStackTrace();
            throw new BadCredentialsException("Username or Password not correct.");
        }

        Set<String> roles = new HashSet<>();
        Map<String, Access> accesses = accessToken.getResourceAccess();
        accesses.entrySet().stream().forEach(e -> {
        	roles.addAll(e.getValue().getRoles());
        });

        List<String> filteredRoles = roles.stream().filter(r -> r.startsWith("ROLE_")).collect(Collectors.toList());
        final List<GrantedAuthority> grantedAuths = filteredRoles.stream().map(SimpleGrantedAuthority::new).collect(Collectors.toList());
        final CurrentUser currentUser = new CurrentUser(name, password, grantedAuths, realm, token);
        return new UsernamePasswordAuthenticationToken(currentUser, password, grantedAuths);
        
	}

	@Override
	public boolean supports(Class<?> authentication) {
		return authentication.equals(UsernamePasswordAuthenticationToken.class);
	}

}
