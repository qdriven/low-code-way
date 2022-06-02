package xyz.resultant.app;

import com.vaadin.flow.component.dependency.NpmPackage;
import com.vaadin.flow.component.page.AppShellConfigurator;
import com.vaadin.flow.server.PWA;
import com.vaadin.flow.theme.Theme;
import com.vaadin.flow.theme.material.Material;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

/**
 * The entry point of the Spring Boot application.
 *
 * Use the @PWA annotation make the application installable on phones, tablets
 * and some desktop browsers.
 *
 */
@SpringBootApplication
@Theme(value = "fluentqapp")
@PWA(name = "FluentQA-App", shortName = "FluentQA-App", offlineResources = {})
@NpmPackage(value = "line-awesome", version = "1.3.0")
public class FluentQAApp extends SpringBootServletInitializer implements AppShellConfigurator {

    public static void main(String[] args) {
        SpringApplication.run(FluentQAApp.class, args);
    }

}
