import grpc

from definitions.running_message_pb2 import RunningDetails
from definitions.running_message_pb2_grpc import RunningMessageStub

# open a gRPC channel
channel = grpc.insecure_channel('localhost:50051')

stub = RunningMessageStub(channel)

running_details = RunningDetails(distance=4.74, time=37.4)

response = stub.GetRunningMessage(running_details)

print(response.message)
