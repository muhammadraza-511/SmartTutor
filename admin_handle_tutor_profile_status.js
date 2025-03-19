const fs = require('fs');
const path = require('path');
const nodemailer = require('nodemailer');

module.exports = (app, db) => {
    // Route to handle fetching tutor data with a pending status
    app.get('/api/admin_handle_tutor_status', (req, res) => {
        const query = `
            SELECT tpd.*, tps.profile_status, tt.Tutor_Name 
            FROM tutor_profile_data_table tpd
            JOIN tutor_profile_status_table tps ON tpd.Tutor_ID = tps.Tutor_ID
            JOIN tutor_table tt ON tpd.Tutor_ID = tt.Tutor_ID
            WHERE tps.profile_status = 'pending';
        `;

        db.query(query, (err, results) => {
            if (err) {
                console.error('Error fetching tutor data:', err);
                return res.status(500).json({ error: 'Failed to fetch data' });
            }

            const tutorsWithFiles = results.map(tutor => {
                const tutorId = tutor.Tutor_ID;

                // Define potential file extensions for images and degree files
                const imageExtensions = ['jpeg', 'jpg', 'png'];
                const degreeExtensions = ['pdf', 'doc', 'docx'];

                let profilePicPath = null;
                let degreeFilePath = null;

                // Find the profile picture file path
                for (const ext of imageExtensions) {
                    const potentialImagePath = path.join(__dirname, 'tutor_pic', `${tutorId}.${ext}`);
                    if (fs.existsSync(potentialImagePath)) {
                        profilePicPath = `/tutor_pic/${tutorId}.${ext}`;
                        break;
                    }
                }

                // Find the degree file path
                for (const ext of degreeExtensions) {
                    const potentialDegreePath = path.join(__dirname, 'tutor_degree', `${tutorId}.${ext}`);
                    if (fs.existsSync(potentialDegreePath)) {
                        degreeFilePath = `/tutor_degree/${tutorId}.${ext}`;
                        break;
                    }
                }

                return {
                    ...tutor,
                    tutor_profile_pic: profilePicPath,
                    tutor_degree_link: degreeFilePath
                };
            });

            res.json(tutorsWithFiles);
        });
    });

    // Route to handle updating tutor profile status (Accept or Reject)
    app.post('/api/update_tutor_profile_status/:tutorId/:status', (req, res) => {
        const tutorId = req.params.tutorId;
        const status = req.params.status;

        // Query to update the profile status in the database
        const query = 'UPDATE tutor_profile_status_table SET profile_status = ? WHERE Tutor_ID = ?';
        db.query(query, [status, tutorId], (err, result) => {
            if (err) {
                console.error('Error updating profile status:', err);
                return res.status(500).json({ error: 'Failed to update profile status' });
            }

            // Fetch tutor's email after status update
            const emailQuery = 'SELECT tutor_email FROM tutor_table WHERE Tutor_ID = ?';
            db.query(emailQuery, [tutorId], (err, emailResult) => {
                if (err) {
                    console.error('Error fetching tutor email:', err);
                    return res.status(500).json({ error: 'Failed to fetch tutor email' });
                }

                const tutorEmail = emailResult[0].tutor_email;
                const subject = `Your Profile Status: ${status === 'accepted' ? 'Accepted' : 'Rejected'}`;
                const message = status === 'accepted'
                    ? `Dear Tutor,\n\nWe are pleased to inform you that your profile has been successfully accepted. Congratulations on joining the SmartTutor community! We look forward to working with you and supporting your journey with us.\n\nBest regards,\nSmartTutor Team`
                    : `Dear Tutor,\n\nWe regret to inform you that after careful review, your profile has not been accepted at this time. We appreciate the effort you put into your application and encourage you to stay in touch for future opportunities.\n\nBest regards,\nSmartTutor Team`;

                // Send the email using Nodemailer
                const transporter = nodemailer.createTransport({
                    service: 'gmail', // You can use other services like 'sendgrid', 'outlook', etc.
                    auth: {
                        user: 'smarttutor253@gmail.com', // Your email
                        pass: 'pggl mteg guur hcjd'  // Your email password (use app password if 2FA enabled)
                    }
                });

                const mailOptions = {
                    from: 'smarttutor253@gmail.com',
                    to: tutorEmail,
                    subject: subject,
                    text: message
                };

                transporter.sendMail(mailOptions, (err, info) => {
                    if (err) {
                        console.error('Error sending email:', err);
                        return res.status(500).json({ error: 'Failed to send email' });
                    }
                    console.log('Email sent: ' + info.response);
                    res.json({ message: `Profile status updated to ${status} and email sent to tutor` });
                });
            });
        });
    });
};
