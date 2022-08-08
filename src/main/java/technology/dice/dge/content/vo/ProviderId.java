package technology.dice.dge.content.vo;

public enum ProviderId {
  FIGHTMETRIC,
  OPTA,
  MANUAL;

  public static ProviderId fromString(String externalProviderId) {
    if (externalProviderId == null) {
      return null;
    }
    for (ProviderId value : values()) {
      if (value.toString().equals(externalProviderId)) {
        return value;
      }
    }
    throw new IllegalArgumentException("Unknown externalProviderId: " + externalProviderId);
  }
}
