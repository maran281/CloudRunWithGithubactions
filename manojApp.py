#import the flask in python
from flask import Flask

#Create an instance of flask application
app = Flask(__name__)

#all the requests will be routed to this function
@app.route('/')
def hello_world():
    return "Gomu Gomu Noaa"

if __name__=="__main__":
    app.run(debug=True)