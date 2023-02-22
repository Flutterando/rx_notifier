import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/rx_generator.dart';

Builder rxBuilder(BuilderOptions options) => SharedPartBuilder([RxGenerator()], 'notifier');
