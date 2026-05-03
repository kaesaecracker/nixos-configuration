{ pkgs, ... }:
let
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    buildToolsVersions = [ "36.1.0" ];
    platformVersions = [ "35" ];
    includeNDK = false;
    includeEmulator = false;
    includeSystemImages = false;
  };
  androidSdk = androidComposition.androidsdk;
in
{
  nixpkgs.config.android_sdk.accept_license = true;

  my.allowedUnfreePackages = [
    "android-sdk-cmdline-tools"
    "android-sdk-platform-tools"
    "android-sdk-tools"
    "android-sdk-build-tools"
    "android-sdk-platforms"

    # wtf
    "platform-tools"
    "tools"
    "build-tools"
    "cmdline-tools"
    "platforms"
    "cmake" # android sdk repackage
  ];

  environment.systemPackages = with pkgs; [
    androidSdk
    gradle
    kotlin
    jdk21
  ];

  environment.variables = {
    ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
    ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
    JAVA_HOME = "${pkgs.jdk21}";
  };
}
