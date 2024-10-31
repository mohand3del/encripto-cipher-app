import 'package:flutter/material.dart';
import 'package:playfair_cipher_app/home_view.dart';

void main() {
  runApp(PlayfairCipherApp());
}

class PlayfairCipherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeView(),
      color: Colors.blueAccent,
      theme: ThemeData(primaryColor: Colors.blueAccent),
    );
  }
}

class PlayfairCipherHomePage extends StatefulWidget {
  @override
  _PlayfairCipherHomePageState createState() => _PlayfairCipherHomePageState();
}

class _PlayfairCipherHomePageState extends State<PlayfairCipherHomePage> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  String _result = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Encrypto',
              style: TextStyle(color: Colors.blueAccent))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Center(
              child: Text('Welcome to Encrypto!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  )),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _inputController,
              decoration: InputDecoration(
                labelText: 'Enter text',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 120, 117, 117)),
                  gapPadding: 8.0,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _keyController,
              decoration: InputDecoration(
                labelText: 'Enter key',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 120, 117, 117)),
                  gapPadding: 8.0,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: _encryptText,
                    child: const Text('Encrypt',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    )),
                ElevatedButton(
                    onPressed: _decryptText,
                    child: const Text('Decrypt',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    )),
              ],
            ),
            const SizedBox(height: 20),
            Text('Result: $_result'),
          ],
        ),
      ),
    );
  }

  void _encryptText() {
    String plainText = _inputController.text.toUpperCase();
    String key = _keyController.text.toUpperCase();
    setState(() {
      _result = encryptPlayfairCipher(plainText, key);
    });
  }

  void _decryptText() {
    String cipherText = _inputController.text.toUpperCase();
    String key = _keyController.text.toUpperCase();
    setState(() {
      _result = decryptPlayfairCipher(cipherText, key);
    });
  }

  // Helper Functions for Playfair Cipher

  String generateKeySquare(String key) {
    String alphabet = 'ABCDEFGHIKLMNOPQRSTUVWXYZ'; // J is often replaced by I
    List<String> keySquare = [];
    Set<String> usedLetters = {};

    // Add key letters to the key square
    for (int i = 0; i < key.length; i++) {
      String letter = key[i];
      if (!usedLetters.contains(letter) && letter != 'J') {
        keySquare.add(letter);
        usedLetters.add(letter);
      }
    }

    // Add remaining letters to the key square
    for (int i = 0; i < alphabet.length; i++) {
      String letter = alphabet[i];
      if (!usedLetters.contains(letter)) {
        keySquare.add(letter);
        usedLetters.add(letter);
      }
    }

    return keySquare.join('');
  }

  List<String> prepareText(String text) {
    text = text.replaceAll(RegExp(r'[^A-Z]'), ''); // Remove non-alphabet chars
    text = text.replaceAll('J', 'I'); // Replace J with I

    List<String> digraphs = [];
    for (int i = 0; i < text.length; i += 2) {
      String first = text[i];
      String second = (i + 1 < text.length) ? text[i + 1] : 'X';

      if (first == second) {
        second = 'X'; // Replace repeated letters in a digraph
        i--; // Move pointer back to account for replacement
      }

      digraphs.add(first + second);
    }

    return digraphs;
  }

  String encryptPlayfairCipher(String plainText, String key) {
    String keySquare = generateKeySquare(key);
    List<String> digraphs = prepareText(plainText);
    return _processDigraphs(digraphs, keySquare, isEncrypt: true);
  }

  String decryptPlayfairCipher(String cipherText, String key) {
    String keySquare = generateKeySquare(key);
    List<String> digraphs = prepareText(cipherText);
    return _processDigraphs(digraphs, keySquare, isEncrypt: false);
  }

  String _processDigraphs(List<String> digraphs, String keySquare,
      {bool isEncrypt = true}) {
    String alphabet = 'ABCDEFGHIKLMNOPQRSTUVWXYZ';
    int gridSize = 5;
    String result = '';

    for (String digraph in digraphs) {
      int firstPos = keySquare.indexOf(digraph[0]);
      int secondPos = keySquare.indexOf(digraph[1]);

      int firstRow = firstPos ~/ gridSize;
      int firstCol = firstPos % gridSize;
      int secondRow = secondPos ~/ gridSize;
      int secondCol = secondPos % gridSize;

      if (firstRow == secondRow) {
       
        result += keySquare[(firstRow * gridSize) +
            ((firstCol + (isEncrypt ? 1 : -1)) % gridSize)];
        result += keySquare[(secondRow * gridSize) +
            ((secondCol + (isEncrypt ? 1 : -1)) % gridSize)];
      } else if (firstCol == secondCol) {
       
        result += keySquare[
            (((firstRow + (isEncrypt ? 1 : -1)) % gridSize) * gridSize) +
                firstCol];
        result += keySquare[
            (((secondRow + (isEncrypt ? 1 : -1)) % gridSize) * gridSize) +
                secondCol];
      } else {
        // Rectangle swap: swap columns
        result += keySquare[firstRow * gridSize + secondCol];
        result += keySquare[secondRow * gridSize + firstCol];
      }
    }

    return result;
  }
}
