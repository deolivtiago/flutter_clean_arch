import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_clean_arch/domain/entities/entities.dart';
import 'package:flutter_clean_arch/domain/helpers/helpers.dart';
import 'package:flutter_clean_arch/domain/usecases/usecases.dart';

import 'package:flutter_clean_arch/presentation/presenters/presenters.dart';
import 'package:flutter_clean_arch/presentation/protocols/protocols.dart';

class ValidationSpy extends Mock implements Validation {}

class AuthenticationSpy extends Mock implements Authentication {}

void main() {
  StreamLoginPresenter sut;
  Authentication authentication;
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

  PostExpectation mockAuthenticationCall() {
    return when(
      authentication.auth(any),
    );
  }

  void mockAuthentication() {
    mockAuthenticationCall()
        .thenAnswer((_) async => AccountEntity(faker.guid.guid()));
  }

  void mockAuthenticationError(DomainError error) {
    mockAuthenticationCall().thenThrow(error);
  }

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    sut = StreamLoginPresenter(
      validation: validation,
      authentication: authentication,
    );
    email = faker.internet.email();
    password = faker.internet.password();
    mockValidation();
    mockAuthentication();
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

  test('Should emit emailError as null if validation succeeds', () {
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

  test('Should emit password error if validation fails', () {
    final error = 'error';
    mockValidation(value: error);

    sut.passwordErrorStream.listen(
      expectAsync1((event) => expect(event, error)),
    );
    sut.isFormValidStream.listen(
      expectAsync1((event) => expect(event, false)),
    );

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit passwordError as null if validation succeeds', () {
    sut.passwordErrorStream.listen(
      expectAsync1((event) => expect(event, null)),
    );
    sut.isFormValidStream.listen(
      expectAsync1((event) => expect(event, false)),
    );

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit email error if validation fails', () {
    final error = 'error';
    mockValidation(field: 'email', value: error);

    sut.emailErrorStream.listen(
      expectAsync1((event) => expect(event, error)),
    );
    sut.passwordErrorStream.listen(
      expectAsync1((event) => expect(event, null)),
    );
    sut.isFormValidStream.listen(
      expectAsync1((event) => expect(event, false)),
    );

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('Should emit email error if validation fails', () async {
    sut.emailErrorStream.listen(
      expectAsync1((event) => expect(event, null)),
    );
    sut.passwordErrorStream.listen(
      expectAsync1((event) => expect(event, null)),
    );

    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
  });

  test('Should call Authentication with correct values', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);
    await sut.auth();

    verify(authentication.auth(AuthenticationParams(
      email: email,
      password: password,
    ))).called(1);
  });

  test('Should emit correct events on Authentication success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.auth();
  });

  test('Should emit correct events on InvalidCredentialsError', () async {
    mockAuthenticationError(DomainError.invalidCredentials);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(false));
    sut.mainErrorStream.listen(
      expectAsync1(
        (event) => expect(
          event,
          'Credenciais Inválidas.',
        ),
      ),
    );

    await sut.auth();
  });
}
