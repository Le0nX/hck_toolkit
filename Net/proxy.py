import socket 
from threading import Thread

class Toonel2Server(Thread):
	def __init__(self, port, host, server):
		super(Toonel2Server, self).__init__()
		self.port = port
		self.host = host
		self.server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		self.server.connect((host,port)) 


	def run(self):
		while True:
			#main thread method...
			data = server.recv(4096)
			if data:
				#send to client...