hdiutil create -o /tmp/Catalina -size 8000m -layout SPUD -fs HFS+J
hdiutil attach /tmp/Catalina.dmg -noverify -mountpoint /Volumes/install_build
sudo /Volumes/macOS\ Catalina\ 10.15\ \(19A583\)/Install\ macOS\ Catalina.app/Contents/Resources/createinstallmedia --volume /Volumes/install_build
hdiutil convert /tmp/Catalina.dmg -format UDTO -o ~/Downloads/Catalina
mv ~/Downloads/Catalina.cdr ~/Downloads/Catalina.iso