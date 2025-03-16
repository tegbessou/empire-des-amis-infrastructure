FROM mariadb:10.11

COPY ./create-users-and-databases.sh /usr/local/bin/create-users-and-databases.sh
RUN chmod +x /usr/local/bin/create-users-and-databases.sh

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["mysqld"]
