# zig_alarm

> This is a simple alarm (timer) application that runs on the CLI.

## Quick start

Check [Releases](https://github.com/tubone24/zig_alerm/releases) and download latest version.

```
Usage: zig_alarm <int> [unit]

Commands:

  int     Integer (default: seconds)
  unit    unit for int such as sec, min, hrs, day

General Options:

  -h, --help       Print command-specific usage
```

## run with zig

```
zig run src/main.zig
```

## fix format

```
zig fmt src/*.zig
```

## test

```
zig test src/*.zig
```

## Build

```
zig build
```
