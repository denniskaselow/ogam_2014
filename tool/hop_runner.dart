library hop_runner;

import 'package:hop/hop.dart';
import 'package:hop/hop_tasks.dart';

void main(List<String> args) {
  var paths = ['web/ogam_2014.dart', 'lib/shared.dart', 'lib/client.dart']; 

  addTask('analyze_libs', createAnalyzerTask(paths));
  
  runHop(args);
}
