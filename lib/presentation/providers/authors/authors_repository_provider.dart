import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lectario_app/data/datasources/authors/authors_datasource_impl.dart';
import 'package:lectario_app/data/repositories/authors/authors_repository_impl.dart';
import 'package:lectario_app/presentation/providers/network/api_client_provider.dart';

final authorsRepositoryProvider = Provider((ref) {
  return AuthorsRepositoryImpl(
    datasource: AuthorsDatasourceImpl(apiClient: ref.watch(apiClientProvider)),
  );
});
