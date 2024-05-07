import 'dart:io';
import 'package:flutter/services.dart';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../core/constants/endpoints.dart';

import '../../../../../core/constants/app_theme.dart';

@RoutePage()
class TheoryPostScreen extends StatefulWidget {
  const TheoryPostScreen({super.key, required this.data, @PathParam('postId') required this.postId});

  final int postId;
  final Map data;

  @override
  State<TheoryPostScreen> createState() => _TheoryPostScreenState();
}

class _TheoryPostScreenState extends State<TheoryPostScreen> {
  late String _localPath;
  late bool _permissionReady;
  late TargetPlatform? platform;

  @override
  void initState() {
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(platform);
    String pdfUrl = '';
    List<String> pdfUrlArray = [];
    String fileName = '';
    if (widget.data['pdf_path'] != null) {
      pdfUrl = '${Endpoints.fileUrl}/${widget.data['pdf_path']}';
      pdfUrlArray = pdfUrl.split("/");
      fileName = pdfUrlArray.last;
    }
    // print('pdfUrl: $pdfUrl');
    // print('fileName: $fileName');

    return Scaffold(
      backgroundColor: AppColor.lightBG,
      appBar: AppBar(
        backgroundColor: AppColor.lightBG,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            context.router.pop();
          },
          icon: RotatedBox(quarterTurns: 2, child: SvgPicture.asset('assets/icons/arrow.svg')),
        ),
        actions: [
          pdfUrl.isNotEmpty
              ? IconButton(
                  icon: SvgPicture.asset('assets/icons/download_pdf.svg'),
                  onPressed: () async {
                    print("Downloading");

                    String pathFile = await downloadFile(pdfUrl, fileName);

                    if (Platform.isAndroid) {
                      // platform = TargetPlatform.android;
                      final mediaStorePlugin = MediaStore();

                      List<Permission> permissions = [
                        Permission.storage,
                      ];

                      if ((await mediaStorePlugin.getPlatformSDKInt()) >= 33) {
                        permissions.add(Permission.photos);
                        permissions.add(Permission.audio);
                        permissions.add(Permission.videos);
                      }

                      await permissions.request();

                      print('permissions: $permissions');

                      NativeMethods.saveFileToDownloads(pathFile, fileName);
                    } else {
                      await downloadAndSavePdf(pdfUrl);
                    }

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Файл $fileName успешно сохранен'),
                        ),
                      );
                    }
                  },
                )
              : const SizedBox(),
        ],
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: 'Теория к курсу и',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColor.blk),
              children: const [
                TextSpan(
                  text: '\nформы документов',
                ),
              ]),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.data['title'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Html(
                    data: widget.data['content'],
                    style: {
                      'p': Style(fontSize: FontSize(16), textAlign: TextAlign.justify),
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 35),
        ],
      ),
    );
  }

  Future<String> downloadFile(String url, String fileName) async {
    Dio dio = Dio();
    var dir = await getTemporaryDirectory(); // Используйте временную директорию
    String filePath = '${dir.path}/$fileName';
    await dio.download(url, filePath);
    return filePath; // Возвращает путь к скачанному файлу
  }

  Future<void> downloadAndSavePdf(String url) async {
    final dio = Dio();
    final fileName = url.split('/').last;

    try {
      final response = await dio.get(url, options: Options(responseType: ResponseType.bytes));
      final bytes = response.data;

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      final result = await saveFileToPublicDirectoryIOS(file);
      print('File downloaded and saved to: $result');
    } catch (e) {
      print('Error downloading file: $e');
    }
  }

  Future<String?> saveFileToPublicDirectoryIOS(File file) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final newFile = await file.copy('${directory.path}/${file.path.split('/').last}');
      return newFile.path;
    } catch (e) {
      print('Error saving file to public directory on iOS: $e');
      return null;
    }
  }
}

class NativeMethods {
  // Соответствует имени канала на стороне Kotlin
  static const MethodChannel _channel = MethodChannel('ru.naporoge.umadmin/save');

  // Метод для вызова saveFileToDownloads из Dart
  static Future<void> saveFileToDownloads(String filePath, String fileName) async {
    try {
      final Map<String, dynamic> arguments = {
        'filePath': filePath,
        'fileName': fileName,
      };
      await _channel.invokeMethod('saveFileToDownloads', arguments);
    } on PlatformException catch (e) {
      print("Ошибка при вызове нативного кода: '${e.message}'.");
    }
  }
}
