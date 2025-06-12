module.exports = (app, db) => {
    // Endpoint to get recent quiz topics for a tutor
    app.get('/recent-quiz-topics', (req, res) => {
        const tutorId = req.query.tutorId;
        
        if (!tutorId) {
            return res.status(400).json({ error: "Tutor ID is required" });
        }

        const query = `
            SELECT Quiz_ID, Quiz_Topic 
            FROM tutor_generate_quiz_table 
            WHERE Tutor_ID = ? 
            AND created_at >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
            GROUP BY Quiz_Topic
            ORDER BY created_at DESC
            LIMIT 10
        `;

        db.query(query, [tutorId], (err, results) => {
            if (err) {
                console.error("Error fetching quiz topics:", err);
                return res.status(500).json({ error: "Database error" });
            }
            res.json(results);
        });
    });

    // Endpoint to get assigned students for a tutor
    app.get('/assigned-students', (req, res) => {
        const tutorId = req.query.tutorId;
        
        if (!tutorId) {
            return res.status(400).json({ error: "Tutor ID is required" });
        }

        const query = `
            SELECT s.Student_ID, s.Student_Name, s.Student_roll_No
            FROM assigned_tutors_record_table a
            JOIN student_table s ON a.Student_ID = s.Student_ID
            WHERE a.Tutor_ID = ?
            ORDER BY s.Student_Name ASC
        `;

        db.query(query, [tutorId], (err, results) => {
            if (err) {
                console.error("Error fetching assigned students:", err);
                return res.status(500).json({ error: "Database error" });
            }
            res.json(results);
        });
    });

    // Endpoint to publish quiz to students
app.post('/publish-quiz', (req, res) => {
    const { tutorId, quizId, quizTopic, studentIds, startTime, endTime } = req.body;
    
    if (!tutorId || !quizId || !quizTopic || !studentIds || !startTime || !endTime) {
        return res.status(400).json({ error: "All fields are required" });
    }

    // Get current date
    const currentDate = new Date().toISOString().split('T')[0];
    
    // Combine with the time values to create full datetime strings
    const startDateTime = `${currentDate} ${startTime}:00`;
    const endDateTime = `${currentDate} ${endTime}:00`;

    // Convert studentIds to an array if it's not already
    const studentsArray = Array.isArray(studentIds) ? studentIds : [studentIds];

    // Prepare values for batch insert
    const values = studentsArray.map(studentId => [
        quizId,
        tutorId,
        studentId,
        quizTopic,
        startDateTime,
        endDateTime
    ]);

    const query = `
        INSERT INTO tutor_schedule_quiz_table 
        (Quiz_ID, Tutor_ID, Student_ID, Quiz_Topic, Start_Time, End_Time)
        VALUES ?
    `;

    db.query(query, [values], (err, result) => {
        if (err) {
            console.error("Error publishing quiz:", err);
            return res.status(500).json({ error: "Failed to publish quiz" });
        }
        
        res.json({
            success: true,
            message: `Quiz published to ${result.affectedRows} student(s)`,
            scheduleId: result.insertId
        });
    });
});

};