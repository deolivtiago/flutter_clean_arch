import 'dart:async';

import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

abstract class Validation {
  String validate({@required String field, @required String value});
}

class ValidationSpy extends Mock implements Validation {}

class LoginState {
  String emailError;
}

class StreamLoginPresenter {
  final Validation validation;
  final _controller = StreamController<LoginState>.broadcast();

  StreamLoginPresenter({@required this.validation});

  Stream<String> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError);

  void validateEmail(String email) {
    validation.validate(field: 'email', value: email);
  }
}

void main() {
  StreamLoginPresenter sut;
  Validation validation;
  String email;

  setUp(() {
    validation = ValidationSpy();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
  });

  test('Should call Validation with correct email', () {
    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () {
    final error = 'error';
    when(validation.validate(
      field: anyNamed('field'),
      value: anyNamed('value'),
    )).thenReturn(error);

    expectLater(sut.emailErrorStream, emits(error));

    sut.validateEmail(email);
  });
}
