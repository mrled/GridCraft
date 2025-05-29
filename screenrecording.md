# Making the screen recording

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