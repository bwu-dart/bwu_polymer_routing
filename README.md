#BWU Polymer Routing

Some helper classes and components to use route_hierarchical with Polymer.dart.

I put [a simple example](http://bwu-dart.github.io/bwu_polymer_routing/example/index.html) online.


##Usage

###pubspec.yaml

Info: Currently the bwu_polymer_routing package can't be published to pub.dartlang.org because it needs a `dependency_overrides` for `code_transformers: '>=0.2.0 <0.3.0'`. This should be solved with `di 2.0.2` which will be published soon.

Add the following dependency to your `pubspec.yaml`.

```yaml
dependencies:
  polymer: '>=0.12.0+7 <0.13.0'
  bwu_polymer_routing: '>=0.0.1 <0.1.0'
  route_hierarchical: '>=0.4.21 <0.5.0'
  di: '>=2.0.1 <2.1.0' 
  
transformers:
- polymer:
    entry_points:
    - web/index.html # customize to your requirements
- di
```

###example/index.html

```html
<!DOCTYPE html>
<html>
  <head lang="en">
    <meta charset="UTF-8">
    <title></title>

    <!-- for Polymer -->
    <script src="packages/web_components/platform.js"></script>
    <script src="packages/web_components/dart_support.js"></script>

    <!-- we use <app-element></app-element> which contains the entire app -->
    <link rel='import' href='src/components/app_element.html'>

    <!-- even though we use an app-element, the di transformer requires a custom main method -->
    <!--<script type="application/dart">export 'package:polymer/init.dart';</script>-->
    <script type="application/dart" src="index.dart"></script>
    <script src="packages/browser/dart.js"></script>
  </head>
  <body>
    <app-element></app-element>
  </body>
</html>
```

The `di` transformer needs a `main()` method where it adds the initialization code for the generated static injector. Therefore we need a main method even though we use an `<app-element>` which encloses the entire application and the application initialization code.

###example/index.dart

```dart
library bwu_polymer_routing.example.main;

import 'package:polymer/polymer.dart';
import 'package:bwu_polymer_routing/module.dart' as brt;

void main() {
  // dummy to satisfy the di transformer
  brt.RouteCfg y;
  initPolymer().run(() {
of
  });
}
```

The index.dart file and its content are only used to satisfy the `di` transformer.  
When we have a custom `main()` we need to call `initPolymer()`. The call to `run()` is optional and only needed if some additional code should be run after Polymer was initialized.

###example/components/app_element.html

In your application package you should put the components somewhere in your `lib` directory. We have the `bwu_polymer_routing` library code in `lib` and therefore keep the example application code entirely in the `example` folder.

```html
<!DOCTYPE html>

<!-- each Polymer element should containt this import 
     the number of '../' depends on the directory where this file is stored in -->
<link rel='import' href='../../../../packages/polymer/polymer.html'>

<!-- each used Polymer element needs to be imported somewhere -->
<!-- bind-view --> is a placeholder where view elements are inserted -->
<link rel='import' href='../../../../packages/bwu_polymer_routing/bind_view.html'>

<!-- this elements are used as views -->
<link rel='import' href='user_list.html'>
<link rel='import' href='user_element.html'>
<link rel='import' href='article_list.html'>
<link rel='import' href='article_element.html'>

<polymer-element name='app-element'>
  <template>
    <style>
      :host {
        display: block;
      }
    </style>

    <!-- our app-element has no HTML content beside this view placeholder --> 
    <bind-view id='app-element'></bind-view>
  </template>
  <script type='application/dart' src='app_element.dart'></script>
</polymer-element>
```

###example/components/app_element.dart

```dart
// each Dart file should have an unique library name
library bwu_polymer_router.example.app_element;

import 'package:polymer/polymer.dart';
import 'package:di/di.dart' show Module, ModuleInjector;
import 'package:bwu_polymer_routing/module.dart'
    show RoutingModule;
import 'package:bwu_polymer_routing/static_keys.dart';
import 'route_initializer.dart';
import 'package:bwu_polymer_routing/di.dart';

// register types for DI 
class AppModule extends Module {
  AppModule() : super() {
    // at first install the RoutingModule 
    install(new RoutingModule(usePushState: false));
    // then add your custom bindings
    // the RoutInitializer class contains our custom router configuration
    bindByKey(ROUTE_INITIALIZER_FN_KEY, toValue: new RouteInitializer());
  }
}


// 'with DIContent' adds a mixin that enables this Polymer element to serve 
// di requests for its child elements 
@CustomTag('app-element')
class AppElement extends PolymerElement with DiContext {
  AppElement.created() : super.created();

  @override
  void attached() {

    super.attached();

    // init the DI container 
    // we pass the element for whose children it should serve di requests
    // and the di configuration (AppModule) 
    initDiContext(this, new ModuleInjector([new AppModule()]));
  }
}
```
