# Use a JDK 21 image as the base for the build stage
FROM openjdk:21-jdk-slim as build

# Install Maven (since it's not pre-installed in openjdk images)
RUN apt-get update && apt-get install -y maven

# Set the working directory inside the container
WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the source code and package the application
COPY src /app/src
RUN mvn clean package -DskipTests

# Use a smaller JDK 21 image for the runtime stage
FROM openjdk:21-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/target/Pal-0.0.1-SNAPSHOT.jar /app/Pal.jar

# Run the JAR file
CMD ["java", "-jar", "/app/Pal.jar"]
