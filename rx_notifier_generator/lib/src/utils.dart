import 'package:analyzer/dart/element/element.dart';

String publicName(Element field) {
  if (field.isPublic) {
    return field.displayName;
  } else {
    return field.displayName.replaceFirst("_", "");
  }
}
