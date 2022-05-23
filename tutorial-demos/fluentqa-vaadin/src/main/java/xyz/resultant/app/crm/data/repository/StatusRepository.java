package xyz.resultant.app.crm.data.repository;

import xyz.resultant.app.crm.data.entity.Status;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface StatusRepository extends JpaRepository<Status, UUID> {

}
