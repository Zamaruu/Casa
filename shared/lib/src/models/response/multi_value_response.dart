import 'package:shared/shared.dart';

class MultiValueResponse<T> extends MultiResponse implements IValueResponse<T> {
  @override
  final T? value;

  const MultiValueResponse({
    required super.responses,
    this.value,
    super.error,
    super.message,
    super.stackTrace,
  });

  @override
  bool get hasValue => value != null;
}
