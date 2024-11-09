const bcrypt = require('bcrypt');

module.exports = (app, db) => {
    // POST endpoint for login
    app.post('/api/login', (req, res) => {
        const rollNumber = req.body.rollNumber;
        const passwordInput = req.body.password;

        const rollNumberRegex = /^\d{2}[ASTP]-\d{4}$/;

        if (!rollNumberRegex.test(rollNumber)) {
            return res.status(400).send('Invalid roll number format. Make sure that roll numbers are in the following format: XXA-XXXX, XXS-XXXX, XXT-XXXX, XXP-XXXX where X represents any number.');
        }

        let table = '';
        if (rollNumber.includes('A')) {
            table = 'admin_table';
        } else if (rollNumber.includes('S')) {
            table = 'student_table';
        } else if (rollNumber.includes('T')) {
            table = 'tutor_table';
        } else if (rollNumber.includes('P')) {
            table = 'parent_table';
        } else {
            return res.status(400).send('Invalid roll number.');
        }

        let sql = '';
        switch (table) {
            case 'admin_table':
                sql = 'SELECT * FROM admin_table WHERE Admin_Roll_number = ?';
                break;
            case 'student_table':
                sql = 'SELECT * FROM student_table WHERE Student_roll_No = ?';
                break;
            case 'tutor_table':
                sql = 'SELECT * FROM tutor_table WHERE Tutor_Roll_No = ?';
                break;
            case 'parent_table':
                sql = 'SELECT * FROM parent_table WHERE Parent_Roll_No = ?';
                break;
        }

        db.query(sql, [rollNumber], (err, results) => {
            if (err) return res.status(500).send('Database query error.');

            if (results.length > 0) {
                const user = results[0];
                let isPasswordValid = false;

                if (table === 'admin_table') {
                    isPasswordValid = (passwordInput === user.Admin_password);
                } else {
                    const storedPassword = user.Password || user.Tutor_password || user.Parent_Password;
                    isPasswordValid = bcrypt.compareSync(passwordInput, storedPassword);
                }

                if (isPasswordValid) {
                    // Check profile status for tutors
                    if (table === 'tutor_table') {
                        const profileStatusQuery = 'SELECT profile_status FROM tutor_profile_status_table WHERE Tutor_ID = ?';
                        db.query(profileStatusQuery, [user.Tutor_ID], (err, statusResults) => {
                            if (err) return res.status(500).send('Error checking tutor profile status.');

                            if (statusResults.length > 0 && statusResults[0].profile_status === 'Not created') {
                                return res.redirect('/tutor_profile_creation.html');
                                //return res.status(400).json({ message: 'You have to create your profile first.', redirect: '/tutor_profile_creation.html' });
                            } else {
                                req.session.user_details = user;
                                return res.redirect('/tutor_dashboard.html');
                            }
                        });
                    } else {
                        // For other roles, redirect directly
                        req.session.user_details = user;

                        switch (table) {
                            case 'admin_table':
                                return res.redirect('/admin_dashboard.html');
                            case 'student_table':
                                return res.redirect('/student_dashboard.html');
                            case 'parent_table':
                                return res.redirect('/parent_dashboard.html');
                        }
                    }
                } else {
                    return res.status(400).send('Invalid roll number or password.');
                }
            } else {
                return res.status(400).send('Invalid roll number or password.');
            }
        });
    });

    // Fetch user details for the dashboard page
    app.get('/dashboard', (req, res) => {
        if (!req.session.user_details) {
            return res.status(401).send('Unauthorized access. Please log in.');
        }
        const user = req.session.user_details;
        const table = user.Admin_Roll_number ? 'admin_table' :
            user.Student_roll_No ? 'student_table' :
            user.Tutor_Roll_No ? 'tutor_table' : 'parent_table';

        res.json({ user, table });
    });
};
