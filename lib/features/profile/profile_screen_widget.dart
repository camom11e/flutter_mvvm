import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import '/features/profile/profile_screen_wm.dart';
import '/domain/product_repository.dart';

class Profile extends ElementaryWidget<IProfileWidgetModel> {
  const Profile({super.key}) : super(defaultProfileWidgetModelFactory);

  @override
  Widget build(IProfileWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      floatingActionButton: FloatingActionButton(
        onPressed: wm.addProduct,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Информация о пользователе
            EntityStateNotifierBuilder<User>(
              listenableEntityState: wm.userListenable,
              loadingBuilder: (_, __) => const CircularProgressIndicator(),
              errorBuilder: (_, error, __) => Text('Ошибка: $error'),
              builder: (_, user) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Имя: ${user?.name ?? "Неизвестно"}', style: const TextStyle(fontSize: 18)),
                  Text('Email: ${user?.email ?? "Не указан"}', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  const Text('Мои продукты:', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Список продуктов
            Expanded(
              child: EntityStateNotifierBuilder<List<String>>(
                listenableEntityState: wm.productListenable,
                loadingBuilder: (_, data) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorBuilder: (_, error, data) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Ошибка: $error'),
                      ElevatedButton(
                        onPressed: wm.loadData,
                        child: const Text('Попробовать снова'),
                      ),
                    ],
                  ),
                ),
                builder: (_, products) => ListView.separated(
                  itemCount: products?.length ?? 0,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) => Card(
                    child: ListTile(
                      title: Text(products?[index] ?? "продукт не определен"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => wm.deleteItem(index),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}