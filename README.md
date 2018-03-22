# ARPA UI

Configuration tool for the LAS+SPARQL keyword extractor web service [ARPA](https://github.com/jiemakel/arpa).

## Running in development

Requires gulp-cli (`npm i -g gulp-cli`).

Install dependencies:

`$ npm install && bower install`

Run:

`$ gulp serve`

The ARPA service url can be configured using the environment variable `ARPA_UI_ARPA_SERVICE_URL`:

`$ ARPA_UI_ARPA_SERVICE_URL=http://localhost:19991/ gulp serve`

## Running with Docker

Build:

`$ docker build -t arpa-ui .`

The ARPA service url can be given as a build arg (`arpa_url`):

`$ docker build -t --build-arg arpa_url=http://localhost:19991/ .`

Run:

`$ docker run --rm -p 3000:3000 --name arpa-ui arpa-ui`

The service is then running at http://localhost:3000
