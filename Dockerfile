# ==========================================
# Stage 1: Build the Maven Project
# ==========================================
FROM maven:3.8.8-eclipse-temurin-17 AS builder
WORKDIR /app

# Copy pom.xml and stage dependencies (cached)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the source code and build the WAR file
COPY src ./src
RUN mvn clean package -DskipTests -B

# ==========================================
# Stage 2: Run inside Tomcat
# ==========================================
FROM tomcat:10.1-jdk17-temurin

# Clean up default webapps to ensure a clean root context
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built WAR file from the builder stage as ROOT.war
COPY --from=builder /app/target/FashionStore.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
