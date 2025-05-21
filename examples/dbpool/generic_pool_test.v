module dbpool

import db.mysql
import db.pg

fn test_new_pool() {
	mut pool := new_pool[mysql.DB](mysql.Config{
		host:     '127.0.0.1'
		port:     3306
		username: 'root'
		password: 'mysql_123456'
		dbname:   'vcore'
	}, pg.DB{}, 5) or { panic('Failed to create mysql pool: ${err}') }
	db := pool.acquire() or { panic(err) }
	data := db.exec('select 1')!
	assert data[0] == mysql.Row{
		vals: ['1']
	}
	pool.release(db)
	pool.close()
}
