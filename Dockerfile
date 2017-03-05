FROM centos:7
MAINTAINER James Montalvo
ENV container=docker

# Install systemd -- See https://hub.docker.com/_/centos/
RUN yum -y update; yum clean all; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

# Install packages to get Docker up to minimal requirements
RUN yum makecache fast \
  && yum -y install deltarpm epel-release initscripts \
  && yum -y update \
  && yum -y install \
    selinux-policy \
    rsyslog \
    sudo \
    which

# Install the packages below for faster test builds

# Install packages from meza base role
RUN yum -y install \
    ntp \
    ntpdate \
    ntp-doc \
    openssh-server \
    openssh-clients \
    vim \
    net-tools \
    firewalld \
    selinux-policy \
    rsyslog \
    jq

# Install packages from base-extras role
RUN yum -y install \
    expect \
    expectk \
    perl \
    wget \
    gcc \
    cifs-utils

# Install packages from php and httpd
RUN yum -y install \
    httpd-devel \
    mod_ssl \
    mod_proxy_html \
    zlib-devel \
    sqlite-devel \
    bzip2-devel \
    pcre-devel \
    openssl-devel \
    curl-devel \
    libxml2-devel \
    libXpm-devel \
    gmp-devel \
    libicu-devel \
    t1lib-devel \
    aspell-devel \
    libcurl-devel \
    libjpeg-devel \
    libvpx-devel \
    libpng-devel \
    freetype-devel \
    readline-devel \
    libtidy-devel \
    libmcrypt-devel \
    pam-devel \
    sendmail \
    sendmail-cf \
    m4 \
    xz-libs \
    mariadb-libs

# Clean up
RUN yum clean all

# Disable requiretty
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers

VOLUME ["/sys/fs/cgroup"]
CMD ["/usr/sbin/init"]
