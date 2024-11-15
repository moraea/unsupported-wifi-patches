#!/bin/zsh

set -e

export code="$(dirname "$0")"
cd "$code"

function clangCommon
{
	clang -fmodules -I "$code/Utils" -Wno-unused-getter-return-value -Wno-objc-missing-super-calls $@
}

prefixOut="Wrapped"
rm -rf "$prefixOut"
mkdir "$prefixOut"

function build
{
	oldIn="$1"
	newIn="$2"
	mainInstall="$3"
	
	name="$(basename "$mainInstall")"
	mainNameOut="$name"
	oldNameOut="${name}Old.dylib"
	
	prefixInstall="$(dirname "$mainInstall")"
	oldInstall="$prefixInstall/$oldNameOut"
	
	mainOut="$prefixOut/$mainNameOut"
	oldOut="$prefixOut/$oldNameOut"
	
	cp "$oldIn" "$oldOut"
	install_name_tool -id "$oldInstall" "$oldOut"
	
	mainIn="$prefixOut/${name}Wrapper.m"
	shimsIn="$code/Shims"
	hackNew="${newIn}.json"
	hackOld="${oldIn}.json"

	# hack for Stubber to get the right name
	nameHack="$prefixOut/$name"
	cp "$newIn" "$nameHack"

	./Stubber "$oldIn" "$nameHack" "$shimsIn" "$mainIn" "$hackNew" "$hackOld"

	rm "$nameHack"
	
	clangCommon -dynamiclib -compatibility_version 1.0.0 -current_version 1.0.0 -install_name "$mainInstall" -Xlinker -reexport_library "$oldOut" -I "$code/Shims" "$mainIn" -o "$mainOut" $4
	
	codesign -f -s - "$oldOut"
	codesign -f -s - "$mainOut"
}

build "IO80211_1372" "IO80211_1472" "/System/Library/PrivateFrameworks/IO80211.framework/Versions/A/IO80211"
build "CoreWLAN_1372" "CoreWLAN_1472" "/System/Library/Frameworks/CoreWLAN.framework/Versions/A/CoreWLAN" "CoreWLAN_1472.json"
build "WiFiPeerToPeer_1372" "WiFiPeerToPeer_1472" "/System/Library/PrivateFrameworks/WiFiPeerToPeer.framework/Versions/A/WiFiPeerToPeer"
build "CoreWiFi_1372" "CoreWiFi_1472" "/System/Library/PrivateFrameworks/CoreWiFi.framework/Versions/A/CoreWiFi" "CoreWiFi_1472.json"