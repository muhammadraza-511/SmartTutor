// tutor_generate_quiz.js
module.exports = (app, db) => {
    app.post('/submit-quiz', (req, res) => {
        const { tutorId, quizTopic, questions, overwrite } = req.body;

        if (!tutorId || !quizTopic || !questions || questions.length === 0) {
            return res.status(400).json({ error: "Missing required fields" });
        }

        // First check if quiz with same topic exists for this tutor
        const checkQuery = `
            SELECT COUNT(*) as count FROM tutor_generate_quiz_table 
            WHERE Tutor_ID = ? AND Quiz_Topic = ?
        `;

        db.query(checkQuery, [tutorId, quizTopic], (err, results) => {
            if (err) {
                console.error("Database error:", err);
                return res.status(500).json({ error: "Failed to check existing quizzes" });
            }

            const exists = results[0].count > 0;

            if (exists && !overwrite) {
                return res.json({ 
                    exists: true,
                    message: `A quiz with topic "${quizTopic}" already exists. Would you like to overwrite it?`
                });
            }

            // If overwrite is requested, delete existing quizzes first
            const deleteQuery = `DELETE FROM tutor_generate_quiz_table WHERE Tutor_ID = ? AND Quiz_Topic = ?`;
            
            const handleInsert = () => {
                // Prepare the values for bulk insert
                const values = questions.map(q => [
                    tutorId,
                    quizTopic,
                    q.question,
                    q.options[0],
                    q.options[1],
                    q.options[2],
                    q.options[3],
                    q.correctAnswer
                ]);

                const insertQuery = `
                    INSERT INTO tutor_generate_quiz_table 
                    (Tutor_ID, Quiz_Topic, Quiz_Question, Quiz_Option1, Quiz_Option2, Quiz_Option3, Quiz_Option4, Quiz_Correct_Option) 
                    VALUES ?
                `;

                db.query(insertQuery, [values], (err, result) => {
                    if (err) {
                        console.error("Database error:", err);
                        return res.status(500).json({ error: "Failed to save quiz" });
                    }
                    
                    res.json({ 
                        success: true, 
                        message: "Quiz saved successfully",
                        insertedRows: result.affectedRows 
                    });
                });
            };

            if (exists && overwrite) {
                db.query(deleteQuery, [tutorId, quizTopic], (err, result) => {
                    if (err) {
                        console.error("Database error:", err);
                        return res.status(500).json({ error: "Failed to delete existing quiz" });
                    }
                    handleInsert();
                });
            } else {
                handleInsert();
            }
        });
    });
};

