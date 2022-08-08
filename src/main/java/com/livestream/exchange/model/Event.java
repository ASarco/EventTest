package com.livestream.exchange.model;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonRawValue;
import com.fasterxml.jackson.annotation.JsonView;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableSet;
import com.imggaming.dge.provision.model.PublishingPoint;
import com.imggaming.dge.provision.model.StreamingConfig;
import com.imggaming.dge.provision.model.ZixiServer;
import com.imggaming.dge.scoring.model.GFXConfig;
import com.livestream.exchange.model.event.EventAttributes;
import com.livestream.exchange.model.event.EventCaptionType;
import com.livestream.exchange.responsemapper.PageResponse;
import com.livestream.exchange.utils.GeolocUtils;
import com.livestream.exchange.validation.LanguageCollectionValidator;
import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.ColumnResult;
import javax.persistence.ConstructorResult;
import javax.persistence.Entity;
import javax.persistence.EntityListeners;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.OrderBy;
import javax.persistence.SqlResultSetMapping;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;
import javax.persistence.Version;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.annotations.Where;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import technology.dice.dge.content.vo.EpgProvider;
import technology.dice.dge.content.vo.EventType;
import technology.dice.dge.content.vo.FollowParentToggle;
import technology.dice.dge.content.vo.ProviderId;
import technology.dice.dge.content.vo.Toggle;
import technology.dice.dge.content.vo.TranscoderRedundancy;
import technology.dice.dge.content.vo.audio.tracks.AudioTrackList;
import technology.dice.dge.geoip.model.vo.Region;
import technology.dice.dge.model.dto.timeline.TimelineDto;

@Entity
@EntityListeners(AuditingEntityListener.class)
@SqlResultSetMapping(
    name = "TimelineDtoMapper",
    classes =
        @ConstructorResult(
            targetClass = TimelineDto.class,
            columns = {
              @ColumnResult(name = "eventId"),
              @ColumnResult(name = "eventTitle"),
              @ColumnResult(name = "eventCourt"),
              @ColumnResult(name = "eventStartDate"),
              @ColumnResult(name = "eventEndDate"),
              @ColumnResult(name = "tournamentId"),
              @ColumnResult(name = "tournamentName"),
              @ColumnResult(name = "tournamentStartDate"),
              @ColumnResult(name = "tournamentEndDate"),
              @ColumnResult(name = "propertyId"),
              @ColumnResult(name = "propertyName"),
              @ColumnResult(name = "propertyLogoUrl"),
              @ColumnResult(name = "sportId"),
              @ColumnResult(name = "sportName"),
              @ColumnResult(name = "sportColor")
            }))
@JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class, property = "id")
public class Event implements Serializable {

  private static final long serialVersionUID = 1509701230316194761L;

  public interface BaseView extends PageResponse.View {}

  public interface SimpleView extends BaseView {}

  public interface GeneralView extends SimpleView {}

  public interface OperatorAPIView extends BaseView {}

  public interface EngineerAPIView extends GeneralView {}

  public interface AdminOnlyView extends SimpleView {}

  public interface EngineerOnlyView extends SimpleView {}

  public interface GeneralAdminView extends GeneralView {}

