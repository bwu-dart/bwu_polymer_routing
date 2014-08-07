/*if( playground == 'core_elements' ) <!-- copyright notice core-elements -->*/

library playground.user_element;

import 'dart:html' as dom;
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
