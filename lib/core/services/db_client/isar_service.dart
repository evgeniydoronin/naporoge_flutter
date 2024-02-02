import 'package:isar/isar.dart';
import 'package:naporoge/features/todo/domain/entities/todo_entity.dart';
import '../../../features/diary/domain/entities/diary_note_entity.dart';
import '../../../features/planning/domain/entities/stream_entity.dart';
import 'package:path_provider/path_provider.dart';

import '../../../features/auth/login/domain/user_model.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();

    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([
        UserSchema,
        NPStreamSchema,
        WeekSchema,
        DaySchema,
        DayResultSchema,
        DiaryNoteSchema,
        TwoTargetSchema,
        TodoEntitySchema
      ], directory: dir.path);
    }

    return Future.value(Isar.getInstance());
  }

  Future<void> saveUser(int userID) async {
    final isar = await db;
    final newUser = User()
      ..id = userID
      ..isLoggedIn = true;

    isar.writeTxnSync(() => isar.users.putSync(newUser));
  }

  Future<List<User>> getUser() async {
    final isar = await db;
    var user = await isar.users.where().findAll();
    return user; // get
  }

  Future<NPStream?> getCurrentStream() async {
    final isar = await db;
    final npStream = await isar.nPStreams.filter().isActiveEqualTo(true).findFirst();
    return npStream;
  }
}
