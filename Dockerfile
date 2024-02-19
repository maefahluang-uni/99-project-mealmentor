FROM node:7.7-alpine

install deps
ADD package.json /tmp/package.json
RUN cd /tmp && npm install

Copy deps
RUN mkdir -p /opt/mealmentor-app && cp -a /tmp/node_modules /opt/mealmentor

Setup workdir
WORKDIR /opt/mealmentor-app
COPY . /opt/mealmentor-app

run
EXPOSE 3000
CMD ["npm", "start"]