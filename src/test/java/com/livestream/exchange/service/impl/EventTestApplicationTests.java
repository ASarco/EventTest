package com.imgarena.eventtest;

import com.livestream.exchange.service.impl.EventServiceImpl;
import org.junit.ClassRule;
import org.junit.jupiter.api.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.DirtiesContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.junit4.SpringRunner;
import org.testcontainers.containers.MySQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

@RunWith(SpringRunner.class)
@SpringBootTest
@Testcontainers
@ContextConfiguration
@Sql(scripts = "create-insert.sql")
class EventTestApplicationTests {

    @Container
    public static MySQLContainer mySqlDB = new MySQLContainer("mysql:5.7")
            .withDatabaseName("integration-tests-db")
            .withUsername("admin")
            .withPassword("admin");

    @DynamicPropertySource
    public static void properties(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url",mySqlDB::getJdbcUrl);
        registry.add("spring.datasource.username", mySqlDB::getUsername);
        registry.add("spring.datasource.password", mySqlDB::getPassword);

    }

    final EventServiceImpl eventService;

    @Autowired
    public EventTestApplicationTests(EventServiceImpl eventService) {
        this.eventService = eventService;
    }

    @Test
    void contextLoads() {
    }

}
