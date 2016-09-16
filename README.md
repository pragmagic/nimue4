# Nim Integration for Unreal Engine 4 [![Build Status](https://travis-ci.org/pragmagic/nimue4.svg?branch=master)](https://travis-ci.org/pragmagic/nimue4)

This repo contains Nim library and tools that allow to create Unreal Engine 4 games on [Nim programming language](http://nim-lang.org/).


The integration is in early development, so breaking changes are possible - backward compatibility is not guaranteed yet.


This integration is being used by an indie development team to create a mobile strategy game. That game runs on iOS, Android, Windows and Mac.

## Why Nim?

Nim is a native programming language that allows excellent programming productivity while not sacrificing the application's performance. It compiles directly into C++, so almost all the features UE4 provides can be made available in Nim.


Nim's syntax and semantics are simple and elegant, so Nim can be easily taught to scripters in game development teams. Nim also has rich support for meta-programming, allowing you to extend capabilities of Nim, which is great for the variety of domains a game developer usually encounters.

## Features

* Gameplay programming (most of the basic classes are available, more wrappers coming soon)
* Blueprint support
* Delegate declaration and usage support
* Support for UProperty and UFunction macros and their specifiers

The integration lacks support for:

* Creating editor extensions (coming soon)
* Creating Unreal plug-ins with Nim
* Debugging Nim code directly. But since Nim functions map to C++ functions clearly, you can use existing C++ debugging and profiling tools.

## Getting Started

See the [Getting Started](https://github.com/pragmagic/nimue4/wiki/Getting-Started) page on the wiki.

If you are new to Nim, make sure to see the [Learn section](http://nim-lang.org/learn.html) of the Nim's website.

See [NimPlatformerGame](https://github.com/pragmagic/NimPlatformerGame) repo for a sample of a game written on Nim.

## Documentation

See the repo's [wiki](https://github.com/pragmagic/nimue4/wiki/) for nimue4 documentation.

See the Nim website's [documentation section](http://nim-lang.org/documentation.html) for the Nim language documentation.

## Community
[![Join Nim Gitter channel](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/nim-lang/Nim)

If you have any questions or feedback for nimue4, feel free to submit an issue on GitHub.

* [Gitter](https://gitter.im/nim-lang/Nim) - you can discuss Nim and nimue4 here in real-time.
* The [Nim forum](http://forum.nim-lang.org/) - a place where you can ask questions and discuss Nim.

## Roadmap

High priority roadmap items include:

* Automated generation of wrappers for UE4 types
* UE4 plug-in that improves editor experience when working with Nim projects

## License

This project is licensed under the MIT license. Read [LICENSE](https://github.com/pragmagic/nimue4/blob/master/LICENSE) file for details.

Copyright (c) 2016 Xored Software, Inc.
