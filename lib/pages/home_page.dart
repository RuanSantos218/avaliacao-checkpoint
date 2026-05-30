import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/loja_controller.dart';
import '../models/usuario.dart';
import '../widgets/produto_card.dart';
import 'detalhe_produto_page.dart';
import 'carrinho_page.dart';
import 'login_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LojaController _controller = LojaController();

  Future<void> _fazerLogin() async {
    final resultado = await Navigator.push<Usuario>(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );

    if (resultado != null) {
      _controller.realizarLogin(resultado);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bem-vindo(a), ${resultado.nome}!")),
        );
      }
    }
  }

  void _gerenciarPerfilUsuario() {
    if (_controller.usuarioLogado == null) {
      _fazerLogin();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Sua Conta", style: GoogleFonts.orbitron()),
          content: Text(
            "Logado como: ${_controller.usuarioLogado!.nome}\nE-mail: ${_controller.usuarioLogado!.email}",
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Fechar")),
            TextButton(
              onPressed: () {
                _controller.realizarLogout();
                Navigator.pop(context);
              },
              child: const Text("Sair", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    }
  }

  void _abrirCarrinhoETratarCompra() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarrinhoPage(
          controller: _controller,
          onFinalizarCompra: () async {
            // Orquestração de Fluxo e Segurança (Guard) centralizada na Home
            if (_controller.usuarioLogado == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Faça login para finalizar a compra!"), backgroundColor: Colors.orange),
              );

              final novoUsuario = await Navigator.push<Usuario>(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );

              if (novoUsuario != null) {
                _controller.realizarLogin(novoUsuario);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Compra de ${novoUsuario.nome} finalizada com sucesso!"), backgroundColor: Colors.green),
                  );
                }
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Compra de ${_controller.usuarioLogado!.nome} finalizada com sucesso!"), backgroundColor: Colors.green),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(icon: const Icon(Icons.menu, color: Colors.black), onPressed: () {}),
            title: Center(
              child: Text(
                "GEEK STORE",
                style: GoogleFonts.orbitron(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _controller.usuarioLogado == null ? Icons.person_outline : Icons.person,
                  color: _controller.usuarioLogado == null ? Colors.black : Colors.purple,
                ),
                onPressed: _gerenciarPerfilUsuario,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
                    onPressed: _abrirCarrinhoETratarCompra,
                  ),
                  if (_controller.totalItensNoCarrinho > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(10)),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          '${_controller.totalItensNoCarrinho}',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.asset(
                      "assets/imagens/Banner.png",
                      width: double.infinity,
                      height: 450,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 250,
                        color: Colors.purple.withValues(alpha: 0.1),
                        child: const Center(child: Icon(Icons.image, size: 50)),
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Text("Hora de abraçar seu", style: GoogleFonts.orbitron(fontSize: 24, color: const Color(0xFFFF55DF), fontWeight: FontWeight.w500)),
                          Text("lado geek", style: GoogleFonts.orbitron(fontSize: 24, color: const Color(0xff8FFF24), fontWeight: FontWeight.w500)),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                            child: Text("Ver as novidades!", style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[100],
                  child: Column(
                    children: [
                      Text("Promos especiais", style: GoogleFonts.orbitron(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      _controller.produtosPromocionais.isEmpty
                          ? const Text("Nenhum produto encontrado")
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _controller.produtosPromocionais.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 20,
                                childAspectRatio: 0.75,
                              ),
                              itemBuilder: (context, index) {
                                final produto = _controller.produtosPromocionais[index];

                                return GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetalheProdutoPage(produto: produto, controller: _controller),
                                    ),
                                  ),
                                  child: ProdutoCard(
                                    imagem: produto.imagem,
                                    nome: produto.nome,
                                    preco: "R\$ ${produto.preco.toStringAsFixed(2).replaceAll('.', ',')}",
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}