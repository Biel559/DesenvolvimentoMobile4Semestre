import 'package:appaula05bdtaexercicio/data/disciplina_dao.dart';
import 'package:appaula05bdtaexercicio/models/disciplina.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _dao = DisciplinaDao();
  final _nomeCtrl = TextEditingController();
  final _nota1Ctrl = TextEditingController();
  final _nota2Ctrl = TextEditingController();
  final _nota3Ctrl = TextEditingController();
  final _searchCtrl = TextEditingController();

  Disciplina? _editing;
  Future<List<Disciplina>>? _futureDisciplinas;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    setState(() {
      final q = _searchCtrl.text.trim(); // trim remove os espaços em branco
      _futureDisciplinas = q.isEmpty ? _dao.getAll() : _dao.searchByName(q);
    });
  }

void _clearForm() {
  _nomeCtrl.clear();
  _nota1Ctrl.clear();
  _nota2Ctrl.clear();
  _nota3Ctrl.clear();
  _editing = null;
}

  void _edit(Disciplina disciplina) {
    setState(() {
      _editing = disciplina;
      _nomeCtrl.text = disciplina.nome;
      _nota1Ctrl.text = disciplina.nota1.toString();
      _nota2Ctrl.text = disciplina.nota2.toString();
      _nota3Ctrl.text = disciplina.nota3.toString();
    });
  }

Future<void> _save() async {
  final nome = _nomeCtrl.text.trim();
  final nota1Str = _nota1Ctrl.text.trim();
  final nota2Str = _nota2Ctrl.text.trim();
  final nota3Str = _nota3Ctrl.text.trim();

  if (nome.isEmpty || nota1Str.isEmpty || nota2Str.isEmpty || nota3Str.isEmpty) {
    _snack('Preencha todos os campos');
    return;
  }

  final nota1 = double.tryParse(nota1Str);
  final nota2 = double.tryParse(nota2Str);
  final nota3 = double.tryParse(nota3Str);

  if (nota1 == null || nota2 == null || nota3 == null) {
    _snack('Notas precisam ser números');
    return;
  }

  if (_editing == null) {
    await _dao.insert(Disciplina(nome: nome, nota1: nota1, nota2: nota2, nota3: nota3));
    _snack('Disciplina cadastrada');
  } else {
    await _dao.update(_editing!.copyWith(nome: nome, nota1: nota1, nota2: nota2, nota3: nota3));
    _snack('Disciplina atualizada');
  }
  _clearForm();
  _reload();
}

  Future<void> _delete(int id) async {
    await _dao.delete(id);
    _snack('Disciplina removida');
    _reload();
  }

  void _cancelEdit() {
    _clearForm();
    _snack('Edição cancelada');
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _nota1Ctrl.dispose();
    _nota2Ctrl.dispose();
    _nota3Ctrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _editing != null;
    return Scaffold(
      appBar: AppBar(
        title: Text('App aula 05 - Matérias BD - SQFLITE'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                labelText: 'Busca por nome',
                hintText: 'Ex Matemática',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                    tooltip: 'Limpar busca',
                    onPressed: () {
                      _searchCtrl.clear();
                      _reload();
                    },
                    icon: Icon(Icons.clear)),
              ),
              onChanged: (_) => _reload(),
            ),
          ),
          TextField(
            controller: _nomeCtrl,
            decoration: InputDecoration(
                labelText: 'Nome da disciplina', border: OutlineInputBorder()),
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 12),
          TextField(
            controller: _nota1Ctrl,
            decoration: InputDecoration(
              labelText: 'Nota 1',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 12),
          TextField(
            controller: _nota2Ctrl,
            decoration: InputDecoration(
              labelText: 'Nota 2',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 12),
          TextField(
            controller: _nota3Ctrl,
            decoration: InputDecoration(
              labelText: 'Nota 3',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: FilledButton.icon(
                      onPressed: _save,
                      icon: Icon(isEditing ? Icons.save : Icons.add),
                      label:
                          Text(isEditing ? 'Salvar alteraçoes' : 'Adicionar'))),
              if (isEditing) ...[
                SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: OutlinedButton.icon(
                        onPressed: _cancelEdit,
                        icon: Icon(Icons.close),
                        label: Text('Cancelar')))
              ]
            ],
          ),
          Divider(
            height: 8,
          ),
          Expanded(
  child: FutureBuilder<List<Disciplina>>(
    future: _futureDisciplinas,
    builder: (context, snapshot) {
      // ...existing code...
      final disciplinas = snapshot.data ?? [];
      if (disciplinas.isEmpty) {
        return Center(child: Text('Nenhuma disciplina encontrada'));
      }
      return ListView.builder(
        itemCount: disciplinas.length,
        itemBuilder: (context, index) {
          final disciplina = disciplinas[index];
          return ListTile(
            title: Text(disciplina.nome),
            subtitle: Text('Média: ${disciplina.media.toStringAsFixed(2)}'),
            leading: CircleAvatar(
              child: Text((disciplina.id ?? 0).toString()),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Editar',
                  icon: Icon(Icons.edit),
                  onPressed: () => _edit(disciplina),
                ),
                IconButton(
                  tooltip: 'Excluir',
                  onPressed: () => _delete(disciplina.id!),
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          );
        },
      );
    },
  ),
),
        ],
      ),
    ); 
  }
}
