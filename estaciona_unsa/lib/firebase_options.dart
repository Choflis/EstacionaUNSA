import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;   
import 'package:flutter/foundation.dart'                                  
show defaultTargetPlatform, kIsWeb, TargetPlatform;                   
                                                                              
class DefaultFirebaseOptions {                                            
      static FirebaseOptions get currentPlatform {                            
        if (kIsWeb) {                                                         
          return web;                                                         
        }                                                                     
        switch (defaultTargetPlatform) {                                      
          case TargetPlatform.android:                                        
            return android;                                                   
          case TargetPlatform.iOS:                                            
            return ios;
          case TargetPlatform.linux:
          case TargetPlatform.windows:
          case TargetPlatform.macOS:
            return web; // Desktop platforms use web configuration
          default:                                                            
            throw UnsupportedError(                                           
              'DefaultFirebaseOptions are not supported for this platform.',  
            );                                                                
        }                                                                     
      }                                                                       
                                                                              
      static const FirebaseOptions web = FirebaseOptions(                     
        apiKey: 'AIzaSyDlUNsPhLT3W6DdBDYrL6Zh4i8zcClYYoE',
        appId: '1:169600291245:web:857a289f4ccc96dee61124',
        messagingSenderId: '169600291245',
        projectId: 'estaciona-unsa',
        authDomain: 'estaciona-unsa.firebaseapp.com',
        storageBucket: 'estaciona-unsa.firebasestorage.app',
        measurementId: 'G-288DZBEX3M',
      );                                                                      
                                                                              
      static const FirebaseOptions android = FirebaseOptions(                 
        apiKey: 'AIzaSyDOV0lDj1dTdGTX7PJrrya_At5oIKv6l4g',
        appId: '1:169600291245:android:4065408241cf18a6e61124',
        messagingSenderId: '169600291245',
        projectId: 'estaciona-unsa',
        storageBucket: 'estaciona-unsa.firebasestorage.app',
      );                                                                      
                                                                              
      static const FirebaseOptions ios = FirebaseOptions(                     
        apiKey: 'AIzaSyDOV0lDj1dTdGTX7PJrrya_At5oIKv6l4g',
        appId: '1:169600291245:ios:estacionaunsa',
        messagingSenderId: '169600291245',
        projectId: 'estaciona-unsa',
        storageBucket: 'estaciona-unsa.firebasestorage.app',
        iosBundleId: 'com.example.estacionaUnsa',
      );                                                                      
}
