FROM nginx

COPY ./janortop5.com/build/ /usr/share/nginx/html/janortop5.com/build/

COPY ./janortop5.conf /etc/nginx/conf.d/

RUN rm /etc/nginx/conf.d/default.conf

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]
