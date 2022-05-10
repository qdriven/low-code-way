package xyz.fluentqa.vaadin.crm.repo;


import org.springframework.data.jpa.repository.JpaRepository;
import xyz.fluentqa.vaadin.crm.entity.Status;

public interface StatusRepository extends JpaRepository<Status, Integer> {

}
