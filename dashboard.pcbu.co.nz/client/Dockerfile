FROM node:10.24.1

RUN npm install bower@1.8.12 --global

RUN npm config set unsafe-perm true --global
RUN echo '{ "allow_root": true }' > /root/.bowerrc

RUN mkdir /pcbu
WORKDIR /pcbu
COPY package.json .
COPY package-lock.json .
RUN npm install

COPY . .

CMD rm -rf /assets/* && npm run revision && cp -r ./wwwRevisioned/* /assets
