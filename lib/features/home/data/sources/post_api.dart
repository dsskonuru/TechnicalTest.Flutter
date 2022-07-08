import 'package:chopper/chopper.dart';
import 'package:flutter_tech_task/features/home/data/sources/connection_interceptor.dart';

part 'post_api.chopper.dart';

@ChopperApi(baseUrl: '/posts')
abstract class PostApiService extends ChopperService {
  static PostApiService create() {
    final client = ChopperClient(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      services: [
        _$PostApiService(),
      ],
      interceptors: [
        HttpLoggingInterceptor(),
        ConnectivityInterceptor(),
      ],
      converter: const JsonConverter(),
      errorConverter: const JsonConverter(),
    );
    return _$PostApiService(client);
  }

  @Get()
  Future<Response> getPosts();

  @Get(path: '/{id}')
  Future<Response> getPost(@Path('id') int id);

  @Get(path: '/{id}/comments')
  Future<Response> getComments(@Path('id') int id);
}
