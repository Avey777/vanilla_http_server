module http

import strings

const http_ok = 'HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n'.bytes()
const http_created = 'HTTP/1.1 201 Created\r\nContent-Type: application/json\r\n'.bytes()

const http_not_modified = 'HTTP/1.1 304 Not Modified\r\nContent-Length: 0\r\nConnection: close\r\n\r\n'.bytes()
const http_bad_request = 'HTTP/1.1 400 Bad Request\r\nContent-Length: 0\r\nConnection: close\r\n\r\n'.bytes()
const http_not_found = 'HTTP/1.1 404 Not Found\r\nContent-Length: 0\r\nConnection: close\r\n\r\n'.bytes()
const http_server_error = 'HTTP/1.1 500 Internal Server Error\r\nContent-Length: 0\r\nConnection: close\r\n\r\n'.bytes()

const content_length_header = 'Content-Length: '.bytes()
const connection_close_header = 'Connection: close\r\n\r\n'.bytes()

fn build_response(header []u8, body string) []u8 {
	mut sb := strings.new_builder(200)
	sb.write(header)!
	sb.write(content_length_header)!
	sb.write_string(body.len.str())!
	sb.write(u8(`\r`))!
	sb.write(u8(`\n`))!
	sb.write_string(body)
	return sb
}
