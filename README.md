# oxebanking-chat
Chat simples feito com TCP sockets escrito em Julia

# ChatServer in Julia
Project for the discipline of Programming Language Concepts.

This is an extension of a simple chat server written in Julia. Based on the project by Sid-Bhatia-0 on (https://github.com/Sid-Bhatia-0/SimpleChatServer.git).

It uses TCP sockets to communicate messages between a server and multiple clients.

### Getting Started
Follow these steps to test the chat server on you localhost:


1. Go inside the project directory and start the Julia REPL

    ```
    $ julia
    ```

2. Activate and instantiate the project from the Julia REPL

    ```
    julia> import Pkg; Pkg.activate("."); Pkg.instantiate()
    ```

    This might take some time. This will generate a `Manifest.toml` file inside the directory.

3. Exit the REPL

4. Run `server.jl` in your terminal
    ```
    $ julia --project=. server.jl
    ```

    Wait for the server to acknowldege that it has started listening.

5. Run `client.jl` in a few different terminals and start chatting.
    ```
    $ julia --project=. client.jl
    ```

    You will be prompted to enter a nickname. The nickname must be composed only of a-z, A-Z, and 0-9, and its length must be between 1 to 32 characters (both inclusive).

Clients may come and go, while the server will keep running. Press `Ctrl-c` to exit the processes.
