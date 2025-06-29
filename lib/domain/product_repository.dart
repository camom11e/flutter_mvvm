class User {
  final String name;
  final String email;

  User({required this.name, required this.email});
}

class ProductRepository {
  Future<List<String>> getProducts() async {
    await Future.delayed(const Duration(seconds: 2));
    return ['Продукт 1', 'Продукт 2', 'Продукт 3'];
  }

  Future<User> getUser() async {
    await Future.delayed(const Duration(seconds: 1));
    return User(name: 'Иван Иванов', email: 'ivan@example.com');
  }

  Future<void> addProduct(String product) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}