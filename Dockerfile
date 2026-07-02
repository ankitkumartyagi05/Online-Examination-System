FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /workspace

COPY pom.xml ./
COPY src ./src
COPY schema.sql ./schema.sql

RUN mvn -q -DskipTests package

FROM tomcat:10.1.29-jre21-temurin
WORKDIR /usr/local/tomcat

RUN rm -rf webapps/ROOT webapps/ROOT.war
COPY --from=build /workspace/target/online-examination.war /usr/local/tomcat/webapps/ROOT.war

ENV DB_URL=jdbc:mysql://host.docker.internal:3306/online_examination \
    DB_INIT_URL=jdbc:mysql://host.docker.internal:3306/?allowMultiQueries=true \
    DB_USERNAME=root \
    DB_PASSWORD=

EXPOSE 8080
CMD ["catalina.sh", "run"]
