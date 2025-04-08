module database

import db.pg

pub struct ConnectionPool {
mut:
    connections chan pg.DB
    config      pg.Config
}

pub fn new_connection_pool(config pg.Config, size int) !ConnectionPool {
    mut connections := chan pg.DB{cap: size}
    for _ in 0 .. size {
        conn := pg.connect(config)!
        connections <- conn
    }
    return ConnectionPool{
        connections: connections
        config: config
    }
}

pub fn (mut pool ConnectionPool) acquire() !pg.DB {
    return <-pool.connections or { return error('Connection pool exhausted') }
}

pub fn (mut pool ConnectionPool) release(conn pg.DB) {
    pool.connections <- conn
}

pub fn (mut pool ConnectionPool) close() {
    for _ in 0 .. pool.connections.len {
        mut conn := <-pool.connections or { break }
        conn.close()
    }
}