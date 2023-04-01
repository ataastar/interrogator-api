const db = require('../db-util')

async function validateEmailAndPassword(email, password) {
    const result = await db.pool.query('SELECT user_id, nickname, (SELECT string_agg(role, \',\') as roles FROM user_role r WHERE r.user_id = u.user_id) FROM users u WHERE email = $1 AND password=CRYPT($2, password)', [email, password]);
    return result && result.rows.length > 0 ? result.rows[0] : null;
}

async function getUser(userId) {
    const result = await db.pool.query('SELECT user_id, nickname, (SELECT string_agg(role, \',\') as roles FROM user_role r WHERE r.user_id = u.user_id) FROM users u WHERE user_id = $1',
        [userId]);
    return result && result.rows.length > 0 ? result.rows[0] : null;
}

module.exports = {
    validateEmailAndPassword,
    getUser
}
