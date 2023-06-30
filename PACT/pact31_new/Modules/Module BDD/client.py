import socket

address = ('127.0.0.1', 8000)
#msg = "Hello [Msg from client]".encode('utf-8')
msg = b"Hello [Msg from client]\n"

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM);


sock.connect(address)

while(True):

    out = sock.recv(1024).decode('utf-8')
    if out == "QUIT":
        break


    print(out)

    inp = input().encode('utf-8')
    sock.send(inp)





sock.close()
