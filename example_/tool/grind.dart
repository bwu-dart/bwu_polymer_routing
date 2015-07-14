library bwu_polymer_routing_examples.tool.grind;

export 'package:bwu_grinder_tasks/bwu_grinder_tasks.dart' hide main, travis;
import 'package:bwu_grinder_tasks/bwu_grinder_tasks.dart'
    hide main
    show checkTask, grind;

// Don't run `pub publish --dry-run
// because it requires
// - a LICENSE file
// - no path dependency to ..
main(args) {
  checkTask = () {};
  grind(args);
}
