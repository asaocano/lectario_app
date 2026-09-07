import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lectario_app/data/datasources/localDatabase/local_storage_datasource_impl.dart';
import 'package:lectario_app/data/repositories/localDatabase/local_storage_repository_impl.dart';

final localStorageRepositoryProvider = Provider((ref) {
  return LocalStorageRepositoryImpl(datasource: LocalStorageDatasourceImpl());
});
