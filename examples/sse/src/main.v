module main

import enghitalo.vanilla.http_server
import enghitalo.vanilla.request_parser
import time
import sync

// Shared state to manage connected SSE clients
struct ClientManager {
mut:
	clients map[int]int
	mutex   &sync.Mutex = sync.new_mutex()
}

fn sse_handler(client_conn_fd int, mut manager ClientManager) {
	println('New SSE client connected: ${client_conn_fd}')

	manager.mutex.lock()
	manager.clients[client_conn_fd] = client_conn_fd // Using client_conn_fd as a simple identifier
	manager.mutex.unlock()

	headers := 'HTTP/1.1 200 OK\r\n' + 'Content-Type: text/event-stream\r\n' +
		'Cache-Control: no-cache\r\n' + 'Connection: keep-alive\r\n' +
		'Access-Control-Allow-Origin: *\r\n\r\n'
	C.send(client_conn_fd, headers.str, headers.len, 0)

	// Keep the connection alive and listen for events
	for {
		time.sleep(1 * time.second) // Keep the thread alive
		// Client disconnection is handled by the server (EPOLLHUP/EPOLLERR)
	}
}

// send_notification Broadcasts a message to all connected clients
fn send_notification(mut manager ClientManager, message string) {
	println('Sending notification to all clients: ${message}')
	manager.mutex.lock()
	for client_conn_fd, _ in manager.clients {
		println('Sending to client: ${client_conn_fd}')
		event := 'data: ${message}\n\n'
		sent := C.send(client_conn_fd, event.str, event.len, 0)
		if sent < 0 {
			// Remove disconnected clients
			manager.clients.delete(client_conn_fd)
		}
	}
	manager.mutex.unlock()
}

fn handle_request(req_buffer []u8, client_conn_fd int, mut manager ClientManager) ![]u8 {
	req := request_parser.decode_http_request(req_buffer)!
	method := unsafe { tos(&req.buffer[req.method.start], req.method.len) }
	path := unsafe { tos(&req.buffer[req.path.start], req.path.len) }

	if method == 'GET' && path == '/sse' {
		// Spawn a new thread to handle the SSE connection
		spawn sse_handler(client_conn_fd, mut manager)
		// Return an empty response to keep the connection open
		return []u8{}
	} else if method == 'POST' && path == '/notification' {
		notification := 'Notification at ${time.utc().format_ss()}'
		spawn send_notification(mut manager, notification)
		return 'HTTP/1.1 200 OK\r\nContent-Length: 0\r\nConnection: close\r\n\r\n'.bytes()
	}

	return http_server.tiny_bad_request_response
}

fn main() {
	mut manager := ClientManager{}

	mut vanilla := http_server.Server{
		request_handler: fn [mut manager] (req_buffer []u8, client_conn_fd int) ![]u8 {
			return handle_request(req_buffer, client_conn_fd, mut manager)
		}
		port:            3001
	}

	println('Server running on http://localhost:3001')
	vanilla.run()
}
