const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// Define the hello-world endpoint
app.get('/api/hello-world', (req, res) => {
  res.json({ message: 'hello-world' });
});

// Root endpoint
app.get('/', (req, res) => {
  res.send('Welcome to the API! Try accessing /api/hello-world');
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
  console.log(`API endpoint available at: http://localhost:${PORT}/api/hello-world`);
});