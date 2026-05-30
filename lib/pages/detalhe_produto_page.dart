import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/loja_controller.dart';
import '../models/produto.dart';

class DetalheProdutoPage extends StatelessWidget {
  final Produto produto;
  final LojaController controller;

  const DetalheProdutoPage({
    super.key,
    required this.produto,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    String precoFormatado = "R\$ ${produto.preco.toStringAsFixed(2).replaceAll('.', ',')}";

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
          "Detalhes do Produto",
          style: GoogleFonts.orbitron(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 320,
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Image.asset(
                  produto.imagem,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 80, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Text(produto.nome, style: GoogleFonts.orbitron(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(precoFormatado, style: GoogleFonts.poppins(fontSize: 22, color: Colors.purple, fontWeight: FontWeight.bold)),
            const SizedBox(height: 25),
            Text("Descrição do Produto", style: GoogleFonts.orbitron(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Text(
              "Este é um produto exclusivo do seu lado Geek! Perfeito para colecionadores e entusiastas da cultura pop.",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600], height: 1.6),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    controller.adicionarAoCarrinho(produto);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${produto.nome} adicionado ao carrinho!"), backgroundColor: Colors.purple),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text(
                    "Adicionar ao Carrinho",
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
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