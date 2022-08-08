package com.livestream.exchange.dao.repository;

import com.livestream.exchange.model.Event;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface EventRepository
    extends JpaRepository<Event, Integer>, JpaSpecificationExecutor<Event> {}
