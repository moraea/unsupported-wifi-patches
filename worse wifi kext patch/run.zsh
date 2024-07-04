set -e
cd "$(dirname "$0")"
PATH+=:/usr/libexec

name=AmyWifi
id=website.amys.wifi-sequoia
version=0.0.5
lilu=/Volumes/Files/sequoia/tmp/Lilu/Lilu
old='/Volumes/Backup/Unfiled/versions.noindex/13.6.5 (22G621)/kdk/System/Library/Extensions'

rm -rf "$name.kext" IOSkywalkFamily.kext IO80211FamilyLegacy.kext
mkdir -p "$name.kext/Contents/MacOS"

clang++ -std=c++20 -mkernel -nostdlib -Xlinker -kext -I "$(xcrun --show-sdk-path)/System/Library/Frameworks/Kernel.framework/Headers" -I "$lilu" main.cpp -o "$name.kext/Contents/MacOS/$name" -DKextName="$name" -DKextVersion="$version"

echo "Add CFBundleIdentifier string $id
Add CFBundleExecutable string $name
Add CFBundleVersion string $version
Add CFBundlePackageType string KEXT
Add OSBundleCompatibleVersion string $version
Add OSBundleLibraries dict
Add OSBundleLibraries:as.vit9696.Lilu string 1.6.7
Add IOKitPersonalities dict
Add IOKitPersonalities:$name dict
Add IOKitPersonalities:$name:CFBundleIdentifier string $id
Add IOKitPersonalities:$name:IOClass string $name
Add IOKitPersonalities:$name:IOMatchCategory string $name
Add IOKitPersonalities:$name:IOProviderClass string IOResources" | while read line
do
	PlistBuddy "$name.kext/Contents/Info.plist" -c "$line"
done

cp -R "$old/IOSkywalkFamily.kext" "$old/IO80211FamilyLegacy.kext" .
PlistBuddy IOSkywalkFamily.kext/Contents/Info.plist -c "Add OSBundleLibraries:$id string $version"
