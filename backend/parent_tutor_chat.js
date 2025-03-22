const express = require("express");
const router = express.Router();
const multer = require("multer");

module.exports = (app, db) => {
  const multer = require("multer");

  const storage = multer.diskStorage({
    destination: (req, file, cb) => cb(null, "uploads/"),
    filename: (req, file, cb) => cb(null, Date.now() + "-" + file.originalname),
  });
  const upload = multer({ storage: storage });

  // Send message
  app.post("/api/chat/send", (req, res) => {
    const { chatId, senderId, userRole, message } = req.body;

    if (!chatId || !senderId || !userRole || !message) {
      return res.status(400).json({ error: "Missing required fields" });
    }

    const sql = `INSERT INTO chat_messages (chat_id, sender_id, user_role, message, file_url, file_type) 
                     VALUES (?, ?, ?, ?, NULL, 'text')`;

    db.query(sql, [chatId, senderId, userRole, message], (err, results) => {
      if (err) {
        console.error("Database Insert Error:", err);
        return res.status(500).json({ error: "Failed to send message" });
      }
      res.status(200).json({ message: "Message sent", id: results.insertId });
    });
  });

  // Upload file
  app.post("/api/chat/upload", upload.single("file"), (req, res) => {
    const { chatId, senderId, userRole } = req.body;
    const fileUrl = req.file.path;
    const fileType = req.file.mimetype.split("/")[0];

    const sql = `INSERT INTO chat_messages (chat_id, sender_id, user_role, message, file_url, file_type) 
                     VALUES (?, ?, ?, NULL, ?, ?)`;
    db.query(
      sql,
      [chatId, senderId, userRole, fileUrl, fileType],
      (err, results) => {
        if (err)
          return res.status(500).send({ error: "Failed to upload file" });
        res.status(200).send({ message: "File uploaded", fileUrl });
      }
    );
  });

  // Fetch chat messages
  app.get("/api/chat/messages/:chatId", (req, res) => {
    const sql = `SELECT * FROM chat_messages WHERE chat_id = ? ORDER BY sent_at ASC`;
    db.query(sql, [req.params.chatId], (err, results) => {
      if (err)
        return res.status(500).send({ error: "Failed to fetch messages" });
      res.status(200).json(results);
    });
  });
  app.get("/api/chat/tutor/:tutorId", (req, res) => {
    const tutorId = req.params.tutorId;

    const sql = `SELECT Tutor_Name FROM tutor_table WHERE Tutor_ID = ?`;
    db.query(sql, [tutorId], (err, results) => {
      if (err) {
        console.error("Database Error:", err);
        return res.status(500).json({ error: "Failed to fetch tutor name" });
      }

      if (results.length > 0) {
        res.json({ tutorName: results[0].Tutor_Name }); // Fetch the correct column
      } else {
        res.json({ tutorName: "Unknown Tutor" });
      }
    });
  });
  // Get tutors the assigned child's parent's
  app.get("/getTutors/:parentId", (req, res) => {
    const parentId = req.params.parentId;

    const query = `
          SELECT 
              tutor_table.Tutor_ID AS id, 
              tutor_table.Tutor_Name AS name, 
              tutor_table.Tutor_Email AS email, 
              tutor_profile_data_table.tutor_teaches_subject AS subject
          FROM tutor_table
          JOIN assigned_tutors_record_table 
              ON tutor_table.Tutor_ID = assigned_tutors_record_table.Tutor_ID
          JOIN parent_table 
              ON parent_table.Parent_ID = assigned_tutors_record_table.Parent_ID
          LEFT JOIN tutor_profile_data_table 
              ON tutor_table.Tutor_ID = tutor_profile_data_table.Tutor_ID
          WHERE parent_table.Parent_ID = ?;
      `;

    db.query(query, [parentId], (err, results) => {
      if (err) {
        console.error("Error fetching tutors:", err);
        return res.status(500).json({ error: "Internal Server Error" });
      }
      res.json(results);
    });
  });

  // Get or create a chat room for a parent and tutor
  app.post("/api/chat/getRoom", (req, res) => {
    const { parentId, tutorId } = req.body;

    const checkRoomQuery = `SELECT chat_id, chat_name FROM chat_rooms WHERE parent_id = ? AND tutor_id = ?`;
    db.query(checkRoomQuery, [parentId, tutorId], (err, results) => {
      if (err) {
        console.error("Error checking chat room:", err);
        return res.status(500).json({ error: "Database Error" });
      }

      if (results.length > 0) {
        return res.json({
          chatId: results[0].chat_id,
          chatName: results[0].chat_name,
        });
      }

      const chatName = `Parent ${parentId} - Tutor ${tutorId}`;
      console.log("Generated Chat Name:", chatName); // Debugging

      const createRoomQuery = `INSERT INTO chat_rooms (parent_id, tutor_id, chat_name) VALUES (?, ?, ?)`;

      db.query(
        createRoomQuery,
        [parentId, tutorId, chatName],
        (err, result) => {
          if (err) {
            console.error("Error creating chat room:", err);
            return res.status(500).json({ error: "Database Error" });
          }

          console.log("Inserted Chat Room:", result.insertId); // Debugging
          res.json({ chatId: result.insertId, chatName });
        }
      );
    });
  });

  // Get list of parents whose children are assigned to a specific tutor
  app.get("/getParentsForTutor/:tutorId", (req, res) => {
    const tutorId = req.params.tutorId;

    const sql = `
    SELECT 
      p.Parent_ID, 
      s.Student_Name
    FROM assigned_tutors_record_table atr
    JOIN parent_table p ON atr.Parent_ID = p.Parent_ID
    JOIN student_table s ON p.Student_ID = s.Student_ID
    WHERE atr.Tutor_ID = ?;
  `;

    db.query(sql, [tutorId], (err, results) => {
      if (err) {
        console.error("Error fetching parents:", err);
        return res.status(500).json({ error: "Database error" });
      }
      res.json(results);
    });
  });

  app.get("/getChatRoomsForTutor/:tutorId", (req, res) => {
    const tutorId = req.params.tutorId;
    //console.log("Received Tutor ID:", tutorId); // Debugging to check if tutorId is being received

    if (!tutorId) {
      return res.status(400).json({ error: "Tutor ID is required" });
    }

    const sql = `
        SELECT 
            c.chat_id, 
            c.chat_name, 
            p.Parent_ID AS parentId, 
            s.Student_Name AS studentName
        FROM chat_rooms c
        JOIN parent_table p ON c.parent_id = p.Parent_ID
        LEFT JOIN student_table s ON p.Student_ID = s.Student_ID
        WHERE c.tutor_id = ?;
    `;

    db.query(sql, [tutorId], (err, result) => {
      if (err) {
        console.error("Error fetching chat rooms:", err);
        return res.status(500).json({ error: "Database error" });
      }
      res.json(result);
    });
  });
  app.get("/api/chat/student/:parentId", (req, res) => {
    const parentId = req.params.parentId;

    const sql = `
      SELECT s.Student_Name 
      FROM student_table s
      JOIN parent_table p ON s.Student_ID = p.Student_ID
      WHERE p.Parent_ID = ?;
    `;

    db.query(sql, [parentId], (err, results) => {
      if (err) {
        console.error("Database Error:", err);
        return res.status(500).json({ error: "Failed to fetch student name" });
      }

      if (results.length > 0) {
        res.json({ studentName: results[0].Student_Name });
      } else {
        res.json({ studentName: "Unknown Student" });
      }
    });
  });
};
