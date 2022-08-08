package com.livestream.exchange.model;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonRawValue;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import org.apache.commons.lang3.StringUtils;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import technology.dice.dge.content.vo.EventType;
import technology.dice.dge.content.vo.ProviderId;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EntityListeners;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;
import javax.persistence.Version;
import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Set;

@Entity
@EntityListeners(AuditingEntityListener.class)
@JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class, property = "id")
public class Event implements Serializable {

  private static final long serialVersionUID = 1509701230316194761L;

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Integer id;

  @JsonIgnore @Version private Integer version;

  private String title;

  @Temporal(TemporalType.TIMESTAMP)
  @Column(nullable = false)
  private Date startDate;

  @Temporal(TemporalType.TIMESTAMP)
  @Column(nullable = false)
  private Date endDate;

  @Basic(optional = true)
  private String location;

  @Basic(optional = true)
  private String description;

  @Basic(optional = true)
  private String externalId;

  @Enumerated(EnumType.STRING)
  @Column(nullable = true)
  private ProviderId externalProviderId;

  @Enumerated(EnumType.STRING)
  @Column(nullable = true, name = "`type`")
  private EventType type = EventType.EVENT;

  @Basic(optional = true)
  @JsonRawValue
  private String details;

  @Basic(optional = true)
  private String commentary;

  @Basic private String posterLocation;

  private String contacts;

  @CreatedDate
  @Temporal(TemporalType.TIMESTAMP)
  @Column(updatable = false)
  private Date createdAt;

  @LastModifiedDate
  @Temporal(TemporalType.TIMESTAMP)
  private Date updatedAt;

  @Transient private Boolean booked;

  @Column(nullable = false)
  private String geoListField;

  private boolean isWhiteList = false;

  private int maxConcurrentViewers = -1;

  private boolean isSlaFailure = false;

  private String slaFailureComment;

  private String court;

  @Transient private Set<String> countryList = null;

  @Transient private String restrictionRequest = null;

  private boolean isDeleted = false;

  private Boolean storeVods = false;

  @Transient private String lastProductionReportState;

  @Transient private String scoreType;

  @Column(nullable = true, columnDefinition = "TINYINT(1)")
  private Boolean useDRM;

  @Column(nullable = false, columnDefinition = "INT(11) DEFAULT -1")
  private Integer dvr = -1;

  private String audioLanguages;

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

  public void setDescription(String description) {
    this.description = description;
  }

  public String getDetails() {
    return details;
  }

  public void setDetails(String details) {
    this.details = details;
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

  public Integer getId() {
    return id;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public String getTitle() {
    return title;
  }

  public void setTitle(String title) {
    this.title = title;
  }

  public String getLastProductionReportState() {
    return lastProductionReportState;
  }

  public void setLastProductionReportState(String value) {
    lastProductionReportState = value;
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

  public String getGeoListField() {
    return geoListField;
  }

  public void setGeoListField(String geoListField) {
    this.geoListField = geoListField;
  }

  public boolean getIsWhiteList() {
    return isWhiteList;
  }

  public void setIsWhiteList(boolean whiteList) {
    isWhiteList = whiteList;
  }

  public boolean getIsDeleted() {
    return isDeleted;
  }

  public void setIsDeleted(boolean isDeleted) {
    this.isDeleted = isDeleted;
  }

  @JsonSerialize(include = JsonSerialize.Inclusion.NON_NULL)
  public Set<String> getCountryList() {
    return countryList;
  }

  public void setCountryList(Set<String> countryList) {
    this.countryList = countryList;
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

  @Transient
  @JsonIgnore
  public boolean isVirtualLiveLinearChannel() {
    return getType() == EventType.VIRTUAL_LINEAR_CHANNEL;
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
