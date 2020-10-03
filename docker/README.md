
Ideally, this build should just dump the outputs via something like

```
docker create -ti --name dummy IMAGE_NAME bash
docker cp dummy:/path/to/file /dest/to/file
docker rm -f dummy
```
<https://stackoverflow.com/questions/22049212/copying-files-from-docker-container-to-host>