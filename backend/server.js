const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const path = require('path');
const session = require('express-session');

const app = express();
const PORT = 3000;

// Middleware
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// MySQL Database connection
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'smarttutor'
});

db.connect((err) => {
    if (err) throw err;
    console.log('Connected to the MySQL database');
});

// Serve the static files
app.use(express.static(path.join(__dirname, '..')));

// Set up session middleware
app.use(session({
    secret: 'your-secret-key',
    resave: false,
    saveUninitialized: true,
    cookie: { secure: false }
}));

// Import and use the login and signup modules
require('./login')(app, db);
require('./signup')(app, db);
// Import and use the tutorProfileCreation module
require('./tutor_profile_creation')(app, db);


// Start the server
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
