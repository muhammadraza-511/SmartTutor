const path = require('path');
const fs = require('fs');

module.exports = (app, db) => {
  app.post('/parent_approve_tutor_appointed_by_student', (req, res) => {
    const { parentID } = req.body;

    const query = `
      SELECT 
        s.Student_ID, s.Tutor_ID, t.Tutor_Name, t.Tutor_Email, t.Tutor_Number, t.Tutor_Roll_No,
        t.Tutor_ID AS Tutor_ID, tp.tutor_country, tp.tutor_city, tp.tutor_language, tp.tutor_specialization,
        tp.tutor_degree_link, tp.tutor_profile_pic, tp.tutor_degree_name, tp.tutor_experience,
        tp.tutor_teaching_fee, tp.tutor_teaches_subject
      FROM student_approve_tutor_status_table AS s
      JOIN tutor_table AS t ON s.Tutor_ID = t.Tutor_ID
      JOIN tutor_profile_data_table AS tp ON s.Tutor_ID = tp.Tutor_ID
      WHERE s.parent_approving_status = 'pending' AND s.Parent_ID = ?
    `;

    db.query(query, [parentID], (err, results) => {
      if (err) {
        console.error("Error fetching tutors for approval:", err);
        return res.status(500).send("Internal server error.");
      }

      if (results.length === 0) {
        return res.status(404).json({ message: "No tutors found for approval." });
      }

      const tutorsWithDetails = results.map(tutor => {
        const imageFormats = ['.jpg', '.jpeg', '.png'];
        let imagePath = null;
        let degreeLink = null;

        for (const format of imageFormats) {
          const imagePathFile = path.join(__dirname, 'tutor_pic', `${tutor.Tutor_ID}${format}`);
          if (fs.existsSync(imagePathFile)) {
            imagePath = `/tutor_pic/${tutor.Tutor_ID}${format}`;
            break;
          }
        }

        const degreeFormats = ['.pdf'];
        for (const format of degreeFormats) {
          const degreeFilePath = path.join(__dirname, 'tutor_degree', `${tutor.Tutor_ID}${format}`);
          if (fs.existsSync(degreeFilePath)) {
            degreeLink = `/tutor_degree/${tutor.Tutor_ID}${format}`;
            break;
          }
        }

        return {
          ...tutor,
          imagePath,
          degreeLink
        };
      });

      res.json({ tutors: tutorsWithDetails });
    });
  });
};
