package xyz.resultant.app.crm.data.repository;

import xyz.resultant.app.crm.data.entity.Company;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CompanyRepository extends JpaRepository<Company, UUID> {

}
