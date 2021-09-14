FROM node:14-alpine as ui-builder
RUN mkdir /usr/src/app
WORKDIR /usr/src/app
ENV PATH /usr/src/app/node_modules/.bin:$PATH
COPY package.json /usr/src/app/package.json
RUN npm install
RUN npm install -g @vue/cli
COPY . /usr/src/app

ARG VUE_APP_DEMO
ENV VUE_APP_DEMO $VUE_APP_DEMO
RUN npm run build

FROM nginx
COPY  --from=ui-builder /usr/src/app/dist /usr/share/nginx/html
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]