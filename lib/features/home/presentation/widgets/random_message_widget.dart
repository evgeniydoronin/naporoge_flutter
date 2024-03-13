import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_theme.dart';

class RandomMessageWidget extends StatefulWidget {
  const RandomMessageWidget({super.key});

  @override
  State<RandomMessageWidget> createState() => _RandomMessageWidgetState();
}

class _RandomMessageWidgetState extends State<RandomMessageWidget> {
  // Список строк текста
  final List<RichText> _items = [
    RichText(
      text: const TextSpan(
        text: 'Пропущенное дело',
        style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w800),
        children: [
          TextSpan(
            text: ' можно выполнить в выходной день',
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    ),
    RichText(
      text: const TextSpan(
        text: 'Вносить',
        style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400),
        children: [
          TextSpan(
            text: ' результаты',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          TextSpan(
            text: ' можно только в текущий день',
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    ),
    RichText(
      text: const TextSpan(
        text: 'Планируйте',
        style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w800),
        children: [
          TextSpan(
            text: ' следующую неделю до ее наступления, иначе она заблокируется',
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    ),
    RichText(
      text: const TextSpan(
        text: 'Отмечайте',
        style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400),
        children: [
          TextSpan(
            text: ' появление мыслей',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          TextSpan(
            text: ' отложить дело и забросить курс',
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    ),
    RichText(
      text: const TextSpan(
        text: 'В конце курса',
        style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400),
        children: [
          TextSpan(
            text: ' появятся итоги,',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          TextSpan(
            text: ' поделитесь ими с другими!',
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    ),
    RichText(
      text: const TextSpan(
        text: 'Отмечайте',
        style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400),
        children: [
          TextSpan(
            text: ' результаты',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          TextSpan(
            text: ' как можно точнее',
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    ),
    RichText(
      text: const TextSpan(
        text: 'Трудно – значит',
        style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400),
        children: [
          TextSpan(
            text: ' воля',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          TextSpan(
            text: ' станет крепче!',
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    ),
    RichText(
      text: const TextSpan(
        text: 'Все',
        style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400),
        children: [
          TextSpan(
            text: ' важное',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          TextSpan(
            text: ' – в дневник! Если не фиксировать факты, многие из них забываются',
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    ),
  ];

  late RichText _selectedText;

  @override
  void initState() {
    super.initState();
    _selectedText = _items[Random().nextInt(_items.length)]; // Выбор случайного текста
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppLayout.contentPadding),
      child: Container(
        padding: const EdgeInsets.only(top: 15, bottom: 25, left: 18, right: 45),
        decoration: BoxDecoration(
            color: AppColor.lightBGItem,
            border: AppLayout.primaryBorder,
            borderRadius: AppLayout.primaryRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                spreadRadius: 0,
              )
            ],
            image: const DecorationImage(alignment: Alignment.bottomRight, image: AssetImage('assets/images/4.png'))),
        child: _selectedText,
      ),
    );
  }
}
