package com.erzone.employroll

import android.content.ContentValues
import android.media.MediaScannerConnection
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

class MainActivity : FlutterActivity() {
    private val mediaStoreChannel = "com.erzone.employroll/media_store"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, mediaStoreChannel)
            .setMethodCallHandler { call, result ->
                if (call.method != "save") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                val bytes = call.argument<ByteArray>("bytes")
                val fileName = call.argument<String>("fileName")
                val mimeType = call.argument<String>("mimeType") ?: "application/octet-stream"
                val collection = call.argument<String>("collection") ?: "DOWNLOADS"
                if (bytes == null || fileName.isNullOrBlank()) {
                    result.error("INVALID_DOCUMENT", "Document bytes and file name are required.", null)
                    return@setMethodCallHandler
                }
                try {
                    result.success(saveToMediaStore(bytes, fileName, mimeType, collection))
                } catch (error: Exception) {
                    result.error("DOCUMENT_SAVE_FAILED", error.message, null)
                }
            }
    }

    private fun saveToMediaStore(bytes: ByteArray, fileName: String, mimeType: String, collection: String): String {
        val pictures = collection.equals("PICTURES", ignoreCase = true)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val values = ContentValues().apply {
                put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
                put(MediaStore.MediaColumns.MIME_TYPE, mimeType)
                put(
                    MediaStore.MediaColumns.RELATIVE_PATH,
                    if (pictures) Environment.DIRECTORY_PICTURES + "/EmployRoll"
                    else Environment.DIRECTORY_DOWNLOADS + "/EmployRoll"
                )
                put(MediaStore.MediaColumns.IS_PENDING, 1)
            }
            val target = if (pictures) MediaStore.Images.Media.EXTERNAL_CONTENT_URI
            else MediaStore.Downloads.EXTERNAL_CONTENT_URI
            val uri = contentResolver.insert(target, values)
                ?: throw IllegalStateException("Unable to create the destination file.")
            try {
                contentResolver.openOutputStream(uri)?.use { it.write(bytes) }
                    ?: throw IllegalStateException("Unable to open the destination file.")
                values.clear()
                values.put(MediaStore.MediaColumns.IS_PENDING, 0)
                contentResolver.update(uri, values, null, null)
                return uri.toString()
            } catch (error: Exception) {
                contentResolver.delete(uri, null, null)
                throw error
            }
        }

        val parent = Environment.getExternalStoragePublicDirectory(
            if (pictures) Environment.DIRECTORY_PICTURES else Environment.DIRECTORY_DOWNLOADS
        )
        val directory = File(parent, "EmployRoll").apply { mkdirs() }
        val file = File(directory, fileName)
        FileOutputStream(file).use { it.write(bytes) }
        MediaScannerConnection.scanFile(this, arrayOf(file.absolutePath), arrayOf(mimeType), null)
        return file.absolutePath
    }
}
