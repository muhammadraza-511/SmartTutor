const crypto = require('crypto');
const nodemailer = require('nodemailer');

module.exports = (app, db) => {
    // Endpoint to handle OTP sending
    app.post('/api/send_otp', async (req, res) => {
        const { email } = req.body;

        if (!email) {
            return res.status(400).json({ message: 'Email is required.' });
        }

        try {
            // Generate a random 6-digit OTP
            const otp = crypto.randomInt(100000, 999999);

            // Get the current timestamp
            const timestamp = new Date();

            // Step 1: Check if email already exists in otp_table
            const checkEmailSQL = 'SELECT * FROM otp_table WHERE email = ?';
            db.query(checkEmailSQL, [email], (err, results) => {
                if (err) {
                    console.error('Error checking email in database:', err);
                    return res.status(500).json({ message: 'Database error.' });
                }

                // Step 2: If email exists, delete the existing OTP record
                if (results.length > 0) {
                    const deleteEmailSQL = 'DELETE FROM otp_table WHERE email = ?';
                    db.query(deleteEmailSQL, [email], (deleteErr) => {
                        if (deleteErr) {
                            console.error('Error deleting existing OTP from database:', deleteErr);
                            return res.status(500).json({ message: 'Database error while deleting OTP.' });
                        }

                        console.log('Old OTP entry deleted.');
                        sendNewOtp();
                    });
                } else {
                    // No existing OTP entry, proceed to send new OTP
                    sendNewOtp();
                }
            });

            // Function to generate and send the OTP
            function sendNewOtp() {
                // Generate a random 6-digit OTP
                const otp = crypto.randomInt(100000, 999999);

                // Get the current timestamp
                const timestamp = new Date();

                // Step 3: Insert new OTP details into otp_table
                const insertSQL = 'INSERT INTO otp_table (email, otp, timestamp, status) VALUES (?, ?, ?, "unauthorized")';
                db.query(insertSQL, [email, otp, timestamp], (insertErr, result) => {
                    if (insertErr) {
                        console.error('Error inserting OTP into database:', insertErr);
                        return res.status(500).json({ message: 'Database error.' });
                    }

                    console.log('OTP stored in database:', result);

                    // Step 4: Configure nodemailer transporter
                    const transporter = nodemailer.createTransport({
                        service: 'gmail', // Change this if using a different email service
                        auth: {
                            user: 'smarttutor253@gmail.com', // Replace with your email
                            pass: 'pggl mteg guur hcjd'   // Replace with your email password or app password
                        }
                    });

                    // Email options
                    const mailOptions = {
                        from: 'smarttutor253@gmail.com',
                        to: email,
                        subject: 'Your OTP for Verification',
                        text: `Your OTP is ${otp}. Please do not share it with anyone.`
                    };

                    // Step 5: Send the email
                    transporter.sendMail(mailOptions, (error, info) => {
                        if (error) {
                            console.error('Error sending email:', error);
                            return res.status(500).json({ message: 'Failed to send OTP email.' });
                        }

                        console.log('Email sent:', info.response);
                        res.status(200).json({ message: 'OTP sent successfully!' });
                    });
                });
            }
        } catch (error) {
            console.error('Error generating OTP:', error);
            res.status(500).json({ message: 'Server error. Please try again later.' });
        }
    });

    // Endpoint to handle OTP verification
    app.post('/api/verify_otp', (req, res) => {
        const { email, otp } = req.body;

        if (!email || !otp) {
            return res.status(400).json({ message: 'Email and OTP are required.' });
        }

        // Step 1: Fetch the OTP from the database for the given email
        const getOtpSQL = 'SELECT * FROM otp_table WHERE email = ? ORDER BY timestamp DESC LIMIT 1';
        db.query(getOtpSQL, [email], (err, results) => {
            if (err) {
                console.error('Error fetching OTP from database:', err);
                return res.status(500).json({ message: 'Database error.' });
            }

            // Step 2: Check if the OTP exists
            if (results.length === 0) {
                return res.status(400).json({ message: 'No OTP found for this email.' });
            }

            const storedOtp = results[0].otp;
            const status = results[0].status;

            // Step 3: Check if the OTP matches and if the status is unauthorized
            if (status === 'authorized') {
                return res.status(400).json({ message: 'OTP already verified.' });
            }

            if (storedOtp === parseInt(otp)) {
                // Step 4: Update the OTP status to 'authorized'
                const updateStatusSQL = 'UPDATE otp_table SET status = "authorized" WHERE email = ?';
                db.query(updateStatusSQL, [email], (updateErr, updateResult) => {
                    if (updateErr) {
                        console.error('Error updating OTP status:', updateErr);
                        return res.status(500).json({ message: 'Failed to update OTP status.' });
                    }

                    console.log('OTP verified and status updated.');
                    res.status(200).json({ message: 'Verification successful!' });
                });
            } else {
                return res.status(400).json({ message: 'Invalid OTP.' });
            }
        });
    });
};
