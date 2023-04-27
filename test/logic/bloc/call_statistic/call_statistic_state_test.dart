/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Apr 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';
import 'package:soca/logic/logic.dart';

void main() {
  const CallStatisticState defaultState = CallStatisticState(
    selectedYear: "2020",
    userType: UserType.blind,
    listOfYear: ["2019", "2020"],
    calls: [CallDataMounthly(total: 20, month: "Apr")],
    totalCall: 20,
    totalDayJoined: 368,
  );

  group("CallStatisticState", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        const CallStatisticState state = CallStatisticState(
          selectedYear: "2020",
          userType: UserType.blind,
          listOfYear: ["2019", "2020"],
          calls: [CallDataMounthly(total: 20, month: "Apr")],
          totalCall: 20,
          totalDayJoined: 368,
        );

        expect(state.selectedYear, "2020");
        expect(state.userType, UserType.blind);
        expect(state.listOfYear, ["2019", "2020"]);
        expect(state.calls, [const CallDataMounthly(total: 20, month: "Apr")]);
        expect(state.totalCall, 20);
        expect(state.totalDayJoined, 368);
      });
    });

    group(".copyWith()", () {
      test("Should copy the selectedYear", () {
        CallStatisticState state = defaultState.copyWith(selectedYear: "2023");

        expect(state.selectedYear, "2023");
        expect(state.userType, UserType.blind);
        expect(state.listOfYear, ["2019", "2020"]);
        expect(state.calls, [const CallDataMounthly(total: 20, month: "Apr")]);
        expect(state.totalCall, 20);
        expect(state.totalDayJoined, 368);
      });

      test("Should copy the userType", () {
        CallStatisticState state = defaultState.copyWith(
          userType: UserType.volunteer,
        );

        expect(state.selectedYear, "2020");
        expect(state.userType, UserType.volunteer);
        expect(state.listOfYear, ["2019", "2020"]);
        expect(state.calls, [const CallDataMounthly(total: 20, month: "Apr")]);
        expect(state.totalCall, 20);
        expect(state.totalDayJoined, 368);
      });

      test("Should copy the listOfYear", () {
        CallStatisticState state = defaultState.copyWith(listOfYear: ["2023"]);

        expect(state.selectedYear, "2020");
        expect(state.userType, UserType.blind);
        expect(state.listOfYear, ["2023"]);
        expect(state.calls, [const CallDataMounthly(total: 20, month: "Apr")]);
        expect(state.totalCall, 20);
        expect(state.totalDayJoined, 368);
      });

      test("Should copy the calls", () {
        CallStatisticState state = defaultState
            .copyWith(calls: [const CallDataMounthly(total: 21, month: "Mei")]);

        expect(state.selectedYear, "2020");
        expect(state.userType, UserType.blind);
        expect(state.listOfYear, ["2019", "2020"]);
        expect(state.calls, [const CallDataMounthly(total: 21, month: "Mei")]);
        expect(state.totalCall, 20);
        expect(state.totalDayJoined, 368);
      });

      test("Should copy the totalCall", () {
        CallStatisticState state = defaultState.copyWith(totalCall: 18);

        expect(state.selectedYear, "2020");
        expect(state.userType, UserType.blind);
        expect(state.listOfYear, ["2019", "2020"]);
        expect(state.calls, [const CallDataMounthly(total: 20, month: "Apr")]);
        expect(state.totalCall, 18);
        expect(state.totalDayJoined, 368);
      });

      test("Should copy the totalDayJoined", () {
        CallStatisticState state = defaultState.copyWith(totalDayJoined: 200);

        expect(state.selectedYear, "2020");
        expect(state.userType, UserType.blind);
        expect(state.listOfYear, ["2019", "2020"]);
        expect(state.calls, [const CallDataMounthly(total: 20, month: "Apr")]);
        expect(state.totalCall, 20);
        expect(state.totalDayJoined, 200);
      });
    });
  });

  group("CallStatisticLoading", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        const CallStatisticLoading state = CallStatisticLoading(
          selectedYear: "2020",
          userType: UserType.blind,
          listOfYear: ["2019", "2020"],
          calls: [CallDataMounthly(total: 20, month: "Apr")],
          totalCall: 20,
          totalDayJoined: 368,
        );

        expect(state.selectedYear, "2020");
        expect(state.userType, UserType.blind);
        expect(state.listOfYear, ["2019", "2020"]);
        expect(state.calls, [const CallDataMounthly(total: 20, month: "Apr")]);
        expect(state.totalCall, 20);
        expect(state.totalDayJoined, 368);
      });
    });

    group(".fromState()", () {
      test("Should copy from state", () {
        CallStatisticLoading state =
            CallStatisticLoading.fromState(defaultState);

        expect(state.selectedYear, "2020");
        expect(state.userType, UserType.blind);
        expect(state.listOfYear, ["2019", "2020"]);
        expect(state.calls, [const CallDataMounthly(total: 20, month: "Apr")]);
        expect(state.totalCall, 20);
        expect(state.totalDayJoined, 368);
      });
    });
  });

  group("CallStatisticError", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        const CallStatisticError state = CallStatisticError(
          selectedYear: "2020",
          userType: UserType.blind,
          listOfYear: ["2019", "2020"],
          calls: [CallDataMounthly(total: 20, month: "Apr")],
          totalCall: 20,
          totalDayJoined: 368,
          callingFailure: CallingFailure(),
          userFailure: UserFailure(),
        );

        expect(state.selectedYear, "2020");
        expect(state.userType, UserType.blind);
        expect(state.listOfYear, ["2019", "2020"]);
        expect(state.calls, [const CallDataMounthly(total: 20, month: "Apr")]);
        expect(state.totalCall, 20);
        expect(state.totalDayJoined, 368);
        expect(state.callingFailure, const CallingFailure());
        expect(state.userFailure, const UserFailure());
      });
    });

    group(".fromState()", () {
      test("Should copy from state", () {
        CallStatisticError state = CallStatisticError.fromState(
          defaultState,
          callingFailure: const CallingFailure(),
          userFailure: const UserFailure(),
        );

        expect(state.selectedYear, "2020");
        expect(state.userType, UserType.blind);
        expect(state.listOfYear, ["2019", "2020"]);
        expect(state.calls, [const CallDataMounthly(total: 20, month: "Apr")]);
        expect(state.totalCall, 20);
        expect(state.totalDayJoined, 368);
        expect(state.callingFailure, const CallingFailure());
        expect(state.userFailure, const UserFailure());
      });
    });
  });
}
