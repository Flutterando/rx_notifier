import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:rx_notifier_annotation/rx_notifier_annotation.dart';
import 'package:source_gen/source_gen.dart';

import 'rx_value_field.dart';
import 'utils.dart';

class RxGenerator extends GeneratorForAnnotation<RxStore> {
  @override
  FutureOr<String> generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    ClassElement clazz = element as ClassElement;

    final name = publicName(clazz);

    if (!clazz.isAbstract || !clazz.isPrivate) {
      throw '''Class ($name) must be abstract and private:
      ex:
          abstract class _${publicName(clazz)} {}
      
      ''';
    }

    final _rxValueChecker = TypeChecker.fromRuntime(RxValue);

    final rxfields = clazz.fields
        .where((f) => _rxValueChecker //
            .hasAnnotationOfExact(f))
        .where((value) => !value.isFinal && !value.isPrivate && !value.isConst)
        .map(RxValueField.new);

    final rxfieldsToProcess = rxfields.map((e) => e.generatedCode).join();

    return """

    class $name = ${clazz.name} with _${name}Mixin;

    mixin _${name}Mixin on ${clazz.name} {
    
      $rxfieldsToProcess
  
    }  
    """;
  }
}
