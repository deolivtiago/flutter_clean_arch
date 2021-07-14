import '../../../../../presentation/protocols/protocols.dart';
import '../../../../../validation/validators/validators.dart';

Validation makeLoginValidation() {
  return ValidationComposite(
    validations: [
      RequiredFieldValidation(field: 'email'),
      RequiredFieldValidation(field: 'password'),
      EmailValidation(field: 'email'),
    ],
  );
}
