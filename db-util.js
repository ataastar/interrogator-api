const Pool = require('pg').Pool

const connectionString = process.env.INTERROGATOR_DATABASE_URL ? process.env.INTERROGATOR_DATABASE_URL : process.env.DATABASE_URL

const pool = new Pool({
    connectionString: connectionString,
    ssl: !process.env.INTERROGATOR_DATABASE_CONN_UNSECURE
});

module.exports = {
    pool
}
