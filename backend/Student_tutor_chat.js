const express = require("express");
const router = express.Router();
const multer = require("multer");
const path = require("path");

module.exports = (app, db) => {
  const storage = multer.diskStorage({
    destination: (req, file, cb) => cb(null, "uploads/"),
    filename: (req, file, cb) => cb(null, Date.now() + "-" + file.originalname),
  });
  const upload = multer({ storage: storage });

  app.get("/tutor_student_chat", (req, res) => {
    res.sendFile(path.join(__dirname, "..", "tutor_student_chat.html"));
  });
  app.get("/student_tutor_chat", (req, res) => {
    res.sendFile(path.join(__dirname, "..", "student_tutor_chat.html"));
  });

  app.get("/api/student-tutor-chat/student/:studentId", (req, res) => {
    const studentId = req.params.studentId;

    const sql = `SELECT Student_Name FROM student_table WHERE Student_ID = ?`;
    db.query(sql, [studentId], (err, results) => {
      if (err) {
        console.error("Database Error:", err);
        return res.status(500).json({ error: "Failed to fetch student name" });
      }

      if (results.length > 0) {
        res.json({ studentName: results[0].Student_Name }); // Fetch the correct column
      } else {
        res.json({ studentName: "Unknown Student" });
      }
    });
  });
  app.get("/api/student-tutor-chat/tutor/:tutorId", (req, res) => {
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
  // Send message (text only)
  app.post("/api/student-tutor-chat/send", (req, res) => {
    const { chatId, senderId, userRole, message } = req.body;

    if (!chatId || !senderId || !userRole) {
      return res.status(400).json({ error: "Missing required fields" });
    }

    const sql = `INSERT INTO student_tutor_messages (chat_id, sender_id, user_role, message, file_url, file_type) 
                 VALUES (?, ?, ?, ?, NULL, NULL)`;

    db.query(sql, [chatId, senderId, userRole, message], (err, results) => {
      if (err) {
        console.error("Database Insert Error:", err);
        return res.status(500).json({ error: "Failed to send message" });
      }
      res.status(200).json({ message: "Message sent", id: results.insertId });
    });
  });

  app.post("/api/student-tutor-chat/upload",upload.single("file"),(req, res) => {
      const { chatId, senderId, userRole } = req.body;
      const fileUrl = req.file.path;
      const fileType = req.file.mimetype.split("/")[0];

      if (!chatId || !senderId || !userRole || !fileUrl) {
        return res.status(400).json({ error: "Missing required fields" });
      }

      const sql = `INSERT INTO student_tutor_messages (chat_id, sender_id, user_role, message, file_url, file_type) 
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
    }
  );

  // Fetch chat messages
  app.get("/api/student-tutor-chat/messages/:chatId", (req, res) => {
    const sql = `SELECT * FROM student_tutor_messages WHERE chat_id = ? ORDER BY sent_at ASC`;
    db.query(sql, [req.params.chatId], (err, results) => {
      if (err)
        return res.status(500).send({ error: "Failed to fetch messages" });
      res.status(200).json(results);
    });
  });

  // Get assigned tutors for a student
  app.get("/api/student/assigned-tutors/:studentId", (req, res) => {
    const sql = `SELECT T.Tutor_ID, T.Tutor_Name, P.tutor_teaches_subject AS Subject
        FROM assigned_tutors_record_table AS A
        JOIN tutor_table AS T ON A.Tutor_ID = T.Tutor_ID
        JOIN tutor_profile_data_table AS P ON T.Tutor_ID = P.Tutor_ID
        WHERE A.Student_ID = ?`;

    db.query(sql, [req.params.studentId], (err, results) => {
      if (err) {
        console.error("Error fetching assigned tutors:", err);
        return res.status(500).json({ error: "Database error" });
      }
      res.json(results);
    });
  });

  // Get assigned students for a tutor
  app.get("/api/tutor/assigned-students/:tutorId", (req, res) => {
    const sql = `SELECT S.Student_ID, S.Student_Name
                 FROM assigned_tutors_record_table AS A
                 JOIN student_table AS S ON A.Student_ID = S.Student_ID
                 WHERE A.Tutor_ID = ?`;

    db.query(sql, [req.params.tutorId], (err, results) => {
      if (err) {
        console.error("Error fetching assigned students:", err);
        return res.status(500).json({ error: "Database error" });
      }
      res.json(results);
    });
  });

  // Get or create a chat room
  app.post("/api/student-tutor-chat/getRoom", (req, res) => {
    const { studentId, tutorId } = req.body;

    const checkRoomQuery = `SELECT chat_id, chat_name FROM student_tutor_chat_rooms WHERE student_id = ? AND tutor_id = ?`;
    db.query(checkRoomQuery, [studentId, tutorId], (err, results) => {
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

      const chatName = `Student ${studentId} - Tutor ${tutorId}`;
      const createRoomQuery = `INSERT INTO student_tutor_chat_rooms (student_id, tutor_id, chat_name) VALUES (?, ?, ?)`;

      db.query(
        createRoomQuery,
        [studentId, tutorId, chatName],
        (err, result) => {
          if (err) {
            console.error("Error creating chat room:", err);
            return res.status(500).json({ error: "Database Error" });
          }
          res.json({ chatId: result.insertId, chatName });
        }
      );
    });
  });

  // Get chat rooms for a tutor
  app.get("/api/student-tutor-chat/rooms/:tutorId", (req, res) => {
    const sql = `SELECT c.chat_id, c.chat_name, s.Student_ID AS studentId, s.Student_Name AS studentName
                 FROM student_tutor_chat_rooms c
                 JOIN student_table s ON c.student_id = s.Student_ID
                 WHERE c.tutor_id = ?`;

    db.query(sql, [req.params.tutorId], (err, results) => {
      if (err) {
        console.error("Error fetching chat rooms:", err);
        return res.status(500).json({ error: "Database error" });
      }
      res.json(results);
    });
  });

  // Get chat rooms for a student
  app.get("/api/student-tutor-chat/student-rooms/:studentId", (req, res) => {
    const sql = `SELECT c.chat_id, c.chat_name, t.Tutor_ID AS tutorId, t.Tutor_Name AS tutorName
                 FROM student_tutor_chat_rooms c
                 JOIN tutor_table t ON c.tutor_id = t.Tutor_ID
                 WHERE c.student_id = ?`;

    db.query(sql, [req.params.studentId], (err, results) => {
      if (err) {
        console.error("Error fetching student chat rooms:", err);
        return res.status(500).json({ error: "Database error" });
      }
      res.json(results);
    });
  });
};
