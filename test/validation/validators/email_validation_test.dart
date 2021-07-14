import 'package:test/test.dart';

import 'package:flutter_clean_arch/validation/protocols/protocols.dart';
import 'package:flutter_clean_arch/validation/validators/validators.dart';

void main() {
  FieldValidation sut;

  setUp(() {
    sut = EmailValidation(field: 'any_field');
  });

  test('Should return null if email is empty', () {
    expect(sut.validate(''), null);
  });

  test('Should return null if email is null', () {
    expect(sut.validate(null), null);
  });

  test('Should return null if email is valid', () {
    expect(sut.validate('valid_email@mail.com'), null);
  });

  test('Should return error if email is invalid', () {
    expect(sut.validate('invalid_email'), 'Campo Inválido.');
  });
}
