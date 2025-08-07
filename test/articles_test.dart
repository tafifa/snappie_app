import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:snappie_app/app/modules/articles/controllers/articles_controller.dart';

void main() {
  group('ArticlesController Tests', () {
    late ArticlesController controller;

    setUp(() {
      controller = ArticlesController();
    });

    tearDown(() {
      Get.reset();
    });

    test('should initialize with empty state', () {
      expect(controller.isLoading, false);
      expect(controller.articles, isEmpty);
      expect(controller.searchQuery, '');
      expect(controller.selectedCategory, '');
    });

    test('should have correct categories', () {
      expect(controller.categories, [
        'Semua',
        'Destinasi',
        'Kuliner',
        'Budaya',
        'Tips Travel',
        'Petualangan'
      ]);
    });

    test('should update search query', () {
      const testQuery = 'test search';
      controller.searchArticles(testQuery);
      expect(controller.searchQuery, testQuery);
    });

    test('should filter by category', () {
      const testCategory = 'Destinasi';
      controller.filterByCategory(testCategory);
      expect(controller.selectedCategory, testCategory);
    });

    test('should clear category filter when selecting "Semua"', () {
      controller.filterByCategory('Semua');
      expect(controller.selectedCategory, '');
    });
  });
}