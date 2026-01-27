# ===== STAGE 1: BUILD =====
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copia apenas arquivos de dependência primeiro (cache)
COPY pom.xml .
COPY settings.xml /root/.m2/settings.xml

# Baixa dependências (usa cache do Docker)
RUN mvn -B -e -DskipTests dependency:go-offline

# Agora copia o código
COPY src ./src

# Build do projeto
RUN mvn -B -DskipTests package


# ===== STAGE 2: RUNTIME =====
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copia o jar gerado
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]
