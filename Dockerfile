#fetching a base image for your image, in this case python slim version 3.9
FROM python:3.9-slim

#setting the environmental variable
ENV PYTHONBUFFERED True

#copying the file from source(current directory) to the target directory(inside the image)
COPY requirements.txt ./

#installing all the required tools needed for your application to run
RUN pip install -r requirements.txt

ENV app_home /app

#creating a working directory which means, from now on 
#all the command will be executed from this directory
WORKDIR ${app_home}

#copy everything from the current location to the 
#target location which will be /app due to above command
COPY . ./

#command to be executed when the container starts
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 manojApp:app
