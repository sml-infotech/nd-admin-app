class UpdateOnboardModel {
  final String? temple_id;
  final bool? is_onboarded;


  UpdateOnboardModel({
    this.temple_id,
    this.is_onboarded,
 
  });

  factory UpdateOnboardModel.fromJson(Map<String, dynamic> json) {
    return UpdateOnboardModel(
      temple_id: json['temple_id'] as String?,
      is_onboarded: json['is_onboarded'] as bool?,
 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temple_id': temple_id,
      'is_onboarded': is_onboarded,
      
    };
  }
}


