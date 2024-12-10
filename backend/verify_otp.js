const crypto = require('crypto');
const nodemailer = require('nodemailer');

module.exports = (app, db) => {
    // Endpoint to handle OTP verification
    app.post('/api/verify_otp', (req, res) => {
        const { email, otp } = req.body;

        if (!email || !otp) {
            return res.status(400).json({ message: 'Email and OTP are required.' });
        }

        // Query to check if the OTP and email match
        const sql = `
            SELECT * FROM otp_table 
            WHERE email = ? AND otp = ? AND status = 'unauthorized'
        `;
        
        db.query(sql, [email, otp], (err, results) => {
            if (err) {
                console.error('Database error:', err);
                return res.status(500).json({ message: 'Database error.' });
            }

            // Check if a matching OTP entry was found
            if (results.length > 0) {
                // OTP is valid, update the status to 'authorized'
                const updateSql = `
                    UPDATE otp_table 
                    SET status = 'authorized' 
                    WHERE email = ? AND otp = ?
                `;
                
                db.query(updateSql, [email, otp], (updateErr) => {
                    if (updateErr) {
                        console.error('Error updating OTP status:', updateErr);
                        return res.status(500).json({ message: 'Error verifying OTP.' });
                    }

                    // Send success response
                    console.log('OTP verified successfully!');
                    res.status(200).json({ message: 'Verification successful!' });

                    // Schedule deletion of the OTP record after 1 minute
                    setTimeout(() => {
                        const deleteSql = `
                            DELETE FROM otp_table 
                            WHERE email = ? AND otp = ?
                        `;
                        
                        db.query(deleteSql, [email, otp], (deleteErr) => {
                            if (deleteErr) {
                                console.error('Error deleting OTP record:', deleteErr);
                            } else {
                                console.log(`OTP record for email: ${email} deleted successfully.`);
                            }
                        });
                    }, 60000); // 60000 ms = 1 minute
                });
            } else {
                // No matching OTP found
                console.log('Invalid OTP or email');
                res.status(400).json({ message: 'Invalid OTP or email.' });
            }
        });
    });
};
