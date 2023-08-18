package com.keysoft.pigfarm.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import com.keysoft.pigfarm.manager.CustomUserDetailsManager;


@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {
    @Autowired
    CustomAuthenticationSuccessHandler authenticationSuccessHandler;
    @Autowired
    CustomAuthenticationFailureHandler authenticationFailureHandler;

    @Autowired
    private CustomAuthenticationProvider authProvider;
    
    @Bean
    public UserDetailsService getUserDetailsService() {
        return new CustomUserDetailsManager();
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
		auth.authenticationProvider(authProvider);
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
    
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .authorizeRequests()
            	.antMatchers("/login").permitAll()
            	.antMatchers("/resources/**").permitAll()
            	
            	// 	filter user's role
            	.antMatchers("/user/list**","/group/list**").hasAnyRole("ADMIN","ORG_ADMIN","USER_VIEW")
            	.antMatchers("/user/form**","/group/form**").hasAnyRole("ADMIN","ORG_ADMIN","USER_CREATE", "USER_UPDATE", "GROUP_CREATE")
            	.antMatchers("/user**","/group**").hasAnyRole("ADMIN", "ORG_ADMIN","USER_CREATE","USER_UPDATE","USER_VIEW")
            	// system parameter
            	.antMatchers("/systemParameter/list**").hasAnyRole("ADMIN", "SYS_PARAM_VIEW")
            	.antMatchers("/systemParameter/form**").hasAnyRole("ADMIN", "SYS_PARAM_CREATE", "SYS_PARAM_UPDATE")
            	// farm
            	.antMatchers("/farm/list**").hasAnyRole("ADMIN", "FARM_VIEW")
            	.antMatchers("/farm/form**").hasAnyRole("ADMIN", "FARM_CREATE", "FARM_UPDATE")
            	// material
            	.antMatchers("/material**").hasAnyRole("ADMIN", "MATERIAL_VIEW")
            	.antMatchers("/materialSupport**").hasAnyRole("ADMIN", "MATERIAL_VIEW")
            	
            	// stockCount
            	.antMatchers("/stockCount/list**").hasAnyRole("ADMIN", "STOCK_COUNT_VIEW", "STOCK_COUNT_EXPORT", "STOCK_COUNT_EDIT")
            	.antMatchers("/stockCount/form**").hasAnyRole("ADMIN", "STOCK_COUNT_UPDATE", "STOCK_COUNT_EDIT")
            	// instock
            	.antMatchers("/instock/list**").hasAnyRole("ADMIN", "INSTOCK_VIEW", "INSTOCK_EXPORT", "INSTOCK_EDIT", "INSTOCK_IMPORT")
            	.antMatchers("/instock/form**").hasAnyRole("ADMIN", "INSTOCK_UPDATE", "INSTOCK_EDIT", "INSTOCK_EXPORT")
            	// instock_baseline
            	.antMatchers("/instock-baseline/list**").hasAnyRole("ADMIN", "INSTOCK_BASELINE_VIEW", "INSTOCK_BASELINE_EXPORT", "INSTOCK_BASELINE_EDIT", "INSTOCK_BASELINE_IMPORT")
            	.antMatchers("/instock-baseline/form**").hasAnyRole("ADMIN", "INSTOCK_BASELINE_UPDATE", "INSTOCK_BASELINE_EDIT", "INSTOCK_BASELINE_EXPORT")
            	// purchaseRequisition
            	.antMatchers("/purchaseRequisition/list**").hasAnyRole("ADMIN", "PURCHASE_REQUISITION_VIEW", "PURCHASE_REQUISITION_EXPORT", "PURCHASE_REQUISITION_DELETE", "PURCHASE_REQUISITION_EDIT", "PURCHASE_REQUISITION_CREATE")
            	.antMatchers("/purchaseRequisition/form**").hasAnyRole("ADMIN", "PURCHASE_REQUISITION_CREATE", "PURCHASE_REQUISITION_CANCEL", "PURCHASE_REQUISITION_CONFIRM", "PURCHASE_REQUISITION_EDIT")
            	// goodsReceiptRequisition
            	.antMatchers("/goodsReceipt-Requisition/list**").hasAnyRole("ADMIN", "GOODS_RECEIPT_REQUISITION_VIEW", "GOODS_RECEIPT_REQUISITION_EDIT", "GOODS_RECEIPT_REQUISITION_DELETE")
            	.antMatchers("/goodsReceipt-Requisition/form**").hasAnyRole("ADMIN", "GOODS_RECEIPT_CREATE")
            	// goodsReceipt
            	.antMatchers("/goodsReceipt/list**").hasAnyRole("ADMIN", "GOODS_RECEIPT_VIEW", "GOODS_RECEIPT_CREATE", "GOODS_RECEIPT_EXPORT", "GOODS_RECEIPT_DELETE", "GOODS_RECEIPT_EDIT")
            	.antMatchers("/goodsReceipt/form**").hasAnyRole("ADMIN", "GOODS_RECEIPT_CREATE", "GOODS_RECEIPT_CANCEL")
            	// goodsIssueRequisition
            	.antMatchers("/goodsIssue-Requisition/list**").hasAnyRole("ADMIN", "GOODS_ISSUE_REQUISITION_VIEW", "GOODS_ISSUE_REQUISITION_EDIT", "GOODS_ISSUE_REQUISITION_DELETE")
            	.antMatchers("/goodsIssue-Requisition/form**").hasAnyRole("ADMIN", "GOODS_ISSUE_CREATE")
            	// goodsIssue
            	.antMatchers("/goodsIssue/list**").hasAnyRole("ADMIN", "GOODS_ISSUE_VIEW", "GOODS_ISSUE_CREATE", "GOODS_ISSUE_EXPORT", "GOODS_ISSUE_DELETE", "GOODS_ISSUE_EDIT")
            	.antMatchers("/goodsIssue/form**").hasAnyRole("ADMIN", "GOODS_ISSUE_CREATE", "GOODS_ISSUE_CANCEL")
            	// instock Adjustment
            	.antMatchers("/instockAdjustment/list**").hasAnyRole("ADMIN", "INSTOCK_ADJUSTMENT_VIEW", "INSTOCK_ADJUSTMENT_CREATE", "INSTOCK_ADJUSTMENT_EDIT")
            	.antMatchers("/instockAdjustment/form**").hasAnyRole("ADMIN", "INSTOCK_ADJUSTMENT_CREATE", "INSTOCK_ADJUSTMENT_CANCEL")
            	// barnplan
            	.antMatchers("/barnPlan/list**").hasAnyRole("ADMIN", "BARN_PLAN_VIEW", "BARN_PLAN_EDIT")
            	.antMatchers("/barnPlan/form**").hasAnyRole("ADMIN", "BARN_PLAN_CREATE")
            	// goodsAttritionSupport
            	.antMatchers("/goodsAttritionSupport/list**").hasAnyRole("ADMIN", "GOODS_ATTRITION_SUPPORT_VIEW", "GOODS_ATTRITION_SUPPORT_CREATE", "GOODS_ATTRITION_SUPPORT_EXPORT", "GOODS_ATTRITION_SUPPORT_EDIT", "MATERIAL_SUPPORT_EDIT","GOODS_ATTRITION_SUPPORT_COPY")
            	.antMatchers("/goodsAttritionSupport/form**").hasAnyRole("ADMIN", "GOODS_ATTRITION_SUPPORT_CREATE","GOODS_ATTRITION_SUPPORT_DELETE", "ROLE_GOODS_ATTRITION_SUPPORT_NOT_DELETE")
            	// materialSupport
            	.antMatchers("/materialSupport/form**").hasAnyRole("ADMIN", "MATERIAL_SUPPORT_CREATE")
            	// processOrder
            	.antMatchers("/processOrder/list**").hasAnyRole("ADMIN", "GOODS_ATTRITION_SUPPORT_VIEW", "GOODS_ATTRITION_SUPPORT_CREATE", "GOODS_ATTRITION_SUPPORT_EXPORT", "GOODS_ATTRITION_SUPPORT_EDIT", "MATERIAL_SUPPORT_EDIT","GOODS_ATTRITION_SUPPORT_COPY")
            	.antMatchers("/processOrder/form**").hasAnyRole("ADMIN", "GOODS_ATTRITION_SUPPORT_CREATE")
            	// materialSupport
            	.antMatchers("/materialSupport/form**").hasAnyRole("ADMIN", "MATERIAL_SUPPORT_CREATE")
            	//pigEntry
            	.antMatchers("/pigEntry/list**").hasAnyRole("ADMIN", "PIG_ENTRY_VIEW", "PIG_ENTRY_CREATE", "PIG_ENTRY_EDIT")
            	.antMatchers("/pigEntry/form**").hasAnyRole("ADMIN", "PIG_ENTRY_CREATE")
            	//goodsAttrition
            	.antMatchers("/goodsAttrition/list**").hasAnyRole("ADMIN", "GOODS_ATTRITION_VIEW", "GOODS_ATTRITION_CREATE", "GOODS_ATTRITION_EDIT")
            	.antMatchers("/goodsAttrition/form**").hasAnyRole("ADMIN", "GOODS_ATTRITION_CREATE")
            	//dailyAverageWeight
            	.antMatchers("/dailyAverageWeight/list**").hasAnyRole("ADMIN", "WEIGHT_NOTE_VIEW", "WEIGHT_NOTE_CREATE", "WEIGHT_NOTE_EDIT")
            	.antMatchers("/dailyAverageWeight/form**").hasAnyRole("ADMIN", "WEIGHT_NOTE_CREATE")
            	//pigCulling
            	.antMatchers("/pigCulling/list**").hasAnyRole("ADMIN", "PIG_CULLING_VIEW", "PIG_CULLING_CREATE", "PIG_CULLING_EDIT")
            	.antMatchers("/pigCulling/form**").hasAnyRole("ADMIN", "PIG_CULLING_CREATE")
            	//pigProduction
            	.antMatchers("/pigProduction/list**").hasAnyRole("ADMIN", "FINISH_PRODUCT_VIEW", "FINISH_PRODUCT_CREATE", "FINISH_PRODUCT_EDIT")
            	.antMatchers("/pigProduction/form**").hasAnyRole("ADMIN", "FINISH_PRODUCT_CREATE")
            	//proposal
            	.antMatchers("/proposal/list**").hasAnyRole("ADMIN", "PROPOSAL_VIEW", "PROPOSAL_CREATE", "PROPOSAL_EDIT", "PROPOSAL_CONFIRM")
            	.antMatchers("/proposal/form**").hasAnyRole("ADMIN", "PROPOSAL_CREATE", "PROPOSAL_EDIT", "PROPOSAL_CONFIRM")
            	// CONSUMING_FARM
            	.antMatchers("/consumingWater/list**").hasAnyRole("ADMIN", "CONSUMING_FARM")
            	// CLOSE PERIOD
            	.antMatchers("/periodClose**").hasAnyRole("ADMIN", "ROLE_PERIOD_CLOSE")
            	//report
            	.antMatchers("/consumingWater**").hasAnyRole("ADMIN", "REPORT_VIEW")
            	.antMatchers("/report**").hasAnyRole("ADMIN", "REPORT_VIEW")
				// hoach toan chi phi
				.antMatchers("/general-ledger/list**").hasAnyRole("ADMIN", "GENERAL_LEDGER_VIEW")
				.antMatchers("/general-ledger/form**").hasAnyRole("ADMIN", "GENERAL_LEDGER_CREATE", "GENERAL_LEDGER_EDIT")
				// cong viec
				.antMatchers("/task/list").hasAnyRole("ADMIN", "TASK_ADMIN_VIEW", "TASK_VIEW")
				.antMatchers("/task/table").hasAnyRole("ADMIN", "TASK_ADMIN_VIEW", "TASK_VIEW")
				.antMatchers("/task/calendar").hasAnyRole("ADMIN", "TASK_ADMIN_VIEW", "TASK_VIEW")
				.antMatchers("/task/form**").hasAnyRole("ADMIN", "TASK_ADMIN_VIEW", "TASK_CREATE")
				.antMatchers("/task/preview**").hasAnyRole("ADMIN", "TASK_ADMIN_VIEW", "TASK_CREATE", "TASK_UPDATE", "TASK_UPDATE_PROGRESS")
            	.anyRequest().authenticated()
            	.and()	
            	.formLogin()
            	//.successHandler(authenticationSuccessHandler)
            	.failureHandler(authenticationFailureHandler)
            	//.loginPage("/login").failureUrl("/login?error=true")
            	.loginPage("/login")
            	.usernameParameter("username")
            	.passwordParameter("password")
            	.and()
            	.logout()
            	.logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
            	.logoutSuccessUrl("/").and().exceptionHandling().accessDeniedPage("/forbidden");
        
        http.csrf().disable();
    }

    @Override
    public void configure(WebSecurity web) throws Exception {
        web
        	.ignoring()
        	.antMatchers("/resources/**")
        	.antMatchers("/themes/**");
    }

}
