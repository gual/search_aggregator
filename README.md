# README

This rails app is an API that provides a search endpoint.

This was developed as a search engine runner that only requires modifying a YAML file in order to add a new engine.

# Configuration file
The engines configuration file is located at `config/engines.yml`.

Each engine configuration requires the following items:
* The key to identify the engine. This will also be the parent conf item.
* `path`: The URL where the request has to be made.
* `search-parameter`: The parameter for the search term.
* `query-parameters`: List of other parameters required for the engine and their corresponding value.
* `headers`: List of headers required for the engine and their corresponding value.
* `results`: The children of this element hold the structure of the engine response.
  * `path`: The JSON path in which the results items are found. Each level must be separated by a dot. _webPages.value_ is an example.
  * `title`: The property name in which the title is returned.
  * `url`: The property name in which the title is returned.
  * `snippet`:  The property name in which the snippet is returned.

## Example
```yaml
default: &default
  google:
    path: https://www.googleapis.com/customsearch/v1
    search-parameter: q
    query-parameters:
      cx: 975e4e
      key: RFRpbrCw
    results:
      path: items
      title: title
      url: link
      snippet: snippet
  bing:
    path: https://api.cognitive.microsoft.com/bing/v7.0/search
    search-parameter: q
    headers:
      ocp-apim-subscription-key: fdfa9d4a7b581fe4a8c4bb2fc218ca34
    results:
      path: webPages.value
      title: name
      url: url
      snippet: snippet

development:
  <<: *default

production:
  <<: *default
```
