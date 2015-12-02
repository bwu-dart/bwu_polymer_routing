##0.2.0
- Upgrade to Polymer 1.0.0-rc.x
- remove deprecated uppercase consts in `lib/static_keys.dart`

##0.1.3
- move examples into a sub-project
- fix linter hints/warnings
- changed the keys in `lib/static_keys.dart` to lower-camel-case to comply with
  the Dart style guide. The upper-case keys will be removed eventually.

##0.1.2
- use dartformat on all source files
- upgrade to Polymer 0.16.0

##0.1.1+1
- remove pubspec.lock from Git repo

##0.1.1
- Widen dependency constraints on core- and paper-elements and move these.
dependencies to `dev_dependencies`.
- Minimum SDK version changed from 1.6.0-dev to 1.7.0.
- Remove `platform.js` script tags in examples.

##0.1.0
- Bump version because the package seems to work pretty good already
- Widen dependency constraints on DI
- Add some more codedoc comments
- Add logging

##0.0.4
- Widen dependency constraints on core_elements, paper_elements

##0.0.3
- Widen dependency constraints on Polymer, route_hierarchical

##0.0.2
- `routePath` renamed to `goPathHandler`
- `parentRoute` renamed to `goRouteHandler`
- `dependency_overrides` for `code_transformer` not necessary anymore
