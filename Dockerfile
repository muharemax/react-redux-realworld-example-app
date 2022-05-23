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

#Run Stage Start
FROM nginx:latest

#Copy production build files from builder phase to nginx
COPY --from=builder /usr/app/build /usr/share/nginx/html