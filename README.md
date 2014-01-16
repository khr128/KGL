KGL
===

Cocoa framework to encapsulate the OpenGL functionality that I use in my apps

## How to install

From the project directory run the following commands in terminal

    xcodebuild clean install
    pkgbuild --root build/Release/KGL.framework --install-location <your-dir> ./KGL.pkg
    open ./KGL.pkg
and follow the standard installer routine.

## Demo Project

See [demo branch](https://github.com/khr128/KGL/tree/demo) for examples of usage.

