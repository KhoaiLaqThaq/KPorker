package com.keysoft.pigfarm.util;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;

/**
 * Get Spring security context to access user data security infos
 *
* @author <a href="mailto:ngtrungkien@gmail.com">Kien Nguyen</a>
 */
public class UserContext {
    /**
     * Get the current username. Note that it may not correspond to a username that
     * currently exists in your accounts' repository; it could be a spring security
     * 'anonymous user'.
     *
     * @return the current user's username, or null if none.
     */
    public static String getUsername() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (auth != null) {
            Object principal = auth.getPrincipal();

            if (principal instanceof UserDetails) {
                return ((UserDetails) principal).getUsername();
            }
            return principal.toString();
        }

        return null;
    }

    /**
     * return the current locale
     */
    public static Locale getLocale() {
        return LocaleContextHolder.getLocale();
    }

    /**
     * Retrieve the current UserDetails bound to the current thread by Spring Security, if any.
     */
    public static UserDetails getUserDetails() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (auth != null && auth.getPrincipal() instanceof UserDetails) {
            return ((UserDetails) auth.getPrincipal());
        }

        return null;
    }

    /**
     * Return the current roles bound to the current thread by Spring Security.
     */
    public static List<String> getRoles() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (auth != null) {
            return toStringList(auth.getAuthorities());
        }

        return Collections.emptyList();
    }

    /**
     * Update new password to the Security Context
     *
     * @param newPassword the new password
     */
    public static void updateNewPassword(String newPassword) {
    	SecurityContext context = SecurityContextHolder.getContext();
    	Authentication auth = context.getAuthentication();
    	String username = "";
        Object principal = auth.getPrincipal();
        if (principal instanceof UserDetails) {
        	username = ((UserDetails) principal).getUsername();
        } else {
        	username = principal.toString();        	
        }
    	
    	UsernamePasswordAuthenticationToken authRequest = new UsernamePasswordAuthenticationToken(username, newPassword , auth.getAuthorities());
    	SecurityContextHolder.getContext().setAuthentication(authRequest);
    	auth.setAuthenticated(false);
    }
    
    private static String token;
    public static String getToken() {
		return token;
	}
	public static void setToken(String token) {
		UserContext.token = token;
	}

	private static String orgIdentityCode;
	public static String getOrgIdentityCode() {
		return orgIdentityCode;
	}
	public static void setOrgIdentityCode(String orgIdentityCode) {
		UserContext.orgIdentityCode = orgIdentityCode;
	}

	// ---------------------------------------
    // Conversion utils
    // ---------------------------------------
    /**
     * To string list.
     *
     * @param grantedAuthorities the granted authorities
     * @return the list
     */
    public static List<String> toStringList(Collection<? extends GrantedAuthority> grantedAuthorities) {
        List<String> result = new ArrayList<>();

        for (GrantedAuthority grantedAuthority : grantedAuthorities) {
            result.add(grantedAuthority.getAuthority());
        }

        return result;
    }
    
    public static List<String> loginedRoles() {
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	return authentication.getAuthorities().stream().map(GrantedAuthority::getAuthority).collect(Collectors.toList());
    }
    
    public static boolean isAdminRole() {
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	return authentication.getAuthorities().stream().anyMatch(r -> r.getAuthority().equals("ROLE_ADMIN"));
    }

    public static boolean isSuperAdminRole() {
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	return authentication.getAuthorities().stream().anyMatch(r -> r.getAuthority().equals("ROLE_SUPER_ADMIN"));
    }
    
    // ----- ACCESS TOKEN ----- //
    public static String getRealm() {
    	final CurrentUser currentUser = (CurrentUser)getUserDetails();
    	return currentUser != null ? currentUser.getRealm() : null;
    }
    
    public static String getAccessToken() {
    	final CurrentUser currentUser = (CurrentUser)getUserDetails();
    	return currentUser != null ? currentUser.getAccessToken() : null;
    }
    
    
}