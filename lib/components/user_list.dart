/*if( playground == 'core_elements' ) <!-- copyright notice core-elements -->*/

library playground.user_list;

import 'dart:html' as dom;
import 'package:polymer/polymer.dart';

@CustomTag('user-list')
class UserList extends PolymerElement {
  UserList.created() : super.created();

  var users = ['Jan', 'Peter', 'Julia', 'Martin'];

  @override
  void attached() {
    super.attached();
  }
}
