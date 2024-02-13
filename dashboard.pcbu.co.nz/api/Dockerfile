FROM node:10.24.1

RUN npm install -g pm2

RUN mkdir /pcbu
WORKDIR /pcbu
COPY . .

RUN npm install

CMD ["pm2-runtime", "./app/app.js"]
