const nodemailer = require("nodemailer");

module.exports = (app, db) => {
    // Fetch assigned students
    app.get("/assigned-students", (req, res) => {
        const tutorId = req.query.tutorId;

        if (!tutorId) {
            return res.status(400).json({ error: "Tutor ID is required" });
        }

        const query = `
            SELECT s.Student_ID, s.Student_Name, s.Student_roll_No
            FROM assigned_tutors_record_table as atr
            JOIN student_table as s ON atr.Student_ID = s.Student_ID
            WHERE atr.Tutor_ID = ?
        `;

        db.query(query, [tutorId], (err, results) => {
            if (err) {
                console.error("Database error:", err);
                return res.status(500).json({ error: "Internal Server Error" });
            }

            res.json(results);
        });
    });

    // Create session in the meeting_details table and send emails
    app.post("/create-session", (req, res) => {
        const { tutorId, sessionId, startTime, endTime, selectedStudents } = req.body;

        if (!tutorId || !sessionId || !startTime || !endTime || !selectedStudents || selectedStudents.length === 0) {
            return res.status(400).json({ error: "All fields are required" });
        }

        const sessionDate = new Date().toISOString().split("T")[0]; // Current date in YYYY-MM-DD format

        // Check if there's an existing session for the same tutor at the same date and overlapping time
        const checkQuery = `
            SELECT * FROM meeting_details 
            WHERE Tutor_ID = ? 
            AND Session_Start_Date = ? 
            AND (
                (Session_Start_Time <= ? AND Session_End_Time > ?) OR 
                (Session_Start_Time < ? AND Session_End_Time >= ?)
            )
        `;

        db.query(checkQuery, [tutorId, sessionDate, endTime, startTime, startTime, endTime], (err, existingSessions) => {
            if (err) {
                console.error("Database error:", err);
                return res.status(500).json({ error: "Failed to check existing sessions" });
            }

            if (existingSessions.length > 0) {
                return res.status(400).json({ error: `You already have a session arranged between ${existingSessions[0].Session_Start_Time} and ${existingSessions[0].Session_End_Time}. Kindly select a different time slot.` });
            }

            // Insert new session
            const values = selectedStudents.map(studentId => [tutorId, studentId, sessionId, sessionDate, startTime, endTime]);
            const insertQuery = `
                INSERT INTO meeting_details (Tutor_ID, Student_ID, Session_ID, Session_Start_Date, Session_Start_Time, Session_End_Time) 
                VALUES ?
            `;

            db.query(insertQuery, [values], (err, result) => {
                if (err) {
                    console.error("Database error:", err);
                    return res.status(500).json({ error: "Failed to create session" });
                }

                // Fetch student emails
                const emailQuery = `
                    SELECT Student_Email FROM student_table 
                    WHERE Student_ID IN (?)
                `;

                db.query(emailQuery, [selectedStudents], (err, emailResults) => {
                    if (err) {
                        console.error("Database error while fetching emails:", err);
                        return res.status(500).json({ error: "Failed to fetch student emails" });
                    }

                    const transporter = nodemailer.createTransport({
                        service: "gmail",
                        auth: {
                            user: "smarttutor253@gmail.com",
                            pass: "pggl mteg guur hcjd",
                        },
                    });

                    const sendEmailPromises = emailResults.map(({ Student_Email }) => {
                        const mailOptions = {
                            from: "smarttutor253@gmail.com",
                            to: Student_Email,
                            subject: "New Session Scheduled",
                            text: `A new session has been scheduled for you.\nSession ID: ${sessionId}\nSession Date: ${sessionDate}\nStart Time: ${startTime}\nEnd Time: ${endTime}`,
                            html: `<p>A new session has been scheduled for you.</p><p><strong>Session ID:</strong> ${sessionId}</p><p><strong>Session Date:</strong> ${sessionDate}</p><p><strong>Start Time:</strong> ${startTime}</p><p><strong>End Time:</strong> ${endTime}</p>`
                        };

                        return transporter.sendMail(mailOptions).catch((emailErr) => {
                            console.error("Error sending email:", emailErr);
                        });
                    });

                    Promise.all(sendEmailPromises)
                        .then(() => {
                            res.json({ message: "Session created successfully and emails sent!", insertedRows: result.affectedRows });
                        })
                        .catch(() => {
                            res.status(500).json({ error: "Session created, but some emails failed to send." });
                        });
                });
            });
        });
    });
};
