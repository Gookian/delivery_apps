import 'dart:math';

class CheckThatPointIsWithinTriggerRadiusUseCase {
  double distanceBetweenCoordinates(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371000; // Радиус Земли в метрах
    var fi1 = lat1 * pi / 180;
    var fi2 = lat2 * pi / 180;
    var deltaFi = (lat2 - lat1) * pi / 180;
    var deltaLambda = (lon2 - lon1) * pi / 180;

    var a = sin(deltaFi / 2) * sin(deltaFi / 2) +
    cos(fi1) * cos(fi2) *
    sin(deltaLambda / 2) * sin(deltaLambda / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var distance = R * c;

    return distance;
  }

  bool isPointInCircle(double centerLat, double centerLon, double pointLat, double pointLon, double radius) {
    var distance = distanceBetweenCoordinates(centerLat, centerLon, pointLat, pointLon);
    return distance <= radius;
  }
}