# tinyfiledialogs-cr

Basic bindings and convenience class for using tinyfiledialogs in Crystal.

tinyfiledialogs and its information can be found here: [https://sourceforge.net/projects/tinyfiledialogs/](https://sourceforge.net/projects/tinyfiledialogs/)

Built against tinyfiledialogs 3.19.1 for Windows GNU and Linux.


## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     tinyfiledialogs-cr:
       github: captainjet/tinyfiledialogs-cr
   ```

2. Run `shards install`

## Usage

```crystal
require "tinyfiledialogs-cr"
```

I cannot be asked to write good usage instructions. Please read the source file for commented documentation.

## Development

Clone the tinyfiledialogs repo. I built the .a files on arch with the following commands:
```
gcc -static -c -o libtinyfiledialogs.a tinyfiledialogs.c
x86_64-w64-mingw32-gcc -static -c -o libtinyfiledialogs.a tinyfiledialogs.c
```

Moving the files as necessary. **Only usable on Crystal GNU for Windows development.**

## Contributing

1. Fork it (<https://github.com/captainjet/tinyfiledialogs-cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Robert Rowe](https://github.com/captainjet) - creator and maintainer
