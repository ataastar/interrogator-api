const expressJwt = require('express-jwt');
const db = require("./queries");
const jwt = require('jsonwebtoken');
const fs = require('fs');


process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';
const RSA_PRIVATE_KEY = fs.readFileSync('./private.key');

async function login(req, res) {
    const email = req.body.email;
    const password = req.body.password;
    // TODO user dto
    let user = null;
    try {
        user = await db.validateEmailAndPassword(email, password);
        setTokenToResponse(user, res);
    } catch (err) {
        console.log(err);
        res.sendStatus(401);
    }
}

// check JWT
const RSA_PUBLIC_KEY = fs.readFileSync('./public.key');

/**
 * Function to check that the token is right
 * @type {(function(*=, *=, *): (*|undefined))|*}
 */
const checkIfAuthenticated = expressJwt({
    secret: RSA_PUBLIC_KEY, algorithms: ['RS256']
});
const checkIfRefreshAuthenticated = expressJwt({
    secret: RSA_PUBLIC_KEY, algorithms: ['RS256'], requestProperty: 'refreshToken'
});
// check JWT

const hasRole = (req, res, next, role) => {
    try {
        const roles = getDataFromToken('roles', req.header('authorization'));
        let found = false;
        if (roles != null) {
            for (const userRole of roles.split(',')) {
                if (userRole === role) {
                    found = true;
                    next()
                    break;
                }
            }
        }
        if (!found) {
            res.sendStatus(403);
        }
    } catch (error) {
        return next(error);
    }
}


async function refreshTokenResponse(req, res) {
    const refreshToken = req.body.refreshToken;
    try {
        const user = await db.getUser(getUserIdFromToken(refreshToken));
        setTokenToResponse(user, res);
    } catch (err) {
        console.log(err);
        res.sendStatus(401);
    }
}

function setTokenToResponse(user, res) {
    if (user) {
        // access/id token
        const jwtBearerToken = jwt.sign({roles: user.roles}, RSA_PRIVATE_KEY, {
            algorithm: 'RS256',
            //expiresIn: 5, // 5 seconds
            expiresIn: 60 * 60, // 1 hour
            subject: user.user_id
        });
        // refresh token
        const jwtRefreshToken = jwt.sign({}, RSA_PRIVATE_KEY, {
            algorithm: 'RS256',
            expiresIn: 60 * 60 * 24 * 7, // 1 week
            subject: user.user_id
        });
        // send the JWT back to the user
        const responseBody = {
            idToken: jwtBearerToken,
            refreshToken: jwtRefreshToken,
            nickname: user.nickname,
            roles: user.roles
        };
        res.status(200).json(responseBody);
    } else {
        res.sendStatus(401);
    }
}

const getDataFromToken = (property, token) => {
    if (token !== null) {
        const base64String = token.split('.')[1];
        const decodedValue = JSON.parse(Buffer.from(base64String, 'base64').toString('ascii'));
        return decodedValue[property];
    }
    return null;
}

const getUserIdFromToken = (token) => {
    return getDataFromToken('sub', token);
}

/**
 * Gets the user id from the jwt token
 * @param req the request
 * @returns {null|*} the user id if the token is exists, otherwise null
 */
const getUserId = (req) => {
    return getUserIdFromToken(req.header('authorization'));
}

module.exports = {
    login,
    checkIfAuthenticated,
    checkIfRefreshAuthenticated,
    getUserId,
    refreshTokenResponse,
    hasRole
}
