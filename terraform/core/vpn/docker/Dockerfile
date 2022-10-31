FROM alpine:latest
ARG config
RUN apk --no-cache add wireguard-tools iptables ip6tables inotify-tools libqrencode
ENV config=$config
COPY ./setup.sh /opt/setup.sh
RUN echo "$config" > /etc/wireguard/wg0.conf
CMD ["/bin/bash", "/opt/setup.sh"]

