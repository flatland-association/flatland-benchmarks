FROM rabbitmq:3.13.7-management
ARG WORKER_CONNECTION_TIMEOUT
RUN echo "consumer_timeout = $WORKER_CONNECTION_TIMEOUT" >> /etc/rabbitmq/conf.d/10-defaults.conf
ADD init.sh /init.sh
RUN chmod +x /init.sh
CMD ["/init.sh"]