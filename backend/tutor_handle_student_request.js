const nodemailer = require('nodemailer');

module.exports = (app, db) => {
    app.post('/tutor_handle_student_request', (req, res) => {
        const { action, Student_ID, Tutor_ID } = req.body;

        if (!action || !Student_ID || !Tutor_ID) {
            return res.status(400).json({ success: false, message: "Missing required parameters" });
        }

        const getEmailsQuery = `
            SELECT s.Student_Email, p.Parent_Email, t.Parent_ID
            FROM student_approve_tutor_status_table AS t
            JOIN student_table AS s ON t.Student_ID = s.Student_ID
            JOIN parent_table AS p ON t.Parent_ID = p.Parent_ID
            WHERE t.Student_ID = ? AND t.Tutor_ID = ?
        `;

        db.query(getEmailsQuery, [Student_ID, Tutor_ID], (err, results) => {
            if (err || results.length === 0) {
                console.error("Error fetching emails:", err);
                return res.status(500).json({ success: false, message: "Failed to fetch email details" });
            }

            const { Student_Email, Parent_Email, Parent_ID } = results[0];

            const getTutorDetailsQuery = `
                SELECT t.Tutor_Name, t.Tutor_Email, t.Tutor_Number, p.tutor_introduction, p.tutor_degree_name, 
                       p.tutor_degree_type, p.tutor_teaching_fee, p.tutor_availability_days, p.tutor_availability_time
                FROM tutor_table AS t
                LEFT JOIN tutor_profile_data_table AS p ON t.Tutor_ID = p.Tutor_ID
                WHERE t.Tutor_ID = ?
            `;

            db.query(getTutorDetailsQuery, [Tutor_ID], (err, tutorResults) => {
                if (err || tutorResults.length === 0) {
                    console.error("Error fetching tutor details:", err);
                    return res.status(500).json({ success: false, message: "Failed to fetch tutor details" });
                }

                const tutor = tutorResults[0];
                const tutorDetails = `
                    Tutor Name: ${tutor.Tutor_Name}
                    Email: ${tutor.Tutor_Email}
                    Contact: ${tutor.Tutor_Number || 'N/A'}
                    Introduction: ${tutor.tutor_introduction || 'N/A'}
                    Degree: ${tutor.tutor_degree_name} (${tutor.tutor_degree_type || 'N/A'})
                    Fee: ${tutor.tutor_teaching_fee || 'N/A'}
                    Availability Days: ${tutor.tutor_availability_days || 'N/A'}
                    Availability Time: ${tutor.tutor_availability_time || 'N/A'}
                `;

                if (action === 'accept') {
                    // First check if the entry already exists
                    const checkExistingQuery = `
                        SELECT * FROM assigned_tutors_record_table
                        WHERE Student_ID = ? AND Parent_ID = ? AND Tutor_ID = ?
                    `;

                    db.query(checkExistingQuery, [Student_ID, Parent_ID, Tutor_ID], (err, results) => {
                        if (err) {
                            console.error("Error checking for existing record:", err);
                            return res.status(500).json({ success: false, message: "Failed to check for existing record" });
                        }

                        // If an existing record is found, delete it
                        if (results.length > 0) {
                            const deleteQuery = `
                                DELETE FROM assigned_tutors_record_table
                                WHERE Student_ID = ? AND Parent_ID = ? AND Tutor_ID = ?
                            `;
                            db.query(deleteQuery, [Student_ID, Parent_ID, Tutor_ID], (err) => {
                                if (err) {
                                    console.error("Error deleting previous record:", err);
                                    return res.status(500).json({ success: false, message: "Failed to delete previous record" });
                                }

                                // Now insert the new record
                                const assignQuery = `
                                    INSERT INTO assigned_tutors_record_table (Student_ID, Parent_ID, Tutor_ID)
                                    VALUES (?, ?, ?)
                                `;
                                db.query(assignQuery, [Student_ID, Parent_ID, Tutor_ID], (err) => {
                                    if (err) {
                                        console.error("Error assigning tutor:", err);
                                        return res.status(500).json({ success: false, message: "Failed to assign tutor" });
                                    }

                                    // Update tutor_approving_status to 'approved'
                                    const updateStatusQuery = `
                                        UPDATE student_approve_tutor_status_table
                                        SET tutor_approving_status = 'approved'
                                        WHERE Student_ID = ? AND Tutor_ID = ?
                                    `;

                                    db.query(updateStatusQuery, [Student_ID, Tutor_ID], (err) => {
                                        if (err) {
                                            console.error("Error updating tutor approving status:", err);
                                            return res.status(500).json({ success: false, message: "Failed to update tutor approving status" });
                                        }

                                        const emailMessage = `Your request has been accepted.\n\nTutor Details:\n${tutorDetails}`;
                                        sendEmail(Student_Email, Parent_Email, 'Request Accepted', emailMessage);
                                        res.json({ success: true, message: "Request accepted, status updated, and emails sent" });
                                    });
                                });
                            });
                        } else {
                            // If no existing record, insert the new record directly
                            const assignQuery = `
                                INSERT INTO assigned_tutors_record_table (Student_ID, Parent_ID, Tutor_ID)
                                VALUES (?, ?, ?)
                            `;
                            db.query(assignQuery, [Student_ID, Parent_ID, Tutor_ID], (err) => {
                                if (err) {
                                    console.error("Error assigning tutor:", err);
                                    return res.status(500).json({ success: false, message: "Failed to assign tutor" });
                                }

                                // Update tutor_approving_status to 'approved'
                                const updateStatusQuery = `
                                    UPDATE student_approve_tutor_status_table
                                    SET tutor_approving_status = 'approved'
                                    WHERE Student_ID = ? AND Tutor_ID = ?
                                `;

                                db.query(updateStatusQuery, [Student_ID, Tutor_ID], (err) => {
                                    if (err) {
                                        console.error("Error updating tutor approving status:", err);
                                        return res.status(500).json({ success: false, message: "Failed to update tutor approving status" });
                                    }

                                    const emailMessage = `Your request has been accepted.\n\nTutor Details:\n${tutorDetails}`;
                                    sendEmail(Student_Email, Parent_Email, 'Request Accepted', emailMessage);
                                    res.json({ success: true, message: "Request accepted, status updated, and emails sent" });
                                });
                            });
                        }
                    });
                } else if (action === 'reject') {
                    const deleteQuery = `
                        DELETE FROM student_approve_tutor_status_table
                        WHERE Student_ID = ? AND Tutor_ID = ?
                    `;
                    db.query(deleteQuery, [Student_ID, Tutor_ID], (err) => {
                        if (err) {
                            console.error("Error rejecting request:", err);
                            return res.status(500).json({ success: false, message: "Failed to reject request" });
                        }

                        const emailMessage = `Your request has been rejected.\n\nTutor Details (for reference):\n${tutorDetails}`;
                        sendEmail(Student_Email, Parent_Email, 'Request Rejected', emailMessage);
                        res.json({ success: true, message: "Request rejected and emails sent" });
                    });
                }
            });
        });
    });

    const sendEmail = (studentEmail, parentEmail, subject, message) => {
        const transporter = nodemailer.createTransport({
            service: 'gmail',
            auth: {
                user: 'smarttutor253@gmail.com',
                pass: 'pggl mteg guur hcjd'
            }
        });

        const mailOptions = {
            from: 'smarttutor253@gmail.com',
            to: `${studentEmail}, ${parentEmail}`,
            subject,
            text: message
        };

        transporter.sendMail(mailOptions, (err) => {
            if (err) {
                console.error("Error sending email:", err);
            }
        });
    };
};
