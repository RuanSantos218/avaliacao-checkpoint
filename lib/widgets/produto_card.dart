import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProdutoCard extends StatelessWidget {
  final String imagem;
  final String nome;
  final String preco;

  const ProdutoCard({
    super.key,
    required this.imagem,
    required this.nome,
    required this.preco,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                color: Color(0xFFF5F5F5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Image.asset(
                  imagem,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.shopping_bag,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Text(
              nome,
              style: GoogleFonts.orbitron(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              preco,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}