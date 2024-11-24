const nodemailer = require('nodemailer'); // Include nodemailer

module.exports = (app, db) => {
  app.post('/update_tutor_status', (req, res) => {
    const { tutorID, parentID, action } = req.body;

    if (action !== 'accept' && action !== 'reject') {
      return res.status(400).json({ success: false, message: "Invalid action" });
    }

    const newStatus = action === 'accept' ? 'approved' : 'rejected';

    // Setup the email transporter outside the queries
    const transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: {
        user: 'smarttutor253@gmail.com',
        pass: 'pggl mteg guur hcjd' // Replace with your actual password or use an environment variable
      }
    });

    if (action === 'accept') {
      // Fetch Student_ID and Parent details from parent_table for the given Parent_ID
      const studentIDQuery = `
        SELECT Student_ID, Parent_Email, Parent_Roll_No FROM parent_table WHERE Parent_ID = ?
      `;
      
      db.query(studentIDQuery, [parentID], (err, results) => {
        if (err || results.length === 0) {
          console.error("Error fetching Student_ID:", err);
          return res.status(500).json({ success: false, message: "Failed to fetch Student_ID" });
        }

        const studentID = results[0].Student_ID; // Get Student_ID
        const parentEmail = results[0].Parent_Email;
        const parentRollNo = results[0].Parent_Roll_No;

        // // Insert into the assigned_tutors_record_table when the tutor is accepted
        // const insertQuery = `
        //   INSERT INTO assigned_tutors_record_table (Student_ID, Parent_ID, Tutor_ID)
        //   VALUES (?, ?, ?)
        // `;
        
        // db.query(insertQuery, [studentID, parentID, tutorID], (err, result) => {
        //   if (err) {
        //     console.error("Error inserting into assigned_tutors_record_table:", err);
        //     return res.status(500).json({ success: false, message: "Failed to assign tutor" });
        //   }

          // Fetch Tutor details for email
          const tutorEmailQuery = `
            SELECT Tutor_Email, Tutor_Name FROM tutor_table WHERE Tutor_ID = ?
          `;
          
          db.query(tutorEmailQuery, [tutorID], (err, results) => {
            if (err || results.length === 0) {
              console.error("Error retrieving tutor email:", err);
              return res.status(500).json({ success: false, message: "Failed to retrieve tutor email" });
            }

            const tutorEmail = results[0].Tutor_Email;
            const tutorName = results[0].Tutor_Name;

            // Fetch Student details from student_table for email to tutor
            const studentQuery = `
              SELECT Student_Name, Student_roll_No, Student_Email FROM student_table WHERE Student_ID = ?
            `;
            
            db.query(studentQuery, [studentID], (err, results) => {
              if (err || results.length === 0) {
                console.error("Error fetching student details:", err);
                return res.status(500).json({ success: false, message: "Failed to fetch student details" });
              }

              const studentName = results[0].Student_Name;
              const studentRollNo = results[0].Student_roll_No;
              const studentEmail = results[0].Student_Email;

              const mailOptions = {
                from: 'smarttutor253@gmail.com',
                to: tutorEmail,
                subject: 'Tutor Appointment Confirmation',
                text: `Dear ${tutorName}, \n\nYou have been appointed to tutor ${studentName} (Roll No: ${studentRollNo}).\n\nParent's Details:\nParent Roll No: ${parentRollNo}\nParent Email: ${parentEmail}\n\nBest regards,\nSmartTutor Team`
              };

              transporter.sendMail(mailOptions, (err, info) => {
                if (err) {
                  console.error("Error sending email:", err);
                } else {
                  console.log("Email sent:", info.response);
                }
              });
            });
          });
        });
      
    }

    // Update status in student_approve_tutor_status_table
    const query = `
      UPDATE student_approve_tutor_status_table
      SET parent_approving_status = ?
      WHERE Tutor_ID = ? AND Parent_ID = ?
    `;

    db.query(query, [newStatus, tutorID, parentID], (err, result) => {
      if (err) {
        console.error("Error updating tutor status:", err);
        return res.status(500).json({ success: false, message: "Failed to update status" });
      }

      if (action === 'reject') {
        // Fetch Student_ID from parent_table based on Parent_ID for rejection email
        const studentIDQuery = `
          SELECT Student_ID FROM parent_table WHERE Parent_ID = ?
        `;
        
        db.query(studentIDQuery, [parentID], (err, results) => {
          if (err || results.length === 0) {
            console.error("Error fetching Student_ID:", err);
            return res.status(500).json({ success: false, message: "Failed to fetch Student_ID" });
          }

          const studentID = results[0].Student_ID; // Get the Student_ID

          // Delete from student_approve_tutor_status_table if rejected
          const deleteQuery = `
            DELETE FROM student_approve_tutor_status_table
            WHERE Tutor_ID = ? AND Parent_ID = ?
          `;
          
          db.query(deleteQuery, [tutorID, parentID], (err, result) => {
            if (err) {
              console.error("Error deleting from student_approve_tutor_status_table:", err);
              return res.status(500).json({ success: false, message: "Failed to delete record" });
            }

            // Send email to the student about rejection
            const studentEmailQuery = `
              SELECT Student_Email FROM student_table WHERE Student_ID = ?
            `;
            
            db.query(studentEmailQuery, [studentID], (err, results) => {
              if (err || results.length === 0) {
                console.error("Error retrieving student email:", err);
                return res.status(500).json({ success: false, message: "Failed to retrieve student email" });
              }

              const studentEmail = results[0].Student_Email;

              // Fetch rejected tutor's details from tutor_profile_data_table
              const tutorProfileQuery = `
                SELECT * FROM tutor_profile_data_table WHERE Tutor_ID = ?
              `;
              
              db.query(tutorProfileQuery, [tutorID], (err, results) => {
                if (err || results.length === 0) {
                  console.error("Error retrieving tutor profile data:", err);
                  return res.status(500).json({ success: false, message: "Failed to retrieve tutor profile" });
                }

                const tutorProfile = results[0]; // Get tutor profile data
                const tutorDetails = `
                  Tutor Email: ${tutorProfile.tutor_email}
                  Tutor Roll No: ${tutorProfile.tutor_rollno}
                  Country: ${tutorProfile.tutor_country}
                  City: ${tutorProfile.tutor_city}
                  Language: ${tutorProfile.tutor_language}
                  Degree: ${tutorProfile.tutor_degree_name} (${tutorProfile.tutor_degree_type})
                  University: ${tutorProfile.tutor_university}
                  Specialization: ${tutorProfile.tutor_specialization}
                  Experience: ${tutorProfile.tutor_experience}
                  Teaching Fee: ${tutorProfile.tutor_teaching_fee}
                  Availability: ${tutorProfile.tutor_availability_days}, ${tutorProfile.tutor_availability_time}
                `;

                const mailOptions = {
                  from: 'smarttutor253@gmail.com',
                  to: studentEmail,
                  subject: 'Tutor Rejection Notification',
                  text: `Dear Student, \n\nYour parent has rejected the tutor appointment you made. Here are the details of the rejected tutor:\n\n${tutorDetails}\n\nBest regards,\nSmartTutor Team`
                };

                transporter.sendMail(mailOptions, (err, info) => {
                  if (err) {
                    console.error("Error sending email:", err);
                  } else {
                    console.log("Email sent:", info.response);
                  }
                });

                // Respond after the email has been sent
                res.json({ success: true, message: "Tutor rejected and student notified" });
              });
            });
          });
        });
      } else {
        // Respond after the tutor status is updated
        res.json({ success: true, message: `Tutor ${action}ed successfully` });
      }
    });
  });
};
