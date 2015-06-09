library bwu_polymer_routing_examples.shared.user_element;

import 'package:polymer/polymer.dart';
import 'package:bwu_polymer_routing/di.dart' as di;

@CustomTag('user-element')
class UserElement extends PolymerElement with di.DiConsumer {
  UserElement.created() : super.created();

  @published String userId;
}
