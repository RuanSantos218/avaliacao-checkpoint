import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/loja_controller.dart';

class CarrinhoPage extends StatelessWidget {
  final LojaController controller;
  final VoidCallback onFinalizarCompra; // Desacoplado de rotas internas

  const CarrinhoPage({
    super.key,
    required this.controller,
    required this.onFinalizarCompra,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Meu Carrinho",
              style: GoogleFonts.orbitron(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: controller.carrinho.isEmpty
              ? Center(child: Text("Seu carrinho está vazio 😢", style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey)))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.carrinho.length,
                        itemBuilder: (context, index) {
                          final item = controller.carrinho[index];
                          String precoItemFormatado = "R\$ ${(item.produto.preco * item.quantidade).toStringAsFixed(2).replaceAll('.', ',')}";

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: Image.asset(
                                        item.produto.imagem,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.shopping_bag),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item.produto.nome, style: GoogleFonts.orbitron(fontSize: 14, fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 4),
                                        Text("Qtd: ${item.quantidade}", style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600])),
                                        const SizedBox(height: 4),
                                        Text(precoItemFormatado, style: GoogleFonts.poppins(fontSize: 14, color: Colors.purple, fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle_outline, color: Colors.grey),
                                        onPressed: () => controller.decrementarItem(item),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add_circle_outline, color: Colors.purple),
                                        onPressed: () => controller.incrementarItem(item),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5)),
                        ],
                      ),
                      child: SafeArea(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Total:", style: GoogleFonts.orbitron(fontSize: 18, fontWeight: FontWeight.bold)),
                                Text(
                                  "R\$ ${controller.precoTotalCarrinho.toStringAsFixed(2).replaceAll('.', ',')}",
                                  style: GoogleFonts.poppins(fontSize: 22, color: Colors.purple, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: onFinalizarCompra,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Text(
                                  "Finalizar Compra",
                                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}