FROM ruby:2.6.5-alpine3.11 as production
RUN apk --update add nodejs yarn git build-base bash  mysql-dev sqlite-dev tzdata less
RUN mkdir /app
WORKDIR /app
COPY . .
RUN bundle install
RUN yarn
CMD ["bash"]

FROM production as development
RUN apk --update add vim
