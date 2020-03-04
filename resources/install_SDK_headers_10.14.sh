#!/bin/bash

if [ ! -f /System/Library/Perl/5.18/darwin-thread-multi-2level/CORE/EXTERN.h ]; then
    sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -allowUntrusted -target /
fi
