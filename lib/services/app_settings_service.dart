import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsService {
  static const _temperatureKey = 'temperature';
  static const _maxTokensKey = 'max_tokens';
  static const _reasoningEffortKey = 'reasoning_effort';
  static const _systemPromptKey = 'system_prompt';

  Future<double> getTemperature() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_temperatureKey) ?? 1.0;
  }

  Future<void> setTemperature(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_temperatureKey, value);
  }

  Future<int> getMaxTokens() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_maxTokensKey) ?? 4096;
  }

  Future<void> setMaxTokens(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_maxTokensKey, value);
  }

  Future<String> getReasoningEffort() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_reasoningEffortKey) ?? 'high';
  }

  Future<void> setReasoningEffort(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_reasoningEffortKey, value);
  }

  Future<String> getSystemPrompt() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_systemPromptKey) ?? '';
  }

  Future<void> setSystemPrompt(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_systemPromptKey, value);
  }
}
