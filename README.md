###BWU Testrunner

runs all configured web test scripts using `content_shell --dump-render-tree`
with or without `pub serve`
and prints a summary.

##Prerequisites
- content_shell needs to be installed

##Usage

- create a config file

```json
{
    "core_ajax_dart": { "doSkipWithoutPubServe": true,  "contentShellOptions": ["--allow-external-pages", "--allow-file-access-from-files"] },
    "core_animated_pages": {},
    "core_collapse": {},
    "core_icon": {"doSkipWithContentShell": true},
    "core_iconset": {"doSkipWithContentShell": true},
    "core_input": {},
    "core_localstorage_dart": {},
    "core_media_query": {"doSkipWithContentShell" : true, "contentShellOptions": ["--disable-popup-blocking"],
        "comment": "TODO(zoechi) resizeTo() doesn't work in contentShell see https://code.google.com/p/dart/issues/detail?id=20273"},
    "core_menu_button": {},
    "core_selection": {},
    "core_selection_multi": {},
    "core_selector_activate_event": {},
    "core_selector_basic": {},
    "core_selector_multi": {},
    "core_shared_lib": {"contentShellOptions": ["--allow-external-pages", "--allow-file-access-from-files"]}
}
```
