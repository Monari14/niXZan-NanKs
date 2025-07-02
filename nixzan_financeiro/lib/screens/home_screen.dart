import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../models/transacao.dart';
import 'nova_transacao_screen.dart';

class HomeScreen extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const HomeScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  double calcularSaldo(Box<Transacao> box) {
    double saldo = 0.0;
    for (var t in box.values) {
      saldo += t.isGanho ? t.valor : -t.valor;
    }
    return saldo;
  }

  @override
  Widget build(BuildContext context) {
    final transacoesBox = Hive.box<Transacao>('transacoes');

    return Scaffold(
      appBar: AppBar(
        title: const Text('niXZan - NanKs'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
            tooltip: isDark ? 'Tema Escuro' : 'Tema Claro',
            onPressed: onToggleTheme,
          )
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: transacoesBox.listenable(),
        builder: (context, Box<Transacao> box, _) {
          final transacoes = box.values.toList().reversed.toList();
          final saldo = calcularSaldo(box);

          return Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: saldo >= 0
                      ? (isDark ? Colors.green[900] : Colors.green[100])
                      : (isDark ? Colors.red[900] : Colors.red[100]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text('Saldo atual', style: TextStyle(fontSize: 18)),
                    Text(
                      'R\$ ${saldo.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: saldo >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: transacoes.isEmpty
                    ? const Center(child: Text('Nenhuma transação ainda'))
                    : ListView.builder(
                        itemCount: transacoes.length,
                        itemBuilder: (_, index) {
                          final t = transacoes[index];
                          return ListTile(
                            leading: Icon(
                              t.isGanho ? Icons.arrow_downward : Icons.arrow_upward,
                              color: t.isGanho ? Colors.green : Colors.red,
                            ),
                            title: Text(t.titulo),
                            subtitle: Text(
                              DateFormat('dd/MM/yyyy').format(t.data),
                            ),
                            trailing: Text(
                              'R\$ ${t.valor.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: t.isGanho ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onLongPress: () async {
                              await t.delete();
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Adicionar'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NovaTransacaoScreen()),
          );
        },
      ),
    );
  }
}
