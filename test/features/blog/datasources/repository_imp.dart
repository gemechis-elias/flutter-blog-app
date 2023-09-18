import 'package:blog_app/features/blog/domain/entities/article.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blog_app/features/blog/data/datasources/data_source_api.dart';
import 'package:blog_app/features/blog/data/datasources/remote_data_source.dart';
import 'package:blog_app/injection.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('RemoteDataSource', () {
    late RemoteDataSource remoteDataSource;
    late MockHttpClient mockHttpClient;
    late MockSharedPreferences mockSharedPreferences;

    setUp(() {
      mockHttpClient = MockHttpClient();
      mockSharedPreferences = MockSharedPreferences();

      remoteDataSource = RemoteDataSource(
          baseUrl: 'https://blog-api-4z3m.onrender.com/api/v1');
      sl.registerSingleton<SharedPreferences>(mockSharedPreferences);
      sl.registerLazySingleton<http.Client>(() => mockHttpClient);
    });

    group('getAllBlog', () {
      test('should return a list of articles when the response is successful',
          () async {
        // Arrange
        when(mockHttpClient.get(
                "https://blog-api-4z3m.onrender.com/api/v1" as Uri,
                headers: anyNamed('headers')))
            .thenAnswer((_) async =>
                http.Response('{"success": true, "data": []}', 200));

        // Act
        final result = await remoteDataSource.getAllBlog();

        // Assert
        expect(result, isA<List<Article>>());
      });

      test('should throw an exception when the response is unsuccessful',
          () async {
        // Arrange
        when(mockHttpClient.get(
                "https://blog-api-4z3m.onrender.com/api/v1" as Uri,
                headers: anyNamed('headers')))
            .thenAnswer((_) async =>
                http.Response('{"success": false, "message": "Error"}', 400));

        // Act
        final call = remoteDataSource.getAllBlog;

        // Assert
        expect(call(), throwsException);
      });
    });

    // Write similar tests for other methods in RemoteDataSource
  });
}
