import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddRecipeScreen extends StatefulWidget {
  final bool isEditing;
  final Map<String, dynamic>? existingData;

  const AddRecipeScreen({
    super.key,
    this.isEditing = false,
    this.existingData,
  });

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final supabase = Supabase.instance.client;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.existingData != null) {
      _nameController.text = widget.existingData!['name'] ?? '';
      _descriptionController.text = widget.existingData!['description'] ?? '';
      _ingredientsController.text = widget.existingData!['ingredients'] ?? '';
    }
  }

  Future<void> _submitRecipe() async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final ingredients = _ingredientsController.text.trim();

    if (name.isEmpty || ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan bahan wajib diisi')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw 'User tidak ditemukan';

      if (widget.isEditing && widget.existingData != null) {
        // UPDATE RECIPE
        await supabase.from('recipes').update({
          'name': name,
          'description': description,
          'ingredients': ingredients,
        }).eq('id', widget.existingData!['id']);
      } else {
        // ADD NEW RECIPE
        await supabase.from('recipes').insert({
          'user_id': user.id,
          'name': name,
          'description': description,
          'ingredients': ingredients,
        });
      }

      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan resep: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Resep' : 'Tambah Resep'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama Resep'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
            ),
            TextField(
              controller: _ingredientsController,
              decoration: const InputDecoration(
                labelText: 'Bahan-bahan (pisahkan dengan koma)',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitRecipe,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(widget.isEditing ? 'Update' : 'Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
