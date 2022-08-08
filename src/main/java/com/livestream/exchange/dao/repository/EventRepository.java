package com.livestream.exchange.dao.repository;

import com.livestream.exchange.model.Event;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;

public interface EventRepository
    extends JpaRepository<Event, Integer>, JpaSpecificationExecutor<Event> {

  @Override
  @Query(
      value =
          "select e from Event e join fetch e.tournament "
              + "left join fetch e.streamingConfigs where e.id=?1")
  Event findOne(Integer id);

  @Query(
      value =
          "select e from Event e "
              + "left outer join fetch e.streamingConfigs sc "
              + "left join fetch e.streamingConfig config "
              + "join fetch e.tournament t "
              + "join fetch t.property p "
              + "join fetch p.sport s "
              + "where e.id = ?1")
  Event findOneWithTournamentPropertySport(Integer eventId);

  @Query(
      value =
          "select e from Event e "
              + "join fetch e.tournament t "
              + "join fetch t.property p "
              + "left join fetch e.streamingConfigs "
              + "where p.id = ?1",
      countQuery = "select count(e) from Event e where e.tournament.property.id = ?1")
  Page<Event> findByProperty(Integer propertyId, Pageable pageable);

  @Query(
      value =
          "select e from Event e "
              + "join fetch e.tournament t "
              + "join fetch t.property p "
              + "left join fetch e.streamingConfigs "
              + "where p.sport.id = ?1",
      countQuery = "select count(e) from Event e where e.tournament.property.sport.id = ?1")
  Page<Event> findBySport(Integer sportId, Pageable pageable);
}
