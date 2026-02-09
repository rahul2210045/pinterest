import 'package:flutter/material.dart';

class ProfileIconController {
  final ValueNotifier<bool> visible = ValueNotifier(true);

  void hide() => visible.value = false;
  void show() => visible.value = true;
}

final profileIconController = ProfileIconController();
