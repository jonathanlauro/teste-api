# ===== STAGE 1: BUILD =====
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copia POM e settings primeiro (cache de deps)
COPY pom.xml .
COPY settings.xml /root/.m2/settings.xml

# Baixa dependências (SEM go-offline)
RUN mvn -B -DskipTests dependency:resolve dependency:resolve-plugins

# Agora copia o código
COPY src ./src

# Build do projeto
RUN mvn -B -DskipTests package


# ===== STAGE 2: RUNTIME =====
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

COPY --from=build /app/target/*jar app.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]
