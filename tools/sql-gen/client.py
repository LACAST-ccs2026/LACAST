import socket
import sys

def main():
    HOST = "127.0.0.1"
    PORT = 4619  # Default port matches server default

    try:
        with socket.create_connection((HOST, PORT), timeout=5) as sock:
            sock.settimeout(10)
            print(f"Connected to {HOST}:{PORT}")
            print("Commands: test: query 0 N | learn: query 0 N | learnR: query 0 N | exit")
            print("Tip: You can also start server with custom port: java -jar SQLCraft-1.0.jar config.json <port>\n")

            recv_buffer = ""

            def recv_line():
                nonlocal recv_buffer
                while "\n" not in recv_buffer:
                    data = sock.recv(4096)
                    if not data:
                        return None
                    recv_buffer += data.decode("utf-8")
                line, recv_buffer = recv_buffer.split("\n", 1)
                return line

            while True:
                cmd = input("> ").strip()
                if not cmd:
                    continue
                
                # Shortcut: if only number, convert to test: query 0 <number>
                if cmd.isdigit():
                    cmd = f"test: query 0 {cmd}"

                sock.sendall((cmd + "\n").encode("utf-8"))

                if cmd.lower() == "exit":
                    line = recv_line()
                    print(line)
                    break

                sql_count = 0
                yes_count = 0
                
                while True:
                    line = recv_line()
                    if line is None:
                        print("server closed")
                        return

                    line = line.rstrip("\r\n")
                    
                    if line == "END":
                        print(f"\n--- Received {sql_count} SQL statements")
                        if yes_count > 0:
                            print(f"--- {yes_count} matched recorded rules (yes)")
                        break
                    
                    if line.startswith("ERROR:"):
                        print(line)
                        break
                    
                    if line == "yes":
                        yes_count += 1
                        print("  [yes]")
                    else:
                        sql_count += 1
                        print(f"SQL {sql_count}: {line}")

    except ConnectionRefusedError:
        print("Error: Cannot connect to server. Is it running?")
        print("Start server with: java -jar SQLCraft-1.0.jar configs/mysql/config.json 5000")
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
