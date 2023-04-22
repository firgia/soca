// Copyright 2020 Rene Floor. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.
// https://github.com/Baseflow/flutter_cached_network_image/blob/develop/cached_network_image/test/fake_cache_manager.dart

import 'dart:typed_data';
import 'package:file/memory.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:async';
import 'package:mocktail/mocktail.dart';

const List<int> kTransparentImage = <int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
];

class FakeDefaultCacheManager extends Mock implements DefaultCacheManager {
  ExpectedData returns(
    String url,
    List<int> imageData, {
    Duration? delayBetweenChunks,
  }) {
    const chunkSize = 8;
    final chunks = <Uint8List>[
      for (int offset = 0; offset < imageData.length; offset += chunkSize)
        Uint8List.fromList(imageData.skip(offset).take(chunkSize).toList()),
    ];

    when(() => getImageFile(
          url,
          key: any(named: 'key'),
          headers: any(named: 'headers'),
          withProgress: any(named: 'withProgress'),
          maxHeight: any(named: 'maxHeight'),
          maxWidth: any(named: 'maxWidth'),
        )).thenAnswer((_) => _createResultStream(
          url,
          chunks,
          imageData,
          delayBetweenChunks,
        ));

    return ExpectedData(
      chunks: chunks.length,
      totalSize: imageData.length,
      chunkSize: chunkSize,
    );
  }

  Stream<FileResponse> _createResultStream(
    String url,
    List<Uint8List> chunks,
    List<int> imageData,
    Duration? delayBetweenChunks,
  ) async* {
    var totalSize = imageData.length;
    var downloaded = 0;
    for (var chunk in chunks) {
      downloaded += chunk.length;
      if (delayBetweenChunks != null) {
        await Future.delayed(delayBetweenChunks);
      }
      yield DownloadProgress(url, totalSize, downloaded);
    }
    var file = MemoryFileSystem().systemTempDirectory.childFile('test.jpg');
    await file.writeAsBytes(imageData);
    yield FileInfo(file, FileSource.Online,
        DateTime.now().add(const Duration(days: 1)), url);
  }
}

class ExpectedData {
  final int chunks;
  final int totalSize;
  final int chunkSize;

  const ExpectedData({
    required this.chunks,
    required this.totalSize,
    required this.chunkSize,
  });
}
