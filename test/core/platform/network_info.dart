import 'package:blog_app/core/platform/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('NetworkInfo', () {
    late NetworkInfoImpl networkInfo;
    late InternetConnectionChecker mockConnectionChecker;

    setUp(() {
      mockConnectionChecker = MockInternetConnectionChecker();
      networkInfo = NetworkInfoImpl(mockConnectionChecker);
    });

    test('should forward the call to InternetConnectionChecker.hasConnection',
        () async {
      // Arrange
      when(mockConnectionChecker.hasConnection).thenAnswer((_) async => true);

      // Act
      final result = await networkInfo.isConnected;

      // Assert
      verify(mockConnectionChecker.hasConnection);
      expect(result, true);
    });
  });
}

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {
  @override
  late List<AddressCheckOptions> addresses;

  @override
  bool operator ==(Object other) {
    // TODO: implement ==
    throw UnimplementedError();
  }

  @override
  // TODO: implement checkInterval
  Duration get checkInterval => throw UnimplementedError();

  @override
  // TODO: implement checkTimeout
  Duration get checkTimeout => throw UnimplementedError();

  @override
  // TODO: implement connectionStatus
  Future<InternetConnectionStatus> get connectionStatus =>
      throw UnimplementedError();

  @override
  // TODO: implement hasConnection
  Future<bool> get hasConnection => throw UnimplementedError();

  @override
  // TODO: implement hasListeners
  bool get hasListeners => throw UnimplementedError();

  @override
  // TODO: implement hashCode
  int get hashCode => throw UnimplementedError();

  @override
  // TODO: implement isActivelyChecking
  bool get isActivelyChecking => throw UnimplementedError();

  @override
  Future<AddressCheckResult> isHostReachable(AddressCheckOptions options) {
    // TODO: implement isHostReachable
    throw UnimplementedError();
  }

  @override
  // TODO: implement onStatusChange
  Stream<InternetConnectionStatus> get onStatusChange =>
      throw UnimplementedError();

  @override
  // TODO: implement runtimeType
  Type get runtimeType => throw UnimplementedError();

  @override
  String toString() {
    // TODO: implement toString
    throw UnimplementedError();
  }
}
