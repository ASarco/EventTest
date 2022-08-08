package com.livestream.exchange.dao.impl;

import com.livestream.exchange.dao.EventDao;
import com.livestream.exchange.dao.repository.EventRepository;
import com.livestream.exchange.model.Event;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import technology.dice.dge.exception.NotFoundException;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.Optional;

@Repository
public class EventDaoImpl implements EventDao {

  @Autowired private EventRepository eventRepository;

  @PersistenceContext private EntityManager entityManager;

  @Override
  @Transactional(readOnly = false, propagation = Propagation.MANDATORY)
  public Event save(Event event) {
    return eventRepository.save(event);
  }

  @Override
  @Transactional(readOnly = true, propagation = Propagation.MANDATORY)
  public Event findById(Integer id) {
    Optional<Event> event = eventRepository.findById(id);
    return event.orElseThrow(() -> new NotFoundException("Event not found"));
  }
}
