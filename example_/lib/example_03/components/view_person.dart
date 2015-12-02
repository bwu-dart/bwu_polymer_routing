@HtmlImport('view_person.html')
library bwu_polymer_routing_examples.example_03.components.view_person;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

@PolymerRegister('view-person')
class ViewPerson extends PolymerElement {
  ViewPerson.created() : super.created();

  @override
  void attached() {
    super.attached();
  }
}
