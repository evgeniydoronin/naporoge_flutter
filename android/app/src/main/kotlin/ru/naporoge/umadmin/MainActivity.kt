package ru.naporoge.umadmin

import android.os.Environment
import android.provider.MediaStore
import android.content.ContentValues
import android.os.Build
import androidx.annotation.RequiresApi
import java.io.FileInputStream
import java.io.File
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {
    private val cHANNEL = "ru.naporoge.umadmin/save"

    @RequiresApi(Build.VERSION_CODES.Q)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, cHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "saveFileToDownloads") {
                val filePath = call.argument<String>("filePath")!!
                val fileName = call.argument<String>("fileName")!!
                saveFileToDownloads(filePath, fileName)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    private fun saveFileToDownloads(filePath: String, fileName: String) {
        val values = ContentValues().apply {
            put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
            put(MediaStore.MediaColumns.MIME_TYPE, "application/pdf")
            put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
        }

        val uri = contentResolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values)
        uri?.let { downloadUri ->
            contentResolver.openOutputStream(downloadUri).use { outputStream ->
                FileInputStream(File(filePath)).use { fileInputStream ->
                    outputStream?.let {
                        fileInputStream.copyTo(it)
                    }
                }
            }
        }
    }
}
