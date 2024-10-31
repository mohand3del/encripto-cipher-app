// hill_cipher.dart
import 'dart:math';

class HillCipher {
  // Hill Cipher encryption method
  String encrypt(String plaintext, String key) {
    List<List<int>> keyMatrix = _createKeyMatrix(key);
    String paddedText = _padPlaintext(plaintext);
    String encryptedText = '';

    for (int i = 0; i < paddedText.length; i += 2) {
      int a = paddedText.codeUnitAt(i) - 'A'.codeUnitAt(0);
      int b = paddedText.codeUnitAt(i + 1) - 'A'.codeUnitAt(0);

      int encryptedA = (keyMatrix[0][0] * a + keyMatrix[0][1] * b) % 26;
      int encryptedB = (keyMatrix[1][0] * a + keyMatrix[1][1] * b) % 26;

      encryptedText += String.fromCharCode(encryptedA + 'A'.codeUnitAt(0));
      encryptedText += String.fromCharCode(encryptedB + 'A'.codeUnitAt(0));
    }

    return encryptedText;
  }


  String decrypt(String ciphertext, String key) {
    List<List<int>> keyMatrix = _createKeyMatrix(key);
    List<List<int>> inverseMatrix = _invertMatrix(keyMatrix);
    String decryptedText = '';

    for (int i = 0; i < ciphertext.length; i += 2) {
      int a = ciphertext.codeUnitAt(i) - 'A'.codeUnitAt(0);
      int b = ciphertext.codeUnitAt(i + 1) - 'A'.codeUnitAt(0);

      int decryptedA = (inverseMatrix[0][0] * a + inverseMatrix[0][1] * b) % 26;
      int decryptedB = (inverseMatrix[1][0] * a + inverseMatrix[1][1] * b) % 26;

      decryptedText += String.fromCharCode(decryptedA + 'A'.codeUnitAt(0));
      decryptedText += String.fromCharCode(decryptedB + 'A'.codeUnitAt(0));
    }

    return decryptedText;
  }

  // Create a 2x2 key matrix from the key string
  List<List<int>> _createKeyMatrix(String key) {
    return [
      [
        key.codeUnitAt(0) - 'A'.codeUnitAt(0),
        key.codeUnitAt(1) - 'A'.codeUnitAt(0)
      ],
      [
        key.codeUnitAt(2) - 'A'.codeUnitAt(0),
        key.codeUnitAt(3) - 'A'.codeUnitAt(0)
      ],
    ];
  }

  // Invert the 2x2 key matrix (if possible)
  List<List<int>> _invertMatrix(List<List<int>> matrix) {
    int det = (matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]) % 26;
    det = _modInverse(det, 26);
    return [
      [(matrix[1][1] * det) % 26, (-matrix[0][1] * det) % 26],
      [(-matrix[1][0] * det) % 26, (matrix[0][0] * det) % 26],
    ];
  }

  // Function to compute modular inverse
  int _modInverse(int a, int m) {
    a = a % m;
    for (int x = 1; x < m; x++) {
      if ((a * x) % m == 1) {
        return x;
      }
    }
    throw Exception("No modular inverse found");
  }

  // Pad the plaintext to ensure it has an even length
  String _padPlaintext(String text) {
    String padded = text.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
    if (padded.length % 2 != 0) {
      padded += 'X'; // Padding character
    }
    return padded;
  }
}
