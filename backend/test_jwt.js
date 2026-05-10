require('dotenv').config();
const jwt = require('jsonwebtoken');

const token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywicGhvbmUiOiI5NDgzNjU3MzM2Iiwicm9sZSI6Im1lbWJlciIsImlhdCI6MTc3ODQzNDkyMSwiZXhwIjoxNzc4NTIxMzIxfQ.L2TBhsSgDvuUCks7PR9PCR6rjh0NuhucofUn4bIVeOI';

console.log('Secret length:', process.env.JWT_SECRET?.length);
console.log('Secret:', process.env.JWT_SECRET);

try {
  const decoded = jwt.verify(token, process.env.JWT_SECRET || 'default_secret');
  console.log('Verified:', decoded);
} catch (error) {
  console.error('Verify error:', error.message);
}

try {
  const decodedDefault = jwt.verify(token, 'default_secret');
  console.log('Verified with default_secret:', decodedDefault);
} catch (error) {
  console.error('Verify with default error:', error.message);
}
