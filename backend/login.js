const bcrypt = require('bcrypt');

module.exports = (app, db) => {
    // POST endpoint for login
    app.post('/api/login', (req, res) => {
        const rollNumber = req.body.rollNumber;
        const passwordInput = req.body.password;

        const rollNumberRegex = /^\d{2}[ASTP]-\d{4}$/;

        if (!rollNumberRegex.test(rollNumber)) {
            return res.status(400).json({ success: false, message: 'Invalid roll number format. Use XXA-XXXX, XXS-XXXX, XXT-XXXX, XXP-XXXX.' });
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
            return res.status(400).json({ success: false, message: 'Invalid roll number.' });
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
            if (err) return res.status(500).json({ success: false, message: 'Database query error.' });

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
                    if (table === 'tutor_table') {
                        const profileStatusQuery = 'SELECT profile_status FROM tutor_profile_status_table WHERE Tutor_ID = ?';
                        db.query(profileStatusQuery, [user.Tutor_ID], (err, statusResults) => {
                            if (err) return res.status(500).json({ success: false, message: 'Error checking tutor profile status.' });

                            if (statusResults.length > 0 && statusResults[0].profile_status === 'Not created') {
                                return res.json({ success: true, redirect: '/tutor_profile_creation.html' });
                            } else {
                                req.session.user_details = user;
                                return res.json({ success: true, redirect: '/tutor_dashboard.html' });
                            }
                        });
                    } else {
                        req.session.user_details = user;
                        const redirectUrl = table === 'admin_table' ? '/admin_dashboard.html'
                            : table === 'student_table' ? '/student_dashboard.html'
                            : '/parent_dashboard.html';

                        return res.json({ success: true, redirect: redirectUrl });
                    }
                } else {
                    return res.status(400).json({ success: false, message: 'Invalid roll number or password.' });
                }
            } else {
                return res.status(400).json({ success: false, message: 'Invalid roll number or password.' });
            }
        });
    });

    // Fetch user details for the dashboard page
    app.get('/dashboard', (req, res) => {
        if (!req.session.user_details) {
            return res.status(401).json({ success: false, message: 'Unauthorized access. Please log in.' });
        }

        const user = req.session.user_details;
        const table = user.Admin_Roll_number ? 'admin_table' :
            user.Student_roll_No ? 'student_table' :
            user.Tutor_Roll_No ? 'tutor_table' : 'parent_table';

        if (table === 'parent_table') {
            const parentID = user.Parent_ID;

            const parentQuery = `
                SELECT * 
                FROM parent_table 
                WHERE Parent_ID = ?
            `;
            const studentQuery = `
                SELECT * 
                FROM student_table 
                WHERE Student_ID = ?
            `;

            db.query(parentQuery, [parentID], (err, parentResults) => {
                if (err) return res.status(500).json({ success: false, message: 'Error fetching parent details.' });

                if (parentResults.length > 0) {
                    const parent = parentResults[0];
                    const studentID = parent.Student_ID;

                    db.query(studentQuery, [studentID], (err, studentResults) => {
                        if (err) return res.status(500).json({ success: false, message: 'Error fetching student details.' });

                        const student = studentResults.length > 0 ? studentResults[0] : null;
                        return res.json({ success: true, user: parent, child: student });
                    });
                } else {
                    return res.status(404).json({ success: false, message: 'Parent details not found.' });
                }
            });
        } else {
            res.json({ success: true, user, table });
        }
    });
};
