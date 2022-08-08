package com.livestream.exchange.dao.impl;

import com.livestream.exchange.dao.EventDao;
import com.livestream.exchange.dao.helper.EventQueryBuilder;
import com.livestream.exchange.dao.helper.PageableQueryBuilder;
import com.livestream.exchange.dao.query.TimelineQuery;
import com.livestream.exchange.dao.repository.EncodeDetailsRepository;
import com.livestream.exchange.dao.repository.EventRepository;
import com.livestream.exchange.model.EncodeDetails;
import com.livestream.exchange.model.Event;
import com.livestream.exchange.model.Operator;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;
import javax.inject.Inject;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import technology.dice.dge.exception.NotFoundException;
import technology.dice.dge.model.dto.timeline.TimelineDto;
import technology.dice.dge.model.dto.timeline.TimelineEventDto;

@Repository
public class EventDaoImpl implements EventDao {

  @Inject private EventRepository eventRepository;

  @Inject private EncodeDetailsRepository encodeDetailsRepository;

  @PersistenceContext private EntityManager entityManager;

  @Override
  @Transactional(readOnly = true, propagation = Propagation.MANDATORY)
  public List<Event> findLiveByOperatorGroup(Operator.Group group) {

    EventQueryBuilder queryBuilder = new EventQueryBuilder().liveOnly().forGroup(group);

    return queryBuilder.buildQuery(entityManager).list();
  }

  @Override
  @Transactional(readOnly = true, propagation = Propagation.MANDATORY)
  public List<Event> find(EventQueryBuilder queryBuilder) {
    PageableQueryBuilder<Event> pBuilder = queryBuilder.buildQuery(entityManager);
    return pBuilder.list();
  }

  @Override
  @Transactional(readOnly = true, propagation = Propagation.MANDATORY)
  public Page<Event> findByProperty(Integer propertyId, Pageable pageable) {
    return eventRepository.findByProperty(propertyId, pageable);
  }

  @Override
  @Transactional(readOnly = true, propagation = Propagation.MANDATORY)
  public Page<Event> findBySport(Integer sportId, Pageable pageable) {
    return eventRepository.findBySport(sportId, pageable);
  }

  @Override
  @Transactional(readOnly = true, propagation = Propagation.MANDATORY)
  public List<Event> findLive(Integer operatorId) {
    EventQueryBuilder queryBuilder = new EventQueryBuilder().liveOnly();

    if (operatorId != null) {
      queryBuilder.forOperator(operatorId).bookedOnly(true);
    }
    return queryBuilder.buildQuery(entityManager).list();
  }

  @Override
  @Transactional(readOnly = true, propagation = Propagation.MANDATORY)
  public List<Event> findLive() {
    EventQueryBuilder queryBuilder = new EventQueryBuilder().liveOnly();
    return queryBuilder.buildQuery(entityManager).list();
  }

  @Override
  @Transactional(readOnly = true, propagation = Propagation.MANDATORY)
  public List<Event> findAll(List<Integer> ids) {
    String queryString =
        "select e from Event e "
            + "join fetch e.tournament t "
            + "join fetch t.property "
            + "left join fetch e.streamingConfigs "
            + "where e.id in(:ids) and e.isDeleted=0";
    List<Event> result =
        entityManager
            .createQuery(queryString, Event.class)
            .setParameter("ids", ids)
            .getResultList();
    if (result.isEmpty()) {
      return Collections.emptyList();
    }
    return result;
  }

  @Override
  @Transactional(readOnly = false, propagation = Propagation.MANDATORY)
  public Event save(Event event) {
    return eventRepository.save(event);
  }

  @Override
  @Transactional(readOnly = true, propagation = Propagation.MANDATORY)
  public Event findById(Integer id) {
    Event event = eventRepository.findOneWithTournamentPropertySport(id);
    if (Objects.nonNull(event)) {
      return event;
    } else {
      throw new NotFoundException("Not Found: Event id = " + id);
    }
  }

  @Override
  public boolean isStoreVodFileEnabled(Integer eventId) {
    String queryString =
        "SELECT oe.event_id "
            + "FROM License l "
            + "JOIN OperatorEvent oe ON l.id = oe.license_id "
            + "WHERE l.storeVod = 1 AND oe.event_id = :id ";
    Query query = entityManager.createNativeQuery(queryString).setParameter("id", eventId);
    return !query.getResultList().isEmpty();
  }

  @Override
  @Transactional(readOnly = false, propagation = Propagation.MANDATORY)
  public void saveEncodeDetails(EncodeDetails encodeDetails) {
    encodeDetailsRepository.save(encodeDetails);
  }

  @Override
  @Transactional(readOnly = false, propagation = Propagation.MANDATORY)
  public void deleteEncodeDetails(EncodeDetails encodeDetails) {
    encodeDetailsRepository.delete(encodeDetails);
  }

  @Override
  @Transactional(readOnly = true, propagation = Propagation.MANDATORY)
  public List<Event> findByTournament(Integer tournamentId) {
    String query =
        "select e from Event e "
            + "left join fetch e.streamingConfig sc left join fetch e.streamingConfigs "
            + "join fetch e.tournament t "
            + "where t.id=:tournamentId and e.isDeleted=0";
    return entityManager
        .createQuery(query, Event.class)
        .setParameter("tournamentId", tournamentId)
        .getResultList();
  }

  @Override
  @Transactional(readOnly = true, propagation = Propagation.MANDATORY)
  public List<Event> findByProperty(Integer propertyId) {
    String query =
        "select e from Event e "
            + "left join fetch e.streamingConfig sc left join fetch e.streamingConfigs "
            + "join fetch e.tournament t "
            + "join fetch t.property p "
            + "where p.id=:propertyId and e.endDate >= current_timestamp() and e.isDeleted=0";
    return entityManager
        .createQuery(query, Event.class)
        .setParameter("propertyId", propertyId)
        .getResultList();
  }

  @Override
  @Transactional(readOnly = true, propagation = Propagation.MANDATORY)
  public Event findById(Integer id, boolean returnDeleted) {
    List<Event> events =
        entityManager
            .createQuery(getFindByIdQuery(returnDeleted), Event.class)
            .setParameter(1, id)
            .getResultList();

    if (events.isEmpty()) {
      return null;
    }
    return events.get(0);
  }

  private String getFindByIdQuery(boolean returnDeleted) {
    String queryString =
        "select e from Event e "
            + "join fetch e.tournament "
            + "left join fetch e.streamingConfig "
            + "left join fetch e.streamingConfigs "
            + "left join fetch e.gfxConfig "
            + "where e.id=?1";

    if (!returnDeleted) {
      queryString = queryString + " and e.isDeleted = 0";
    }

    return queryString;
  }

  @Override
  public List<TimelineEventDto> findForTimeLine(Integer channelId, Date startDate, Date endDate) {
    List<TimelineDto> timelines;
    if (channelId == null) {
      Query query =
          entityManager.createNativeQuery(
              TimelineQuery.FIND_ALL_EVENTS_TIMELINE, "TimelineDtoMapper");
      query.setParameter(1, startDate);
      query.setParameter(2, endDate);
      timelines = query.getResultList();
    } else {
      Query query =
          entityManager.createNativeQuery(
              TimelineQuery.FIND_ALL_EVENTS_TIMELINE_BY_CHANNEL_ID, "TimelineDtoMapper");
      query.setParameter(1, startDate);
      query.setParameter(2, endDate);
      query.setParameter(3, channelId);
      timelines = query.getResultList();
    }
    return timelines.stream().map(TimelineEventDto::from).collect(Collectors.toList());
  }
}
