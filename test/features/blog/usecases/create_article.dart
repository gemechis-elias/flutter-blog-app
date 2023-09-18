import 'dart:io';

import 'package:blog_app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blog_app/features/blog/domain/entities/article.dart';
import 'package:blog_app/features/blog/domain/usecases/create_article.dart';
import 'package:blog_app/features/blog/domain/repositories/article_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';

class MockArticleRepository extends Mock implements ArticleRepository {}

void main() {
  late CreateArticleUseCase createArticleUseCase;
  late MockArticleRepository mockArticleRepository;

  setUp(() {
    mockArticleRepository = MockArticleRepository();
    createArticleUseCase = CreateArticleUseCase(mockArticleRepository);
  });

  group('CreateArticleUseCase', () {
    const testTitle = 'Test Title';
    const testContent = 'Test Content';
    const testSubTitle = 'Test SubTitle';
    final testImage = File('test_image.jpg');
    const testTagList = 'tag1,tag2';

    test('should create an article when called with correct parameters',
        () async {
      // Arrange
      final expectedArticle = Article(
        id: '1',
        title: testTitle,
        content: testContent,
        subTitle: testSubTitle,
        image: "assets/images/doctor.jpg",
        tags: [],
      );
      final params = CreateArticleParams(
        title: testTitle,
        content: testContent,
        subTitle: testSubTitle,
        image: testImage,
        tagList: testTagList,
      );

      when(mockArticleRepository.createArticle(
        title: anyNamed('title') ?? '',
        content: anyNamed('content') ?? '',
        subTitle: anyNamed('subTitle') ?? '',
        image: anyNamed('image') ?? File(''),
        tags: anyNamed('tags') ?? '',
      )).thenAnswer((_) async => Right(expectedArticle));

      // Act
      final result = await createArticleUseCase(params);

      // Assert
      expect(result, equals(Right(expectedArticle)));
      verify(mockArticleRepository.createArticle(
        title: testTitle,
        content: testContent,
        subTitle: testSubTitle,
        image: testImage,
        tags: testTagList,
      ));
      verifyNoMoreInteractions(mockArticleRepository);
    });

    test('should return a failure when repository throws an exception',
        () async {
      // Arrange
      final params = CreateArticleParams(
        title: testTitle,
        content: testContent,
        subTitle: testSubTitle,
        image: testImage,
        tagList: testTagList,
      );

      when(mockArticleRepository.createArticle(
        title: anyNamed('title') ?? '',
        content: anyNamed('content') ?? '',
        subTitle: anyNamed('subTitle') ?? '',
        image: anyNamed('image') ?? File(''),
        tags: anyNamed('tags') ?? '',
      )).thenThrow(Exception('Error creating article'));

      // Act
      final result = await createArticleUseCase(params);

      // Assert
      expect(result, equals(Left(ServerFailure('Error creating article'))));
      verify(mockArticleRepository.createArticle(
        title: testTitle,
        content: testContent,
        subTitle: testSubTitle,
        image: testImage,
        tags: testTagList,
      ));
      verifyNoMoreInteractions(mockArticleRepository);
    });
  });
}
