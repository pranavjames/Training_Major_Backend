FROM eclipse-temurin:17

LABEL maintainer="pranavsur@cybage.com"

WORKDIR /app

COPY target/deccan-sport-club-1.1.jar /app/deccan-sport-club-1.1.jar

ENTRYPOINT ["java", "-jar", "deccan-sport-club-1.1.jar"]
