

import 'package:pulse/features/bills/domain/entities/action.dart';

class ActionModel extends Action {
  ActionModel({
    required super.id,
    required super.actionDate,
    required super.actionText,
    required super.actionCode,
    required super.chamber,
  });

  factory ActionModel.fromJson(Map<String, dynamic> json) {
    return ActionModel(
      id: json['id'] as int? ?? 0,
      actionDate: json['action_date'] as String? ?? '',
      actionText: json['action_text'] as String? ?? '',
      actionCode: json['action_code'] as String? ?? '',
      chamber: json['chamber'] as String? ?? '',
    );
  }
}

