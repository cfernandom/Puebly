import 'package:puebly/features/towns/domain/entities/category.dart';
import 'package:puebly/features/towns/domain/entities/post.dart';
import 'package:puebly/features/towns/domain/entities/town.dart';

abstract class TownsRepository {
  Future<List<Town>> getTowns(int page);
  Future<Map<int, List<Post>>> getNewerPosts(int townCategoryId, int page,
      {int? section, List<int>? sectionChilds});
  Future<Map<int, List<Category>>> getSectionChildCategories(int townCategoryId);
  Future<Post> getPost(int id);
}