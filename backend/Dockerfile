# Use Maven image to build the app
FROM maven:3.9.6-eclipse-temurin-17 AS build

# Set working directory inside container
WORKDIR /app

# Copy pom.xml and download dependencies first (to leverage Docker layer caching)
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build the Spring Boot app
RUN mvn clean package -DskipTests

# Use lightweight JDK to run the app
FROM eclipse-temurin:17-jdk-alpine

# Set working directory inside the container
WORKDIR /app

# Copy built JAR from previous stage
COPY --from=build /app/target/ecommerce-1.0-SNAPSHOT.jar app.jar

# Expose port (optional - based on what your app uses)
EXPOSE 8080

# Run the Spring Boot app
ENTRYPOINT ["java", "-jar", "app.jar"]


