# Use lightweight Java 21 runtime
FROM eclipse-temurin:21-jdk

# Set maintainer
LABEL maintainer="rushikeshkendre.369@example.com"

# Create non-root user
RUN useradd -m booking-mss1

# Set working directory
WORKDIR /app

# Copy JAR file
COPY target/booking-mss1*.jar app.jar

# Change ownership (important for non-root)
RUN chown -R booking-mss1:booking-mss1 /app

# Switch to non-root user
USER booking-mss1

# Expose application port (Spring Boot default)
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "app.jar"]