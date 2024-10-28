// app.js
const express = require('express');
const dotenv = require('dotenv');
dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Set the view engine to ejs
app.set('view engine', 'ejs');

// Instance and version data
const instanceNumber = process.env.INSTANCE_NUMBER || "01";
const version = process.env.VERSION || "1.0";
const hostname = `Node-${instanceNumber}`;

// Route
app.get('/', (req, res) => {
    res.render('index', { hostname, version });
});

// Start server
app.listen(PORT, () => {
    console.log(`App running on http://localhost:${PORT}`);
});
