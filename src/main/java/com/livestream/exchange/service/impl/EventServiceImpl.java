package com.imgarena.exchange.service.impl;

import static com.google.common.base.Preconditions.checkArgument;

import com.github.benmanes.caffeine.cache.Cache;
import com.github.benmanes.caffeine.cache.Caffeine;
import com.github.benmanes.caffeine.cache.LoadingCache;
import com.google.common.annotations.VisibleForTesting;
import com.google.common.base.Preconditions;
import com.google.common.base.Stopwatch;
import com.google.common.collect.Sets;
import com.imggaming.dge.external.syndication.service.SyndicationIntegrationService;
import com.imggaming.dge.provision.model.ZixiServer;
import com.imggaming.dge.scoring.model.GFXConfig;
import com.livestream.exchange.dao.EventDao;
import com.livestream.exchange.dao.TournamentDao;
import com.livestream.exchange.dao.helper.EventQueryBuilder;
import com.livestream.exchange.dao.repository.EventRenditionRepository;
import com.livestream.exchange.dto.StreamPrefix;
import com.livestream.exchange.model.EncodeDetails;
import com.livestream.exchange.model.Event;
import com.livestream.exchange.model.EventRendition;
import com.livestream.exchange.model.LocalBroadcaster;
import com.livestream.exchange.model.Operator;
import com.livestream.exchange.model.Tournament;
import com.livestream.exchange.service.EventBookingService;
import com.livestream.exchange.service.EventService;
import com.livestream.exchange.service.OperatorEventService;
import com.livestream.exchange.utils.GeolocUtils;
import java.time.Duration;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;
import javax.persistence.PersistenceException;
import org.apache.commons.collections.CollectionUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import technology.dice.dge.content.dto.event.EventBitrateDto;
import technology.dice.dge.content.dto.streamingconfig.StreamingConfig;
import technology.dice.dge.content.model.dto.stream.ZixiInputDto;
import technology.dice.dge.content.service.StreamingConfigService;
import technology.dice.dge.content.viewevent.exception.EventNotFoundException;
import technology.dice.dge.exception.StreamingConfigsException;
import technology.dice.dge.exchange.content.model.dto.live.LiveEventDto;
import technology.dice.dge.exchange.scoring.service.ExternalIntegrationService;
import technology.dice.dge.exchange.scoring.service.GFXConfigServiceImpl;
import technology.dice.dge.exchange.transcoder.model.dto.TranscoderDto;
import technology.dice.dge.exchange.transcoder.service.TranscoderService;
import technology.dice.dge.model.command.UpdateEventRatiosCommand;
import technology.dice.dge.model.dto.timeline.TimelineEventDto;
import technology.dice.dge.repository.LocalBroadcasterRepository;

@Service
@Transactional
public class EventServiceImpl implements EventService {

  private static final Logger LOG = LoggerFactory.getLogger(EventServiceImpl.class);

  private static final Long ADMIN_LIVE_EVENTS_CACHE_KEY = Long.MIN_VALUE;
  private final Cache<String, List<TimelineEventDto>> timelineCache =
      Caffeine.newBuilder().expireAfterWrite(Duration.ofSeconds(30L)).build();
  @Autowired private EventDao eventDao;
  private final LoadingCache<Long, List<LiveEventDto>> liveEventsPerOperators =
      Caffeine.newBuilder().expireAfterWrite(Duration.ofSeconds(60L)).build(this::getLiveEvents);
  @Autowired private technology.dice.dge.content.service.EventService eventService;
  @Autowired private TournamentDao tournamentDao;
  @Autowired private OperatorEventService operatorEventService;
  @Autowired
  private technology.dice.dge.licensing.service.OperatorEventService newOperatorEventService;
  @Autowired private GFXConfigServiceImpl gfxConfigService;
  @Autowired private EventRenditionRepository eventRenditionRepository;
  @Autowired private EventBookingService eventBookingService;
  @Autowired private ExternalIntegrationService externalIntegrationService;
  @Autowired private SyndicationIntegrationService syndicationIntegrationService;
  @Autowired private LocalBroadcasterRepository localBroadcasterRepository;
  @Autowired private StreamingConfigService streamingConfigService;
  @Autowired private TranscoderService transcoderService;

