module jwt

import time

const secret = 'b17989d7-57d2-4ffa-88ab-f6987feb3eec' // uuid_v4

const payload = JwtPayload{
	iss: 'vprod-workspase'
	sub: '0196b736-f807-73f0-8731-7a08c0ed75ea' // User unique identifier (Subject) | 用户唯一标识 (Subject)
	aud: ['api-service', 'webapp']
	exp: time.now().add_days(30).unix()
	nbf: time.now().unix()
	iat: time.now().unix()
	// JWT unique identifier (JWT ID), anti duplication and anti attack |  JWT唯一标识 (JWT ID)，防重防攻击
	jti: '5907af3a-3f5a-4086-aaeb-68eca283d8d2'
	// Custom Claims | 自定义业务字段
	roles:     ['admin', 'editor']
	client_ip: '192.168.1.100'
	device_id: 'device-xyz'
}

fn test_jwt_generate() {
	token := jwt_generate(secret, payload)
	dump(token)
}

fn test_jwt_verify() {
	token := jwt_generate(secret, payload)
	verify := jwt_verify(secret, token)
	dump(verify)
}
