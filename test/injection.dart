import 'package:blog_app/injection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

// Import your classes here

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockHttpClien extends Mock implements http.Client {}

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  group('Dependency Injection Setup', () {
    late GetIt sl;
    late MockSharedPreferences mockSharedPreferences;
    late MockHttpClien mockHttpClient;
    late MockInternetConnectionChecker mockConnectionChecker;

    setUp(() {
      sl = GetIt.instance;
      mockSharedPreferences = MockSharedPreferences();
      mockHttpClient = MockHttpClien();
      mockConnectionChecker = MockInternetConnectionChecker();

      sl.registerSingleton<SharedPreferences>(mockSharedPreferences);
      sl.registerLazySingleton<http.Client>(() => mockHttpClient);
      sl.registerLazySingleton<InternetConnectionChecker>(
          () => mockConnectionChecker);

      // Perform other registrations here

      // Call the init() function
      init();
    });

    test('SharedPreferences registration', () {
      expect(sl<SharedPreferences>(), mockSharedPreferences);
    });

    test('http.Client registration', () {
      expect(sl<http.Client>(), mockHttpClient);
    });

    test('InternetConnectionChecker registration', () {
      expect(sl<InternetConnectionChecker>(), mockConnectionChecker);
    });

    // Write similar tests for other dependencies
  });
}
