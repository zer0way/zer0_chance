FROM ubuntu:18.04
MAINTAINER Sad Cactus
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update
######################################
######################################
#########    *  PACKAGE *    #########
######################################
# tor
# mysql-server
#
######################################
RUN apt install -y vim wget ca-certificates xorgxrdp pulseaudio xrdp\
  xfce4 xfce4-terminal xfce4-screenshooter xfce4-taskmanager \
  xfce4-clipman-plugin xfce4-cpugraph-plugin xfce4-netload-plugin \
  xfce4-xkb-plugin xauth supervisor uuid-runtime locales \
  firefox pepperflashplugin-nonfree openssh-server sudo \
  nano netcat xterm curl git unzip  python-pip firefox xvfb \
  python3-pip gedit locate  libxml2-dev libxslt1-dev  \
  libmysqlclient-dev byobu locate
######################################
######################################
#########    *  FILES *    #########
######################################
######################################
ADD bin /usr/bin
ADD etc /etc
ADD shit /root
RUN tar xvf /root/proxy.tar.gz -C /usr/bin/
######################################
######################################
#########   *  Configure *   #########
######################################
######################################

# Configure
RUN mkdir -p ~/.ssh
RUN rm /etc/ssh/sshd_config
RUN locale-gen en_US.UTF-8
RUN cp /root/sshd_config /etc/ssh/
RUN echo "xfce4-session" > /etc/skel/.Xclients
RUN cp /root/authorized_keys  ~/.ssh/authorized_keys

RUN rm -rf /etc/xrdp/rsakeys.ini /etc/xrdp/*.pem
RUN echo "export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> ~/.bashrc
RUN echo "export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games" >> ~/.bashrc
RUN echo "export LC_ALL='en_US.utf8'" >> ~/.bashrc
#RUN wget https://raw.githubusercontent.com/l0se3x/anyway/master/authorized_keys
#RUN cat authorized_keys  >>  /etc/ssh/sshd_config
RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.23.0/geckodriver-v0.23.0-linux64.tar.gz 
RUN tar -xvf geckodriver-v0.23.0-linux64.tar.gz
RUN chmod +x geckodriver
RUN cp geckodriver /usr/bin/geckodriver


RUN pip3 install faker-e164 Faker mysql-connector PySocks stem torrequest bs4 selenium mysqlclient ConfigParser pymysql lxml fake_useragent

# Add sample user
RUN update-rc.d tor enable
RUN ssh-keygen -q -t rsa -N '' -f /id_rsa

RUN echo "root:1" | /usr/sbin/chpasswd
RUN addgroup uno
RUN useradd -m -s /bin/bash -g uno uno
RUN echo "uno:1" | /usr/sbin/chpasswd
RUN echo "uno    ALL=(ALL) ALL" >> /etc/sudoers


# Docker config

VOLUME ["/etc/ssh"]
EXPOSE 3389 22 9001 993 7513 1984 1985 1022
ENTRYPOINT ["sh","/usr/bin/docker-entrypoint.sh"]
CMD ["supervisord"]
