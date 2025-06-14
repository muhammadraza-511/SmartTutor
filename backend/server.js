const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const path = require('path');
const session = require('express-session');
const http = require('http');
const socketIO = require('socket.io');
const multer = require('multer');
const { exec } = require('child_process');
const fs = require('fs-extra');
const axios = require('axios');
const nodemailer = require('nodemailer');  // Add this line



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


require('./video_call')(io, db);

require('./parent_tutor_chat')(app, db);
require('./Student_tutor_chat')(app, db);

require('./tutor_generate_quiz')(app, db);
// Add this with your other require statements
require('./tutor_schedule_quiz')(app, db);
// Add this with your other routes in server.js
require('./student_get_pending_quizzes')(app, db);
require('./studentreport')(app, db);


const FormData = require('form-data');

// Multer for Image Upload
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        const studentID = req.body.Student_ID || req.query.Student_ID;  
        const sessionID = req.body.Session_ID || req.query.Session_ID;  

        if (!studentID || !sessionID) {
            return cb(new Error("Missing Student_ID or Session_ID"), false);
        }

        const uploadPath = path.join(__dirname, 'student_emotion', studentID, sessionID);

        // Ensure the directory exists
        fs.mkdirSync(uploadPath, { recursive: true });

        cb(null, uploadPath);
    },
    filename: (req, file, cb) => {
        const fileName = `emotion_${Date.now()}${path.extname(file.originalname)}`;
        cb(null, fileName);
    }
});

const upload = multer({ storage });

const fileUpload = require('express-fileupload');

app.use(fileUpload());

app.post('/upload-student-emotion', async (req, res) => {
    try {
        const { Student_ID, Session_ID } = req.body;
        if (!req.files || !req.files.image || !Student_ID || !Session_ID) {
            return res.status(400).json({ error: "Missing required fields" });
        }

        const imageFile = req.files.image;
        const folderPath = path.join(__dirname, 'student_emotion', Student_ID, Session_ID);
        await fs.ensureDir(folderPath); // Ensure directory exists

        const timestamp = Date.now();
        const imagePath = path.join(folderPath, `emotion_${timestamp}.jpg`);

        await imageFile.mv(imagePath); // Save image

        // Send image to FastAPI for emotion detection
        const formData = new FormData();
        formData.append('file', fs.createReadStream(imagePath));

        const response = await axios.post('http://localhost:8000/detect-emotion/', formData, {
            headers: formData.getHeaders()
        });

        const detectedEmotion = response.data.emotion;

        // Store detected emotion in MySQL
        const sql = `INSERT INTO emotions_details (Student_ID, Session_ID, Emotion_Type, captured_time) 
                     VALUES (?, ?, ?, NOW())`;
        db.query(sql, [Student_ID, Session_ID, detectedEmotion, imagePath], (err, result) => {
            if (err) {
                console.error("Database error:", err);
                return res.status(500).json({ error: "Database error" });
            }

            res.json({ message: "Emotion detected and stored", emotion: detectedEmotion, path: imagePath });
        });

    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({ error: "Internal server error" });
    }
});




app.get('/get-recent-emotion/:sessionId', (req, res) => {
    const { sessionId } = req.params;

    const query = `
        SELECT e.Emotion_Type, e.captured_time, s.Student_Name, e.Student_ID
        FROM emotions_details e
        JOIN student_table s ON e.Student_ID = s.Student_ID
        WHERE e.Session_ID = ?
        AND e.captured_time = (
            SELECT MAX(captured_time)
            FROM emotions_details
            WHERE Student_ID = e.Student_ID AND Session_ID = ?
        )
        ORDER BY e.captured_time DESC;
    `;

    db.query(query, [sessionId, sessionId], (err, results) => {
        if (err) {
            console.error("Error fetching recent emotion:", err);
            return res.status(500).json({ error: "Database error" });
        }

        if (results.length === 0) {
            return res.json({ message: "No recent emotions found." });
        }

        res.json(results);
    });
});

// Add this with your other routes in server.js
app.get('/tutor-quiz-results', (req, res) => {
    const tutorId = req.query.tutorId;
    
    if (!tutorId) {
        return res.status(400).json({ error: "Tutor ID is required" });
    }

    const query = `
        SELECT 
            sq.Schedule_ID,
            sq.Quiz_ID,
            sq.Quiz_Topic,
            sq.Quiz_score,
            sq.Start_Time,
            sq.End_Time,
            s.Student_ID,
            s.Student_Name
        FROM tutor_schedule_quiz_table sq
        JOIN student_table s ON sq.Student_ID = s.Student_ID
        WHERE sq.Tutor_ID = ? AND sq.status = 'completed'
        ORDER BY sq.End_Time DESC
    `;

    db.query(query, [tutorId], (err, results) => {
        if (err) {
            console.error("Error fetching tutor quiz results:", err);
            return res.status(500).json({ error: "Database error" });
        }
        
        res.json({ results });
    });
});

// Add this route for parent notification
app.post('/notify-parent', (req, res) => {
    const { studentId, quizId, quizTopic, quizScore, feedback } = req.body;

    if (!studentId || !quizId || !quizTopic || !feedback) {
        return res.status(400).json({ success: false, message: "Missing required fields" });
    }

    // First, get parent email for the student
    const getParentQuery = `
        SELECT p.Parent_Email, s.Student_Name 
        FROM parent_table p
        JOIN student_table s ON p.Student_ID = s.Student_ID
        WHERE p.Student_ID = ?
    `;

    db.query(getParentQuery, [studentId], (err, results) => {
        if (err) {
            console.error("Error fetching parent email:", err);
            return res.status(500).json({ success: false, message: "Database error" });
        }

        if (results.length === 0) {
            return res.status(404).json({ success: false, message: "Parent not found for this student" });
        }

        const parentEmail = results[0].Parent_Email;
        const studentName = results[0].Student_Name;

        // Configure Nodemailer
        const transporter = nodemailer.createTransport({
            service: 'gmail',
            auth: {
                user: 'smarttutor253@gmail.com',
                pass: 'pggl mteg guur hcjd'
            },
            tls: {
                rejectUnauthorized: false
            }
        });

        // Email content
        const mailOptions = {
            from: 'smarttutor253@gmail.com',
            to: parentEmail,
            subject: `Quiz Results Notification for ${studentName}`,
            text: `Dear Parent,\n\nYour child ${studentName} has completed the quiz "${quizTopic}" with a score of ${quizScore}.\n\nTutor's Feedback:\n${feedback}\n\nIf you have any questions, please feel free to contact us.\n\nBest Regards,\nSmart Tutor Team`
        };

        // Send email
        transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
                console.error("Error sending email:", error);
                return res.status(500).json({ success: false, message: "Error sending email" });
            }
            
            res.json({ success: true, message: "Notification sent successfully" });
        });
    });
});

// Start the server
server.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});


//server.listen(3000, '0.0.0.0', () => {
//    console.log(`Server is running on http:/192.168.1.12:3000`);
//});