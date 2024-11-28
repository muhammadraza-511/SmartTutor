const nodemailer = require('nodemailer');

module.exports = (app, db) => {
    app.get('/tutor_manage_student_requests', (req, res) => {
        const { Tutor_ID } = req.query;

        if (!Tutor_ID) {
            return res.status(400).json({ success: false, message: "Tutor_ID is required" });
        }

        const statusQuery = `
            SELECT t.Student_ID, s.Student_Name, s.Student_roll_No, s.Student_Email, s.Student_number,
                   t.Parent_ID, p.Parent_Roll_No, p.Parent_Email, p.Parent_number
            FROM student_approve_tutor_status_table AS t
            JOIN student_table AS s ON t.Student_ID = s.Student_ID
            JOIN parent_table AS p ON t.Parent_ID = p.Parent_ID
            WHERE t.Tutor_ID = ? AND t.tutor_approving_status = 'pending'
        `;

        db.query(statusQuery, [Tutor_ID], (err, results) => {
            if (err) {
                console.error("Error fetching student requests:", err);
                return res.status(500).json({ success: false, message: "Failed to fetch student requests" });
            }

            if (results.length === 0) {
                return res.json({ success: true, message: "No pending requests", data: [] });
            }

            res.json({ success: true, data: results });
        });
    });

};
