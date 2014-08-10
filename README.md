#BWU Polymer Routing

Some helper classes and components to use route_hierarchical with Polymer.dart.

I put [a simple example](http://bwu-dart.github.io/bwu_polymer_routing/example/example_01.html) online.


##Usage

This is the code of the example in the `example` directory with addition comments.

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

<!-- These Polymer elements are used as views. 
     Polymer elements must be imported somewhere before they can be used used -->
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

    <!-- our app-element has no HTML content beside this view placeholder 
         the view element configured for any top level route is added as 
         a child element to the <bind-view> element.
         The 'id' attribute was only added for debugging purposes and can
         be omitted. --> 
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
    // usePushState: true/false defines whether only the hash part (after #) 
    // should be used for routing (false)  or the entire URL (true)
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
    // we pass the element it should listen for di request events
    // and the di configuration (AppModule) 
    initDiContext(this, new ModuleInjector([new AppModule()]));
  }
}
```

###example/src/route_initializer.dart

This class defines the routing configuration for this example.

```Dart
library bwu_polymer_routing_example.route_initializer;

import 'package:route_hierarchical/client.dart' as rt;
import 'package:bwu_polymer_routing/module.dart';

class RouteInitializer implements Function {
  void call(rt.Router router, RouteViewFactory views) {
    views.configure({

      // 'userList' is the name for this route
      'usersList': routeCfg(
          // '/users' is the path element shown in the browsers URL bar for this route
          path: '/users',
          // The tag name for the view to create for this route.
          view: 'user-list',
          // Use this route when no specific route can be found for the current URL.
          defaultRoute: true,
          // Don't recreate (remove/add) the view element but just pass the 
          // updated parameter values.
          dontLeaveOnParamChanges: true,
          // When this route is choosen as default route, the view is created but 
          // the URL in the browsers URL bar doesn't reflect this
          // explicitely go to this route updates the URL in the address bar
          // (maybe there is a better way to reach the same result).  
          enter: (route) => router.go('usersList', {})),
      'user': routeCfg(
          // The ':userId' part gets assigned to the attribute named 'userId' 
          // of the created view.
          path: '/user/:userId',
          view: 'user-element',
          // When the 'userId' value changes the new value is passed to the
          // view without removing and recreating the view.
          dontLeaveOnParamChanges: true,
          // The user route has some sub routes.
          mount: {
        'articleList': routeCfg(
            path: '/articles',
            view: 'article-list',
            defaultRoute: true,
            dontLeaveOnParamChanges: true,
            mount: {
            // The route 'user.articleList' again has sub-routes.
          'article': routeCfg(
              path: '/article/:articleId',
              view: 'article-element',
              // All parameters from this route and all parent routes are
              // assigned to the view. If the view doesn't have an attribute
              // with this name the assignment fails with an exception.
              // With bindParameters the set of parameters assigned to the view
              // can be limited.
              // The default is all paremeters.
              // This example lists all parameters and is therefor redundant.
              bindParameters: ['articleId', 'userId'],
              dontLeaveOnParamChanges: true,
              mount: {
            // These sub-routes don't create their own view but update the
            // status of the view of the parent route instead.
            // In fact this isn't done automatically but needs some additional 
            // code in the view itself.
            // The implementation of the (parent) view would be easier when 
            // these parts had been implemented as parameters instead of 
            // sub-routes.
            'view': routeCfg(
                path: '/view',
                defaultRoute: true,
                // This seems not to have any effect for routes which don't 
                // create their own view (I have to investigate further how 
                // this actually works).
                dontLeaveOnParamChanges: true),
            'edit': routeCfg(
                path: '/edit',
                dontLeaveOnParamChanges: true)
          })
        })
      })
    });
  }
}
```

