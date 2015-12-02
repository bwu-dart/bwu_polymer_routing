@HtmlImport('view_movie.html')
library bwu_polymer_routing_examples.example_03.components.view_movie;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

@PolymerRegister('view-movie')
class ViewMovie extends PolymerElement {
  ViewMovie.created() : super.created();

  @override
  void attached() {
    super.attached();
  }
}
