import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'custom_form_test_field.dart'; // Ensure you have this file
import 'playfair_cipher.dart'; // Assuming you have a PlayfairCipher class
import 'hill_cipher.dart'; // Assuming this is your HillCipher class

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _outputController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();

  PlayfairCipher? _playfairCipher;
  HillCipher? _hillCipher;
  bool _isEncryptMode = true; // Toggle state for encryption/decryption mode
  String _selectedCipher = "Playfair"; // Default cipher

  // Available ciphers
  final List<String> _cipherOptions = ["Playfair", "Hill"];

  void _processMessage() {
  String message = _inputController.text.toUpperCase();

  String result = '';
  try {
    if (_selectedCipher == "Playfair") {
      String key = _keyController.text.toUpperCase();
      if (key.isEmpty) {
        _showSnackBar('Please enter a key for Playfair cipher!');
        return;
      }

      _playfairCipher = PlayfairCipher(key);
      result = _isEncryptMode
          ? _playfairCipher!.encrypt(message)
          : _playfairCipher!.decrypt(message);
    } else if (_selectedCipher == "Hill") {
      String key = _keyController.text.toUpperCase();
      if (key.length != 4) {
        _showSnackBar('Please enter a valid 4-character key for Hill cipher!');
        return;
      }

      _hillCipher = HillCipher();
      result = _isEncryptMode
          ? _hillCipher!.encrypt(message, key)
          : _hillCipher!.decrypt(message, key);
    } else {
      result = "Unsupported cipher selected!";
    }
  } catch (e) {
    result = "Error: ${e.toString()}";
  }

  _outputController.text = result;
}
void _showSnackBar(String message, {Duration duration = const Duration(seconds: 2)}) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: duration,
    backgroundColor: Colors.black87, // You can customize the color
    action: SnackBarAction(
      label: 'Close',
      textColor: Colors.white,
      onPressed: () {
        // Some code to undo the change if needed
      },
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

  void _copyToClipboard() {
    String result = _outputController.text;
    if (result.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: result));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Copied to clipboard!'),
      ));
    }
  }

  void _toggleMode() {
    setState(() {
      _isEncryptMode = !_isEncryptMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff141414),
        title: const Center(
          child: Text(
            'Encrypto',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Manrope',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xff141414),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              DropdownButton<String>(
                value: _selectedCipher,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCipher = newValue!;
                  });
                },
                items: _cipherOptions
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                dropdownColor: const Color(0xff141414),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                maxLine: 5,
                controller: _inputController,
                hintText: "Enter Your Message",
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                hintText: "Enter Key",
                maxLine: 1,
                controller: _keyController,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 172,
                    height: 48,
                    child: MaterialButton(
                      color: const Color(0xff369EFF),
                      onPressed: _processMessage,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _isEncryptMode ? 'Encrypt' : 'Decrypt',
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Manrope',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 172,
                    height: 48,
                    child: MaterialButton(
                      onPressed: _toggleMode,
                      color: const Color(0xff26303B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _isEncryptMode
                            ? 'Switch to Decrypt'
                            : 'Switch to Encrypt',
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Manrope',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                hintText: "Result",
                maxLine: 8,
                controller: _outputController,
                isOutputField: true,
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                height: 42,
                child: MaterialButton(
                  color: const Color(0xff369EFF),
                  onPressed: _copyToClipboard,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Copy to Clipboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Manrope',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