  @Override
  public Event findById(Integer id) {
    return eventDao.findById(id);
  }

  @Override
  public Event findByIdWithScoreType(Integer id) {
    Event event = eventDao.findById(id);
    if (event != null) {
      GFXConfig gfxConfig = event.getGfxConfig();
      if (null != gfxConfig && null != gfxConfig.getExternalEventId()) {
        try {
          final String scoreType =
              externalIntegrationService.getScoreType(gfxConfig.getExternalEventId());
          event.setScoreType(scoreType);
        } catch (Exception e) {
          LOG.error("Failed to contact scoring app.");
        }
      }
    }
    return event;
  }

  @Override
  public Event findById(Integer id, Integer operatorId) {
    final Event event = eventDao.findById(id);
    event.setBooked(
        newOperatorEventService.isBookedByOperatorAndEvent(
            Long.valueOf(operatorId), Long.valueOf(id)));
    return event;
  }

  @Override
  @Transactional
  public Event delete(Integer id) {
    final Event event = this.findById(id);
    return delete(event);
  }

  @Override
  public Event delete(Event event) {
    Long longId = Long.valueOf(event.getId());
    List<StreamingConfig> configs = streamingConfigService.getStreamingConfigsByEvent(longId);
    checkArgument(CollectionUtils.isEmpty(configs), "Cannot delete event with provisioned stream");
    event.setIsDeleted(true);
    eventDao.save(event);
    eventBookingService.removeEventBooking(longId);
    return event;
  }

  @VisibleForTesting
  public Event create(Integer tournamentId, Event event) {
    final Tournament tournament = tournamentDao.findById(tournamentId);
    if (tournament == null) {
      LOG.info("Cant save event to unexisting tournament id: {}", tournamentId);
      throw new IllegalArgumentException(
          "Cant save event to unexisting tournament id: " + tournamentId);
    }
    event.setTournament(tournament);

    Event savedEvent = save(event);

    operatorEventService.bookEventForUnlimitedLicenses(savedEvent);

    return savedEvent;
  }

  @Override
  public void saveWithLocalBroadcasters(Event event, List<Integer> broadcastersIds) {
    HashSet<LocalBroadcaster> newBroadcasters = prepareBroadcasters(broadcastersIds);
    event.setLocalBroadcasters(newBroadcasters);

    save(event);
  }

  @Override
  public Event createWithLocalBroadcasters(
      Integer tournamentId, Event event, List<Integer> broadcastersIds) {
    HashSet<LocalBroadcaster> newBroadcasters = prepareBroadcasters(broadcastersIds);
    event.setLocalBroadcasters(newBroadcasters);

    return create(tournamentId, event);
  }

  private HashSet<LocalBroadcaster> prepareBroadcasters(List<Integer> broadcastersIds) {
    Iterable<LocalBroadcaster> broadcasters = localBroadcasterRepository.findAll(broadcastersIds);
    return Sets.newHashSet(broadcasters);
  }

  @Override
  public Event save(Event event) {
    GeolocUtils.verifyLocationList(event.getGeoListField());
    verifyTranscoders(event);

    if (event.getId() == null) {
      LOG.info("Creating event in tournament id={}", event.getTournament().getId());
    } else {
      LOG.info("Updating event with id={}", event.getId());
    }

    setupEventRenditions(event);
    Event managedEvent = null;
    try {
      managedEvent = eventDao.save(event);
    } catch (Exception e) {
      LOG.info("Caught EXCEPTION , for event , safe to ignore.", e);
      //return managedEvent;
      throw e;
    }

    if (managedEvent.getEventAttributes() != null) {
      managedEvent.getEventAttributes().setEvent(managedEvent);
    }

    eventRenditionRepository.save(managedEvent.getRenditions());

    LOG.info("Event saved with id={}", managedEvent.getId());

    GFXConfig gfxConfig = gfxConfigService.findByEvent(managedEvent);
    if (gfxConfig == null) {
      gfxConfigService.saveForEvent(managedEvent);
    }

    LOG.info("Event saved successfully id={}", managedEvent.getId());
    return managedEvent;
  }

