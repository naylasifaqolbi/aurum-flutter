import 'dart:async';

class SplashViewModel {
  Future<void> startSplash({required Function() onFinished}) async {
    await Future.delayed(const Duration(seconds: 3));

    onFinished();
  }
}
