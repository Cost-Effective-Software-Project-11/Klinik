import 'package:freezed_annotation/freezed_annotation.dart';

part 'workplace.freezed.dart';
part 'workplace.g.dart';

@freezed
class Workplace with _$Workplace {
  const factory Workplace({
    required String name,
    required String city,
  }) = _Workplace;

  factory Workplace.empty() => const Workplace(name: '', city: '');

  factory Workplace.fromJson(Map<String, dynamic> json) =>
      _$WorkplaceFromJson(json);
}