FROM httpd:latest
ENV PA_PASSWORD mypassword
# RUN cat /etc/hosts | grep -v ^127 > /tmp/host
# RUN echo 127.0.0.1       localhost openam.acme.cat www.acme.cat acme.cat > /etc/hosts
# RUN cat /tmp/host >> /etc/hosts
RUN apt-get update || true
RUN apt-get install -y wget unzip
RUN wget --show-progress --progress=bar:force:noscroll --quiet --output-document=/tmp/Apache_v24_Linux_64bit_4.1.1.zip https://github.com/OpenIdentityPlatform/OpenAM-Web-Agents/releases/download/4.1.1/Apache_v24_Linux_64bit_4.1.1.zip
RUN unzip /tmp/Apache_v24_Linux_64bit_4.1.1.zip -d /usr/
RUN rm /tmp/Apache_v24_Linux_64bit_4.1.1.zip
RUN echo $PA_PASSWORD > /tmp/pwd.txt
RUN cat /tmp/pwd.txt
RUN cat /etc/issue
RUN /usr/web_agents/apache24_agent/bin/agentadmin --s "/usr/local/apache2/conf/httpd.conf" "http://openam.acme.cat:8080/openam" "http://www.acme.cat:80" "/" "apache_agent" "/tmp/pwd.txt" --acceptLicence --changeOwner || true
RUN cat /usr/web_agents/apache24_agent/bin/../log/*.log
