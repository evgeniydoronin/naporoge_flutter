import 'package:flutter/material.dart';

Future todoBottomSheet(context, Map? item, Map? parent) async {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
    builder: (context) {
      TextEditingController textEditingController = item != null
          ? TextEditingController(text: item['title'])
          : TextEditingController();
      textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));

      return Wrap(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      autofocus: true,
                      maxLines: null,
                      maxLength: 51,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        // create new subTodo by parent id
                        // or
                        // update subTodo
                        print('parentID ${parent?['id']}');
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.send))
                ],
              ),
            ),
          )
        ],
      );
    },
  );
}
