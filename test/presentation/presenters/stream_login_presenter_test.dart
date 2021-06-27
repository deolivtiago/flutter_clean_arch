import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_clean_arch/presentation/presenters/presenters.dart';
import 'package:flutter_clean_arch/presentation/protocols/protocols.dart';

class ValidationSpy extends Mock implements Validation {}

void main() {
  StreamLoginPresenter sut;
  Validation validation;
  String email;
  String password;

  PostExpectation mockValidationCall(String field) {
    return when(
      validation.validate(
        field: field == null ? anyNamed('field') : field,
        value: anyNamed('value'),
      ),
    );
  }

  void mockValidation({String field, String value}) {
    mockValidationCall(field).thenReturn(value);
  }

  setUp(() {
    validation = ValidationSpy();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
    password = faker.internet.password();
    mockValidation();
  });

  test('Should call Validation with correct email', () {
    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () {
    final error = 'error';
    mockValidation(value: error);

    sut.emailErrorStream.listen(
      expectAsync1((event) => expect(event, error)),
    );
    sut.isFormValidStream.listen(
      expectAsync1((event) => expect(event, false)),
    );

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null if validation succeeds', () {
    sut.emailErrorStream.listen(
      expectAsync1((event) => expect(event, null)),
    );
    sut.isFormValidStream.listen(
      expectAsync1((event) => expect(event, false)),
    );

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call Validation with correct password', () {
    sut.validatePassword(password);

    verify(validation.validate(field: 'password', value: password)).called(1);
  });
}
