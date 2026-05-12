class AlertStore {
  static List<String> alerts = [];

  static void addAlert(String alert) {
    alerts.insert(0, alert); // latest on top
  }

  static List<String> getAlerts() {
    return alerts;
  }

  static void clear() {
    alerts.clear();
  }
}