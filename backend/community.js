const multer = require('multer');

// Set up file storage (e.g., save to 'uploads' folder)
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, 'uploads/'); // folder to store the uploaded files
    },
    filename: function (req, file, cb) {
        cb(null, Date.now() + '-' + file.originalname);
    }
});

const upload = multer({ storage: storage });

module.exports = (app, db) => {
    // Send a message to the community chat
    app.post('/api/community/chat', (req, res) => {
        const { userId, communityId, message, role } = req.body;

        const sql = 'INSERT INTO community_chat (community_id, sender_id, message, sender_role) VALUES (?, ?, ?, ?)';
        db.query(sql, [communityId, userId, message, role], (err, results) => {
            if (err) {
                console.error(err);
                return res.status(500).send({ error: 'Failed to send message' });
            }

            res.status(200).send({ message: 'Message sent successfully' });
        });
    });

    // Upload a file (document, image, video)
    app.post('/api/community/upload', upload.single('file'), (req, res) => {
        const { userId, communityId, role } = req.body;
        const fileUrl = req.file.path; // path to the uploaded file

        const sql = 'INSERT INTO community_files (community_id, sender_id, file_url, file_type, sender_role) VALUES (?, ?, ?, ?, ?)';
        const fileType = req.file.mimetype.split('/')[0]; // Extract type: document, image, video

        db.query(sql, [communityId, userId, fileUrl, fileType, role], (err, results) => {
            if (err) {
                console.error(err);
                return res.status(500).send({ error: 'Failed to upload file' });
            }

            res.status(200).send({ message: 'File uploaded successfully', fileUrl });
        });
    });

    // Fetch messages and files for a community, ordered by time
    app.get('/api/community/chat-and-files/:communityId', (req, res) => {
        const { communityId } = req.params;

        const sql = `(
            SELECT 'message' AS type, 
                   CASE WHEN community_chat.sender_role = 'student' THEN student_table.Student_Name 
                        ELSE tutor_table.Tutor_Name END AS sender_name, 
                   community_chat.message, 
                   community_chat.sent_at AS timestamp, 
                   null AS file_url, 
                   null AS file_type, 
                   community_chat.sender_role
            FROM community_chat
            LEFT JOIN student_table ON community_chat.sender_id = student_table.Student_ID
            LEFT JOIN tutor_table ON community_chat.sender_id = tutor_table.Tutor_ID
            WHERE community_chat.community_id = ?
        )
        UNION
        (
            SELECT 'file' AS type, 
                   CASE WHEN community_files.sender_role = 'student' THEN student_table.Student_Name 
                        ELSE tutor_table.Tutor_Name END AS sender_name,
                   null AS message, 
                   community_files.uploaded_at AS timestamp, 
                   community_files.file_url AS file_url, 
                   community_files.file_type AS file_type, 
                   community_files.sender_role
            FROM community_files
            LEFT JOIN student_table ON community_files.sender_id = student_table.Student_ID
            LEFT JOIN tutor_table ON community_files.sender_id = tutor_table.Tutor_ID
            WHERE community_files.community_id = ?
        )
        ORDER BY timestamp ASC`;

        db.query(sql, [communityId, communityId], (err, results) => {
            if (err) {
                console.error(err);
                return res.status(500).send({ error: 'Failed to fetch messages and files' });
            }

            res.status(200).json(results);  // Send both messages and files ordered by timestamp
        });
    });
};
