@HtmlImport('view_movies.html')
library bwu_polymer_routing_examples.example_03.components.view_movies;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

@PolymerRegister('view-movies')
class ViewMovies extends PolymerElement {
  ViewMovies.created() : super.created();

  @override
  void attached() {
    super.attached();
  }
}
