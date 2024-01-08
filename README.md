# unsupported-wifi-patches
Patches to fix old wireless cards support for MacOS Ventura/Sonoma

## Legacy WiFi Sources

   - airportd - MacOS Big Sur - /usr/libexec
   - wifip2pd - MacOS Monterey - /usr/libexec
   - WiFiAgent.app - MacOS Big Sur - /System/Library/CoreServices
   - wps - MacOS Monterey - /usr/libexec
   - CoreWLAN - MacOS Monterey - /System/Library/Frameworks/CoreWLAN.framework
   - CoreWiFi - MacOS Monterey - /System/Library/PrivateFrameworks/CoreWiFi.framework
   - Apple80211 - MacOS Monterey (renamed to IO80211 on Ventura) - /System/Library/PrivateFrameworks/Apple80211.framework
   - WiFiPeerToPeer - MacOS Monterey - /System/Library/PrivateFrameworks/WiFiPeerToPeer.framework

## Modern WiFi Sources

   - airportd - MacOS Ventura - /usr/libexec
   - wifip2pd - MacOS Ventura - /usr/libexec
   - CoreWLAN - MacOS Ventura - /System/Library/Frameworks/CoreWLAN.framework
   - IO80211 - MacOS Ventura - /System/Library/PrivateFrameworks/IO80211.framework
   - WiFiPeerToPeer - MacOS Ventura - /System/Library/PrivateFrameworks/WiFiPeerToPeer.framework