  private void setupEventRenditions(Event event) {
    // when it is audioOnly event, but only audio rendition is NOT set
    if (event.isAudioOnly()
        && !event.getRenditions().stream().anyMatch(EventRendition::isAudioOnly)) {

      eventRenditionRepository.delete(event.getRenditions());
      event.setupAudioOnlyRenditions();
    }

    // when it is NOT audioOnly event, but only audio rendition it set
    if (event.isVideoAudio()
        && event.getRenditions().stream().anyMatch(EventRendition::isAudioOnly)) {
      eventRenditionRepository.delete(event.getRenditions());
      event.setupVideoAndAudioRenditions();
    }
  }

  private void verifyTranscoders(Event event) {
    ZixiServer primaryTranscoder = event.getPreferedZixiServer();
    ZixiServer backupTranscoder = event.getPreferedBackupZixiServer();
    if (primaryTranscoder != null
        && backupTranscoder != null
        && primaryTranscoder.getIp().equals(backupTranscoder.getIp())) {
      LOG.warn(
          "Cannot save event with the same primary and backup transcoder, tournamentId={}, IP={}",
          event.getId(),
          primaryTranscoder.getIp());
      throw new IllegalArgumentException(
          "Cannot save event with the same primary and backup transcoder.");
    }
    if (event.isVirtualLiveLinearChannel()) {
      checkArgument(
          primaryTranscoder == null && backupTranscoder == null,
          "Cannot assign preferred transcoders to VLL event");
    }
  }

  @Override
  public List<Event> findByTournament(Integer tournamentId) {
    return eventDao.findByTournament(tournamentId);
  }

  @Override
  public Page<Event> findByProperty(Integer propertyId, Pageable pageable) {
    return eventDao.findByProperty(propertyId, pageable);
  }

  @Override
  public List<Event> findByProperty(Integer propertyId) {
    return eventDao.findByProperty(propertyId);
  }

  @Override
  public Page<Event> findBySport(Integer sportId, Pageable pageable) {
    return eventDao.findBySport(sportId, pageable);
  }

  @Override
  public List<Event> find(EventQueryBuilder builder) {
    return eventDao.find(builder);
  }

  @Override
  @Transactional
  public void saveEncodeDetails(EncodeDetails encodeDetails) {
    eventDao.saveEncodeDetails(encodeDetails);
  }

  @Override
  public Event get(Long id) {
    if (id == null) {
      throw new IllegalArgumentException("Id must be provided");
    }
    return get(Math.toIntExact(id));
  }

  /**
   * Get event by event Id and throw Exception if event dosent exist
   *
   * @param id Event id
   * @return Event
   */
  @Override
  public Event get(Integer id) {
    if (id == null) {
      throw new IllegalArgumentException("Id must be provided");
    }

    final Event event = findById(id);
    if (event == null) {
      throw new PersistenceException(String.format("Event with id=%d is not found", id));
    }

    return event;
  }

  @Override
  public boolean isStoreVodFileEnabled(Integer eventId) {
    return eventDao.isStoreVodFileEnabled(eventId);
  }

  @Override
  @Transactional
  public void deleteEncodeDetails(EncodeDetails encodeDetails) {
    eventDao.deleteEncodeDetails(encodeDetails);
  }

  @Override
  @Transactional
  public Event findById(Integer id, boolean returnDeleted) {
    return eventDao.findById(id, returnDeleted);
  }

  @Override
  public List<LiveEventDto> findLive(Integer operatorId) {
    Long operatorIdLong =
        operatorId == null ? ADMIN_LIVE_EVENTS_CACHE_KEY : Long.valueOf(operatorId);
    return liveEventsPerOperators.get(operatorIdLong);
  }

  private List<LiveEventDto> getLiveEvents(Long key) {
    Stopwatch stopwatch = Stopwatch.createStarted();
    List<Event> events;
    if (ADMIN_LIVE_EVENTS_CACHE_KEY.equals(key)) {
      events = eventDao.findLive();
      LOG.info("Live events loaded for admin in {} ms", stopwatch.elapsed(TimeUnit.MILLISECONDS));
    } else {
      events = eventDao.findLive(Math.toIntExact(key));
      LOG.info(
          "Live events loaded for operator {} in {} ms",
          key,
          stopwatch.elapsed(TimeUnit.MILLISECONDS));
    }
    return events.stream()
        .peek(e -> LOG.debug("Processing Event eventId={}, title={}", e.getId(), e.getTitle()))
        .map(e -> LiveEventDto.from(e, key))
        .collect(Collectors.toList());
  }

