class LoginState {
  const LoginState._({
    required this.status,
    this.errorMessage,
  });

  const LoginState.initial() : this._(status: LoginStatus.initial);
  const LoginState.loading() : this._(status: LoginStatus.loading);
  const LoginState.success() : this._(status: LoginStatus.success);
  const LoginState.failure(String message)
      : this._(status: LoginStatus.failure, errorMessage: message);

  final LoginStatus status;
  final String? errorMessage;

  bool get isInitial => status == LoginStatus.initial;
  bool get isLoading => status == LoginStatus.loading;
  bool get isSuccess => status == LoginStatus.success;
  bool get isFailure => status == LoginStatus.failure;
}

enum LoginStatus { initial, loading, success, failure }

