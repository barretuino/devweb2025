// lib/models/produto.dart

import 'package:hive/hive.dart';

part 'produto.g.dart'; 

@HiveType(typeId: 0) 
class Produto extends HiveObject {
  @HiveField(0)
  late String nome;

  @HiveField(1)
  late double preco;

  @HiveField(2)
  late int quantidade;

  Produto({
    required this.nome,
    required this.preco,
    required this.quantidade,
  });
}

//flutter pub run build_runner build