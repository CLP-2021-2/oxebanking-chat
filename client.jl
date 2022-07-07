import Sockets

const SERVER_HOST = Sockets.localhost
const SERVER_PORT = 9000

function send_msg(socket, message)
    try
        println(socket, message)
    catch error
        @error error
        close(socket)
    end

    return nothing
end

function start_client(server_host, server_port)
    socket = Sockets.connect(server_host, server_port)

    @async while !eof(socket)
        println(readline(socket))
    end

    while isopen(socket)
        send_msg(socket, readline())
    end

    return nothing
end

start_client(SERVER_HOST, SERVER_PORT)