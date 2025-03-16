module.exports = (app, db) => {
    // Fetch ongoing and future sessions for a student
    app.post('/getStudentSessions', (req, res) => {
        const { studentRollNo } = req.body;

        if (!studentRollNo) {
            return res.status(400).json({ error: 'Student roll number is required' });
        }

        // Get Student_ID from student_table
        const getStudentQuery = 'SELECT Student_ID FROM student_table WHERE Student_roll_No = ?';

        db.query(getStudentQuery, [studentRollNo], (err, result) => {
            if (err) {
                console.error('Error fetching student ID:', err);
                return res.status(500).json({ error: 'Database error' });
            }

            if (result.length === 0) {
                return res.status(404).json({ error: 'Student not found' });
            }

            const studentId = result[0].Student_ID;

            // Get current date and time
            const currentDate = new Date().toISOString().split('T')[0]; // YYYY-MM-DD
            const currentTime = new Date().toTimeString().split(' ')[0]; // HH:MM:SS

            // Fetch ongoing and future sessions for the student
            const getSessionsQuery = `
                SELECT Session_ID, Session_Start_Date, Session_Start_Time, Session_End_Time
                FROM meeting_details
                WHERE Student_ID = ?
                AND (
                    (Session_Start_Date > ?) -- Future sessions
                    OR (Session_Start_Date = ? AND Session_Start_Time >= ?) -- Today's future sessions
                    OR (Session_Start_Date = ? AND Session_Start_Time <= ? AND Session_End_Time >= ?) -- Ongoing sessions
                )
                ORDER BY Session_Start_Date, Session_Start_Time
            `;

            db.query(getSessionsQuery, [studentId, currentDate, currentDate, currentTime, currentDate, currentTime, currentTime], (err, sessions) => {
                if (err) {
                    console.error('Error fetching student sessions:', err);
                    return res.status(500).json({ error: 'Database error' });
                }

                res.status(200).json(sessions);
            });
        });
    });
};
