#!/bin/bash
# qt run

wget https://download.qt.io/archive/qt/5.12/5.12.0/qt-opensource-linux-x64-5.12.0.run
chmod +x qt-opensource-linux-x64-5.12.0.run
echo "QT HAPPENS HERE"
sudo ./qt-opensource-linux-x64-5.12.0.run --script ./non-interactive-install.qs
wait
