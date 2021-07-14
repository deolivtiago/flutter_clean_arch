import 'package:meta/meta.dart';

import '../protocols/protocols.dart';

class RequiredFieldValidation implements FieldValidation {
  final String field;

  RequiredFieldValidation({@required this.field});

  String validate(String value) {
    return value?.isNotEmpty == true ? null : 'Campo Obrigatório.';
  }
}
