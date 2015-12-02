@HtmlImport('view_people.html')
library bwu_polymer_routing_examples.example_03.components.view_people;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

@PolymerRegister('view-people')
class ViewPeople extends PolymerElement {
  ViewPeople.created() : super.created();

  @override
  void attached() {
    super.attached();
  }
}
