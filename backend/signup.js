const nodemailer = require('nodemailer');
const bcrypt = require('bcrypt');

module.exports = (app, db) => {
    // Generate a unique Student Roll Number
    function generateStudentRollNo() {
        const year = new Date().getFullYear().toString().slice(-2);
        const randomDigits = Math.floor(1000 + Math.random() * 9000);
        return `${year}S-${randomDigits}`;
    }

    // Function to check if email exists in otp_table
    function checkOtpEmailExistence(email, callback) {
        const query = 'SELECT * FROM otp_table WHERE email = ?';
        db.query(query, [email], (err, results) => {
            if (err) return callback(err);
            callback(null, results.length > 0); // Returns true if email exists
        });
    }

    function checkOtpStatus(email, callback) {
        const query = 'SELECT * FROM otp_table WHERE email = ? AND status = "authorized"';
        db.query(query, [email], (err, results) => {
            if (err) return callback(err);
            // Check if OTP status is authorized
            callback(null, results.length > 0);
        });
    }

    // Add this function to delete OTP from otp_table
    function deleteOtpByEmail(email, callback) {
        const deleteQuery = 'DELETE FROM otp_table WHERE email = ?';
        db.query(deleteQuery, [email], (err, results) => {
            if (err) return callback(err);
            callback(null, results.affectedRows > 0); // Returns true if a row is deleted
        });
    }




    // Generate a unique Tutor Roll Number
    function generateTutorRollNo() {
        const year = new Date().getFullYear().toString().slice(-2);
        const randomDigits = Math.floor(1000 + Math.random() * 9000);
        return `${year}T-${randomDigits}`;
    }

    // Generate a unique Parent Roll Number
    function generateParentRollNo(studentRollNo) {
        return studentRollNo.replace('S', 'P');
    }

    // Function to generate a random 8-character password
    function generateRandomPassword(length = 8) {
        const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        let password = '';
        for (let i = 0; i < length; i++) {
            const randomIndex = Math.floor(Math.random() * characters.length);
            password += characters[randomIndex];
        }
        return password;
    }

    // Function to check if username or email exists
    function checkUserExistence(username, email, role, callback) {
        const query = `SELECT * FROM ${role === 'tutor' ? 'tutor_table' : 'student_table'} WHERE Tutor_UserName = ? OR Tutor_Email = ?`;
        db.query(query, [username, email], (err, results) => {
            if (err) return callback(err);
            callback(null, results.length > 0); // Returns true if user exists
        });
    }

    // Function to check if Tutor Roll Number exists
    function checkTutorRollNoExistence(rollNo, callback) {
        const query = 'SELECT * FROM tutor_table WHERE Tutor_Roll_No = ?';
        db.query(query, [rollNo], (err, results) => {
            if (err) return callback(err);
            callback(null, results.length > 0); // Returns true if roll number exists
        });
    }

    // Function to check if Student Roll Number, Username or Email exists
    function checkStudentExistence(rollNo, username, email, callback) {
        const query = 'SELECT * FROM student_table WHERE Student_Roll_No = ? OR Student_UserName = ? OR Student_Email = ?';
        db.query(query, [rollNo, username, email], (err, results) => {
            if (err) return callback(err);
            callback(null, results.length > 0); // Returns true if any of the values exist
        });
    }

    // POST endpoint to handle form submissions
    app.post('/api/signup', (req, res) => {
        const { role, fullname, username, email, contact, password, confirm_password, parent_email, parent_contact, student_roll_no } = req.body;
    
        // Simple validation
        if (!fullname || !email || !contact || !password || !confirm_password) {
            return res.status(400).send('All fields are required.');
        }
    
        if (password !== confirm_password) {
            return res.status(400).send('Passwords do not match.');
        }

        // Check if the email exists in otp_table
        checkOtpEmailExistence(email, (err, exists) => {
        if (err) {
            console.error('Error checking OTP email existence:', err);
            return res.status(500).json({ message: 'Error checking OTP email existence' });
        }

        if (!exists) {
            // Respond with the redirect URL containing the email as a query parameter
            const redirectUrl = `/otp_verification.html?email=${encodeURIComponent(email)}`;
            return res.json({ action: 'open_otp_page', redirectUrl });
        }


        // Check if the OTP status is authorized for the provided email
        checkOtpStatus(email, (err, isAuthorized) => {
            if (err) {
                console.error('Error checking OTP status:', err);
                return res.status(500).json({ message: 'Error checking OTP status' });
            }

            if (!isAuthorized) {
                // If OTP is not authorized, respond with a redirect to the OTP page
                const redirectUrl = `/otp_verification.html?email=${encodeURIComponent(email)}`;
                return res.json({ action: 'open_otp_page', redirectUrl });
            }


    
        // Configure Nodemailer
        const transporter = nodemailer.createTransport({
            service: 'gmail',
            auth: {
                user: 'smarttutor253@gmail.com',
                pass: 'pggl mteg guur hcjd' // Use environment variables for sensitive data
            },
            tls: {
                rejectUnauthorized: false
            }
        });
    
        if (role === 'student') {
            // Check if Student Roll No, Username or Email exists
            checkStudentExistence(student_roll_no, username, email, (err, exists) => {
                if (err) {
                    console.error('Error checking student existence:', err);
                    return res.status(500).json({ message: 'Error checking student existence' });
                }
    
                if (exists) {
                    return res.status(400).json({ message: 'Student Roll No, Username, or Email already exists.' });
                }
    
                // Hash the password before inserting
                bcrypt.hash(password, 10, (err, hashedPassword) => {
                    if (err) {
                        console.error('Error hashing password:', err);
                        return res.status(500).json({ message: 'Error registering student' });
                    }
    
                    // Insert student data into the database
                    const insertStudentQuery = `INSERT INTO student_table (Student_Name, Student_Roll_No, Student_UserName, Student_Email, Student_number, Password) VALUES (?, ?, ?, ?, ?, ?)`;
                    const studentValues = [fullname, student_roll_no, username, email, contact, hashedPassword];
    
                    db.query(insertStudentQuery, studentValues, (err, result) => {
                        if (err) {
                            console.error('Error inserting student data:', err);
                            return res.status(500).json({ message: 'Error registering student' });
                        }
    
                        console.log('Student registered with ID:', result.insertId);
    
                        // Generate random password for parent
                        const parentPassword = generateRandomPassword();
    
                        // Hash the parent password before inserting
                        bcrypt.hash(parentPassword, 10, (err, hashedParentPassword) => {
                            if (err) {
                                console.error('Error hashing parent password:', err);
                                return res.status(500).json({ message: 'Error registering parent' });
                            }
    
                            // Insert parent data into the database
                            const insertParentQuery = `INSERT INTO parent_table (Student_ID, Parent_Roll_No, Parent_Email, Parent_number, Parent_Password) VALUES (?, ?, ?, ?, ?)`;
                            const parentValues = [result.insertId, generateParentRollNo(student_roll_no), parent_email, parent_contact, hashedParentPassword];
    
                            db.query(insertParentQuery, parentValues, (err) => {
                                if (err) {
                                    console.error('Error inserting parent data:', err);
                                    return res.status(500).json({ message: 'Error registering parent' });
                                }
    
                                // Send confirmation email to the student
                                const studentMailOptions = {
                                    from: 'smarttutor253@gmail.com',
                                    to: email,
                                    subject: 'Student Registration confirmation!',
                                    text: `Dear ${fullname},\n\nThank you for signing up as a student!\n\nHere are your important details:\n- Student Roll No: ${student_roll_no}\n- Student Username: ${username}\n\nWe are excited to have you on board!\n\nBest Regards,\nSmart Tutor Team`
                                };
    
                                transporter.sendMail(studentMailOptions, (error) => {
                                    if (error) {
                                        console.error('Error sending email to student:', error);
                                        return res.status(500).json({ message: 'Error sending confirmation email to student' });
                                    }
    
                                    // Send confirmation email to the parent
                                    const parentMailOptions = {
                                        from: 'smarttutor253@gmail.com',
                                        to: parent_email,
                                        subject: 'Child Registartion Alert!',
                                        text: `Dear Parent,\n\nThank you for registering your child with us!\n\nHere are the important details:\n- Parent Roll No: ${generateParentRollNo(student_roll_no)}\n- Student Name: ${fullname}\n- Parent Password: ${parentPassword}\n\nWe are here to support your child's educational journey!\n\nBest Regards,\nSmart Tutor Team`
                                    };
    
                                    transporter.sendMail(parentMailOptions, (error) => {
                                        if (error) {
                                            console.error('Error sending email to parent:', error);
                                            return res.status(500).json({ message: 'Error sending confirmation email to parent' });
                                        }
    
                                        res.json({ message: 'Student and Parent registered successfully!', redirect: '/index.html' });
                                    });
                                    deleteOtpByEmail(email, (err, isDeleted) => {
                                        if (err) {
                                            console.error('Error deleting OTP entry:', err);
                                        } else if (isDeleted) {
                                            console.log(`OTP entry for ${email} deleted successfully.`);
                                        } else {
                                            console.log(`No OTP entry found for ${email} to delete.`);
                                        }
                                    });
                                    
                                });
                            });
                        });
                    });
                });
            });
        } else if (role === 'tutor') {
            // Check if username or email exists
            checkUserExistence(username, email, role, (err, exists) => {
                if (err) {
                    console.error('Error checking username/email existence:', err);
                    return res.status(500).json({ message: 'Error checking username/email existence' });
                }
    
                if (exists) {
                    return res.status(400).json({ message: 'Username or email already exists.' });
                }
    
                let tutorRollNumber = generateTutorRollNo();
                
                checkTutorRollNoExistence(tutorRollNumber, (err, exists) => {
                    if (err) {
                        console.error('Error checking roll number existence:', err);
                        return res.status(500).json({ message: 'Error checking roll number existence' });
                    }

                    while (exists) {
                        tutorRollNumber = generateTutorRollNo();
                        checkTutorRollNoExistence(tutorRollNumber, (err, result) => {
                            if (err) {
                                console.error('Error checking roll number existence:', err);
                                return res.status(500).json({ message: 'Error checking roll number existence' });
                            }
                            exists = result;
                        });
                    }
    
                    bcrypt.hash(password, 10, (err, hashedPassword) => {
                        if (err) {
                            console.error('Error hashing password:', err);
                            return res.status(500).json({ message: 'Error registering tutor' });
                        }
    
                        const insertTutorQuery = `INSERT INTO tutor_table (Tutor_Name, Tutor_Roll_No, Tutor_UserName, Tutor_Email, Tutor_number, Tutor_Password) VALUES (?, ?, ?, ?, ?, ?)`;
                        const tutorValues = [fullname, tutorRollNumber, username, email, contact, hashedPassword];
    
                        db.query(insertTutorQuery, tutorValues, (err, result) => {
                            if (err) {
                                console.error('Error inserting tutor data:', err);
                                return res.status(500).json({ message: 'Error registering tutor' });
                            }
                            const tutorID = result.insertId;
                            console.log('Tutor registered with ID:', tutorID);

                            // Insert into tutor_profile_status_table
                            const insertProfileStatusQuery = `INSERT INTO tutor_profile_status_table (Tutor_ID, profile_status) VALUES (?, 'Not created')`;
                            db.query(insertProfileStatusQuery, [tutorID], (err) => {
                                if (err) {
                                    console.error('Error inserting profile status:', err);
                                    return res.status(500).json({ message: 'Error setting profile status' });
                                }
                                
                                // Send confirmation email
                                const mailOptions = {
                                    from: 'smarttutor253@gmail.com',
                                    to: email,
                                    subject: 'Tutor Registration Confirmation!',
                                    text: `Dear ${fullname},\n\nThank you for signing up as a Tutor!\n\nHere are your important details:\n- Tutor Roll No: ${tutorRollNumber}\n\nWe are excited to have you on our team!\n\nBest Regards,\nSmart Tutor Team`
                                };
    
                                transporter.sendMail(mailOptions, (error) => {
                                    if (error) {
                                        console.error('Error sending email to tutor:', error);
                                        return res.status(500).json({ message: 'Error sending confirmation email to tutor' });
                                    }
                                    
                                    res.json({ message: 'Student and Parent registered successfully!', redirect: '/tutor_profile_creation.html' });

                                    // Send response with alert and redirect
                                    // res.send(`
                                    //     <script>
                                    //         alert("Registration successful. Please complete your profile now");
                                    //         window.location.href = "/tutor_profile_creation.html";
                                    //     </script>
                                    // `);
                                });
                            });
                        });
                        deleteOtpByEmail(email, (err, isDeleted) => {
                            if (err) {
                                console.error('Error deleting OTP entry:', err);
                            } else if (isDeleted) {
                                console.log(`OTP entry for ${email} deleted successfully.`);
                            } else {
                                console.log(`No OTP entry found for ${email} to delete.`);
                            }
                        });
                        
                    });
                });
            });
        } else {
            res.status(400).send('Invalid role.');
        }
    });
});
});

};
