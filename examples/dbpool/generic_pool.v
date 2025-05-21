module dbpool

import db.mysql
import db.pg

struct ConnectionPoolGeneric[T, U] {
mut:
	connections chan T
	config      U
}

// 创建连接池（通过泛型指定类型）
pub fn new_pool[T, U](config U, size int) !&ConnectionPoolGeneric[T, U] {
	// 根据配置类型初始化
	$if T is mysql.DB {
		mut pool_mysql := &ConnectionPoolGeneric[mysql.DB, mysql.Config]{
			connections: chan mysql.DB{cap: size}
			config:      config
		}
		for _ in 0 .. size {
			conn := mysql.connect(config)!
			pool_mysql.connections <- conn // 类型转换保证安全
		}
		return pool_mysql
	} $else $if T is pg.DB {
		mut pool_pg := &ConnectionPoolGeneric[pg.DB, U]{
			connections: chan mysql.DB{cap: size}
			config:      config
		}
		for _ in 0 .. size {
			conn := pg.connect(config)!
			pool_pg.connections <- conn
		}
		return pool_pg
	} $else {
		return error('')
	}
}

// acquire gets a connection from the pool | 从池中获取连接
pub fn (mut pool ConnectionPoolGeneric[T, U]) acquire() !T {
	conn := <-pool.connections or { return error('Failed mysql') }
	return conn
}

// release returns a connection back to the pool. | 释放将连接返回到池中
pub fn (mut pool ConnectionPoolGeneric[T, U]) release(conn T) {
	pool.connections <- conn
}

// close closes all connections in the pool | 关闭池中的所有连接
pub fn (mut pool ConnectionPoolGeneric[T, U]) close() {
	for _ in 0 .. pool.connections.len {
		mut conn := <-pool.connections or { break }
		conn.close()
	}
}
