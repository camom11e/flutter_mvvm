import 'package:elementary/elementary.dart';
import '/domain/product_repository.dart';

abstract class IProfileModel extends ElementaryModel {
  Future<List<String>> getProducts();
  Future<User> getUser();
  Future<void> addProduct(String product);
}

class ProfileModel extends IProfileModel {
  ProfileModel(this._repository);
  final ProductRepository _repository;

  @override
  Future<List<String>> getProducts() => _repository.getProducts();

  @override
  Future<User> getUser() => _repository.getUser();

  @override
  Future<void> addProduct(String product) => _repository.addProduct(product);
}