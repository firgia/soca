/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Mar 20 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

class Calculator {
  /// Calculate [birthOfDate] to get current age
  static int calculateAge(DateTime birthOfDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthOfDate.year;

    int currMonth = currentDate.month;
    int birthMonth = birthOfDate.month;

    if (birthMonth > currMonth) {
      age--;
    } else if (currMonth == birthMonth) {
      int day1 = currentDate.day;
      int day2 = birthOfDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }
}
