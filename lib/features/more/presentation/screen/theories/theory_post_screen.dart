import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    print('pdfUrl: $pdfUrl');
    print('fileName: $fileName');

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
                    _permissionReady = await _checkPermission();

                    if (_permissionReady) {
                      await _prepareSaveDir();
                      print("Downloading");
                      try {
                        await Dio().download(pdfUrl, "$_localPath/$fileName");
                        print("Download Completed.");
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Файл $fileName успешно сохранен'),
                            ),
                          );
                        }
                      } catch (e) {
                        print("Невозможно скачать файл.\n\n$e");
                      }
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

  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;

    print(_localPath);
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    if (platform == TargetPlatform.android) {
      return "/sdcard/download/";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return '${directory.path}${Platform.pathSeparator}Download';
    }
  }
}
