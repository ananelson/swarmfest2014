# Run MASON simulations and generate reports from output.
FROM       phusion/baseimage
MAINTAINER Ana Nelson <ana@ananelson.com>

# locales are necessary for Python to operate as expected.
RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 || :

# Use squid deb proxy (if available on host OS)
# as per https://gist.github.com/dergachev/8441335
ENV HOST_IP_FILE /tmp/host-ip.txt
RUN /sbin/ip route | awk '/default/ { print "http://"$3":8000" }' > $HOST_IP_FILE
RUN HOST_IP=`cat $HOST_IP_FILE` && curl -s $HOST_IP | grep squid && echo "found squid" && echo "Acquire::http::Proxy \"$HOST_IP\";" > /etc/apt/apt.conf.d/30proxy || echo "no squid"

# Update the system
RUN apt-get update

# Install system utils.
RUN apt-get install -y build-essential
RUN apt-get install -y adduser
RUN apt-get install -y curl
RUN apt-get install -y sudo

# Install nice things to have.
RUN apt-get install -y ack-grep
RUN apt-get install -y strace
RUN apt-get install -y vim
RUN apt-get install -y wget
RUN apt-get install -y unzip
RUN apt-get install -y tree
RUN apt-get install -y rsync

# Fake fuse install so we can install openjdk
RUN apt-get install -y fuse || :
RUN rm -rf /var/lib/dpkg/info/fuse.postinst
RUN apt-get install -y fuse

### "install-jdk"
RUN apt-get install -y openjdk-7-jdk

### "install-python"
RUN apt-get install -y python
RUN apt-get install -y python-dev
RUN apt-get install -y python-pip
RUN pip install dexy

### "install-r"
RUN apt-get install -y r-base
ENV CRAN_MIRROR http://cran.case.edu/
RUN R -e "install.packages(\"plyr\", repos=\"$CRAN_MIRROR\")"

### "create-user"
RUN useradd -m -p $(perl -e'print crypt("foobarbaz", "aa")') repro
RUN adduser repro sudo

# Set up user home
ENV HOME /home/repro
USER repro
WORKDIR /home/repro
