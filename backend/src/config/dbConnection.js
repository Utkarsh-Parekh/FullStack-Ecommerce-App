const mongoose = require('mongoose');

if (!process.env.MONGODB_AUTH_URL || !process.env.MONGODB_PRODUCTS_URL) {
  console.error('❌ MongoDB URLs are not set in .env');
  process.exit(1);
}

const authDB = mongoose.createConnection(process.env.MONGODB_AUTH_URL);
const productsDB = mongoose.createConnection(process.env.MONGODB_PRODUCTS_URL);

authDB.on('connected', () => console.log('✅ Auth DB connected'));
authDB.on('error', (err) => {
  console.error('❌ Auth DB error:', err.message);
  process.exit(1);
});

productsDB.on('connected', () => console.log('✅ Products DB connected'));
productsDB.on('error', (err) => {
  console.error('❌ Products DB error:', err.message);
  process.exit(1);
});

module.exports = { authDB, productsDB };