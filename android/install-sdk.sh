#!/bin/sh

set -ex

# Prep the SDK and emulator
#
# Note that the update process requires that we accept a bunch of licenses, and
# we can't just pipe `yes` into it for some reason, so we take the same strategy
# located in https://github.com/appunite/docker by just wrapping it in a script
# which apparently magically accepts the licenses.

mkdir sdk
curl http://dl.google.com/android/android-sdk_r24.4-linux.tgz | \
    tar xzf - -C sdk --strip-components=1

filter="platform-tools,android-18,android-21"
filter="$filter,sys-img-armeabi-v7a-android-21"

/usr/bin/expect -f /android/accept-licenses.sh "android - update sdk -a --no-ui --filter $filter"

echo "no" | android create avd \
                --name arm-21 \
                --target android-21 \
                --abi armeabi-v7a
