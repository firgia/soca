// Mocks generated by Mockito 5.3.2 from annotations
// in soca/test/mock/mock.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:flutter_dotenv/src/dotenv.dart' as _i3;
import 'package:flutter_dotenv/src/parser.dart' as _i5;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeIOSOptions_0 extends _i1.SmartFake implements _i2.IOSOptions {
  _FakeIOSOptions_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAndroidOptions_1 extends _i1.SmartFake
    implements _i2.AndroidOptions {
  _FakeAndroidOptions_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeLinuxOptions_2 extends _i1.SmartFake implements _i2.LinuxOptions {
  _FakeLinuxOptions_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeWindowsOptions_3 extends _i1.SmartFake
    implements _i2.WindowsOptions {
  _FakeWindowsOptions_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeWebOptions_4 extends _i1.SmartFake implements _i2.WebOptions {
  _FakeWebOptions_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeMacOsOptions_5 extends _i1.SmartFake implements _i2.MacOsOptions {
  _FakeMacOsOptions_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [DotEnv].
///
/// See the documentation for Mockito's code generation for more information.
class MockDotEnv extends _i1.Mock implements _i3.DotEnv {
  MockDotEnv() {
    _i1.throwOnMissingStub(this);
  }

  @override
  Map<String, String> get env => (super.noSuchMethod(
        Invocation.getter(#env),
        returnValue: <String, String>{},
      ) as Map<String, String>);
  @override
  bool get isInitialized => (super.noSuchMethod(
        Invocation.getter(#isInitialized),
        returnValue: false,
      ) as bool);
  @override
  void clean() => super.noSuchMethod(
        Invocation.method(
          #clean,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  String get(
    String? name, {
    String? fallback,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #get,
          [name],
          {#fallback: fallback},
        ),
        returnValue: '',
      ) as String);
  @override
  String? maybeGet(
    String? name, {
    String? fallback,
  }) =>
      (super.noSuchMethod(Invocation.method(
        #maybeGet,
        [name],
        {#fallback: fallback},
      )) as String?);
  @override
  _i4.Future<void> load({
    String? fileName = r'.env',
    _i5.Parser? parser = const _i5.Parser(),
    Map<String, String>? mergeWith = const {},
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #load,
          [],
          {
            #fileName: fileName,
            #parser: parser,
            #mergeWith: mergeWith,
          },
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  void testLoad({
    String? fileInput = r'',
    _i5.Parser? parser = const _i5.Parser(),
    Map<String, String>? mergeWith = const {},
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #testLoad,
          [],
          {
            #fileInput: fileInput,
            #parser: parser,
            #mergeWith: mergeWith,
          },
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool isEveryDefined(Iterable<String>? vars) => (super.noSuchMethod(
        Invocation.method(
          #isEveryDefined,
          [vars],
        ),
        returnValue: false,
      ) as bool);
}

/// A class which mocks [FlutterSecureStorage].
///
/// See the documentation for Mockito's code generation for more information.
class MockFlutterSecureStorage extends _i1.Mock
    implements _i2.FlutterSecureStorage {
  MockFlutterSecureStorage() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.IOSOptions get iOptions => (super.noSuchMethod(
        Invocation.getter(#iOptions),
        returnValue: _FakeIOSOptions_0(
          this,
          Invocation.getter(#iOptions),
        ),
      ) as _i2.IOSOptions);
  @override
  _i2.AndroidOptions get aOptions => (super.noSuchMethod(
        Invocation.getter(#aOptions),
        returnValue: _FakeAndroidOptions_1(
          this,
          Invocation.getter(#aOptions),
        ),
      ) as _i2.AndroidOptions);
  @override
  _i2.LinuxOptions get lOptions => (super.noSuchMethod(
        Invocation.getter(#lOptions),
        returnValue: _FakeLinuxOptions_2(
          this,
          Invocation.getter(#lOptions),
        ),
      ) as _i2.LinuxOptions);
  @override
  _i2.WindowsOptions get wOptions => (super.noSuchMethod(
        Invocation.getter(#wOptions),
        returnValue: _FakeWindowsOptions_3(
          this,
          Invocation.getter(#wOptions),
        ),
      ) as _i2.WindowsOptions);
  @override
  _i2.WebOptions get webOptions => (super.noSuchMethod(
        Invocation.getter(#webOptions),
        returnValue: _FakeWebOptions_4(
          this,
          Invocation.getter(#webOptions),
        ),
      ) as _i2.WebOptions);
  @override
  _i2.MacOsOptions get mOptions => (super.noSuchMethod(
        Invocation.getter(#mOptions),
        returnValue: _FakeMacOsOptions_5(
          this,
          Invocation.getter(#mOptions),
        ),
      ) as _i2.MacOsOptions);
  @override
  _i4.Future<void> write({
    required String? key,
    required String? value,
    _i2.IOSOptions? iOptions,
    _i2.AndroidOptions? aOptions,
    _i2.LinuxOptions? lOptions,
    _i2.WebOptions? webOptions,
    _i2.MacOsOptions? mOptions,
    _i2.WindowsOptions? wOptions,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #write,
          [],
          {
            #key: key,
            #value: value,
            #iOptions: iOptions,
            #aOptions: aOptions,
            #lOptions: lOptions,
            #webOptions: webOptions,
            #mOptions: mOptions,
            #wOptions: wOptions,
          },
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<String?> read({
    required String? key,
    _i2.IOSOptions? iOptions,
    _i2.AndroidOptions? aOptions,
    _i2.LinuxOptions? lOptions,
    _i2.WebOptions? webOptions,
    _i2.MacOsOptions? mOptions,
    _i2.WindowsOptions? wOptions,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #read,
          [],
          {
            #key: key,
            #iOptions: iOptions,
            #aOptions: aOptions,
            #lOptions: lOptions,
            #webOptions: webOptions,
            #mOptions: mOptions,
            #wOptions: wOptions,
          },
        ),
        returnValue: _i4.Future<String?>.value(),
      ) as _i4.Future<String?>);
  @override
  _i4.Future<bool> containsKey({
    required String? key,
    _i2.IOSOptions? iOptions,
    _i2.AndroidOptions? aOptions,
    _i2.LinuxOptions? lOptions,
    _i2.WebOptions? webOptions,
    _i2.MacOsOptions? mOptions,
    _i2.WindowsOptions? wOptions,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #containsKey,
          [],
          {
            #key: key,
            #iOptions: iOptions,
            #aOptions: aOptions,
            #lOptions: lOptions,
            #webOptions: webOptions,
            #mOptions: mOptions,
            #wOptions: wOptions,
          },
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
  @override
  _i4.Future<void> delete({
    required String? key,
    _i2.IOSOptions? iOptions,
    _i2.AndroidOptions? aOptions,
    _i2.LinuxOptions? lOptions,
    _i2.WebOptions? webOptions,
    _i2.MacOsOptions? mOptions,
    _i2.WindowsOptions? wOptions,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #delete,
          [],
          {
            #key: key,
            #iOptions: iOptions,
            #aOptions: aOptions,
            #lOptions: lOptions,
            #webOptions: webOptions,
            #mOptions: mOptions,
            #wOptions: wOptions,
          },
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<Map<String, String>> readAll({
    _i2.IOSOptions? iOptions,
    _i2.AndroidOptions? aOptions,
    _i2.LinuxOptions? lOptions,
    _i2.WebOptions? webOptions,
    _i2.MacOsOptions? mOptions,
    _i2.WindowsOptions? wOptions,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #readAll,
          [],
          {
            #iOptions: iOptions,
            #aOptions: aOptions,
            #lOptions: lOptions,
            #webOptions: webOptions,
            #mOptions: mOptions,
            #wOptions: wOptions,
          },
        ),
        returnValue: _i4.Future<Map<String, String>>.value(<String, String>{}),
      ) as _i4.Future<Map<String, String>>);
  @override
  _i4.Future<void> deleteAll({
    _i2.IOSOptions? iOptions,
    _i2.AndroidOptions? aOptions,
    _i2.LinuxOptions? lOptions,
    _i2.WebOptions? webOptions,
    _i2.MacOsOptions? mOptions,
    _i2.WindowsOptions? wOptions,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteAll,
          [],
          {
            #iOptions: iOptions,
            #aOptions: aOptions,
            #lOptions: lOptions,
            #webOptions: webOptions,
            #mOptions: mOptions,
            #wOptions: wOptions,
          },
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}
