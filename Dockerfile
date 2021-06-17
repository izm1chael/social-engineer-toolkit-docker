FROM ubuntu:latest

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV DEBIAN_FRONTEND=noninteractive


# Install dependencies
RUN apt-get update -y
RUN apt-get upgrade -y 
RUN apt-get install -y build-essential \
    libreadline-dev \
    libssl-dev libpq5 \
    libpq-dev \
    libreadline5 \
    libsqlite3-dev \
    libpcap-dev \
    git-core \
    autoconf \
    postgresql \
    pgadmin3 \
    curl \
    zlib1g-dev \
    libxml2-dev \
    libxslt1-dev \
    libyaml-dev \
    gawk bison \
    libffi-dev \
    libgdbm-dev \
    libncurses5-dev \
    libtool \
    sqlite3 \
    libgmp-dev \
    gnupg2 \
    dirmngr \
    python3-pip \
    software-properties-common \
    openjdk-8-jdk \
    openjdk-8-jre \
    automake \
    build-essential \
    patch ruby-bundler \
    ruby-dev zlib1g-dev \
    liblzma-dev \
    git \
    postgresql-contrib \
    postgresql-client \
    ruby python \
    dialog apt-utils \
    nmap \
    nasm \
    libssl-dev \
    python3-dev \
    cargo

RUN echo 'JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64\n\
JRE_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre'\
>> /etc/environment

# Install Metasploit framework
RUN cd /opt && \
    curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
    chmod 755 msfinstall && \
    ./msfinstall

WORKDIR /tmp
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -y | sh

# Clone SETOOLKIT
WORKDIR /opt
RUN git clone https://github.com/trustedsec/social-engineer-toolkit.git
# Change Working Directory
WORKDIR /opt/social-engineer-toolkit
RUN pip3 install setuptools-rust
RUN pip3 install -r requirements.txt
RUN python3 setup.py 

WORKDIR /opt/social-engineer-toolkit
ENTRYPOINT [ "./setoolkit" ]
