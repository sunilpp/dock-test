# builder 2016-06-12 09:46:49 -0700
FROM phusion/baseimage:0.9.18
MAINTAINER Unknown

ENV DISPLAY :100
ENV RBENV_ROOT /usr/local/rbenv

EXPOSE 9999

COPY Dockerfile /Dockerfile


RUN `# Creating user / Adjusting user permissions`                    &&       \
     (groupadd -g 501 builder || true)                                &&       \
     ((useradd -u 501 -g 501 -p builder -m builder) ||                         \
      (usermod -u 501 builder && groupmod -g 501 builder))            &&       \
     mkdir -p /home/builder                                           &&       \
     chown -R builder:builder /home/builder /opt                      &&       \
                                                                               \
    `# Updating Package List`                                         &&       \
     DEBIAN_FRONTEND=noninteractive apt-get update                    &&       \
                                                                               \
    `# Installing packages`                                           &&       \
     DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
     python-software-properties                                                \
     software-properties-common                                                \
                                                                               \
    `# Adding bitcoin PPA`                                            &&       \
     add-apt-repository -y ppa:bitcoin                                &&       \
                                                                               \
    `# Updating Package List`                                         &&       \
     DEBIAN_FRONTEND=noninteractive apt-get update                    &&       \
                                                                               \
    `# Installing packages`                                           &&       \
     DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
     curl git-core python-software-properties build-essential libssl-dev       \
                                                                               \
    `# Cleaning up after installation`                                &&       \
     DEBIAN_FRONTEND=noninteractive apt-get clean                     &&       \
     rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*                    &&       \
                                                                               \
    `# Creating /path/to/somefile.txt`                                &&       \
     mkdir -p /path/to                                                &&       \
     echo "This is the contents of the file" >> /path/to/somefile.txt &&       \
     echo "Hopefully this works for parsing" >> /path/to/somefile.txt &&       \
     chown builder:builder /path/to/somefile.txt                      &&       \
                                                                               \
    `# Defining startup script`                                       &&       \
     echo '#!/bin/sh -e' > /etc/rc.local                              &&       \
     echo "echo"Hello World!\"" >> /etc/rc.local                    &&      

ENTRYPOINT ["/sbin/my_init"]
CMD [""]
