// Simple Express server to generate Stream Chat JWT tokens for production use
const express = require('express');
const StreamChat = require('stream-chat').StreamChat;
const cors = require('cors');
require('dotenv').config();

console.log('Starting token server...');
console.log('Environment variables loaded:', {
  STREAM_API_KEY: process.env.STREAM_API_KEY ? '*** (set)' : 'MISSING',
  STREAM_API_SECRET: process.env.STREAM_API_SECRET ? '*** (set)' : 'MISSING',
  PORT: process.env.PORT || '3000 (default)'
});

const app = express();
const port = process.env.PORT || 3000;

// Load Stream credentials from environment variables
const apiKey = process.env.STREAM_API_KEY;
const apiSecret = process.env.STREAM_API_SECRET;

if (!apiKey || !apiSecret) {
  console.error('ERROR: STREAM_API_KEY and STREAM_API_SECRET must be set in .env');
  process.exit(1);
}

try {
  const serverClient = StreamChat.getInstance(apiKey, apiSecret);
  console.log('Stream Chat client initialized successfully');

  app.use(cors());
  app.use(express.json());

  // Request logging middleware
  app.use((req, res, next) => {
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
    next();
  });

  app.get('/token', (req, res) => {
    console.log('Token request received:', req.query);
    const userId = req.query.user_id;
    if (!userId) {
      console.error('No user_id provided');
      return res.status(400).json({ error: 'user_id query parameter is required' });
    }
    try {
      const token = serverClient.createToken(userId);
      console.log(`Token generated for user: ${userId}`);
      res.json({ token });
    } catch (error) {
      console.error('Error generating token:', error);
      res.status(500).json({ error: 'Failed to generate token', details: error.message });
    }
  });

  app.get('/', (req, res) => {
    res.send(`
      <h1>Stream Chat Token Server</h1>
      <p>Server is running. Use /token?user_id=USER_ID to get a token.</p>
      <p>Example: <a href="/token?user_id=doctor_anna">Get token for doctor_anna</a></p>
    `);
  });

  // Error handling middleware
  app.use((err, req, res, next) => {
    console.error('Server error:', err);
    res.status(500).json({ error: 'Internal server error', details: err.message });
  });

  const server = app.listen(port, '0.0.0.0', () => {
    const address = server.address();
    console.log('\n--- Server Info ---');
    console.log(`Server running at:`);
    console.log(`- Local:   http://localhost:${address.port}`);
    console.log(`- Network: http://${require('os').hostname()}:${address.port}`);
    console.log(`- Network: http://${getLocalIpAddress()}:${address.port}`);
    console.log('-------------------\n');
    console.log('Test endpoints:');
    console.log(`- http://localhost:${address.port}/token?user_id=doctor_anna`);
    console.log('\nPress Ctrl+C to stop the server\n');
  });

  // Handle process termination
  process.on('SIGINT', () => {
    console.log('\nShutting down server...');
    server.close(() => {
      console.log('Server stopped');
      process.exit(0);
    });
  });

} catch (error) {
  console.error('Failed to initialize server:', error);
  process.exit(1);
}

// Helper function to get local IP address
function getLocalIpAddress() {
  const interfaces = require('os').networkInterfaces();
  for (const name of Object.keys(interfaces)) {
    for (const iface of interfaces[name]) {
      if ('IPv4' === iface.family && !iface.internal) {
        return iface.address;
      }
    }
  }
  return 'localhost';
}

// --- USER SEEDING SCRIPT ---
async function seedUsers(serverClient) {
  try {
    // All demo users for the application (ids/names must match Flutter app)
    const demoUsers = [
      // Patients
      { id: 'patient_bob', name: 'Bob Brown', role: 'patient' },
      { id: 'patient_jane', name: 'Jane Doe', role: 'patient' },
      { id: 'patient_mike', name: 'Mike Green', role: 'patient' },
      // Doctors
      { id: 'doctor_anna', name: 'Dr. Anna Smith', role: 'doctor' },
      { id: 'doctor_john', name: 'Dr. John Lee', role: 'doctor' },
      { id: 'doctor_emily', name: 'Dr. Emily Wong', role: 'doctor' },
    ];

    // Upsert all demo users
    await serverClient.upsertUsers(demoUsers);
    console.log('✅ Stream users seeded successfully');
    return true;
  } catch (error) {
    console.error('❌ Failed to seed users:', error);
    return false;
  }
}
