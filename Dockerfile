# ===== STAGE 1: BUILD =====
FROM maven:3.9.6-eclipse-temurin-17 AS build

ARG GITHUB_USERNAME
ARG GITHUB_TOKEN

WORKDIR /app

# Copia settings
COPY settings.xml /root/.m2/settings.xml

# Exporta ARG como ENV (pra Maven enxergar)
ENV GITHUB_USERNAME=${GITHUB_USERNAME}
ENV GITHUB_TOKEN=${GITHUB_TOKEN}

# Copia projeto
COPY pom.xml .
COPY src ./src

# Build direto (SEM dependency:resolve)
RUN mvn -B -DskipTests package


# ===== STAGE 2: RUNTIME =====
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]
