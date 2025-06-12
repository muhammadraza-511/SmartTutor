const nodemailer = require('nodemailer');

// Configure Nodemailer transporter
const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: 'smarttutor253@gmail.com',
        pass: 'pggl mteg guur hcjd' // Consider using environment variables for security
    },
    tls: {
        rejectUnauthorized: false
    }
});

module.exports = function(app, db) {
    app.get('/student-pending-quizzes', (req, res) => {
        const studentId = req.query.studentId || req.session.studentId;
        
        if (!studentId) {
            return res.status(400).json({ error: "Student ID is required" });
        }

        const query = `
            SELECT Schedule_ID, Quiz_ID, Quiz_Topic, Start_Time, End_Time, Tutor_ID 
            FROM tutor_schedule_quiz_table 
            WHERE Student_ID = ? AND status = 'pending'
        `;

        db.query(query, [studentId], (err, results) => {
            if (err) {
                console.error("Error fetching pending quizzes:", err);
                return res.status(500).json({ error: "Database error" });
            }
            
            res.json({ quizzes: results });
        });
    });

    app.post('/update-quiz-status', (req, res) => {
        const { scheduleId } = req.body;
        
        if (!scheduleId) {
            return res.status(400).json({ error: "Schedule ID is required" });
        }

        const query = `
            UPDATE tutor_schedule_quiz_table 
            SET status = 'done' 
            WHERE Schedule_ID = ?
        `;

        db.query(query, [scheduleId], (err, result) => {
            if (err) {
                console.error("Error updating quiz status:", err);
                return res.status(500).json({ error: "Database error" });
            }
            
            res.json({ success: true });
        });
    });

    app.get('/get-quiz-details', (req, res) => {
        const { scheduleId } = req.query;
        
        if (!scheduleId) {
            return res.status(400).json({ error: "Schedule ID is required" });
        }

        const query = `
            SELECT Tutor_ID, Quiz_Topic 
            FROM tutor_schedule_quiz_table 
            WHERE Schedule_ID = ?
        `;

        db.query(query, [scheduleId], (err, results) => {
            if (err) {
                console.error("Error fetching quiz details:", err);
                return res.status(500).json({ error: "Database error" });
            }
            
            if (results.length === 0) {
                return res.status(404).json({ error: "Quiz not found" });
            }
            
            res.json({ quizDetails: results[0] });
        });
    });

    app.get('/get-quiz-questions-by-topic', (req, res) => {
        const { tutorId, topic } = req.query;
        
        if (!tutorId || !topic) {
            return res.status(400).json({ error: "Tutor ID and Topic are required" });
        }

        const query = `
            SELECT * FROM tutor_generate_quiz_table 
            WHERE Tutor_ID = ? AND Quiz_Topic = ?
            ORDER BY Quiz_ID
        `;

        db.query(query, [tutorId, topic], (err, results) => {
            if (err) {
                console.error("Error fetching quiz questions:", err);
                return res.status(500).json({ error: "Database error" });
            }
            
            res.json({ questions: results });
        });
    });

    app.post('/save-quiz-result', (req, res) => {
        const { scheduleId, score, studentId } = req.body;
        
        if (!scheduleId || score === undefined || !studentId) {
            return res.status(400).json({ error: "Schedule ID, score, and student ID are required" });
        }

        // First, get all necessary details for the email
        const getDetailsQuery = `
            SELECT 
                sq.Quiz_Topic, 
                sq.Start_Time,
                sq.End_Time,
                s.Student_Name,
                s.Student_Email,
                p.Parent_Email,
                t.Tutor_Name
            FROM tutor_schedule_quiz_table sq
            JOIN student_table s ON sq.Student_ID = s.Student_ID
            JOIN parent_table p ON s.Student_ID = p.Student_ID
            JOIN tutor_table t ON sq.Tutor_ID = t.Tutor_ID
            WHERE sq.Schedule_ID = ? AND sq.Student_ID = ?
        `;

        db.query(getDetailsQuery, [scheduleId, studentId], (err, results) => {
            if (err) {
                console.error("Error fetching quiz details:", err);
                return res.status(500).json({ error: "Database error" });
            }
            
            if (results.length === 0) {
                return res.status(404).json({ error: "Quiz details not found" });
            }

            const quizDetails = results[0];
            
            // Format the date/time for the email
            const formatDateTime = (dateTime) => {
                if (!dateTime) return 'N/A';
                const date = new Date(dateTime);
                return date.toLocaleString();
            };

            // Update the quiz result in the database
            const updateQuery = `
                UPDATE tutor_schedule_quiz_table 
                SET Quiz_score = ?, status = 'completed' 
                WHERE Schedule_ID = ? AND Student_ID = ?
            `;

            db.query(updateQuery, [score, scheduleId, studentId], (err, result) => {
                if (err) {
                    console.error("Error saving quiz result:", err);
                    return res.status(500).json({ error: "Database error" });
                }
                
                // Send email to parent with quiz details
                const mailOptions = {
                    from: 'smarttutor253@gmail.com',
                    to: quizDetails.Parent_Email,
                    subject: `Quiz Results Notification for ${quizDetails.Student_Name}`,
                    html: `
                        <div style="font-family: Arial, sans-serif; line-height: 1.6;">
                            <h2 style="color: #2c3e50;">Quiz Results Notification</h2>
                            <p>Dear Parent,</p>
                            
                            <p>Your child <strong>${quizDetails.Student_Name}</strong> has completed a quiz with the following details:</p>
                            
                            <table style="border-collapse: collapse; width: 100%; margin: 15px 0;">
                                <tr>
                                    <td style="padding: 8px; border: 1px solid #ddd; background-color: #f2f2f2;"><strong>Quiz Topic:</strong></td>
                                    <td style="padding: 8px; border: 1px solid #ddd;">${quizDetails.Quiz_Topic}</td>
                                </tr>
                                <tr>
                                    <td style="padding: 8px; border: 1px solid #ddd; background-color: #f2f2f2;"><strong>Tutor:</strong></td>
                                    <td style="padding: 8px; border: 1px solid #ddd;">${quizDetails.Tutor_Name}</td>
                                </tr>
                                <tr>
                                    <td style="padding: 8px; border: 1px solid #ddd; background-color: #f2f2f2;"><strong>Start Time:</strong></td>
                                    <td style="padding: 8px; border: 1px solid #ddd;">${formatDateTime(quizDetails.Start_Time)}</td>
                                </tr>
                                <tr>
                                    <td style="padding: 8px; border: 1px solid #ddd; background-color: #f2f2f2;"><strong>End Time:</strong></td>
                                    <td style="padding: 8px; border: 1px solid #ddd;">${formatDateTime(quizDetails.End_Time)}</td>
                                </tr>
                                <tr>
                                    <td style="padding: 8px; border: 1px solid #ddd; background-color: #f2f2f2;"><strong>Score:</strong></td>
                                    <td style="padding: 8px; border: 1px solid #ddd;">${score}</td>
                                </tr>
                            </table>
                            
                            <p>You can log in to the portal to view more details about your child's performance.</p>
                            
                            <p>Best Regards,<br>
                            <strong>Smart Tutor Team</strong></p>
                        </div>
                    `
                };

                transporter.sendMail(mailOptions, (error, info) => {
                    if (error) {
                        console.error('Error sending email to parent:', error);
                        // Don't fail the request, just log the error and continue
                        return res.json({ 
                            success: true, 
                            emailSent: false,
                            message: "Quiz results saved successfully but failed to send email notification"
                        });
                    }
                    
                    res.json({ 
                        success: true, 
                        emailSent: true,
                        message: "Quiz results saved and parent notified successfully"
                    });
                });
            });
        });
    });
};