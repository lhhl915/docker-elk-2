FROM weian404/docker-jdk:jdk8u66

RUN curl -v -j -k -L \
      -o /opt/kibana.tar.gz \
      --insecure \
      https://download.elastic.co/kibana/kibana/kibana-4.4.1-linux-x64.tar.gz

RUN curl -v -j -k -L \
      -o /opt/elasticsearch.tar.gz \
      --insecure \
      https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.2.0/elasticsearch-2.2.0.tar.gz

RUN tar -xzvf /opt/kibana.tar.gz -C /opt/ && \
    tar -xzvf /opt/elasticsearch.tar.gz -C /opt/ && \
    rm -rf /opt/elasticsearch.tar.gz && \
    rm -rf /opt/kibana.tar.gz

RUN /opt/kibana/bin/kibana plugin --install elastic/sense && \
    /opt/elasticsearch/bin/plugin install license && \
    /opt/elasticsearch/bin/plugin install marvel-agent && \
    /opt/kibana/bin/kibana plugin --install elasticsearch/marvel/latest

RUN chown daily:daily -R /opt/*

COPY supervisord.conf /etc/supervisord.conf
EXPOSE 5601 9200 9300

CMD ["supervisord","-n","-c","/etc/supervisord.conf"]
