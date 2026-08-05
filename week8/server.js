const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const multer = require('multer');
const upload = multer();

const productRoute = require('./routes/api/productRoute');

// Connecting to the Database
const mongodb_url = 'mongodb://localhost/';
const dbName = 'yolomy';

// Define the MongoDB connection URL
const MONGODB_URI = process.env.MONGODB_URI || mongodb_url + dbName;

// Connect to MongoDB
mongoose
    .connect(MONGODB_URI, {
        useNewUrlParser: true,
        useUnifiedTopology: true
    })
    .then(() => {
        console.log('Database connected successfully');
    })
    .catch((err) => {
        console.error('Database connection failed:', err.message);
        console.log('Application will continue running without a database.');
    });

// Initializing express
const app = express();

// Body parser middleware
app.use(express.json());

// Multer middleware
app.use(upload.array());

// CORS
app.use(cors());

// Routes
app.use('/api/products', productRoute);

// Health endpoint
app.get('/health', (req, res) => {
    res.status(200).json({
        status: 'UP'
    });
});

// Define the PORT
const PORT = process.env.PORT || 5000;

// Start the server
app.listen(PORT, () => {
    console.log(`Server listening on port ${PORT}`);
});
