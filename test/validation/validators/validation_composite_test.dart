import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:flutter_clean_arch/presentation/protocols/protocols.dart';
import 'package:flutter_clean_arch/validation/protocols/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite({@required this.validations});

  String validate({String field, String value}) => null;
}

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  test('Should return null if all validations returns null or empty', () {
    final validation1 = FieldValidationSpy();
    final validation2 = FieldValidationSpy();
    when(validation1.field).thenReturn('any_field');
    when(validation1.validate(any)).thenReturn(null);
    when(validation2.field).thenReturn('any_field');
    when(validation2.validate(any)).thenReturn('');
    final sut = ValidationComposite(validations: [validation1, validation2]);

    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, null);
  });
}
