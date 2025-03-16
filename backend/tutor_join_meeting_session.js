module.exports = (app, db) => {
    app.post('/getTutorSessions', (req, res) => {
        const { tutorRollNo } = req.body;

        if (!tutorRollNo) {
            return res.status(400).json({ error: 'Tutor roll number is required' });
        }

        // Get Tutor_ID from tutor_table
        const getTutorQuery = 'SELECT Tutor_ID FROM tutor_table WHERE Tutor_Roll_No = ?';

        db.query(getTutorQuery, [tutorRollNo], (err, result) => {
            if (err) {
                console.error('Error fetching tutor ID:', err);
                return res.status(500).json({ error: 'Database error' });
            }

            if (result.length === 0) {
                return res.status(404).json({ error: 'Tutor not found' });
            }

            const tutorId = result[0].Tutor_ID;

            // Get current date and time
            const currentDate = new Date().toISOString().split('T')[0]; // YYYY-MM-DD
            const currentTime = new Date().toTimeString().split(' ')[0]; // HH:MM:SS

            // Fetch ongoing and future sessions for the tutor
            const getSessionsQuery = `
            SELECT DISTINCT Session_ID, Session_Start_Date, Session_Start_Time, Session_End_Time
            FROM meeting_details
            WHERE Tutor_ID = ?
            AND (
                (Session_Start_Date > ?) 
                OR (Session_Start_Date = ? AND Session_Start_Time <= ? AND Session_End_Time >= ?)
            )
            ORDER BY Session_Start_Date, Session_Start_Time
            `;

            db.query(getSessionsQuery, [tutorId, currentDate, currentDate, currentTime, currentTime], (err, sessions) => {
                if (err) {
                    console.error('Error fetching tutor session details:', err);
                    return res.status(500).json({ error: 'Database error' });
                }

                res.status(200).json(sessions);
            });
        });
    });
};
