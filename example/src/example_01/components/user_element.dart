library bwu_polymer_router.example_01.user_element;

import 'package:polymer/polymer.dart';
import 'package:bwu_polymer_routing/di.dart' as di;

@CustomTag('user-element')
class UserElement extends PolymerElement with di.DiConsumer {
  UserElement.created() : super.created();

  @published String userId;
}
