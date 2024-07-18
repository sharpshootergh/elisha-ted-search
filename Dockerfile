FROM maven:3.6.3-openjdk-8
WORKDIR /app
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
COPY . .
RUN mvn verify



ENTRYPOINT [ "entrypoint.sh" ]