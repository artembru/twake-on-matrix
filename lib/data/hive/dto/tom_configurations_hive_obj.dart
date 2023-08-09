import 'package:equatable/equatable.dart';
import 'package:fluffychat/data/hive/dto/tom_server_information_hive_obj.dart';
import 'package:fluffychat/domain/model/tom_configurations.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tom_configurations_hive_obj.g.dart';

@JsonSerializable(explicitToJson: true)
class ToMConfigurationsHiveObj with EquatableMixin {
  final ToMServerInformationHiveObj tomServerInformation;

  final String? identityServerUrl;

  ToMConfigurationsHiveObj({
    required this.tomServerInformation,
    this.identityServerUrl,
  });

  factory ToMConfigurationsHiveObj.fromToMConfigurations(
    ToMConfigurations toMConfigurations,
  ) {
    return ToMConfigurationsHiveObj(
      tomServerInformation:
          ToMServerInformationHiveObj.fromToMServerInformation(
        toMConfigurations.tomServerInformation,
      ),
      identityServerUrl:
          toMConfigurations.identityServerInformation?.baseUrl.toString(),
    );
  }

  factory ToMConfigurationsHiveObj.fromJson(Map<String, dynamic> json) =>
      _$ToMConfigurationsHiveObjFromJson(json);

  Map<String, dynamic> toJson() => _$ToMConfigurationsHiveObjToJson(this);

  @override
  List<Object?> get props => [tomServerInformation, identityServerUrl];
}
