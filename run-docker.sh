set -e
docker build -t mason/repro .
docker run -t -i \
    -v `pwd`:/home/repro/work \
    mason/repro /bin/bash
