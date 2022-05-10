package xyz.fluentqa.vaadin.crm.entity;

import xyz.fluentqa.vaadin.base.AbstractEntity;

import javax.persistence.Entity;


@Entity
public class Status extends AbstractEntity {
    private String name;

    public Status() { }

    public Status(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

}
