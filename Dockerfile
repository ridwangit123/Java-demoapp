# -----------------------------
# Stage 1: Build the Java app
# -----------------------------
FROM maven:3.9.1-eclipse-temurin-17 AS build
WORKDIR /app

# Copy Maven files first (for caching)
COPY pom.xml .
COPY src ./src

# Build the app and skip tests + checkstyle
RUN mvn clean package -DskipTests -Dcheckstyle.skip=true

# -----------------------------
# Stage 2: Run the Java app
# -----------------------------
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app

# Copy the compiled JAR from the build stage
COPY --from=build /app/target/java-demoapp-*.jar app.jar

# Expose default Spring Boot port
EXPOSE 8080

# Command to run the app
ENTRYPOINT ["java", "-jar", "app.jar"]