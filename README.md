#BWU Polymer Routing

Some helper classes and components to use the [route_hierarchical package](http://pub.dartlang.org/packages/route_hierarchical) (used by Angular.dart) with Polymer.dart.

I put a simple example online.
- [Simple example 1 - usePushState: false](http://bwu-dart.github.io/bwu_polymer_routing/example/example_01.html)
- [Simple example 2 - usePushState: true](http://bwu-dart.github.io/bwu_polymer_routing/example/example_02.html)


##Usage

This is the code of `example_01` from the `example` directory with additional comments.

###pubspec.yaml

Add the following dependency and transformers configuration to your `pubspec.yaml`.

```yaml
dependencies:
  polymer: '>=0.12.0+7 <0.13.0'
  bwu_polymer_routing: '>=0.0.1 <0.1.0'
  route_hierarchical: '>=0.4.21 <0.5.0'
  di: '>=2.0.1 <2.1.0'
   
dependency_overrides:
  code_transformers: '>=0.2.0 <0.3.0' # necessary until di 2.0.2 is published
  
transformers:
- polymer:
    entry_points:
    - web/index.html # customize to your requirements
- di
```

###example/example_01.html

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
    <script type="application/dart" src="example_01.dart"></script>
    <script src="packages/browser/dart.js"></script>
  </head>
  <body>
    <app-element></app-element>
  </body>
</html>
```

The `di` transformer needs a custom `main()` method where it adds the initialization code for the generated static injector. Therefore we need a main method even though we use an `<app-element>` which encloses the entire application and the application initialization code.

###example/example_01.dart

```dart
library bwu_polymer_routing.example_01.main;

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


###example/src/example_01/components/app_element.html

In your application package you should put the components somewhere in your `lib` directory. We have to keep the `bwu_polymer_routing` library code in `lib` and therefore keep the example application code entirely inside the `example` folder.

```html
<!DOCTYPE html>

<!-- each Polymer element should containt this import 
     the number of '../' depends on the directory where this file is stored in -->
<link rel='import' href='../../../../../packages/polymer/polymer.html'>

<!-- each used Polymer element needs to be imported somewhere -->
<!-- bind-view --> is a placeholder where view elements are inserted -->
<link rel='import' href='../../../../../packages/bwu_polymer_routing/bind_view.html'>

<!-- These Polymer elements are used as views. 
     Polymer elements must be imported somewhere before they can be used -->
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

    <!-- Our app-element has no HTML content beside this view placeholder 
         the view element configured for any top level route is added as 
         a child element to the <bind-view> element.
         The 'id' attribute was only added for debugging purposes and can
         be omitted. --> 
    <bind-view id='app-element'></bind-view>
    
  </template>
  <script type='application/dart' src='app_element.dart'></script>
</polymer-element>
```

###example/src/example_01/components/app_element.dart

```dart
// Each Dart file should have an unique library name.
library bwu_polymer_router.example_01.app_element;

import 'package:polymer/polymer.dart';
import 'package:di/di.dart' show Module, ModuleInjector;
import 'package:bwu_polymer_routing/module.dart'
    show RoutingModule;
import 'package:bwu_polymer_routing/static_keys.dart';
import '../route_initializer.dart';
import 'package:bwu_polymer_routing/di.dart';

// Register types for DI (dependency injection)
class AppModule extends Module {
  AppModule() : super() {
    // At first install the RoutingModule. 
    // usePushState: true/false defines whether only the hash part (after #) 
    // should be used for routing (false) or the entire URL (true).
    //
    // Using `usePushState: true` requires server support otherwise resources
    // like CSS files can't be found and a reload of the page will fail.
    // Our example_02 doesn't load any additional ressource therefore it works
    // with `usePushState: true` but you can't just reload the page because
    // the original URL of the page is not available anymore.
    install(new RoutingModule(usePushState: false));
    
    // After installing the RoutingModule a your custom bindings.
    // The RoutInitializer class contains our custom router configuration.
    bindByKey(ROUTE_INITIALIZER_FN_KEY, toValue: new RouteInitializer());
  }
}


// 'with DIContent' applies a mixin that enables this Polymer element to serve 
// DI requests for its child elements 
@CustomTag('app-element')
class AppElement extends PolymerElement with DiContext {
  AppElement.created() : super.created();

  @override
  void attached() {

    super.attached();

    // Initialize the DI container. 
    // We pass the element it should listen for di request events on
    // and the DI configuration (AppModule). 
    initDiContext(this, new ModuleInjector([new AppModule()]));
    
    // NOTE: If an element is DiContext and DiConsumer at the same time
    // the `<content>` element should be passed to `initDiContext` otherwise
    // the element serves its own DI requests, which would lead ot endless loops.
  }
}
```

###example/src/example_01/route_initializer.dart

This class defines the routing configuration for this example.

```Dart
library bwu_polymer_routing_example_01.route_initializer;

import 'package:route_hierarchical/client.dart' as rt;
import 'package:bwu_polymer_routing/module.dart';

class RouteInitializer implements Function {
  void call(rt.Router router, RouteViewFactory views) {
    views.configure({

      // 'userList' is the name of the route.
      'usersList': routeCfg(
          // '/users' is the path element shown in the browsers URL bar when this 
          // route is active.
          path: '/users',
          // The tag name for the view to create for this route.
          view: 'user-list',
          // Use this route when no specific route can be found for the current URL.
          defaultRoute: true,
          // Don't recreate (remove/add) the view element but just pass the 
          // updated parameter values to the existing view when the route stays 
          // the same as before but some route parameters have changed.
          dontLeaveOnParamChanges: true,
          // When this route is choosen as default route, the view is created but 
          // the URL in the browsers URL bar doesn't reflect this.
          // Explicitely `go` to this route updates the URL in the address bar
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
              // All parameters from this and all parent routes are
              // assigned to the view. If the view doesn't have an attribute
              // that matches the route parameter name the assignment fails with 
              // an exception.
              // With bindParameters the set of parameters assigned to the view
              // can be limited.
              // The default is all paremeters.
              // This example lists all parameters and is therefor redundant but
              // shows how it can be used.
              bindParameters: ['articleId', 'userId'],
              dontLeaveOnParamChanges: true,
              mount: {
            // These sub-routes don't create their own view but update the
            // status of the view of the parent route instead.
            // In fact this isn't done automatically but needs some additional 
            // code in the view itself (explained below).
            // The implementation of the (parent) view would be easier when 
            // these parts had been implemented as parameters instead of 
            // sub-routes.
            'view': routeCfg(
                path: '/view',
                defaultRoute: true,
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

###example/src/example_01/components/user_element.html

The `<user-element>` is a view that is shown inside the `<app-element>` and is itself a container for other views.  
According to the route configuration it can contain the view for the `user.articleList` route.

To support this two lines are required:

```HTML
<link rel='import' href='../../../packages/bwu_polymer_routing/bind_view.html'>
...
<bind-view id="user_element"></bind-view> 
<!-- the id is again only for debugging purposes and can be omitted -->
```

The `<user-element>` also contains a link to the `userList` route.

```HTML
<a href='#' on-click="{{routePath}}" route-path='usersList'>users</a>
```

`routePath` is a helper method provided by the `DiConsumer` mixin.   
To make it available we need to apply the mixin to the `UserElement` class (in the `user_element.dart` file) as shown below.
`routePath` is an event handler that routes to the route defined in the `route-path` attribute (`userList` in this case).


###example/src/example_01/components/user_element.dart

```dart
library bwu_polymer_router.example_01.user_element;

import 'package:polymer/polymer.dart';
// Import the DiConsume mixin.
import 'package:bwu_polymer_routing/di.dart' as di;

@CustomTag('user-element')
// `with di.DiConsumer` applies the DiConsumer mixin and makes some additional 
// helper methods for routing and DI available.
class UserElement extends PolymerElement with di.DiConsumer {
  UserElement.created() : super.created();

  // The route configuration (in route_initialized.dart) defines a `userId` 
  // routing parameter for the `user` route.
  // The actual value for the `userId` route parameter is assigned automatically 
  // to a field in the view with a matching name when the view is created or when
  // the parameter value changes.  
  @published String userId;
}
```


###example/src/example_01/components/user_list.html

Uses `<template repeat='...'>` to create a list of links (one for each user) that forwards to the user detail view ('<user-element>') and also to the sub-route `articles` which creates the `<article-list>` element as view inside the `<user-element>` view.

```HTML
<template repeat='{{user in users}}'>
  <li><a href='#' on-click="{{routePath}}"
    route-path='user.articleList'
    route-param-name="userId"
    route-param-value="{{user}}">{{user}}</a></li>
  </template>
```       
`routePath` is the same helper method provided by the `DiConsumer` and the `route-path` attribute defines that the link should navigate to the `user.articleList` route (as already shown in the `<user-element>` above).  

In addition to a specific route we want to pass an `userId` argument because we want to see the `<user-element>` and the `<article-list>` for a specific user when we click one of these links.  
This is done by a pair of attributes `route-param-name` and `route-param-value`.  
Here for each link the actual `user` value is passed as `userId` route parameter.  

It is supported to add more than one route parameter by adding an arbitrary suffix to the attribute name. 
The only requirement is that there is a pair with matching suffixes. 
A second parameter could be passed with `route-param-name-x2='birthDate'` and `route-param-value-x2='01/01/1985`. 
In this example there is a `route-param-name`/`route-param-value` attribute pair with the matching suffix `-x2`.


###example/src/example_01/components/user_list.dart

The `UserList` class doesn't contain anything new. Only the `DiConsumer` mixin is applied again to make the `routePath` event handler available.


###example/src/example_01/components/article_element.html
  
The `<article-element>` offers a few new things.

```html
<a href="#" on-click="{{parentRoute}}">articles</a>
```

This link uses another event handler `parentRoute` from the `DiConsumer` mixin that just navigates one level up in the route hierarchy (from `user.articleList.article` to `user.articleList`).

A bit special is the edit mode toggle button that switches between the `view` and `edit` sub route of the `user.articleList.article` route.

```html
<button on-click="{{toggleEdit}}">{{isEditMode ? 'view' : 'edit'}}</button>
```


###example/src/example_01/components/article_element.dart

```dart
library bwu_polymer_router.example_01.article_element;

import 'dart:async' as async;
import 'package:polymer/polymer.dart';
// The RouteProvider type is used for a DI request.
import 'package:bwu_polymer_routing/module.dart' show RouteProvider;
// The Router type from this library are also used for a DI request.
import 'package:route_hierarchical/client.dart' as rt;
// This import is again only to import the DiConsumer mixin.
import 'package:bwu_polymer_routing/di.dart' as di;

@CustomTag('article-element')
// The DiConsumer mixin is used to provide the `inject` and `parentRoute` methods. 
class ArticleElement extends PolymerElement with di.DiConsumer {
  ArticleElement.created() : super.created();

  // articleId and userId are passed in when the view is created/updated on a 
  //route change
  @observable String articleId;
  @observable String userId;
  
  // isEditMode is updated by code below.
  @observable bool isEditMode = false;

  @override
  void attached() {
    super.attached();

    _routeChange();
  }

  rt.Router router;
  rt.Route route;

  // An articleId change indicates a route change.
  void articleIdChanged(old) {
    _routeChange();
  }

  // An userId change indicates a route change.
  void userIdChanged(old) {
    _routeChange();
  }

  // Fetch dependencies again to ensure we have the most recent value.
  void _routeChange() {
    router = null;
    route = null;
    new async.Future(() {
      if(router != null) {
        // prevent repeated execution when
        // attached, articleIdChanged, userIdChanged fire succinctly.
        return;
      }
      _requestDependencies();
      // init isEditMode depending on the current active route.
      isEditMode = route.findRoute('edit').isActive;
    });
  }

  void _requestDependencies() {
    // If dependencies are not already fetched, do it now.
    if(router == null) {
      _requestDependencies();
    }
  
    // This line sends the DI request for two different types.
    var di = inject(this, [RouteProvider, rt.Router]);
    // Here we take the values from the result.
    route = (di[RouteProvider].route as rt.Route);
    router = (di[rt.Router] as rt.Router);
  }


  // This is the button event handler to switch between `edit` and `view` mode.
  void toggleEdit(e) {
    // At first we check which sub-route is currently active
    if(route.findRoute('view').isActive) {
      // Then we switch to the not yet active sub-route of the current route.
      router.go('${routeToPath(route)}.edit', route.parameters)
      .then((success) {
        if(success) isEditMode = true;
      });
    } else {
      router.go('${routeToPath(route)}.view', route.parameters)
      .then((success) => isEditMode = false);
    }
  }
}
````

###Summary

I hope this helps you to get started with Polymer, routing and DI.  

Any suggestions for improvements are greatly appreciated. [Just create an issue in the GitHub repository](https://github.com/bwu-dart/bwu_polymer_routing/issues/new)

