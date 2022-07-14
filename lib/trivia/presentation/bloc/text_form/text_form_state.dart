part of 'text_form_cubit.dart';

class TextFormState extends Equatable {
  final String value;

  const TextFormState({required this.value});

  @override
  List<Object> get props => [value];

  TextFormState copyWith({
    String? value,
  }) {
    return TextFormState(
      value: value ?? this.value,
    );
  }
}
