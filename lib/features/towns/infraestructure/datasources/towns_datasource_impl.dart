import 'package:dio/dio.dart';
import 'package:puebly/config/constants/enviroment_constants.dart';
import 'package:puebly/features/towns/domain/datasources/towns_datasource.dart';
import 'package:puebly/features/towns/infraestructure/mappers/post_model_mapper.dart';
import 'package:puebly/features/towns/infraestructure/mappers/town_model_mapper.dart';
import 'package:puebly/features/towns/infraestructure/models/post_model.dart';
import 'package:puebly/features/towns/infraestructure/models/town_model.dart';

class TownsDataSourceImpl extends TownsDataSource {
  late final Dio _dio;

  TownsDataSourceImpl() {
    _dio = Dio();
    _dio.options.baseUrl = EnviromentConstants.homeURL;
  }

  @override
  Future<List<TownModel>> getTowns(int page) async {
    try {
      final response = await _dio.get('/wp-json/api/v2/towns?p=$page');
      final List<TownModel> towns = (response.data as List)
          .map((town) => TownModelMapper.fromJson(town))
          .toList();
      return towns;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PostModel>> getNewerPosts(int townCategoryId, int page) async {
    try {
      final response = await _dio.get('/wp-json/api/v1/newer-post?t=$townCategoryId&p=$page');
      final List<PostModel> posts = (response.data as List)
          .map((post) => PostModelMapper.fromJson(post))
          .toList();
      return posts;
    } catch (e) {
      rethrow;
    }
  }
}
