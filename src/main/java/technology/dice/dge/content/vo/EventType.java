package technology.dice.dge.content.vo;

public enum EventType {
  EVENT,
  LINEAR_CHANNEL,
  VIRTUAL_LINEAR_CHANNEL;

  public static EventType fromString(String eventType) {
    if (eventType == null) {
      return EVENT;
    }
    for (EventType value : values()) {
      if (value.toString().equals(eventType)) {
        return value;
      }
    }
    throw new IllegalArgumentException("Unknown event type: " + eventType);
  }

  public boolean isLinearChannel() {
    return this == EventType.VIRTUAL_LINEAR_CHANNEL || this == EventType.LINEAR_CHANNEL;
  }
}
