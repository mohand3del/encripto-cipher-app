class PlayfairCipher {
  late String _keySquare;
  late List<List<String>> _matrix;

  PlayfairCipher(String key) {
    _keySquare = _generateKeySquare(key);
    _matrix = _createMatrix(_keySquare);
  }

  String _generateKeySquare(String key) {
    key = key.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '').replaceAll('J', 'I');
    var seen = <String>{};
    var keySquare = key + 'ABCDEFGHIKLMNOPQRSTUVWXYZ'; // 'J' is omitted
    return keySquare.split('').where((letter) => seen.add(letter)).join();
  }

  List<List<String>> _createMatrix(String keySquare) {
    List<List<String>> matrix = [];
    for (int i = 0; i < 5; i++) {
      matrix.add(keySquare.substring(i * 5, i * 5 + 5).split(''));
    }
    return matrix;
  }

  String encrypt(String plaintext) {
    plaintext = _prepareText(plaintext);
    return _processText(plaintext, true);
  }

  String decrypt(String ciphertext) {
    return _processText(ciphertext, false);
  }

  String _prepareText(String text) {
    text = text.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '').replaceAll('J', 'I');
    List<String> pairs = [];
    for (int i = 0; i < text.length; i += 2) {
      String first = text[i];
      String second = (i + 1 < text.length && text[i + 1] != first) ? text[i + 1] : 'X';
      pairs.add(first + second);
    }
    print("Prepared pairs: $pairs"); // Debugging line
    return pairs.join();
  }

  String _processText(String text, bool encrypt) {
    List<String> result = [];
    for (int i = 0; i < text.length; i += 2) {
      var firstPos = _findPosition(text[i]);
      var secondPos = _findPosition(text[i + 1]);

      print("Positions: $firstPos, $secondPos"); // Debugging line

      if (firstPos[0] == secondPos[0]) {
        // Same row
        result.add(_matrix[firstPos[0]][(firstPos[1] + (encrypt ? 1 : 4)) % 5]);
        result.add(_matrix[secondPos[0]][(secondPos[1] + (encrypt ? 1 : 4)) % 5]);
      } else if (firstPos[1] == secondPos[1]) {
        // Same column
        result.add(_matrix[(firstPos[0] + (encrypt ? 1 : 4)) % 5][firstPos[1]]);
        result.add(_matrix[(secondPos[0] + (encrypt ? 1 : 4)) % 5][secondPos[1]]);
      } else {
        // Rectangle swap
        result.add(_matrix[firstPos[0]][secondPos[1]]);
        result.add(_matrix[secondPos[0]][firstPos[1]]);
      }
    }
    print("Resulting text: ${result.join()}"); // Debugging line
    return result.join();
  }

  List<int> _findPosition(String char) {
    for (int row = 0; row < 5; row++) {
      for (int col = 0; col < 5; col++) {
        if (_matrix[row][col] == char) return [row, col];
      }
    }
    return [-1, -1]; // Character not found
  }
}
