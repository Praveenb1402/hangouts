import 'package:url_launcher/url_launcher.dart';
class GoogleMapRedirector
{
  void openGoogleMaps(double latitude, double longitude,String address) async {
    final googleMapsUrl = 'https://www.google.com/maps/place/'+(address).replaceAll(" ", "+").replaceAll('/', '%2F');
    // final googleMapsUrl = 'https://www.google.com/maps/place/98%2F1,+17t+B+Main+Rd,+KHB+Block+Koramangala,+5th+Block,+Koramangala,+Bengaluru,+Karnataka+560095/@12.935686,77.6162202,16.97z/data=!4m10!1m2!2m1!1s98%2FA,+17th+B+Main,+Koramangala+5th+Block,+Bangalore,+Bengaluru,+Karnataka!3m6!1s0x3bae14453c2f1e21:0x76a674a3f61e730!8m2!3d12.935765!4d77.621064!15sCkk5OC9BLCAxN3RoIEIgTWFpbiwgS29yYW1hbmdhbGEgNXRoIEJsb2NrLCBCYW5nYWxvcmUsIEJlbmdhbHVydSwgS2FybmF0YWthkgEQZ2VvY29kZWRfYWRkcmVzc-ABAA!16s%2Fg%2F11y44m5bm3?entry=ttu&g_ep=EgoyMDI1MDEwOC4wIKXMDSoASAFQAw%3D%3D';

    // final  = "https://www.google.com/maps?q=,";


try{
  await launch(googleMapsUrl);
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl); // Opens Google Maps
    } else {
      // throw 'Could not open Google Maps.';
    }
}
    catch(e)
    {
    }
  }
}