import 'package:flutter/material.dart';

void addFirstFrameCallback(Future<void> Function() callback) {
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await callback();
  });
}
