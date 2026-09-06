import 'package:flutter/material.dart';
import '../services/secure_storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _storageService = SecureStorageService();
  final _apiKeyController = TextEditingController();

  bool _isKeyHidden = true;
  bool _isLoading = true;
  bool _hasSavedKey = false;

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    final savedKey = await _storageService.getApiKey();
    setState(() {
      if (savedKey != null) {
        _apiKeyController.text = savedKey;
        _hasSavedKey = true;
      }
      _isLoading = false;
    });
  }

  Future<void> _saveApiKey() async {
    final key = _apiKeyController.text.trim();
    if (key.isEmpty) return;

    await _storageService.saveApiKey(key);
    setState(() => _hasSavedKey = true);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('API key saved')),
      );
    }
  }

  Future<void> _deleteApiKey() async {
    await _storageService.deleteApiKey();
    _apiKeyController.clear();
    setState(() => _hasSavedKey = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('API key deleted')),
      );
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'NVIDIA API Key',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _apiKeyController,
                    obscureText: _isKeyHidden,
                    decoration: InputDecoration(
                      hintText: 'nvapi-...',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isKeyHidden ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() => _isKeyHidden = !_isKeyHidden);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _saveApiKey,
                        child: const Text('Save'),
                      ),
                      const SizedBox(width: 12),
                      if (_hasSavedKey)
                        TextButton(
                          onPressed: _deleteApiKey,
                          child: const Text('Delete'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
