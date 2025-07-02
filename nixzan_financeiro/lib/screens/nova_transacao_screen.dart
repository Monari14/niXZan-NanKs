import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/transacao.dart';

class NovaTransacaoScreen extends StatefulWidget {
  const NovaTransacaoScreen({super.key});

  @override
  State<NovaTransacaoScreen> createState() => _NovaTransacaoScreenState();
}

class _NovaTransacaoScreenState extends State<NovaTransacaoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _valorController = TextEditingController();
  bool _isGanho = true;
  DateTime _dataSelecionada = DateTime.now();

  void _salvarTransacao() async {
    if (_formKey.currentState!.validate()) {
      final novaTransacao = Transacao(
        titulo: _tituloController.text.trim(),
        valor: double.parse(_valorController.text.trim()),
        data: _dataSelecionada,
        isGanho: _isGanho,
      );

      final box = Hive.box<Transacao>('transacoes');
      await box.add(novaTransacao);

      Navigator.pop(context);
    }
  }

  void _escolherData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      helpText: 'Selecione a data da transação',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
    );

    if (data != null) {
      setState(() {
        _dataSelecionada = data;
      });
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Transação')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Digite um título' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _valorController,
                decoration: InputDecoration(
                  labelText: 'Valor (ex: 123.45)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Digite um valor';
                  final valor = double.tryParse(value.replaceAll(',', '.'));
                  if (valor == null || valor <= 0) return 'Valor inválido';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Data: ${_dataSelecionada.day.toString().padLeft(2, '0')}/'
                      '${_dataSelecionada.month.toString().padLeft(2, '0')}/'
                      '${_dataSelecionada.year}',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Selecionar data'),
                    onPressed: _escolherData,
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Text('Tipo:', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(width: 20),
                  ChoiceChip(
                    label: const Text('Ganho'),
                    selected: _isGanho,
                    onSelected: (_) => setState(() => _isGanho = true),
                    selectedColor: theme.colorScheme.primary.withOpacity(0.3),
                  ),
                  const SizedBox(width: 12),
                  ChoiceChip(
                    label: const Text('Gasto'),
                    selected: !_isGanho,
                    onSelected: (_) => setState(() => _isGanho = false),
                    selectedColor: theme.colorScheme.error.withOpacity(0.3),
                  ),
                ],
              ),
              const SizedBox(height: 36),
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('Salvar', style: TextStyle(fontSize: 18)),
                  onPressed: _salvarTransacao,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
