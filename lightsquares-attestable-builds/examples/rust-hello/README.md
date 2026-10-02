# rust-hello

Minimal Attestable Builds layout. Test it exactly as the platform builds it:

```bash
podman build -t ab-builder -f Dockerfile docker/
podman run --rm -v "$PWD:/workspace:Z" -w /workspace ab-builder ./build.sh
ls -l target/release/hello
```
