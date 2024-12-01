# kernel-nim
implementation kernel in nim programming

## notes

install gcc which is configure it ``i685-elf-gcc`` and ``i686-elf`` as executable in ``$HOME/cross-tools/bin/``

```bash
export PATH=$PATH:$HOME/cross-tools/bin
```

## running
using nim nakefile

- makesure to install nakefile first by
    ```bash
    nimble install nakefile
    ```
- and execute by using nakefile
```
nim c nakefile
./nakefile run
```
