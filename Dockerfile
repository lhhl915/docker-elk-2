FROM weian404/docker-jdk:jdk8u66

RUN curl -v -j -k -L \
      -o /opt/kibana.tar.gz \
      --insecure \
      https://download.elastic.co/kibana/kibana/kibana-4.5.1-linux-x64.tar.gz

RUN curl -v -j -k -L \
      -o /opt/elasticsearch.tar.gz \
      --insecure \
      https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.3.3/elasticsearch-2.3.3.tar.gz

RUN tar -xzvf /opt/kibana.tar.gz -C /opt/ && \
    tar -xzvf /opt/elasticsearch.tar.gz -C /opt/ && \
    rm -rf /opt/elasticsearch.tar.gz && \
    rm -rf /opt/kibana.tar.gz && \
    mv elasticsearch* elasticsearch && \
    mv kibana* kibana

RUN cd /opt/kibana && \
    bin/kibana plugin --install elastic/sense && \
    bin/kibana plugin --install elasticsearch/marvel/latest

RUN cd /opt/elasticsearch && \
    bin/plugin install license && \
    bin/plugin install marvel-agent

COPY config/ /opt/elasticsearch/config/

RUN chown daily:daily -R /opt/*

COPY supervisord.conf /etc/supervisord.conf
EXPOSE 5601 9200 9300

CMD ["supervisord","-n","-c","/etc/supervisord.conf"]
