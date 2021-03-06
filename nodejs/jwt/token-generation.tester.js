/**
 * Just few lines to test the behavior.
 */

const TokenGenerator = require('./token-generator');
const jwt = require('jsonwebtoken');

const tokenGenerator = new TokenGenerator('a', 'a', { algorithm: 'HS256', keyid: '1', noTimestamp: false, expiresIn: '2m', notBefore: '2s' })
token = tokenGenerator.sign({ myclaim: 'something' }, { audience: 'myaud', issuer: 'myissuer', jwtid: '1', subject: 'user' })
setTimeout(function () {
  token2 = tokenGenerator.refresh(token, { verify: { audience: 'myaud', issuer: 'myissuer' }, jwtid: '2' })
  console.log(jwt.decode(token, { complete: true }))
  console.log(jwt.decode(token2, { complete: true }))
}, 3001)
