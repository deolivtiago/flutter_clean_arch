import 'package:test/test.dart';
import 'package:meta/meta.dart';

abstract class FieldValidation {
  String get field;
  String validate(String value);
}

class RequiredFieldValidation implements FieldValidation {
  final String field;

  RequiredFieldValidation({@required this.field});

  String validate(String value) {
    return null;
  }
}

void main() {
  test('Should return null if value is not empty', () {
    final sut = RequiredFieldValidation(field: 'any_field');

    final error = sut.validate('any_value');

    expect(error, null);
  });
}
