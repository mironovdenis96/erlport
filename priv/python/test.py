import time
import sys
#import erlport modules and functions
from erlport.erlang import set_message_handler, cast
from erlport.erlterms import Atom
from datetime import datetime

message_handler = None #reference to the elixir process to send result to

#send message to pid
def cast_message(pid, message):
    cast(pid, message)

def register_handler(pid):
    #save message handler pid
    global message_handler
    message_handler = pid

def handle_message(count):
    print(datetime.now())

set_message_handler(handle_message)