module jwt

pub struct JwtHeader {
pub:
	alg string // Encryption (algorithm)：'HS256'，"none"
	typ string // (Type) Header Parameter
	cty string // (Content Type) Header Parameter
}

pub struct JwtPayload {
pub:
	// Standard Declaration | 标准声明
	iss string   @[default: 'v-admin'; required] // Issuer |  签发者
	sub string   @[required]                     // Subject | 接收方
	aud []string @[omitempty]                    // ['app.mall.com'] Audience | 接收方
	nbf i64      @[required]                     // Effective time | 生效时间 (Not Before)
	exp i64      @[required]                     // Expiration Time | 过期时间
	iat i64      @[required]                     // Time of Issue | 签发时间 (Issued At)
	jti string   @[required]                     // JWT unique identifier,Anti duplication and anti attack | JWT唯一标识 (JWT ID)，防重防攻击
	// Custom Declaration | 自定义声明
	roles     []string
	client_ip string
	device_id string
}
