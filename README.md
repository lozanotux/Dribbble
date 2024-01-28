# Dribbble

A music player writen in Vala and GTK+

![Screenshot](./data/media/screenshot.jpg)

## Build

1. Install required dependencies:
```bash
sudo apt-get install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev build-essential gettext libgirepository1.0-dev libglib2.0-dev libgtk-3-dev cmake valac valadoc
```

2. Configure installation target directory and prepare the source code:
```bash
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr
```

3. Compile the source code and install the app on your system:
```bash
make -j
sudo make install
```

## Uninstall

To remove the application files from your system, run next command from the root of the project:
```bash
sudo make uninstall
```