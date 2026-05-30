import 'dart:math';
import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../models/item_carrinho.dart';
import '../models/usuario.dart';

class LojaController extends ChangeNotifier {
  final Random _random = Random();
  
  List<Produto> _produtosPromocionais = [];
  final List<ItemCarrinho> _carrinho = [];
  Usuario? _usuarioLogado;

  List<Produto> get produtosPromocionais => _produtosPromocionais;
  List<ItemCarrinho> get carrinho => _carrinho;
  Usuario? get usuarioLogado => _usuarioLogado;

  LojaController() {
    _gerarProdutos();
  }

  void _gerarProdutos() {
    List<String> bancoDeImagens = [
      "assets/imagens/capibaba.png",
      "assets/imagens/cartao.png",
      "assets/imagens/bone.png",
      "assets/imagens/vaso.png",
      "assets/imagens/caneca.png",
      "assets/imagens/guadro.png",
    ];

    bancoDeImagens.shuffle(_random);

    _produtosPromocionais = List.generate(bancoDeImagens.length, (index) {
      String imagemSelecionada = bancoDeImagens[index % bancoDeImagens.length];
      double precoAleatorio = 10.0 + _random.nextDouble() * 90.0;

      return Produto(
        imagem: imagemSelecionada,
        nome: "Geek Prod ${index + 1}",
        preco: precoAleatorio,
      );
    });
    notifyListeners();
  }

  void adicionarAoCarrinho(Produto produto) {
    int index = _carrinho.indexWhere((item) => item.produto.nome == produto.nome);

    if (index != -1) {
      _carrinho[index].quantidade++;
    } else {
      _carrinho.add(ItemCarrinho(produto: produto));
    }
    notifyListeners();
  }

  void incrementarItem(ItemCarrinho item) {
    item.quantidade++;
    notifyListeners();
  }

  void decrementarItem(ItemCarrinho item) {
    if (item.quantidade > 1) {
      item.quantidade--;
    } else {
      _carrinho.remove(item);
    }
    notifyListeners();
  }

  void realizarLogin(Usuario usuario) {
    _usuarioLogado = usuario;
    notifyListeners();
  }

  void realizarLogout() {
    _usuarioLogado = null;
    notifyListeners();
  }

  int get totalItensNoCarrinho => _carrinho.fold(0, (total, item) => total + item.quantidade);

  double get precoTotalCarrinho => _carrinho.fold(0.0, (total, item) => total + (item.produto.preco * item.quantidade));
}