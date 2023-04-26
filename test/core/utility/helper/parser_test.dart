/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Mar 21 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/core/core.dart';

void main() {
  group(".get()", () {
    test("Should return based on Type when available", () {
      expect(Parser.get<bool>(true), true);
      expect(Parser.get<int>(1), 1);
      expect(Parser.get<double>(12.3), 12.3);
      expect(Parser.get<Map>({"name": "Firgia"}), {"name": "Firgia"});
    });

    test("Should return null when invalid Type", () {
      expect(Parser.get<bool>(1), null);
      expect(Parser.get<int>("test"), null);
      expect(Parser.get<double>(false), null);
      expect(Parser.get<Map>("test"), null);
    });
  });

  group(".getBool()", () {
    test("Should return bool when available", () {
      expect(Parser.getBool("true"), true);
      expect(Parser.getBool("false"), false);
      expect(Parser.getBool(true), true);
      expect(Parser.getBool(false), false);
    });

    test("Should return null when invalid bool or null", () {
      expect(Parser.getDouble("123,0"), null);
      expect(Parser.getDouble("34rt"), null);
      expect(Parser.getDouble(null), null);
    });
  });

  group(".getDouble()", () {
    test("Should return double when available", () {
      expect(Parser.getDouble(123.2), 123.2);
      expect(Parser.getDouble(123), 123.0);
    });

    test("Should return null when invalid double or null", () {
      expect(Parser.getDouble("123,0"), null);
      expect(Parser.getDouble("34rt"), null);
      expect(Parser.getDouble(null), null);
    });
  });

  group(".getInt()", () {
    test("Should return int when available", () {
      expect(Parser.getInt(123), 123);
    });

    test("Should return null when invalid int or null", () {
      expect(Parser.getInt("123.4"), null);
      expect(Parser.getInt("123.0"), null);
      expect(Parser.getInt("123,0"), null);
      expect(Parser.getInt("34rt"), null);
      expect(Parser.getInt(null), null);
    });
  });

  group(".getListDynamic()", () {
    test("Should return List<Dynamic> when available", () {
      expect(Parser.getListDynamic(["hello", "world"]), ["hello", "world"]);
      expect(Parser.getListDynamic(["hello", 123, true]), ["hello", 123, true]);
    });

    test("Should return null when invalid List<Dynamic> or null", () {
      expect(Parser.getListDynamic("123,0"), null);
      expect(Parser.getListDynamic(null), null);
    });
  });

  group(".getListString()", () {
    test("Should return List<String> when available", () {
      expect(Parser.getListString(["hello", "world"]), ["hello", "world"]);
    });

    test("Should return null when invalid List<String> or null", () {
      expect(Parser.getListString("123,0"), null);
      expect(Parser.getListString(null), null);
    });
  });

  group(".getMap()", () {
    test("Should return Map<String, Dynamic> when available", () {
      expect(Parser.getMap({"name": "Firgia"}), {"name": "Firgia"});
    });

    test("Should return null when invalid Map<String, Dynamic> or null", () {
      expect(Parser.getMap("123,0"), null);
      expect(Parser.getMap(null), null);
    });
  });

  group(".getString()", () {
    test("Should return string when available", () {
      expect(Parser.getString("test"), "test");
    });

    test("Should return null when string is empty or null", () {
      expect(Parser.getString(""), null);
      expect(Parser.getString(null), null);
    });
  });
}
