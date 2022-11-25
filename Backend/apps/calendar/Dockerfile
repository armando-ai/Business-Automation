FROM node:alpine As development

WORKDIR /usr/src/app

COPY tsconfig.json ./
COPY package*.json ./
COPY prisma ./prisma/
COPY . .
ENV GENERATE_SOURCEMAP=false


ENV TZ=America/Utah
RUN npm install
RUN npm run build
RUN npx prisma generate
RUN apk add -U tzdata

FROM node:alpine as production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}
ENV GENERATE_SOURCEMAP=false
ENV TZ=America/Utah
WORKDIR /usr/src/app

COPY tsconfig.json ./
COPY package*.json ./
COPY ./prisma ./prisma/

RUN npm install --only=production
RUN npx prisma generate
COPY . .

COPY --from=development /usr/src/app/dist ./dist

# 
CMD ["node", "dist/apps/calendar/main"]
# CMD ["npx prisma migrate dev --name init"]