import grpc
from concurrent import futures
import time

# import the generated classes
# from definitions. import {$APP_NAME}Request, {$APP_NAME}Response
# from definitions. import {$APP_NAME}Servicer, add_{$APP_NAME}Servicer_to_server

# import running_message function
import running_message

# create a class to define the server functions, derived from
# running_message_pb2_grpc.RunningMessageServicer
class RunningMessageServer(RunningMessageServicer):

    # running_message.get_message is expose here
    # the request and resposne are of the data type
    # running_message_p2.RunningMessage
    def GetRunningMessage(self, request, context):
        response = RunningMessageResponse()
        response.message = running_message.return_message(request.distance, request.time)
        return response

server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))

add_RunningMessageServicer_to_server(RunningMessageServer(), server)

print('Starting server. Listening on port 50051')
server.add_insecure_port('[::]:50051')
server.start()

# since server.start() will not block,
# a sleep-loop is added to keep alive
try:
    while True:
        time.sleep(86400)
except KeyboardInterrupt:
    server.stop(0)
