# YUV -> RGB Conversion in Flutter

Full working example of YUV to RGB transform in Dart with native code(Java)

## Why is it needed?
Personally, I encountered a problem while making a [real time recognition app](https://github.com/tomerblecher/fruit-recoginition-app), using a model i trained   with the [FastAI](https://www.fast.ai/) library.  
Since the library requires an RGBA image type for prediction, i got stuck for a few days searching for efficient solution, reading half working examples and eventually, with a lot of trial and error, managed to get a decent solution for my purposes.

## The solution in brief
After trying a few examples, the best solution seemed to be using native code(Java) to convert the image.
A [MethodChanel](https://flutter.dev/docs/development/platform-integration/platform-channels?tab=android-channel-java-tab) is being opened upon page init, allowing a direct connection for transferring the content of the frame forwards and backwards.

#### Average conversion time:
The conversion speed depends on the phone itself + the quality you chose for the cameraController.  
I tested it on 2 types of physical phones:

* Redmi Note 4:
  * *Low quality*: **~0.03-0.06** Seconds.
  * *Medium quality*: **~0.1-0.14** Seconds.
  * *High quality*: **~0.2-0.24** Seconds.

## Important notes
* The minimum SDK version of the application is 21 ( Required by the "Camera" package).
  * **Action to preform**: Open "android/app/build.gradle" and change
   ```minSdkVersion XX``` to ```minSdkVersion 21```
* Camera privileges need to be requested at the Manifest level.
  * **Action to preform**: Open "android/app/src/main/AndroidManifest.xml",
add ```<uses-permission android:name="android.permission.CAMERA"/>``` to the ```<manifest>``` element.
  * **Note**: Do not insert the element to the ```<application>```). It should be a direct child of the manifest element.

## What does this example includes?
* Permission handling for the camera(loop until the users accept).
* Full screen live camera preview
* Channeling camera frames for conversion
* Optional response stream for the RGBA Jpeg image(Uint8List)

## Camera resolution
When initializing the "CameraController" object, an enum called "ResolutionPreset" should be passed to define the camera quality.  
Those are the values for each entry.

* high → 720p (1280x720)

* low →352x288 on iOS, 240p (320x240) on Android

* max → The highest resolution available.

* medium → 480p (640x480 on iOS, 720x480 on Android)

* ultraHigh → 2160p (3840x2160)

* veryHigh → 1080p (1920x1080)

