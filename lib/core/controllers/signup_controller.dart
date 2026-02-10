import 'package:flutter_riverpod/legacy.dart';
import 'package:pinterest/presentation/models/signup_model.dart';

class SignupController extends StateNotifier<SignupData> {
  SignupController(String email)
      : super(SignupData(email: email));

  void setPassword(String v) =>
      state = state.copyWith(password: v);

  void setName(String v) =>
      state = state.copyWith(name: v);

  void setDob(DateTime v) =>
      state = state.copyWith(dob: v);

  void setGender(String v) =>
      state = state.copyWith(gender: v);

  void setCountry(String v) =>
      state = state.copyWith(country: v);
}

final signupProvider =
    StateNotifierProvider.family<SignupController, SignupData, String>(
  (ref, email) => SignupController(email),
);
