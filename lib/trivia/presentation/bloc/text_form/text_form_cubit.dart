import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'text_form_state.dart';

class TextFormCubit extends Cubit<TextFormState> {
  TextFormCubit() : super(const TextFormState(value: ''));

  void updateState(String newValue) => emit(TextFormState(value: newValue));
}
