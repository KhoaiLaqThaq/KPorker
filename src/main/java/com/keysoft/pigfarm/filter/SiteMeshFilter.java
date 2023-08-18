package com.keysoft.pigfarm.filter;

import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;

public class SiteMeshFilter extends ConfigurableSiteMeshFilter {
	@Override
	protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {
		builder.addDecoratorPath("/*", "/themes/admin/decorator/admin.jsp")
			   .addExcludedPath("/login")
			   .addExcludedPath("/passwordChange");
	}
}
