set -e
docker build -t mason/repro .
docker run -t -i \
    -v `pwd`:/home/repro/work \
    -v /home/ana/dev/dexy:/home/repro/dexy \
    mason/repro /bin/bash
