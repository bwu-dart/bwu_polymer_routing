library bwu_polymer_routing.bind_route;

import 'package:polymer/polymer.dart';

@CustomTag('bind-route')
class BindRoute extends PolymerElement {
  BindRoute.created() : super.created();

  @override
  void attached() {
    super.attached();
    var error = '<bind-route> is not yet implemented.';
    print(error);
    throw error;
  }
}
