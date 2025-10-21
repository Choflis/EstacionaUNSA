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
        apiKey: 'AIzaSyASHVg2nejHLi-vkeGA-tSreAGUQmPmufc',
        appId: '1:53250810553:web:estacionaunsa',
        messagingSenderId: '53250810553',
        projectId: 'estacionaunsa',
        authDomain: 'estacionaunsa.firebaseapp.com',
        storageBucket: 'estacionaunsa.firebasestorage.app',
      );                                                                      
                                                                              
      static const FirebaseOptions android = FirebaseOptions(                 
        apiKey: 'AIzaSyASHVg2nejHLi-vkeGA-tSreAGUQmPmufc',
        appId: '1:53250810553:android:efceb2ce8f4cc7d967f168',
        messagingSenderId: '53250810553',
        projectId: 'estacionaunsa',
        storageBucket: 'estacionaunsa.firebasestorage.app',
      );                                                                      
                                                                              
      static const FirebaseOptions ios = FirebaseOptions(                     
        apiKey: 'AIzaSyASHVg2nejHLi-vkeGA-tSreAGUQmPmufc',
        appId: '1:53250810553:ios:estacionaunsa',
        messagingSenderId: '53250810553',
        projectId: 'estacionaunsa',
        storageBucket: 'estacionaunsa.firebasestorage.app',
        iosBundleId: 'com.example.estacionaUnsa',
      );                                                                      
}
