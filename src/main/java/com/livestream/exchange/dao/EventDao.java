package com.livestream.exchange.dao;

import com.livestream.exchange.dao.helper.EventQueryBuilder;
import com.livestream.exchange.model.EncodeDetails;
import com.livestream.exchange.model.Event;
import com.livestream.exchange.model.Operator;
import java.util.Date;
import java.util.List;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import technology.dice.dge.model.dto.timeline.TimelineEventDto;

public interface EventDao {

  List<Event> find(EventQueryBuilder queryBuilder);

  List<Event> findByTournament(Integer tournamentId);

  Page<Event> findByProperty(Integer propertyId, Pageable pageable);

  Page<Event> findBySport(Integer sportId, Pageable pageable);

  List<Event> findLive(Integer operatorId);

  List<Event> findLive();

  Event save(Event persistent);

  Event findById(Integer id);

  List<Event> findAll(List<Integer> ids);

  boolean isStoreVodFileEnabled(Integer eventId);

  void saveEncodeDetails(EncodeDetails encodeDetails);

  List<Event> findByProperty(Integer propertyId);

  Event findById(Integer id, boolean returnDeleted);

  List<Event> findLiveByOperatorGroup(Operator.Group group);

  void deleteEncodeDetails(EncodeDetails encodeDetails);

  List<TimelineEventDto> findForTimeLine(Integer channelId, Date startDate, Date endDate);
}
