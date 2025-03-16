const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const path = require('path');
const session = require('express-session');
const http = require('http');
const socketIO = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = socketIO(server);
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

// Serve uploaded files statically
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Serve static files from tutor_pic and tutor_degree folders
app.use('/tutor_pic', express.static(path.join(__dirname, 'tutor_pic')));
app.use('/tutor_degree', express.static(path.join(__dirname, 'tutor_degree')));


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
require('./send_otp')(app, db);
require('./verify_otp')(app, db);

// Import and use the tutorProfileCreation module
require('./tutor_profile_creation')(app, db);

// Import and use the adminHandleTutorProfileStatus module
require('./admin_handle_tutor_profile_status')(app, db);
// Import and use the student_search_for_tutor module
require('./student_search_for_tutor')(app, db);
require('./approve_tutor')(app, db);


require('./parent_approve_tutor_appointed_by_student')(app, db);
require('./update_tutor_status')(app, db);

require('./tutor_manage_student_requests')(app, db);
require('./tutor_handle_student_request')(app, db);

// Import and use the community module
require('./communitycreate')(app, db);

// Import and use the communityPosts module
require('./community')(app, db);

require("./tutor_assigned_students")(app, db);
require('./student_join_meeting_session')(app, db);
require('./tutor_join_meeting_session')(app, db);
require('./video_call')(io);
require('./parent_tutor_chat')(app, db);
require('./Student_tutor_chat')(app, db);

// Start the server
server.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
