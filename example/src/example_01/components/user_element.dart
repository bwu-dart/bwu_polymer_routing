library bwu_polymer_router.example.user_element;

import 'package:polymer/polymer.dart';

@CustomTag('user-element')
class UserElement extends PolymerElement {
  UserElement.created() : super.created();

  @published String userId;

  @override
  void attached() {
    super.attached();
  }
}
