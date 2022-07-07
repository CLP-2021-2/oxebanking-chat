import Sockets

#Obter ip: localhost, Sockets.ip ou getipaddr()
const SERVER_HOST = Sockets.localhost
const SERVER_PORT = 9000

#Enviar mensagem para um dado socket
function send_msg(socket, message)

    #Controle de fluxo - tratamento de exceções - "try/catch statement"
    try
        println(socket, message)
    catch error
        #Macro padrão de erro
        @error error
        close(socket)
    end

    return nothing
end

#Função de saída do CHAT
function leave_chat(room, room_lock, socket, nickname)

    user_exit_message = "[$(nickname) saiu da sala!]"
    lock(room_lock) do
        pop!(room, socket)
        msg_to_all(room, user_exit_message)
    end

    close(socket)

    return nothing
end

#Envia a msg a todos do server
function msg_to_all(room, message)
    @info message

    for socket in room
        send_msg(socket, message)
    end

    return nothing
end

#Função de Conexão
function connection_chat(room, room_lock, socket, peername)
    @async begin
        send_msg(socket, "Digite seu nome:")
        nickname = readline(socket)

        if occursin(r"^[A-Za-z0-9]{1,32}$", nickname)
            user_entry_message = "[Conectado, $(nickname) entrou na sala!]"

            lock(room_lock) do
                push!(room, socket)
                msg_to_all(room, user_entry_message)
                send_msg(socket, "Digite '!SAIR' para sair do chat.")
            end

            while !eof(socket)
                user_message = readline(socket)

                if all(char -> isprint(char) && isascii(char), user_message)

                    if cmp(user_message, "!SAIR") == 0
                        break
                    else
                        broadcast_message = "$(nickname): $(user_message)"
                        lock(room_lock) do
                            msg_to_all(room, broadcast_message)
                        end
                    end

                else
                    @info "$(peername) mensagem inválida."
                    send_msg(socket, "[ERRO: Caracteres inválidos]")
                    close(socket)
                    break
                end
            end

            leave_chat(room, room_lock, socket, nickname)

        else
            @info "(ip,socket) = $(peername): Falha de conexão, usuário com nome inválido."
            

            send_msg(socket, "ERRO: Usar caracteres de a-z, A-Z, 0-9, sem acentos, Tamanho[Mín,Máx][1,32]")
            
            sleep(1)

            connection_chat(room, room_lock, socket, peername)
            
        end

        @info "(ip,socket) = $(peername) Desconectado "
    end
end

#Iniciar servidor
function start_server(server_host, server_port)
    room = Set{Sockets.TCPSocket}()

    room_lock = ReentrantLock()

    server = Sockets.listen(server_host, server_port)
    @info "Server iniciado com sucesso!"

    while true
        socket = Sockets.accept(server)

        peername = Sockets.getpeername(socket)
        @info "(ip,socket) = $(peername) Tentando conexão"

        connection_chat(room, room_lock, socket, peername)
    end

    return nothing
end

start_server(SERVER_HOST, SERVER_PORT)