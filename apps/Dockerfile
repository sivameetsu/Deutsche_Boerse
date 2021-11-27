# referece image from alpine family
FROM alpine

# Upgrade the packages to avoid the vulnarability
RUN apk upgrade 

# Python3 installation
RUN apk add python3

# Pip3 installtion
RUN apk add py3-pip

# Setup the working directory
WORKDIR /usr/app

# Create the user and group to avoid the root privileges.
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy the dependencies files
COPY requirments.txt .

# To setup the user and group privileges from the application directory
RUN chown -R appuser:appgroup /usr/app

# swutch the user mode
USER appuser

# install the dependencies packages
RUN pip3 install -r requirments.txt

# copy the dependencies files
COPY . .

# Start the service
CMD ["python3", "app.py"]

