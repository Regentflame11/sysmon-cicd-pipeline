FROM ubuntu:latest

# Install required utilities (procps is needed for top and free commands)
RUN apt-get update && apt-get install -y \
    dos2unix \
    procps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the sysmon.sh script into the container
COPY sysmon.sh /app/sysmon.sh

# Convert line endings to Unix-style
RUN dos2unix /app/sysmon.sh

# Ensure the script has execute permissions
RUN chmod +x /app/sysmon.sh

# Set the default command to execute sysmon.sh
CMD ["bash", "/app/sysmon.sh"]
