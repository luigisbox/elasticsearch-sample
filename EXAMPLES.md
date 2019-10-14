```
POST /vi/lectures 
{
  "title": "Elasticsearch",
  "date": "5.10.2015",
  "length": 90
}

GET /vi/lectures/AVA0McaCinWDgnzEorMX

GET /vi/lectures/_mapping

GET /_analyze?analyzer=standard&text=George Formby Sr (1875–1921) was one of the greatest music hall performers of the early 20th century.

GET /_analyze?analyzer=english&text=George Formby Sr (1875–1921) was one of the greatest music hall performers of the early 20th century.

PUT /vi2 
{
  "settings": { 
    "analysis": {
      "analyzer": {
        "whitespace_asciifolding": {
          "tokenizer": "whitespace",
          "filter": ["asciifolding"] 
        }
      }
    }
  }
}

PUT /vi2 
{
  "settings": {
    "analysis": {
      "analyzer": {
        "ngram_asciifolding": {
          "tokenizer": "my_ngram",
          "filter": ["asciifolding", "lowercase"]
        }
      }, 
      "tokenizer": {
        "my_ngram": { 
          "type" : "nGram", 
          "min_gram" : "2",
          "max_gram" : "3"
        }
      }
    }
  }
}

GET /vi2/_analyze?analyzer=ngram_asciifolding {bača kráča pri teľati}

GET /vi2/_analyze?tokenizer=standard&filters=asciifolding,lowercase,shingle {bača kráča pri teľati}

GET /vi/_search?q=title:Elasticsearch

PUT /vi/lectures/AVA0McaCinWDgnzEorMX
{
  "tags": ["search"]
}

PUT /vi/lectures/AVA0McaCinWDgnzEorMX
{
  "title": "Elasticsearch",
  "date": "5.10.2015",
  "length": 90,
  "description": "Using elasticsearch for a fast & scalable real-time search", 
  "tags": ["search"]
}

POST /vi/lectures/AVA0McaCinWDgnzEorMX/_update 
{
  "script" : "ctx._source.tags += tag", 
  "params" : {
    "tag" : "elastic"
  }
}

DELETE /vi/lectures/AVA0McaCinWDgnzEorMX

POST /vi/lectures/_search
{
  "query": {
    "match": {
      "title": "Elasticsearch"
    }
  }

}

POST /vi/lectures/_search 
{
  "query": { 
    "fuzzy": {
      "title": "Elastisearch"
    }
  } 
}

POST /vi/lectures/_search 
{
  "query": { 
    "range": {
      "length": { 
        "gte": 90
      }
    }
  } 
}

POST /vi/lectures/_search
{
  "query": {
    "bool": {
      "must": { 
        "range": {
          "length": {             
            "gte": 90
          }
        }
      }, 
      "should": [
        {"match": {"tag": "search"}},
        {"match": {"tag": "java"}}
      ]
    }
  }
}

POST /vi/lectures/_search 
{
  "query": { 
    "match": {
      "description": "Elasticsearch"
    }
  },
  "highlight": {
    "fields": { 
      "description": {}
    }
  }
}

POST /vi/lectures
{
  "title": "Inverted indices",
  "date": "1.10.2015",
  "length": 120,
  "description": "Deep dive into inverted indices",
  "tags": ["search", "index"]
}

POST /vi/lectures
{
  "title": "Relevance models",
  "date": "16.10.2015",
  "length": 110,
  "description": "Full-text scoring models",
  "tags": ["search", "tfidf", "bm25"]
}

POST /vi/lectures
{
  "title": "Beyond fulltext",
  "date": "21.10.2015",
  "length": 110,
  "description": "b-tree indices",
  "tags": ["search", "b-tree"]
}

POST /vi/lectures/_search
{
  "query": { 
    "match": {
      "_all": "indices" 
    }
  }
}

POST /vi/lectures/_search 
{
  "query": { 
    "bool": {
      "should": [
        {
          "match": {
            "description": { 
              "query": "search", 
              "boost": 2
            }
          }
        },
        {
          "match": {"tags": "index"}
        }
      ]
    }
  }
}

POST /vi/lectures/_search
{
  "query": {
    "function_score": {
      "query": {
        "match": {
          "_all": "search" 
        }
      }, 
      "field_value_factor": {
        "field": "length" 
      }
    }
  }
}

POST /vi/lectures/_search
{
  "query": { 
    "function_score": {
      "query": { 
        "match": {"_all": "search" }
      },
      "boost_mode": "replace", 
      "script_score": {
        "script": "1/doc['length'].value" 
      }
    }
  }
}

POST /vi/lectures/_search
{
  "query": { 
    "match": {"_all": "search"}
  }, 
  "aggregations": {
    "top_tags": { 
      "terms": {
        "field": "tags"
      },
      "aggregations": { 
        "by_length": {
          "histogram": { 
            "field": "length", 
            "interval": 100
          }
        },
        "stats": {
          "stats": {
            "field": "length"
          }
        }
      } 
    }
  } 
}
```
