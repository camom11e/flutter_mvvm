import 'package:flutter/foundation.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import '/domain/product_repository.dart';
import '/features/profile/profile_screen_model.dart';
import 'package:flutter/material.dart';
import '/features/profile/profile_screen_widget.dart';

abstract class IProfileWidgetModel implements IWidgetModel {
  ValueNotifier<EntityState<List<String>>> get productListenable;
  ValueNotifier<EntityState<User>> get userListenable;
  ValueNotifier<bool> get isLoadingState;
  void deleteItem(int index);
  void addProduct();
  Future<void> loadData(); // Объявленный абстрактный метод
}

ProfileWidgetModel defaultProfileWidgetModelFactory(BuildContext context) {
  return ProfileWidgetModel(ProfileModel(ProductRepository()));
}

class ProfileWidgetModel extends WidgetModel<Profile, IProfileModel>
    implements IProfileWidgetModel {
  ProfileWidgetModel(ProfileModel model) : super(model);

  final _productEntity = EntityStateNotifier<List<String>>();
  final _userEntity = EntityStateNotifier<User>();
  final _isLoading = ValueNotifier<bool>(false);

  @override
  ValueNotifier<EntityState<List<String>>> get productListenable => _productEntity;

  @override
  ValueNotifier<EntityState<User>> get userListenable => _userEntity;

  @override
  ValueNotifier<bool> get isLoadingState => _isLoading;

  @override
  Future<void> loadData() async { // Конкретная реализация абстрактного метода
    _isLoading.value = true;
    _userEntity.loading();
    _productEntity.loading();

    try {
      final user = await model.getUser();
      if (user != null) {
        _userEntity.content(user);
      } else {
        _userEntity.error(Exception('Данные пользователя не получены'));
      }

      final products = await model.getProducts();
      if (products != null) {
        _productEntity.content(products);
      } else {
        _productEntity.error(Exception('Список продуктов пуст'));
      }
    } on Exception catch (e) {

      _userEntity.error(e);
      _productEntity.error(e);
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void deleteItem(int index) {
    final data = _productEntity.value.data;
    if (data == null) return;
    data.removeAt(index);
    _productEntity.content([...data]);
  }

  @override
  void addProduct() async {
    final data = _productEntity.value.data ?? [];
    final newProduct = 'Продукт ${data.length + 1}';
    
    _productEntity.loading(data);
    
    try {
      await model.addProduct(newProduct);
      _productEntity.content([...data, newProduct]);
    } on Exception catch (e) {
      _productEntity.error(e, data);
    }
  }

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    loadData();
  }
}