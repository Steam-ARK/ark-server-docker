FROM cm2network/steamcmd:root

# 更新源
RUN sed -i s@/deb.debian.org/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN apt-get clean && \
    apt-get update -y && \
    apt-get upgrade -y

# 校准服务器时间
ENV TZ=Asia/Shanghai
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN apt-get install tzdata

# 安装系统 GBK 和 UTF-8 中文语言包
RUN apt-get install -y locales && \
    echo 'zh_CN.GBK GBK' >> /etc/locale.gen && \
    echo 'zh_CN.UTF-8 UTF-8' >> /etc/locale.gen && \
    echo "LANG=zh_CN.UTF-8" >> /etc/environment && \
    locale-gen

# 安装系统必要组件
RUN apt-get install -y curl wget vim zip unzip git telnet net-tools cron logrotate rsyslog tofrodos procps
RUN apt-get install -y python3 python3-pip
RUN ln -s /usr/bin/python3 /usr/bin/python && \
    ln -s /usr/bin/todos /usr/bin/unix2dos && \
    ln -s /usr/bin/fromdos /usr/bin/dos2unix 
RUN python -m pip install --upgrade pip


# 安装 ark-server-tools（没用）
# RUN apt-get install -y coreutils findutils perl rsync
# RUN apt-get install -y perl-modules lsof libc6-i386 libgcc1 bzip2
# RUN curl -sL https://git.io/arkmanager | bash -s steam

# 安装 ARK
# RUN arkmanager install
RUN mkdir -p /home/steam/bin
ADD ./bin/ark.sh /home/steam/bin/ark.sh


# 入口
WORKDIR /home/steam/steamcmd
RUN echo "alias ll='ls -l'" >> /root/.bashrc
ADD ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod a+x /docker-entrypoint.sh
ENTRYPOINT [ "/docker-entrypoint.sh" ]
