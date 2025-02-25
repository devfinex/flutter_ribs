import 'package:flutter/material.dart';
import 'view_controllable.dart';

/// The controller used for launching [ViewControllable]
class WindowController {
  static final navigator = GlobalKey<NavigatorState>();

  /// Pushes this view to the top of the [Navigator] stack
  static present(ViewControllable viewControllable, {bool isInitialRoute = false}) async {
    navigator.currentState.push(MaterialPageRoute(
      builder: (context) => viewControllable,
      settings: RouteSettings(
          isInitialRoute: isInitialRoute,
          arguments: viewControllable
      ),
    ));
  }

  static dismiss(ViewControllable viewControllable) {
    Route previousRoute;

    navigator.currentState.popUntil((route) {
      final result = previousRoute?.settings?.arguments == viewControllable;
      previousRoute = route;
      return result;
    });
  }

  final _currentView = ValueNotifier<ViewControllable>(null);

  ValueNotifier<Widget> get currentView => _currentView;

  void launch(ViewControllable view) {
    _currentView.value = view;
  }
}

/// The root Window class for launching [ViewControllable]
class Window extends StatelessWidget {
  Window(this.controller);

  final WindowController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller.currentView,
      builder: (context, value, child) {
        return value ?? Container();
      },
    );
  }
}
