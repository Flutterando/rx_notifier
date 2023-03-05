import 'package:analyzer/dart/element/element.dart';

import 'utils.dart';

class RxValueField {
  final FieldElement f;

  RxValueField(this.f);
  String get name => f.name;

  String get sourcePublicFieldName => publicName(f);

  String get type => f.type.getDisplayString(withNullability: true);

  String get nameRx => "_${name}Rx";
  String get nameValue => "_${name}Value";

  String get disposeCall => "$nameRx.dispose();";

  String get generatedCode => """

    /// 
    /// GENERATED $name($type)
    /// 
    
    late final $nameRx = RxNotifier<$type>(super.$name);
    RxValueListenable<$type> get ${name}Listenable => $nameRx;

    @override
    set ${name}($type $nameValue) => $nameRx.value = $nameValue;
    @override
    $type get ${name} => $nameRx.value;

  """;
}
