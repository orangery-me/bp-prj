class DataAnalyzeExtension {
  static int getPP(int systolic, int diastolic) {
    return systolic - diastolic;
  }

  static double getMAP(int systolic, int diastolic) {
    return diastolic + (systolic - diastolic) / 3;
  }

  static double getBMI(double weight, int height) {
    return weight / (height * height * 0.0001);
  }

  static double convertToKg(double weightInLbs) {
    return weightInLbs / 2.2046;
  }

  static int convertFeetInchesToCm(int feet, int inches) {
    double feetToCm = feet * 30.48;
    double inchesToCm = inches * 2.54;
    return (feetToCm + inchesToCm).round();
  }

  static int convertInchestoCm(double inches) {
    return (inches * 2.54).round();
  }

  static int getBPStatus(int systolic, int diastolic) {
    if (systolic < 80 || diastolic < 60) {
      return 0;
    } else if ((systolic >= 80 && systolic < 120) &&
        (diastolic >= 60 && diastolic < 80)) {
      return 1;
    } else if ((systolic >= 120 && systolic < 140) ||
        (diastolic >= 80 && diastolic < 90)) {
      return 2;
    } else if ((systolic >= 140 && systolic < 160) ||
        (diastolic >= 90 && diastolic < 100)) {
      return 3;
    } else {
      return 4;
    }
  }

  static int getMAPStatus(int map) {
    if (map < 70) {
      return 0;
    } else if (map >= 70 && map < 100) {
      return 1;
    } else {
      return 2;
    }
  }

  static int getHeartRateStatus(int heartRate) {
    if (heartRate >= 60 && heartRate <= 100) {
      return 1;
    } else {
      return 4;
    }
  }
}
