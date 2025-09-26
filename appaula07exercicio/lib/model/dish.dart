// Criando a classe dish
class Dish{
  final String id;
  final String name;
  final String description;
  final int price;
  final String imagePath;
  final List<String> categories;
  final String? restaurantName;

  Dish copyWith({
    String? id,
    String? name,
    String? description,
    int? price,
    String? imagePath,
    List<String>? categories,
    String? restaurantName,
  }) {
    return Dish(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      categories: categories ?? this.categories,
      restaurantName: restaurantName ?? this.restaurantName,
    );
  }

// Cria o construtor
  Dish({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    this.categories = const [],
    this.restaurantName,
  });

  // metodo para tratar chave e valor
  Map<String,dynamic>toMap(){
  return{
    'id': id,
    'name':name,
    'description':description,
    'price': price,
    'imagePath':imagePath
  };
  }


  // Função para fazer a conversão de chave e valor

  factory Dish.fromMap(Map<String,dynamic>map){
    return Dish(
      id: map['id'],
       name: map['name'], 
       description: map['description'], 
       price: map['price'],
        imagePath: map['imagePath']);
  }

 // função para converter para string
  @override 
  String toString(){
    return 'Dish(id:$id,name: $name, description: $description, price: $price, imagePath: $imagePath)';
  }
}