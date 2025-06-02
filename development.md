# Development notes

## Installing in development

### Building from source

Build the spoon and install it from the command-line:

```sh
make didist/GridCraft.spoon/version.txt
mkdir -p ~/.hammerspoon/Spoons
cp -r dist/GridCraft.spoon ~/.hammerspoon/Spoons/
```

(You can also double-click the `GridCraft.spoon` directory in the Finder and it should install it for you.)

### Installing in development

For development, you may want to use the repo directly:

```sh
cd /path/to/GridCraft
make phosphor
cd ~/.hammerspoon/Spoons
ln -s /path/to/GridCraft/spoon GridCraft.spoon
```

## Releasing new versions

Releases are based on Git tags.

```sh
git commit -a
git tag v420.69.666
git push origin HEAD --tags
```

## Documentation

### Building `docs.json`

**We must build `site/data/docs.json` on a machine running Hammerspoon and commit it to the repo.**

This is required for API documentation, which is generated using Hammerspoon's regular tooling.
[Process described here](https://me.micahrl.com/blog/hammerspoon-docs-content-adapter/).

```sh
make site/data/docs.json
git add site/data/docs.json
git commit
```

### Docstrings

The Lua docstrings conform to the Hammerspoon format.

* You'll want to have the hammerspoon repo checked out so you can refer to it for examples
* Especially notice `module.lp`

### Making screen recordings

First make a recording with QuickTime.

For the gif:

```sh
ffmpeg -i input.mov -vf "fps=10,scale=320:-1:flags=lanczos" -c:v gif temp.gif
gifsicle -O3 --colors 128 temp.gif > output.gif
```

For a small web-playable .mp4 (not embeddable in a GitHub readme):

```sh
ffmpeg -i input.mov -vcodec libx264 -crf 28 -preset veryslow -acodec aac -movflags +faststart screenrecording.mp4
```