  @Override
  public List<LiveEventDto> findLiveByOperatorGroup(Operator.Group group) {
    return eventDao.findLiveByOperatorGroup(group).stream()
        .map(event -> LiveEventDto.from(event, null))
        .collect(Collectors.toList());
  }

  @Override
  public List<TimelineEventDto> findForTimeline(Integer channelId, Date startDate, Date endDate) {
    LocalDate localDate = startDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
    String cacheKey = channelId + "_" + localDate.getYear() + "_" + localDate.getDayOfYear();
    List<TimelineEventDto> result = timelineCache.getIfPresent(cacheKey);
    if (result == null) {
      result = eventDao.findForTimeLine(channelId, startDate, endDate);
      timelineCache.put(cacheKey, result);
    }
    return result;
  }

  @Override
  // FIXME: this method is an ugly hack
  public Event updateEvent(Integer gfxConfigId, Map<Object, Object> params) {
    final Event event = gfxConfigService.findById(gfxConfigId).getEvent();
    event.setStartDate(new Date((Long) params.get("startDate")));
    if (params.containsKey("endDate") && params.get("endDate") != null) {
      event.setEndDate(new Date((Long) params.get("endDate")));
    }
    event.setTitle((String) params.get("title"));
    // syndicationIntegrationService.notifySyndicationUpdate(event);
    return save(event);
  }

  @VisibleForTesting
  public void setStreamingConfigService(StreamingConfigService streamingConfigService) {
    this.streamingConfigService = streamingConfigService;
  }

  @Override
  public Event updateStreamingConfigRatiosByEvent(UpdateEventRatiosCommand command) {

    Event event = findById(command.getId());

    Set<com.imggaming.dge.provision.model.StreamingConfig> updatedConfigs =
        command.getStreamingConfigs().stream()
            .map(
                configRatio -> {
                  Optional<com.imggaming.dge.provision.model.StreamingConfig> config =
                      event.getStreamingConfigById(configRatio.getId());
                  config.ifPresent(presentConfig -> presentConfig.setRatio(configRatio.getRatio()));
                  return config;
                })
            .map(Optional::get)
            .collect(Collectors.toSet());

    Integer reduce =
        event.getStreamingConfigs().stream()
            .map(com.imggaming.dge.provision.model.StreamingConfig::getRatio)
            .reduce(0, Integer::sum);

    Preconditions.checkState(reduce == 100, "All ratios must add up to 100.");

    event.setStreamingConfigs(updatedConfigs);

    return event;
  }

  @Override
  public ZixiInputDto getZixiInputUrl(Long eventId, Long streamingConfigId, boolean isBackup)
      throws StreamingConfigsException {
    technology.dice.dge.content.dto.event.Event event = eventService.getById(eventId);

    if (event == null) {
      throw new EventNotFoundException("Not found event by eventId:" + eventId);
    }

    StreamingConfig streamingConfig =
        streamingConfigService
            .getStreamingConfig(eventId, streamingConfigId)
            .orElseThrow(() -> StreamingConfigsException.notFound(eventId));

    Long transcoderId = streamingConfig.transcoderId(isBackup);

    if (transcoderId == null) {
      throw new RuntimeException(
          "Transcoder id for streaming:" + streamingConfig.id() + " is empty");
    }

    TranscoderDto transcoder = transcoderService.getTranscoderId(transcoderId);

    if (transcoder == null) {
      throw new RuntimeException("Not found transcoder by id: " + transcoderId);
    }

    EventBitrateDto eventBitrate = eventService.getEventBitrate(eventId);

    if (eventBitrate == null) {
      throw new RuntimeException("Not found event bitrates by event id: " + eventId);
    }

    String transcoderIp = transcoder.ip(event.infrastructure().isEnabledDirectConnect());

    return ZixiInputDto.of(
        transcoderIp,
        StreamPrefix.of(transcoder.useWowzaInput(), streamingConfig.streamPrefix(), eventBitrate)
            .getInputStreamPrefix());
  }
}
