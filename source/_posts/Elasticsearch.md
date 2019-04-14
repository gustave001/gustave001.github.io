---
title: Elasticsearch
tags: [Elasticsearch]
date: 2019-03-27 10:19:12
updated: 2019-04-14 23:32:17
categories: 好奇尚异
---

# 安装ES
```yaml
version: '3.3'
services:
  elasticsearch:
    image: wutang/elasticsearch-shanghai-zone:6.3.2
    container_name: elasticsearch
    restart: always
    ports:
      - 9200:9200
      - 9300:9300
    environment:
      cluster.name: elasticsearch
```

# 连接ES
```java
    @Test
    public void testElasticsearch() throws UnknownHostException {
        Settings settings = Settings.builder()
                .put("cluster.name", "elasticsearch")
                .put("client.transport.sniff", false)
                .build();
        TransportClient client = new PreBuiltTransportClient(settings);

        client.addTransportAddress(new TransportAddress(InetAddress.getByName("192.168.147.128"),9300));
        
        GetResponse response = client.prepareGet("accounts", "person", "1").get();

        System.out.println(response.toString());

    }
```