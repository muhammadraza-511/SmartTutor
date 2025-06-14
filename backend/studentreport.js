const nodemailer = require("nodemailer");

module.exports = (app, db) => {
  app.get("/api/assigned-students", (req, res) => {
    const tutorId = req.query.tutorId;

    const query = `
            SELECT s.Student_ID, s.Student_Name, s.Student_Email, s.Student_roll_No, s.Student_number
            FROM assigned_tutors_record_table AS a
            JOIN student_table AS s ON a.Student_ID = s.Student_ID
            WHERE a.Tutor_ID = ?
        `;

    db.query(query, [tutorId], (err, results) => {
      if (err) {
        console.error("Error fetching students:", err);
        return res.status(500).json({ error: "Database error" });
      }

      res.json(results);
    });
  });
  app.get("/api/student-emotions", (req, res) => {
    const studentId = req.query.studentId;
    if (!studentId) {
      return res.status(400).json({ error: "studentId is required" });
    }

    const sql = `
    SELECT 
  md.Student_ID, 
  md.Session_ID,
  SUM(ed.Emotion_Type = 'happy') AS happy,
  SUM(ed.Emotion_Type = 'surprise') AS surprise,
  SUM(ed.Emotion_Type = 'angry') AS angry,
  SUM(ed.Emotion_Type = 'fear') AS fear,
  SUM(ed.Emotion_Type = 'sad') AS sad,
  SUM(ed.Emotion_Type = 'disgust') AS disgust,
  SUM(ed.Emotion_Type = 'neutral') AS neutral
FROM meeting_details md
LEFT JOIN emotions_details ed 
  ON md.Session_ID = ed.Session_ID AND md.Student_ID = ed.Student_ID
WHERE md.Student_ID = ? AND md.Session_Start_Date >= CURDATE() - INTERVAL 30 DAY
GROUP BY md.Session_ID, md.Student_ID;
  `;

    db.query(sql, [studentId], (err, results) => {
      if (err) {
        console.error("DB error:", err);
        return res.status(500).json({ error: "Database error" });
      }
      res.json(results);
    });
  });

  app.post("/send_student_report", (req, res) => {
    const { studentId, studentName, reportHTML } = req.body;

    const fetchParentEmailQuery = `
    SELECT pt.Parent_Email 
    FROM parent_table pt 
    WHERE pt.Student_ID = ?
  `;

    db.query(fetchParentEmailQuery, [studentId], (err, results) => {
      if (err) {
        console.error("Error fetching parent email:", err);
        return res.status(500).json({ message: "Server error." });
      }

      if (results.length === 0) {
        return res.status(404).json({ message: "Parent email not found." });
      }

      const parentEmail = results[0].Parent_Email;

      const transporter = nodemailer.createTransport({
        service: "gmail",
        auth: {
          user: "smarttutor253@gmail.com",
          pass: "pggl mteg guur hcjd", // Keep this safe in production!
        },
      });

      const mailOptions = {
        from: "smarttutor253@gmail.com",
        to: parentEmail,
        subject: `Session Report for Student ID: ${studentId}`,
        html: `
  <div style="font-family: Arial, sans-serif; color: #333;">
    <h2 style="color: #007bff;">SmartTutor – Student Session Report</h2>
    <p>Dear Parent,</p>
    <p>Please find below the report for your child’s tutoring sessions.</p>
    
    <h3>Student Details</h3>
    <p><strong>Name:</strong> ${studentName}<br>
    <strong>ID:</strong> ${studentId}</p>

    <h3>Summary</h3>
    <div style="overflow-x: auto;">
      ${reportHTML
        .replace(
          /<table/g,
          `<table style="width: 100%; border-collapse: collapse; border: 1px solid #ccc; font-size: 14px;"`
        )
        .replace(
          /<th/g,
          `<th style="border: 1px solid #ccc; padding: 8px; background-color: #f2f2f2;"`
        )
        .replace(/<td/g, `<td style="border: 1px solid #ccc; padding: 8px;"`)}
    </div>

    <p style="margin-top: 20px;">For any questions or clarifications, feel free to reach out to us.</p>
    
    <p>Best regards,<br>
    <strong>SmartTutor Team</strong></p>
  </div>
`,
      };

      transporter.sendMail(mailOptions, (emailErr, info) => {
        if (emailErr) {
          console.error("Error sending email:", emailErr);
          return res.status(500).json({ message: "Failed to send email." });
        }

        console.log("Report email sent:", info.response);
        return res.json({ message: "Report sent to parent successfully." });
      });
    });
  });
};
