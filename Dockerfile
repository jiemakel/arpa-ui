FROM node:9

RUN npm i -g bower gulp-cli serve

COPY --chown=node package*.json .bowerrc bower.json /app/

USER node

WORKDIR /app/

RUN npm install && bower install

COPY --chown=node . /app/

ARG arpa_url
ENV ARPA_UI_ARPA_SERVICE_URL ${arpa_url}

RUN gulp dist

CMD serve --port 3000 -s dist
