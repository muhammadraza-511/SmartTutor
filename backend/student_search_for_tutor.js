const path = require('path');
const fs = require('fs');

module.exports = (app, db) => {
  app.post('/student_search_for_tutor', (req, res) => {
    const { subject, availability, price, country, name, language, grade } = req.body;

    let query = `
      SELECT 
        t.Tutor_ID, t.Tutor_Name, t.Tutor_Roll_No, t.Tutor_Email, t.Tutor_Number, 
        tp.tutor_teaches_subject, tp.tutor_experience, tp.tutor_teaching_fee, tp.tutor_availability_days, 
        tp.tutor_introduction, tp.tutor_availability_time, tp.tutor_country, 
        tp.tutor_language, tp.tutor_teaches_to_grade
      FROM tutor_table AS t
      JOIN tutor_profile_data_table AS tp ON t.Tutor_ID = tp.Tutor_ID
      JOIN tutor_profile_status_table AS s ON t.Tutor_ID = s.Tutor_ID
      WHERE s.profile_status = 'accepted'
    `;
    const queryParams = [];

    if (name) {
      query += ` AND t.Tutor_Name LIKE ?`;
      queryParams.push(`%${name}%`);
    }

    if (subject) {
      query += ` AND FIND_IN_SET(?, REPLACE(tp.tutor_teaches_subject, ' ', ''))`;
      queryParams.push(subject);
    }

    if (availability && availability !== 'Anytime') {
      query += ` AND FIND_IN_SET(?, REPLACE(tp.tutor_availability_time, ' ', ''))`;
      queryParams.push(availability);
    }

    if (price) {
      query += ` AND tp.tutor_teaching_fee BETWEEN ? AND ?`;
      queryParams.push(price - 1000, +price + 1000);
    }

    if (country) {
      query += ` AND tp.tutor_country = ?`;
      queryParams.push(country);
    }

    if (language) {
      query += ` AND FIND_IN_SET(?, REPLACE(tp.tutor_language, ' ', ''))`;
      queryParams.push(language);
    }

    if (grade) {
      query += ` AND FIND_IN_SET(?, REPLACE(tp.tutor_teaches_to_grade, ' ', ''))`;
      queryParams.push(grade);
    }

    db.query(query, queryParams, (err, results) => {
      if (err) {
        console.error('Error fetching tutors:', err);
        return res.status(500).send('Internal server error.');
      }

      if (results.length === 0) {
        return res.status(404).send('No tutors found for the given criteria.');
      }

      const tutorsWithImages = results.map((tutor) => {
        const imageFormats = ['.jpg', '.jpeg', '.png'];
        let imagePath = null;

        for (const format of imageFormats) {
          const potentialPath = path.join(__dirname, 'tutor_pic', `${tutor.Tutor_ID}${format}`);
          if (fs.existsSync(potentialPath)) {
            imagePath = `/tutor_pic/${tutor.Tutor_ID}${format}`;
            break;
          }
        }

        return { ...tutor, imagePath };
      });

      res.json({ tutors: tutorsWithImages });
    });
  });

  
};
