package com.imggaming.dge.scoring.controller;

import com.livestream.exchange.model.Event;
import com.livestream.exchange.service.impl.EventServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
public class EventController {
    private static final Logger LOG = LoggerFactory.getLogger(EventController.class);
    private final EventServiceImpl eventService;

    public EventController(EventServiceImpl eventService) {
        this.eventService = eventService;
    }

    @PutMapping("/external/events/{eventId}")
    public List<Event> event(@PathVariable Integer eventId, @RequestBody Map<Object, Object> params) {
        var result = new ArrayList<Event>();
        var event = eventService.updateEvent(eventId, params);
        LOG.info("UPDATE: Event {} has been updated", event);
        result.add(eventService.getEventById(event.getId()));
        return result;
    }
}
