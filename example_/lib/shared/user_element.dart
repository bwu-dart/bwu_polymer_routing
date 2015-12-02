@HtmlImport('user_element.html')
library bwu_polymer_routing_examples.shared.user_element;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

import 'package:bwu_polymer_routing/di.dart' as di;
import 'package:bwu_polymer_routing/bind_view.dart';

/// Silence analyzer [BindView]
@PolymerRegister('user-element')
class UserElement extends PolymerElement with di.DiConsumer {
  UserElement.created() : super.created();

  @property
  String userId;
}
