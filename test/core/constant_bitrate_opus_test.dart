import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:livekit_client/src/core/transport.dart';

void main() {
  test('every Opus payload asks for a constant bitrate and no DTX', () {
    const sdp = 'v=0\r\n'
        'o=- 1 2 IN IP4 127.0.0.1\r\n'
        's=-\r\n'
        't=0 0\r\n'
        'm=audio 9 UDP/TLS/RTP/SAVPF 111 63\r\n'
        'c=IN IP4 0.0.0.0\r\n'
        'a=rtpmap:111 opus/48000/2\r\n'
        'a=fmtp:111 minptime=10;usedtx=1;useinbandfec=1\r\n'
        'a=rtpmap:63 red/48000/2\r\n'
        'm=video 9 UDP/TLS/RTP/SAVPF 96\r\n'
        'c=IN IP4 0.0.0.0\r\n'
        'a=rtpmap:96 H264/90000\r\n'
        'a=fmtp:96 profile-level-id=42e01f\r\n';
    final munged = withConstantBitrateOpus(rtc.RTCSessionDescription(sdp, 'answer'));
    expect(munged.type, 'answer');
    expect(munged.sdp, contains('a=fmtp:111 minptime=10;useinbandfec=1;cbr=1;usedtx=0'));
    expect(munged.sdp, contains('a=fmtp:96 profile-level-id=42e01f'));
    expect(munged.sdp, isNot(contains('usedtx=1')));
  });
}
