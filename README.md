# Nim Integration for Unreal Engine 4

This project contains Nim library and tools allowing to create Unreal Engine 4 games on Nim programming language.


The project is in early development, so breaking changes are possible - backward compatibility is not guaranteed yet.


The project is currently being used by an indie development team to create a mobile strategy game.

## Why Nim?

Nim is a native programming language that allows excellent programming productivity while not sacrificing the application's performance. It compiles directly into C++, so almost all the features UE4 provides can be made available in Nim.


Nim's syntax and semantics are simple and elegant, allowing Nim to be easily taught to scripters in game development teams. Nim also has reach meta-programming capabilities, allowing you to extend capabilities of Nim, which is great for the variety of domains a game developer usually encounters.

## Getting Started

### Setting up Nim and nimue4

1. Compile Nim for your platform as described at https://github.com/nim-lang/Nim/. Notice that nimue4 currently depends on `devel` branch (upcoming release) of Nim. So, after cloning the repository, run `git checkout devel`, and then follow the compilation instructions.

2. [Visual Studio Code](https://code.visualstudio.com/) is the recommended environment for working with Nim code. Install VSCode by following the instructions on the website, then install `nim` extension by bringing up the command palette (`ctrl-shift-p`), selecting `Install Extension` and typing `nim`. Also, install `c#` extension to work with C# code (UE4 build files).

3. Clone this repository into a folder of your choice. You will then specify that folder when setting up UE4 project(s):
`git clone https://github.com/pragmagic/nimue4.git`

### Setting up Unreal Engine 4

This library has been tested to work with Unreal Engine 4.10 and 4.11. It may work with earlier versions, too, as long as you don't use features added in recent versions. Note that the library intentionally doesn't provide wrappers for deprecated methods and fields.

Follow instructions on the [official Unreal Engine site](https://www.unrealengine.com/) to set up Unreal Engine 4.

### Setting up Unreal Project with Nim support

1. Create a new UE4 project using the Unreal Editor.
2. Put files from `nimue4/stubs/` folder into the project's root folder.
3. Change paths to nimue4 and Nim in `build.cmd` and `build.sh` files. If on Windows, change path to Visual Studio, if necessary.
4. Open the project's root folder in VSCode (`File` -> `Open Folder`).
5. Add these lines to the game module's build rules constructor (`YourGame.Build.cs`):
```csharp
var moduleDir = Path.GetDirectoryName(RulesCompiler.GetModuleFilename(this.GetType().Name));
PrivateIncludePaths.Add(Path.Combine(Environment.GetEnvironmentVariable("NIM_HOME"), "lib"));
PublicIncludePaths.Add(Path.Combine(moduleDir, ".nimgen", "Public"));
PrivateIncludePaths.Add(Path.Combine(moduleDir, ".nimgen", "Private"));
UEBuildConfiguration.bForceEnableExceptions = true;
```
6. Add these lines to `Config/DefaultEngine.ini`:
```ini
[/Script/Engine.Engine]
GameEngine=/Script/YourGame.NimGameEngine
```
7. From now on, run `build.cmd deploy` on Windows or `build.sh deploy` on OS X/Linux to compile and deploy your code.

## Documentation

See the project's [[wiki|Wiki]] for nimue4 documentation.

See the Nim website's [documentation section](http://nim-lang.org/documentation.html) for the Nim language documentation.

## Community [![nimue4 channel on Gitter](https://badges.gitter.im/gitterHQ/gitter.svg)](https://gitter.im/pragmagic/nimue4)

* Join the [Gitter channel](https://gitter.im/pragmagic/nimue4) for nimue4 conversations.
* The [Nim forum](http://forum.nim-lang.org/) - the best place to ask questions and to discuss Nim.
* [IRC (Freenode#nim)](https://webchat.freenode.net/?channels=nim) - the best place to discuss Nim in real-time.

If you have any questions or feedback, feel free to submit an issue on GitHub.

## License

This project is licensed under the MIT license. Read LICENSE file for details.

Copyright (c) 2016 Xored Software, Inc.
