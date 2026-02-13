import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String _cloudName = 'dktir0vuo';
  static const String _apiKey = '252467799644227';
  static const String _apiSecret =
      'ItSajfpjY0QtqFZjyg8rbUtd9bg';

  static Future<String> uploadImage(
      String filePath) async {
    if (_cloudName == 'seu_cloud_name_aqui' ||
        _apiKey == 'sua_api_key_aqui' ||
        _apiSecret == 'seu_api_secret_aqui') {
      throw Exception(
          'Configure suas credenciais (_cloudName, _apiKey, _apiSecret) no arquivo cloudinary_service.dart');
    }

    final timestamp =
        (DateTime.now().millisecondsSinceEpoch /
                1000)
            .round();
    final signature =
        _generateSignature(timestamp);

    final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/$_cloudName/image/upload');
    final request = http.MultipartRequest(
        'POST', uri)
      ..fields['api_key'] = _apiKey
      ..fields['timestamp'] = timestamp.toString()
      ..fields['signature'] = signature
      ..files.add(
          await http.MultipartFile.fromPath(
              'file', filePath));

    print(
        '📤 Enviando imagem para Cloudinary (Signed)...');

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData =
          await response.stream.bytesToString();
      final decodedData =
          json.decode(responseData);
      final imageUrl = decodedData['secure_url'];
      print('✅ Upload concluído: $imageUrl');
      return imageUrl;
    } else {
      final errorBody =
          await response.stream.bytesToString();
      print(
          '❌ Erro no upload: ${response.statusCode}');
      print('❌ Corpo do erro: $errorBody');
      throw Exception(
          'Erro ao fazer upload da imagem: ${response.reasonPhrase}');
    }
  }

  static Future<void> deleteImage(
      String imageUrl) async {
    final publicId = _extractPublicId(imageUrl);
    if (publicId == null) {
      print(
          '⚠️ Não foi possível extrair o public_id da URL: $imageUrl');

      return;
    }

    final timestamp =
        (DateTime.now().millisecondsSinceEpoch /
                1000)
            .round();
    final paramsToSign =
        'public_id=$publicId&timestamp=$timestamp$_apiSecret';
    final bytes = utf8.encode(paramsToSign);
    final signature =
        sha1.convert(bytes).toString();

    final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/$_cloudName/image/destroy');

    print(
        '🗑️ Excluindo imagem do Cloudinary: $publicId');

    final response = await http.post(
      uri,
      body: {
        'public_id': publicId,
        'api_key': _apiKey,
        'timestamp': timestamp.toString(),
        'signature': signature,
      },
    );

    if (response.statusCode == 200) {
      final decodedData =
          json.decode(response.body);
      if (decodedData['result'] == 'ok') {
        print(
            '✅ Imagem excluída com sucesso: $publicId');
      } else {
        print(
            '⚠️ Resposta da API ao excluir: ${decodedData['result']}. A imagem pode já ter sido removida.');
      }
    } else {
      final errorBody = response.body;
      print(
          '❌ Erro ao excluir imagem: ${response.statusCode}');
      print('❌ Corpo do erro: $errorBody');
    }
  }

  static String _generateSignature(
      int timestamp) {
    final paramsToSign =
        'timestamp=$timestamp$_apiSecret';
    final bytes = utf8.encode(paramsToSign);
    final digest = sha1.convert(bytes);
    return digest.toString();
  }

  static String? _extractPublicId(
      String imageUrl) {
    final uri = Uri.parse(imageUrl);
    final parts = uri.pathSegments;
    final uploadIndex = parts.indexOf('upload');
    if (uploadIndex != -1 &&
        parts.length > uploadIndex + 2) {
      return parts
          .sublist(uploadIndex + 2)
          .join('/')
          .split('.')
          .first;
    }
    return null;
  }
}
