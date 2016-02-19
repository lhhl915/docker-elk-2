FROM weian404/docker-jdk:jdk8u66

ENV elasticsearch-version 2.2.0
ENV kibana-version 4.4.1

RUN curl -v -j -k -L \
      -o /opt/kibana-${kibana-version}-linux-x64.tar.gz \
      --insecure \
      https://download.elastic.co/kibana/kibana/kibana-${kibana-version}-linux-x64.tar.gz && \
      curl -v -j -k -L \
      -o /opt/elasticsearch-${elasticsearch-version}.tar.gz \
      --insecure \
      https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.1.1/elasticsearch-${elasticsearch-version}.tar.gz && \
    tar -xzvf /opt/kibana-${kibana-version}-linux-x64.tar.gz -C /opt/ && \
    tar -xzvf /opt/elasticsearch-${elasticsearch-version}.tar.gz -C /opt/ && \
    mv /opt/elasticsearch-${elasticsearch-version} /opt/elasticsearch && \
    mv /opt/kibana-${kibana-version}-linux-x64 /opt/kibana && \
    \
    /opt/kibana/bin/kibana plugin --install elastic/sense && \
    /opt/elasticsearch/bin/plugin install license && \
    /opt/elasticsearch/bin/plugin install marvel-agent && \
    /opt/kibana/bin/kibana plugin --install elasticsearch/marvel/latest && \
    \
    rm -rf /opt/kibana-${kibana-version}-linux-x64.tar.gz \
    rm -rf /opt/elasticsearch-${elasticsearch-version}.tar.gz
    chown daily:daily -R /opt/*

COPY supervisord.conf /etc/supervisord.conf
EXPOSE 5601 9200 9300

CMD ["supervisord","-n","-c","/etc/supervisord.conf"]
