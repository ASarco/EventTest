package com.livestream.exchange.dao;

import com.livestream.exchange.model.Event;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface EventDao {

  Event save(Event persistent);

  Event findById(Integer id);

}
