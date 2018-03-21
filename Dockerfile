FROM node:9

RUN npm i -g bower gulp-cli serve

COPY --chown=node package*.json .bowerrc bower.json /app/

USER node

WORKDIR /app/

RUN npm install && bower install

COPY --chown=node . /app/

ARG arpa_url=http://demo.seco.tkk.fi/arpa/

RUN sed -i "s;http://demo.seco.tkk.fi/arpa/;${arpa_url};" app/scripts/config.ls

RUN gulp dist

CMD serve --port 3000 -s dist
