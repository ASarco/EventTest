package com.livestream.exchange.service.impl;

import com.livestream.exchange.dao.EventDao;
import com.livestream.exchange.model.Event;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.Map;

@Service
@Transactional
public class EventServiceImpl {

  private static final Logger LOG = LoggerFactory.getLogger(EventServiceImpl.class);

  @Autowired private EventDao eventDao;

  public Event getEventById(Integer eventId) {
    return eventDao.findById(eventId);
  }

  public Event save(Event event) {
    if (event.getId() == null) {
      LOG.info("Creating event.");
    } else {
      LOG.info("Updating event with id={}", event.getId());
    }

    Event managedEvent = null;
    try {
      managedEvent = eventDao.save(event);
    } catch (Exception e) {
      LOG.info("Caught EXCEPTION , for event , safe to ignore.", e);
      // return managedEvent;
      throw e;
    }
    LOG.info("Event saved with id={}", managedEvent.getId());
    return managedEvent;
  }

  // FIXME: this method is an ugly hack
  public Event updateEvent(Integer gfxConfigId, Map<Object, Object> params) {
    final Event event = eventDao.findById(gfxConfigId);
    event.setStartDate(new Date((Long) params.get("startDate")));
    if (params.containsKey("endDate") && params.get("endDate") != null) {
      event.setEndDate(new Date((Long) params.get("endDate")));
    }
    event.setTitle((String) params.get("title"));
    return save(event);
  }
}
