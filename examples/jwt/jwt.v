// JWT标准声明 (Standard Claims) https://datatracker.ietf.org/doc/html/rfc7519#section-4.1
module jwt

import crypto.hmac
import crypto.sha256
import encoding.base64
import json
import x.json2
import time

// JWT head fixed using HS256 algorithm | JWT 头部固定使用HS256算法
const header = base64.url_encode_str(json.encode(JwtHeader{
	alg: 'HS256'
	typ: 'JWT'
}))

// Generate Token | 生成令牌
pub fn jwt_generate(secret string, payload JwtPayload) string {
	playload_64 := base64.url_encode_str(json.encode(payload))

	message := '${header}.${playload_64}'
	signature := hmac.new(secret.bytes(), message.bytes(), sha256.sum, 64)
	base64_signature := base64.url_encode_str(signature.bytestr())
	return '${header}.${playload_64}.${base64_signature}'
}

// Verify Token | 验证令牌
pub fn jwt_verify(secret string, token string) bool {
	// 验证 token 长度
	parts := token.split('.')
	if parts.len != 3 {
		return false
	}
	// verify signature | 验证签名
	message := '${parts[0]}.${parts[1]}'
	signature := hmac.new(secret.bytes(), message.bytes(), sha256.sum, 64)
	expected_sig := base64.url_encode_str(signature.bytestr())
	if parts[2] != expected_sig {
		return false
	}
	// Verify time validity | 验证时间有效性
	payload_base64 := base64.url_decode_str(parts[1])
	payload_json := json2.decode[JwtPayload](payload_base64.str()) or { return false }
	now := time.now().unix()
	if now > payload_json.exp || now < payload_json.nbf {
		return false
	}

	return true
}
