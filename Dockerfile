#Specify a base image
FROM node:alpine as builder

#Specify a working directory
WORKDIR /usr/app

#Copy the dependencies file
COPY package*.json ./

#Install dependencies
RUN npm install

#Copy remaining files
COPY . .

#Build the project for production
RUN npm run build --verbose
#EXPOSE 4100
#CMD npm start

#Run Stage Start
FROM nginx:latest

#Copy production build files from builder phase to nginx
COPY --from=builder /usr/app/build /usr/share/nginx/html

#WORKDIR /usr/app
#COPY package*.json ./
#RUN npm install --production
#
#COPY --from=builder /usr/app/dist ./dist
#EXPOSE 4100
#CMD npm start
#COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
#COPY --from=build /app/build /usr/share/nginx/html