  @OneToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL, mappedBy = "event")
  @JsonIgnore
  private List<OperatorEvent> operatorEvents;

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @JsonView(
      value = {
        BaseView.class,
        Tournament.GeneralView.class,
        OperatorEvent.GeneralView.class,
        ZixiServer.GeneralView.class,
        ProductionReport.GeneralView.class,
        GFXConfig.BaseView.class,
        PublishingPoint.ExtendedView.class,
        StreamingConfig.BaseView.class,
        Channel.BaseView.class
      })
  private Integer id;

  @JsonIgnore @Version private Integer version;

  @Column(nullable = false)
  @JsonView(
      value = {
        BaseView.class,
        ProductionReport.GeneralView.class,
        GFXConfig.BaseView.class,
        PublishingPoint.ExtendedView.class,
        StreamingConfig.BaseView.class,
        ZixiServer.GeneralView.class,
        Channel.BaseView.class
      })
  private String title;

  @Temporal(TemporalType.TIMESTAMP)
  @JsonView(value = {BaseView.class})
  @Column(nullable = false)
  private Date startDate;

  @Temporal(TemporalType.TIMESTAMP)
  @JsonView(value = {BaseView.class})
  @Column(nullable = false)
  private Date endDate;

  @ManyToOne(optional = false, fetch = FetchType.LAZY)
  @JsonView(value = {GeneralView.class, OperatorAPIView.class, SimpleView.class})
  private Tournament tournament;

  @Basic(optional = true)
  @JsonView(value = {GeneralView.class, SimpleView.class})
  private String location;

  @Basic(optional = true)
  @JsonView(value = {GeneralView.class, SimpleView.class})
  private String description;

  @Basic(optional = true)
  @JsonView(value = {GeneralView.class, SimpleView.class})
  private String externalId;

  @Enumerated(EnumType.STRING)
  @Column(nullable = true)
  @JsonView(value = {GeneralView.class, SimpleView.class})
  private ProviderId externalProviderId;

  @Enumerated(EnumType.STRING)
  @Column(nullable = true, name = "`type`")
  @JsonView(value = {GeneralView.class, SimpleView.class})
  private EventType type = EventType.EVENT;

  @Basic(optional = true)
  @JsonView(value = {GeneralView.class, SimpleView.class})
  @JsonRawValue
  private String details;

  @OneToOne(cascade = CascadeType.ALL, optional = true, fetch = FetchType.LAZY, mappedBy = "event")
  @JsonView(value = {GeneralView.class})
  private EncodeDetails encodeDetails;

  @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY, mappedBy = "event")
  @Where(clause = "deleted <> 1")
  @OrderBy("streamingOrder")
  @JsonView(value = {BaseView.class})
  private Set<StreamingConfig> streamingConfigs;

  @OneToOne(optional = true, cascade = CascadeType.ALL, fetch = FetchType.LAZY)
  @Where(clause = "deleted <> 1")
  @JsonView(value = {BaseView.class})
  private StreamingConfig streamingConfig;

  @Basic(optional = true)
  @JsonView(value = {GeneralView.class, SimpleView.class})
  private String commentary;

  @Basic
  @JsonView(value = {GeneralView.class})
  private String posterLocation;

  @JsonView(value = {GeneralView.class})
  private String contacts;

  @CreatedDate
  @JsonView(value = {SimpleView.class})
  @Temporal(TemporalType.TIMESTAMP)
  @Column(updatable = false)
  private Date createdAt;

  @LastModifiedDate
  @JsonView(value = {GeneralView.class, OperatorAPIView.class})
  @Temporal(TemporalType.TIMESTAMP)
  private Date updatedAt;

  @Transient
  @JsonView(value = {GeneralView.class, SimpleView.class})
  private Boolean booked;

  @JsonView(value = {GeneralView.class})
  @Column(nullable = false)
  private String geoListField;

  @JsonView(value = {GeneralView.class})
  private boolean isWhiteList = false;

  @JsonView(value = {GeneralView.class})
  private int maxConcurrentViewers = -1;

  @JsonView(value = {AdminOnlyView.class})
  private boolean isSlaFailure = false;

  @JsonView(value = {AdminOnlyView.class})
  private String slaFailureComment;

  @OneToMany(fetch = FetchType.LAZY, mappedBy = "event")
  @JsonIgnore
  private Set<ProductionReport> productionReports;

  @JsonView(value = {BaseView.class})
  private String court;

  @Transient private Set<String> countryList = null;

  @Transient private String restrictionRequest = null;

  @OneToOne(mappedBy = "event", fetch = FetchType.LAZY, optional = true)
  @JsonView(value = {GeneralView.class})
  private GFXConfig gfxConfig;

  @JsonView(value = {BaseView.class})
  private boolean isDeleted = false;

  @JsonView(value = {GeneralAdminView.class})
  @ManyToOne(optional = true)
  private ZixiServer preferedZixiServer;

  @JsonView(value = {GeneralAdminView.class})
  @ManyToOne(optional = true)
  private ZixiServer preferedBackupZixiServer;

  @JsonView(value = {BaseView.class})
  private Boolean storeVods = false;

  @Transient
  @JsonView(value = {EngineerOnlyView.class})
  private String lastProductionReportState;

  @JsonView(value = {Event.GeneralView.class})
  @OneToMany(fetch = FetchType.EAGER, mappedBy = "event", cascade = CascadeType.ALL)
  private Set<EventRendition> renditions;

  @OrderBy("orderIndex asc")
  @JsonView(value = {GeneralView.class, SimpleView.class})
  @OneToMany(
      fetch = FetchType.EAGER,
      targetEntity = SubEvent.class,
      mappedBy = "event",
      cascade = CascadeType.ALL,
      orphanRemoval = true)
  private Set<SubEvent> subEvents;

  @Transient
  @JsonView(value = {GeneralView.class})
  private String scoreType;

  @JsonView(value = {Property.GeneralView.class, GeneralView.class})
  @Column(nullable = true, columnDefinition = "TINYINT(1)")
  private Boolean useDRM;

  @Column(nullable = false, columnDefinition = "INT(11) DEFAULT -1")
  @JsonView(value = {GeneralView.class, OperatorAPIView.class, SimpleView.class})
  private Integer dvr = -1;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false, columnDefinition = "VARCHAR(24) DEFAULT 'NO'")
  @JsonView(value = {GeneralView.class, OperatorAPIView.class, SimpleView.class})
  private DirectConnect directConnect = DirectConnect.NO;

  @JsonView(value = {GeneralView.class})
  private String audioLanguages;

  @OneToOne(cascade = CascadeType.ALL, optional = true, fetch = FetchType.LAZY, mappedBy = "event")
  @JsonView(value = {GeneralView.class})
  private EventAttributes eventAttributes;

  @JsonIgnore
  @Enumerated(EnumType.STRING)
  @Column(nullable = false, columnDefinition = "VARCHAR(32) DEFAULT 'FOLLOW_PARENT'")
  private FollowParentToggle normalizeInputStream;

  @JsonIgnore
  @Enumerated(EnumType.STRING)
  @Column(nullable = true, columnDefinition = "VARCHAR(2) DEFAULT NULL'")
  private Region preferredPublishingPointRegion;

  @ManyToMany(cascade = CascadeType.ALL, fetch = FetchType.EAGER)
  @JoinTable(
      name = "EventLocalBroadcaster",
      joinColumns = {@JoinColumn(name = "event_id")},
      inverseJoinColumns = {@JoinColumn(name = "local_broadcaster_id")})
  @JsonView(
      value = {
        Property.GeneralView.class,
        Property.SimpleView.class,
        Property.SimpleList.class,
        Event.OperatorAPIView.class,
        Event.SimpleView.class,
        Tournament.GeneralView.class,
        Tournament.GeneralAdminView.class
      })
  private Set<LocalBroadcaster> localBroadcasters;

  @JsonView(value = {SimpleView.class})
  public Integer getTournamentId() {
    return tournament == null ? null : tournament.getId();
  }

  @JsonView(value = {OperatorAPIView.class})
  @JsonSerialize(include = JsonSerialize.Inclusion.NON_NULL)
  public String getRestrictionRequest() {
    return restrictionRequest;
  }

  public void setRestrictionRequest(String restrictionRequest) {
    this.restrictionRequest = restrictionRequest;
  }

  public Boolean getBooked() {
    return booked;
  }

  public void setBooked(Boolean booked) {
    this.booked = booked;
  }

  public String getLocation() {
    return location;
  }

  public void setLocation(String location) {
    this.location = location;
  }

  public String getDescription() {
    return description;
  }

  public String getDetails() {
    return details;
  }

  public void setDetails(String details) {
    this.details = details;
  }

  public Set<SubEvent> getSubEvents() {
    return subEvents;
  }

  public void setSubEvents(Set<SubEvent> subEvents) {
    this.subEvents = subEvents;
  }

  public void setDescription(String description) {
    this.description = description;
  }

  public String getExternalId() {
    return externalId;
  }

  public void setExternalId(String externalId) {
    this.externalId = externalId;
  }

  public Date getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(Date createdAt) {
    this.createdAt = createdAt;
  }

  public Date getUpdatedAt() {
    return updatedAt;
  }

  public void setUpdatedAt(Date updatedAt) {
    this.updatedAt = updatedAt;
  }

  public String getCommentary() {
    return commentary;
  }

  public void setCommentary(String commentary) {
    this.commentary = commentary;
  }

  public String getPosterLocation() {
    return posterLocation;
  }

  public void setPosterLocation(String posterLocation) {
    this.posterLocation = posterLocation;
  }

  public String getContacts() {
    return contacts;
  }

  public void setContacts(String contacts) {
    this.contacts = contacts;
  }

  public Tournament getTournament() {
    return tournament;
  }

  public void setTournament(Tournament tournament) {
    this.tournament = tournament;
  }

  public Set<Integer> getUsedTranscodersIds() {
    if (isVirtualLiveLinearChannel()) {
      return ImmutableSet.of();
    }
    return Collections.unmodifiableSet(
        getStreamingConfigs().stream()
            .flatMap(e -> e.getZixiServerIds().stream())
            .collect(Collectors.toSet()));
  }

  @JsonView(value = {BaseView.class})
  public Set<StreamingConfig> getStreamingConfigs() {
    ImmutableSet.Builder<StreamingConfig> builder = ImmutableSet.builder();

    if (streamingConfigs != null) {
      builder.addAll(streamingConfigs);
    }

    if (streamingConfig != null) {
      builder.add(streamingConfig);
    }

    return builder.build();
  }

  public void setStreamingConfigs(Set<StreamingConfig> streamingConfigs) {
    this.streamingConfigs = streamingConfigs;
  }

  @JsonView(value = {BaseView.class})
  public StreamingConfig getStreamingConfig() {
    if (CollectionUtils.isNotEmpty(streamingConfigs)) {
      return streamingConfigs.stream()
          .min(Comparator.comparing(StreamingConfig::getStreamingOrder))
          .orElse(streamingConfig);
    }

    return streamingConfig;
  }

  public void setStreamingConfig(StreamingConfig streamingConfig) {
    this.streamingConfig = streamingConfig;
  }

  public void addStreamingConfig(StreamingConfig streamingConfig) {

    if (streamingConfig == null) {
      return;
    }

    if (this.streamingConfig == null) {
      this.streamingConfig = streamingConfig;
    }

    if (streamingConfigs == null) {
      streamingConfigs = new HashSet<>();
    }

    if (streamingConfigs.isEmpty()) {
      streamingConfigs.add(streamingConfig);
    }

    if (!streamingConfigs.isEmpty()) {
      StreamingConfig maxOrder =
          streamingConfigs.stream()
              .max(Comparator.comparing(StreamingConfig::getStreamingOrder))
              .orElse(streamingConfig);

      Integer order = maxOrder.getStreamingOrder();
      streamingConfig.setStreamingOrder(order + 1);
      this.streamingConfigs.add(streamingConfig);
    }
  }

  public void removeStreamingConfig(Integer streamingConfigId) {
    if (streamingConfig.getId().equals(streamingConfigId)) {
      streamingConfig = null;
    }

    setStreamingConfigs(
        getStreamingConfigs().stream()
            .filter(s -> !s.getId().equals(streamingConfigId))
            .collect(Collectors.toSet()));

    // pickup new master config
    if (streamingConfig == null && getStreamingConfigs().size() > 0) {
      streamingConfig = getStreamingConfigs().stream().findFirst().get();
    }
  }

  public boolean hasStreamingConfigs() {
    return streamingConfig != null || (streamingConfigs != null && !streamingConfigs.isEmpty());
  }

  public Integer getId() {
    return id;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public String getTitle() {
    return title;
  }

  public String getLastProductionReportState() {
    return lastProductionReportState;
  }

  public void setLastProductionReportState(String value) {
    lastProductionReportState = value;
  }

  public void setTitle(String title) {
    this.title = title;
  }

  public Date getStartDate() {
    return startDate;
  }

  public void setStartDate(Date startDate) {
    this.startDate = startDate;
  }

  public Date getEndDate() {
    return endDate;
  }

  public void setEndDate(Date endDate) {
    this.endDate = endDate;
  }

  public EncodeDetails getEncodeDetails() {
    return encodeDetails;
  }

  public void setEncodeDetails(EncodeDetails encodeDetails) {
    this.encodeDetails = encodeDetails;
  }

  public String getGeoListField() {
    return geoListField;
  }

  public void setGeoListField(String geoListField) {
    this.geoListField = geoListField;
  }

  public void setIsWhiteList(boolean whiteList) {
    isWhiteList = whiteList;
  }

  public boolean getIsWhiteList() {
    return isWhiteList;
  }

  public boolean getIsDeleted() {
    return isDeleted;
  }

  public void setIsDeleted(boolean isDeleted) {
    this.isDeleted = isDeleted;
  }

  public DirectConnect getDirectConnect() {
    return directConnect;
  }

  @JsonIgnore
  public boolean isEnabledDirectConnect() {
    if (DirectConnect.FOLLOW_TOURNAMENT == getDirectConnect()) {
      return tournament != null && DirectConnect.YES == tournament.getDirectConnect();
    }
    return DirectConnect.YES == getDirectConnect();
  }

  public void setDirectConnect(DirectConnect directConnect) {
    this.directConnect = directConnect;
  }

  @JsonView(value = {OperatorAPIView.class})
  @JsonSerialize(include = JsonSerialize.Inclusion.NON_NULL)
  public Set<String> getCountryList() {
    return countryList;
  }

  public void setCountryList(Set<String> countryList) {
    this.countryList = countryList;
  }

  public String getLowLatencyUrl() {
    if (streamingConfig == null) {
      return null;
    }
    return streamingConfig.getLowLatencyPlayerUrl();
  }

  public boolean isLocationAllowed(String code) {
    return GeolocUtils.isLocationAllowed(isWhiteList, geoListField, code);
  }

  public int getMaxConcurrentViewers() {
    return maxConcurrentViewers;
  }

  public void setMaxConcurrentViewers(int maxConcurrentViewers) {
    this.maxConcurrentViewers = maxConcurrentViewers;
  }

  @JsonIgnore
  public boolean isSlaFailure() {
    return isSlaFailure;
  }

  public boolean getIsSlaFailure() {
    return isSlaFailure;
  }

  public void setIsSlaFailure(boolean isSLAFailure) {
    isSlaFailure = isSLAFailure;
  }

  public List<OperatorEvent> getOperatorEvents() {
    return operatorEvents;
  }

  public void setOperatorEvents(List<OperatorEvent> operatorEvents) {
    this.operatorEvents = operatorEvents;
  }

  public Set<ProductionReport> getProductionReports() {
    return productionReports;
  }

  public void setProductionReports(Set<ProductionReport> productionReports) {
    this.productionReports = productionReports;
  }

  public String getCourt() {
    return court;
  }

  public void setCourt(String court) {
    this.court = court;
  }

  public String getSlaFailureComment() {
    return slaFailureComment;
  }

  public void setSlaFailureComment(String slaFailureComment) {
    this.slaFailureComment = slaFailureComment;
  }

  public ZixiServer getPreferedZixiServer() {
    if (isVirtualLiveLinearChannel()) {
      return null;
    }
    return preferedZixiServer;
  }

  public ZixiServer getPreferedBackupZixiServer() {
    if (isVirtualLiveLinearChannel()) {
      return null;
    }
    return preferedBackupZixiServer;
  }

  public void setPreferedBackupZixiServer(ZixiServer preferedBackupZixiServer) {
    this.preferedBackupZixiServer = preferedBackupZixiServer;
  }

  public void setPreferedZixiServer(ZixiServer zixiServer) {
    preferedZixiServer = zixiServer;
  }

  public GFXConfig getGfxConfig() {
    return gfxConfig;
  }

  public void setGfxConfig(GFXConfig gfxConfig) {
    this.gfxConfig = gfxConfig;
  }

  @JsonIgnore
  public void setupAudioOnlyRenditions() {
    setRenditions(Stream.of(EventRendition.buildOnlyAudio(this)).collect(Collectors.toSet()));
  }

  @JsonIgnore
  public void setupVideoAndAudioRenditions() {
    setRenditions(
        getTournament().getRenditions().stream()
            .filter(EventRendition::getIsActive)
            .map(EventRendition::new)
            .peek(rendition -> rendition.setEvent(this))
            .collect(Collectors.toSet()));
  }

  @JsonIgnore
  public Set<EventRendition> getRenditions() {
    if (renditions == null || renditions.isEmpty()) {
      if (isAudioOnly()) {
        setupAudioOnlyRenditions();
      } else {
        setupVideoAndAudioRenditions();
      }
    }
    return renditions;
  }

  public void setRenditions(Set<EventRendition> renditions) {
    this.renditions = renditions;
  }

  public Boolean getStoreVods() {
    return storeVods;
  }

  public void setStoreVods(Boolean storeVods) {
    this.storeVods = storeVods;
  }

  public Integer getVersion() {
    return version;
  }

  public void setVersion(Integer version) {
    this.version = version;
  }

  public String getScoreType() {
    return scoreType;
  }

  public void setScoreType(String scoreType) {
    this.scoreType = scoreType;
  }

  public Boolean isUseDRM() {
    return useDRM;
  }

  public void setUseDRM(Boolean useDRM) {
    this.useDRM = useDRM;
  }

  public Integer getDvr() {
    return dvr;
  }

  public void setDvr(Integer dvr) {
    this.dvr = dvr;
  }

  public String getAudioLanguages() {
    return audioLanguages;
  }

  public void setAudioLanguages(String audioLanguages) {
    audioLanguages = StringUtils.trim(audioLanguages);

    if (audioLanguages != null && audioLanguages.isEmpty()) {
      this.audioLanguages = null;
    } else {
      if (!LanguageCollectionValidator.from(audioLanguages).isValid()) {
        throw new RuntimeException("Wrong audio languages format");
      }
      this.audioLanguages = audioLanguages;
    }
  }

  public boolean hasMultiAudioEnabled() {
    boolean audioLanguagesIsNotEmpty = StringUtils.isNotBlank(audioLanguages);
    boolean audioTracksIsNotEmpty = getAudioTracks().isNotEmpty();
    return audioLanguagesIsNotEmpty || audioTracksIsNotEmpty;
  }

  @JsonIgnore
  public Set<LocalBroadcaster> getLocalBroadcasters() {
    return localBroadcasters;
  }

  public void setLocalBroadcasters(Set<LocalBroadcaster> localBroadcasters) {
    this.localBroadcasters = localBroadcasters;
  }

  @JsonIgnore
  public EventAttributes getEventAttributes() {
    return eventAttributes;
  }

  @JsonIgnore
  public void setEventAttributes(EventAttributes eventAttributes) {
    this.eventAttributes = eventAttributes;
  }

  @JsonView(value = {Event.GeneralView.class, Event.SimpleView.class})
  @Transient
  public String getTrailerId() {
    if (eventAttributes != null) {
      return eventAttributes.getTrailerId();
    }

    return null;
  }

  @JsonView(value = {Event.GeneralView.class, Event.SimpleView.class})
  @Transient
  public Boolean getIs4k() {
    if (eventAttributes != null) {
      return eventAttributes.getIs4k();
    }

    return Boolean.FALSE;
  }

  @JsonView(value = {Event.GeneralView.class, Event.SimpleView.class})
  @Transient
  public String getEpgId() {
    if (eventAttributes != null) {
      return eventAttributes.getEpgId();
    }

    return null;
  }

  @JsonView(value = {Event.GeneralView.class, Event.SimpleView.class})
  @Transient
  public EventCaptionType getCaptionType() {
    if (eventAttributes != null) {
      return eventAttributes.getCaptionType();
    }

    return null;
  }

  @JsonView(value = {Event.GeneralView.class, Event.SimpleView.class})
  @Transient
  public String getCaptionLanguages() {
    if (eventAttributes != null) {
      return eventAttributes.getCaptionLanguages();
    }

    return null;
  }

  @JsonProperty("isCombiner")
  @JsonView(value = {Event.GeneralView.class, Event.SimpleView.class})
  @Transient
  public Boolean isCombiner() {
    if (eventAttributes != null) {
      return eventAttributes.getCombiner();
    }

    return Boolean.FALSE;
  }

  @JsonProperty("audioOnly")
  @JsonView(value = {Event.GeneralView.class, Event.SimpleView.class})
  public FollowParentToggle getAudioOnly() {
    if (getEventAttributes() == null) {
      return FollowParentToggle.FOLLOW_PARENT;
    }

    return getEventAttributes().getAudioOnly();
  }

  public void setAudioOnly(FollowParentToggle audioOnly) {
    if (audioOnly == null) {
      return;
    }

    this.eventAttributes.setAudioOnly(audioOnly);
  }

  @JsonProperty("audioTracks")
  @JsonView(value = {Event.GeneralView.class, Event.SimpleView.class})
  @Transient
  public AudioTrackList getAudioTracks() {
    if (eventAttributes != null) {
      return AudioTrackList.fromJsonString(eventAttributes.getAudioTracks());
    }

    return AudioTrackList.fromJsonString(null);
  }

  @JsonIgnore
  @Transient
  public boolean isAudioOnly() {
    FollowParentToggle eventAudioOnly = getAudioOnly();

    if (eventAudioOnly == FollowParentToggle.FOLLOW_PARENT) {
      if (getTournament() == null) {
        return false;
      }
      return getTournament().getAudioOnly() == Toggle.ON;
    }

    return eventAudioOnly == FollowParentToggle.ON;
  }

  @JsonIgnore
  @Transient
  public boolean isVideoAudio() {
    return !isAudioOnly();
  }

  private List<String> getCalculatedCaptionLanguages() {
    List<String> listOfLanguages = ImmutableList.of();

    if (getCaptionType() == EventCaptionType.TOURNAMENT_FLOW
        && getTournament() != null
        && getTournament().getCaptionLanguages() != null) {
      listOfLanguages = ImmutableList.copyOf(getTournament().getCaptionLanguages().split(","));
    } else if (getCaptionType() != null && getCaptionLanguages() != null) {
      listOfLanguages = ImmutableList.copyOf(getCaptionLanguages().split(","));
    }

    return listOfLanguages;
  }

  public boolean hasCalculatedCaptionlanguages() {
    return getCalculatedCaptionLanguages().size() > 0;
  }

  public Optional<StreamingConfig> getStreamingConfigById(Integer id) {
    return getStreamingConfigs().stream().filter(config -> config.getId().equals(id)).findFirst();
  }

  @JsonProperty("transcoderRedundancy")
  @JsonView(value = {Event.GeneralView.class, Event.SimpleView.class})
  public TranscoderRedundancy getTranscoderRedundancy() {
    if (getEventAttributes() == null) {
      return TranscoderRedundancy.FOLLOW_TOURNAMENT;
    }

    return getEventAttributes().getTranscoderRedundancy();
  }

  public void setTranscoderRedundancy(TranscoderRedundancy transcoderRedundancy) {
    if (transcoderRedundancy == null) {
      return;
    }

    this.eventAttributes.setTranscoderRedundancy(transcoderRedundancy);
  }

  public ProviderId getExternalProviderId() {
    return externalProviderId;
  }

  public void setExternalProviderId(ProviderId externalProviderId) {
    this.externalProviderId = externalProviderId;
  }

  public EventType getType() {
    return type;
  }

  public void setType(EventType type) {
    this.type = type;
  }

  @JsonProperty("epgProvider")
  @JsonView(value = {Event.GeneralView.class, Event.SimpleView.class})
  @Transient
  public EpgProvider getEpgProvider() {
    if (eventAttributes != null) {
      return eventAttributes.getEpgProvider();
    }

    return null;
  }

  @JsonProperty("epgProviderId")
  @JsonView(value = {Event.GeneralView.class, Event.SimpleView.class})
  @Transient
  public String getEpgProviderId() {
    if (eventAttributes != null) {
      return eventAttributes.getEpgProviderId();
    }

    return null;
  }

  public FollowParentToggle getNormalizeInputStream() {
    if (normalizeInputStream != null) {
      return normalizeInputStream;
    }
    return FollowParentToggle.FOLLOW_PARENT;
  }

  public void setNormalizeInputStream(FollowParentToggle normalizeInputStream) {
    this.normalizeInputStream = normalizeInputStream;
  }

  @Transient
  @JsonIgnore
  public boolean isVirtualLiveLinearChannel() {
    return getType() == EventType.VIRTUAL_LINEAR_CHANNEL;
  }

  public Region getPreferredPublishingPointRegion() {
    return preferredPublishingPointRegion;
  }

  public void setPreferredPublishingPointRegion(Region preferredPublishingPointRegion) {
    this.preferredPublishingPointRegion = preferredPublishingPointRegion;
  }

  @Override
  public String toString() {
    final SimpleDateFormat format = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss.SSS");
    return String.format(
        "ID: %s, Title: %s, Start: %s, End: %s",
        getId(),
        getTitle(),
        getStartDate() == null ? "null " : format.format(getStartDate()),
        getEndDate() == null ? "null" : format.format(getEndDate()));
  }
}
