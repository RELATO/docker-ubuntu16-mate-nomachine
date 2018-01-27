FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get install -y software-properties-common python-software-properties python3-software-properties sudo
RUN add-apt-repository universe
RUN apt-get update -y && apt-get install -y vim xterm pulseaudio cups curl libgconf2-4 iputils-ping libnss3-1d libxss1 wget xdg-utils libpango1.0-0 fonts-liberation

# Configure timezone and locale to spanish and America/Bogota timezone. Change locale and timezone to whatever you want
ENV LANG="pt_BR.UTF-8"
ENV LANGUAGE=pt_BR

RUN echo "America/Sao_Paulo" > /etc/timezone && \
    apt-get install -y language-pack-pt && \
    sed -i -e "s/# $LANG.*/$LANG.UTF-8 UTF-8/" /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=$LANG
RUN locale-gen pt_BR.UTF-8 && locale-gen pt_BR

# Install the mate-desktop-enviroment version you would like to have
RUN apt-get update -y && \
    apt-get install -y mate-desktop-environment-extras

# download tor, firefox, libreoffice and git
# RUN add-apt-repository ppa:webupd8team/tor-browser
# RUN apt-get update -y && apt-get install -y tor firefox htop nano git vim tor-browser
# RUN add-apt-repository ppa:ubuntu-mozilla-security/ppa
# RUN apt-get update -y && apt-get install -y language-pack-gnome-pt firefox htop nano git vim

RUN wget "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=pt-BR" -O firefox.tar.bz2
RUN tar -jxvf  firefox.tar.bz2 -C /opt/
# RUN mv /opt/firefox*/ /opt/firefox
RUN ln -sf /opt/firefox/firefox /usr/bin/firefox
RUN echo -e '[Desktop Entry]\n Version=57.0.1\n Encoding=UTF-8\n Name=Mozilla Firefox\n Comment=Navegador Web\n Exec=/opt/firefox/firefox\n Icon=/opt/firefox/browser/icons/mozicon128.png\n Type=Application\n Categories=Network' | sudo tee /usr/share/applications/firefox.desktop
RUN chmod +x /usr/share/applications/firefox.desktop

# Goto https://www.nomachine.com/download/download&id=10 and change for the latest NOMACHINE_PACKAGE_NAME and MD5 shown in that link to get the latest version.
ENV NOMACHINE_PACKAGE_NAME nomachine_6.0.66_2_amd64.deb
ENV NOMACHINE_MD5 0176d029267523a38e65b0119cde263d
# Install nomachine, change password and username to whatever you want here
RUN curl -fSL "http://download.nomachine.com/download/6.0/Linux/${NOMACHINE_PACKAGE_NAME}" -o nomachine.deb \
&& echo "${NOMACHINE_MD5} *nomachine.deb" | md5sum -c - \
&& dpkg -i nomachine.deb

ADD nxserver.sh /

ENTRYPOINT ["/nxserver.sh"]
