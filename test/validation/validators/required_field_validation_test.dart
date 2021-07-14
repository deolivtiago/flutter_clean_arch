import 'package:test/test.dart';

import 'package:flutter_clean_arch/validation/protocols/protocols.dart';
import 'package:flutter_clean_arch/validation/validators/validators.dart';

void main() {
  FieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation(field: 'any_field');
  });

  test('Should return null if value is not empty', () {
    expect(sut.validate('any_value'), null);
  });

  test('Should return error if value is empty', () {
    expect(sut.validate(''), 'Campo Obrigatório.');
  });

  test('Should return error if value is null', () {
    expect(sut.validate(null), 'Campo Obrigatório.');
  });
}
