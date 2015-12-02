@HtmlImport('bind_route.html')
library bwu_polymer_routing.bind_route;

import 'package:web_components/web_components.dart' show HtmlImport;
import 'package:polymer/polymer.dart';

@PolymerRegister('bind-route')
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
