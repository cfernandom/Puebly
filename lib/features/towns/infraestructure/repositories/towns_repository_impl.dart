import 'package:collection/collection.dart';
import 'package:puebly/features/towns/domain/datasources/towns_datasource.dart';
import 'package:puebly/features/towns/domain/entities/category.dart';
import 'package:puebly/features/towns/domain/entities/post.dart';
import 'package:puebly/features/towns/domain/entities/town.dart';
import 'package:puebly/features/towns/domain/repositories/towns_repository.dart';
import 'package:puebly/features/towns/infraestructure/models/category_model.dart';

class TownsRepositoryImpl extends TownsRepository {
  final TownsDataSource _townsDataSource;

  TownsRepositoryImpl(this._townsDataSource);

  @override
  Future<List<Town>> getTowns(int page) async {
    final townsModel = await _townsDataSource.getTowns(page);
    return townsModel
        .map((town) => Town(
            id: town.id,
            name: town.name,
            description: town.description,
            featuredImgUrl: town.featuredImgUrl,
            enabled: town.enabled,
            categoryId: town.categoryId))
        .toList();
  }

  @override
  Future<Map<int, List<Post>>> getNewerPosts(int townCategoryId, int page) async {
    try {
      final postModels = await _townsDataSource.getNewerPosts(townCategoryId, page);
      final newerPostByCategory = <int, List<Post>>{};
      for (final postModel in postModels) {
        final categoryId = postModel.sectionCategoryId;
        newerPostByCategory[categoryId] ??= [];
        newerPostByCategory[categoryId]!.add(Post(
            id: postModel.id,
            title: postModel.title,
            content: postModel.content,
            featuredImgUrl: postModel.featuredImgUrl,
            images: postModel.images,
            categories: postModel.categories));
      }
      return newerPostByCategory;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<int, List<Category>>> getSectionChildCategories(
      int townCategoryId) async {
    try {
      final categoryModels =
          await _townsDataSource.getSectionChildCategories(townCategoryId);

      final categoryModelsByParentId = groupBy(
        categoryModels,
        (CategoryModel categoryModel) => categoryModel.parentId,
      );

      return categoryModelsByParentId.map((parentId, categoryModelList) {
        final categories = categoryModelList
            .map((categoryModel) => Category(
                  id: categoryModel.id,
                  name: categoryModel.name,
                  count: categoryModel.count,
                  description: categoryModel.description,
                ))
            .toList();
        return MapEntry(parentId, categories);
      });
    } catch (e) {
      rethrow;
    }
  }
}
