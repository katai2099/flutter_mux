import 'dart:core';

class PlaybackID{
  
  String policy;
  String id;

  PlaybackID(this.policy,this.id);

  PlaybackID.fromJson(List<dynamic>json)
    : policy = json[0]['policy'],
      id = json[0]['id'];

  Map<String,dynamic> toJson() =>{
    'policy' : policy,
    'id' : id
  };

  @override
  String toString() => '$policy $id';

}