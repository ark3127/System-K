import 'package:flutter/material.dart';
import '../services/secure_storage_service.dart';
import '../services/app_settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _storageService = SecureStorageService();
  final _settingsService = AppSettingsService();

  final _apiKeyController = TextEditingController();
  final _systemPromptController = TextEditingController();

  bool _isKeyHidden = true;
  bool _isLoading = true;
  bool _hasSavedKey = false;

  double _temperature = 1.0;
  int _maxTokens = 4096;
  String _reasoningEffort = 'high';

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    final savedKey = await _storageService.getApiKey();
    final temperature = await _settingsService.getTemperature();
    final maxTokens = await _settingsService.getMaxTokens();
    final reasoningEffort = await _settingsService.getReasoningEffort();
    final systemPrompt = await _settingsService.getSystemPrompt();

    setState(() {
      if (savedKey != null) {
        _apiKeyController.text = savedKey;
        _hasSavedKey = true;
      }
      _temperature = temperature;
      _maxTokens = maxTokens;
      _reasoningEffort = reasoningEffort;
      _systemPromptController.text = systemPrompt;
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

  Future<void> _saveSystemPrompt() async {
    await _settingsService.setSystemPrompt(_systemPromptController.text.trim());

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('System prompt saved')),
      );
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _systemPromptController.dispose();
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
          : ListView(
              padding: const EdgeInsets.all(16),
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
                const SizedBox(height: 12),
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

                const Divider(height: 40),

                const Text(
                  'Generation Settings',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),

                Text('Temperature: ${_temperature.toStringAsFixed(2)}'),
                Slider(
                  value: _temperature,
                  min: 0.0,
                  max: 2.0,
                  divisions: 20,
                  label: _temperature.toStringAsFixed(2),
                  onChanged: (value) {
                    setState(() => _temperature = value);
                  },
                  onChangeEnd: (value) async {
                    await _settingsService.setTemperature(value);
                  },
                ),

                const SizedBox(height: 12),
                Text('Max output tokens: $_maxTokens'),
                Slider(
                  value: _maxTokens.toDouble(),
                  min: 512,
                  max: 32768,
                  divisions: 63,
                  label: '$_maxTokens',
                  onChanged: (value) {
                    setState(() => _maxTokens = value.round());
                  },
                  onChangeEnd: (value) async {
                    await _settingsService.setMaxTokens(value.round());
                  },
                ),

                const SizedBox(height: 12),
                const Text('Reasoning effort'),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: _reasoningEffort,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 'low', child: Text('Low')),
                    DropdownMenuItem(value: 'high', child: Text('High')),
                    DropdownMenuItem(value: 'max', child: Text('Max')),
                  ],
                  onChanged: (value) async {
                    if (value == null) return;
                    setState(() => _reasoningEffort = value);
                    await _settingsService.setReasoningEffort(value);
                  },
                ),

                const Divider(height: 40),

                const Text(
                  'System Prompt',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _systemPromptController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'e.g. You are a helpful assistant...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _saveSystemPrompt,
                  child: const Text('Save system prompt'),
                ),
              ],
            ),
    );
  }
}
