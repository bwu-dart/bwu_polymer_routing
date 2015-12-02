@HtmlImport('app_element.html')
library bwu_polymer_routing_examples.example_03.components.app_element;

import 'dart:html' as dom;
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

import 'package:di/di.dart' show Module, ModuleInjector;
import 'package:bwu_polymer_routing/module.dart' show RoutingModule;
import 'package:bwu_polymer_routing/static_keys.dart';
import '../route_initializer.dart';
import 'package:bwu_polymer_routing/bind_view.dart';

import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/iron_icon.dart';
import 'package:polymer_elements/iron_icons.dart';
import 'package:polymer_elements/av_icons.dart';
import 'package:polymer_elements/paper_menu.dart';
import 'package:polymer_elements/paper_drawer_panel.dart';
import 'package:polymer_elements/paper_header_panel.dart';
import 'package:polymer_elements/paper_toolbar.dart';

import 'view_movie.dart';
import 'view_movies.dart';
import 'view_overview.dart';
import 'view_people.dart';
import 'view_person.dart';

/// Silence analyzer [BindView] [ViewMovie], [ViewMovies], [ViewOverview],
/// [ViewPeople], [ViewPerson], [PaperDrawerPanel], [PaperHeaderPanel],
/// [IronIcon], [PaperToolbar], [PaperMenu], [PaperItem]
class AppModule extends Module {
  AppModule() : super() {
    install(new RoutingModule(usePushState: false));
    bindByKey(routeInitializerFnKey, toValue: new RouteInitializer());
  }
}

@PolymerRegister('app-element')
class AppElement extends PolymerElement with DiContext, DiConsumer {
  AppElement.created() : super.created();

  @override
  void attached() {
    super.attached();

    initDiContext(this, new ModuleInjector(<Module>[new AppModule()]));
  }

  @reflectable
  void overviewSelectHandler([_, __]) {
    ($['main-menu'] as PaperMenu).selected = 0;
  }

  @reflectable
  void menuSelectHandler(dom.CustomEvent e, [_]) {
    PaperItem item =
        (new PolymerEvent(e).localTarget as PaperMenu).selectedItem;
    if (item != null) {
      set('selectedMenuLabel', item.attributes['label']);
      goPathFromAttributes(item);
    }
  }

  @property
  String selectedMenuLabel = "Home";
}
