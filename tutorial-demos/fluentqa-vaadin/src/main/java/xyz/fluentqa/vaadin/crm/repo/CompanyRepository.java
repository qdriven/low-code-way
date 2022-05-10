package xyz.fluentqa.vaadin.crm.repo;


import org.springframework.data.jpa.repository.JpaRepository;
import xyz.fluentqa.vaadin.crm.entity.Company;

public interface CompanyRepository extends JpaRepository<Company, Integer> {

}
