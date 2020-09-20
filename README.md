# convert audio TS files to mp3 (requires vlc)

```shell
for i in *ts; do vlc -I dummy --sout "#transcode{vcodec=none,acodec=mp3,channels=2,samplerate=44100,scodec=none}:std{access=file,mux=raw,dst=$i.mp3}" "$i" vlc://quit; done
```
