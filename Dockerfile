FROM weian404/docker-jdk:jdk8u66

RUN curl -v -j -k -L \
      -o /opt/kibana-4.3.1-linux-x64.tar.gz \
      --insecure \
      https://download.elastic.co/kibana/kibana/kibana-4.3.1-linux-x64.tar.gz && \
    curl -v -j -k -L \
      -o /opt/elasticsearch-2.1.1.tar.gz \
      --insecure \
      https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.1.1/elasticsearch-2.1.1.tar.gz && \
    tar -xzvf /opt/kibana-4.3.1-linux-x64.tar.gz -C /opt/ && \
    tar -xzvf /opt/elasticsearch-2.1.1.tar.gz -C /opt/ && \
    mv /opt/elasticsearch-2.1.1 /opt/elasticsearch && \
    mv /opt/kibana-4.3.1-linux-x64 /opt/kibana && \
    \
    /opt/kibana/bin/kibana plugin --install elastic/sense && \
    /opt/elasticsearch/bin/plugin install license && \
    /opt/elasticsearch/bin/plugin install marvel-agent && \
    /opt/kibana/bin/kibana plugin --install elasticsearch/marvel/latest && \
    \
    chown daily:daily -R /opt/*

COPY supervisord.conf /etc/supervisord.conf
EXPOSE 5601 9200

CMD ["supervisord","-n","-c","/etc/supervisord.conf"]
