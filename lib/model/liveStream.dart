import 'package:mux_flutter/model/playbackID.dart';

class LiveStream{

  String id;
  String status;
  PlaybackID playbackId;
  String createAt;

  LiveStream(this.id,this.status,this.playbackId,this.createAt);

  LiveStream.fromJson(Map<String,dynamic>json)
    : id = json['id'],
      status = json['status'],
      playbackId = PlaybackID.fromJson(json['playback_ids']),
      createAt = json['created_at'];

  Map<String,dynamic> toJson() =>{
    'id' : id,
    'status' : status,
    'playback_ids' : playbackId,
    'created_at' : createAt
  };

  @override
  String toString() => '$id $status ${playbackId.toString()} $createAt';


}