FROM centos:centos7
MAINTAINER Ernestas Poskus <hierco@gmail.com>
ENV container docker

RUN (cd /lib/systemd/system/sysinit.target.wants/; \
for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN yum clean all && \
    yum -y install epel-release && \
    yum -y install iproute PyYAML python-jinja2 python-httplib2 python-keyczar python-paramiko python-setuptools git python-pip

# Install/prepare Ansible
RUN mkdir -p /etc/ansible/
RUN mkdir -p /opt/ansible/roles
RUN printf '[local]\nlocalhost ansible_connection=local\n' > /etc/ansible/hosts
RUN pip install ansible

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
