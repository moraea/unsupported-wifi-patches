#!/bin/zsh

# standalone Stubber build script for EduCovas
# edit the last line to reflect the two input paths and the final install path

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

#modern wifi

build "IO80211_1272" "IO80211_144" "/System/Library/PrivateFrameworks/IO80211.framework/Versions/A/IO80211"
build "CoreWLAN_1272" "CoreWLAN_144" "/System/Library/Frameworks/CoreWLAN.framework/Versions/A/CoreWLAN" "CoreWLAN_144.json"
build "WiFiPeerToPeer_1272" "WiFiPeerToPeer_144" "/System/Library/PrivateFrameworks/WiFiPeerToPeer.framework/Versions/A/WiFiPeerToPeer"
build "CoreWiFi_1272" "CoreWiFi_144" "/System/Library/PrivateFrameworks/CoreWiFi.framework/Versions/A/CoreWiFi" "CoreWiFi_144.json"

cp "airportd" "$prefixOut" 
./Binpatcher $prefixOut/airportd $prefixOut/airportd 'set 0x6c758
nop 0x5'
codesign -fs - $prefixOut/airportd