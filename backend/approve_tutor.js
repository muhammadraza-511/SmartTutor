const path = require("path");
const fs = require("fs");
const nodemailer = require("nodemailer"); // Import Nodemailer

module.exports = (app, db) => {
  app.post("/approve_tutor", (req, res) => {
    const { tutorID, studentID } = req.body;

    const checkQuery = `
      SELECT * 
      FROM student_approve_tutor_status_table 
      WHERE Student_ID = ? AND Tutor_ID = ?
    `;
    db.query(checkQuery, [studentID, tutorID], (checkErr, checkResults) => {
      if (checkErr) {
        console.error("Error checking approval status:", checkErr);
        return res.status(500).json({ message: "Server error." });
      }

      if (checkResults.length > 0) {
        return res
          .status(400)
          .json({ message: "You have already approved this tutor." });
      }

      const parentIDQuery = `
        SELECT Parent_ID 
        FROM parent_table 
        WHERE Student_ID = ?
      `;
      db.query(parentIDQuery, [studentID], (parentErr, parentResults) => {
        if (parentErr) {
          console.error("Error fetching Parent ID:", parentErr);
          return res.status(500).json({ message: "Server error." });
        }

        const parentID =
          parentResults.length > 0 ? parentResults[0].Parent_ID : null;

        if (!parentID) {
          return res
            .status(404)
            .json({ message: "Parent information not found." });
        }

        const insertQuery = `
          INSERT INTO student_approve_tutor_status_table 
          (Student_ID, student_approving_status, Parent_ID, parent_approving_status, Tutor_ID) 
          VALUES (?, 'approved', ?, 'pending', ?)
        `;
        db.query(insertQuery, [studentID, parentID, tutorID], (insertErr) => {
          if (insertErr) {
            console.error("Error inserting approval:", insertErr);
            return res.status(500).json({ message: "Server error." });
          }

          const fetchParentEmailQuery = `
            SELECT Parent_Email 
            FROM parent_table 
            WHERE Parent_ID = ?
          `;
          db.query(
            fetchParentEmailQuery,
            [parentID],
            (emailErr, emailResults) => {
              if (emailErr) {
                console.error("Error fetching parent email:", emailErr);
                return res.status(500).json({ message: "Server error." });
              }

              if (emailResults.length === 0) {
                return res
                  .status(404)
                  .json({ message: "Parent email not found." });
              }

              const parentEmail = emailResults[0].Parent_Email;

              // Send Email using Nodemailer
              const transporter = nodemailer.createTransport({
                service: "gmail", // Use your email provider
                auth: {
                  user: "smarttutor253@gmail.com", // Replace with your email
                  pass: "pggl mteg guur hcjd", // Replace with your email password
                },
              });

              const mailOptions = {
                from: "smarttutor253@gmail.com", // Sender address
                to: parentEmail, // Parent email
                subject: "Your Child Has Approved a Tutor",
                text: `
Dear Parent,

We are pleased to inform you that your child has approved a tutor for assistance. Kindly review the details and approve the tutor at your earliest convenience.

Best regards,
SmartTutor Team`,
                html: `
<p>Dear Parent,</p>
<p>We are pleased to inform you that your child has approved a tutor for assistance. Kindly review the details and approve the tutor at your earliest convenience.</p>
<p>Best regards,</p>
<p><strong>SmartTutor Team</strong></p>`,
              };

              transporter.sendMail(mailOptions, (emailErr, info) => {
                if (emailErr) {
                  console.error("Error sending email:", emailErr);
                  return res
                    .status(500)
                    .json({ message: "Tutor approved, but email not sent." });
                }

                console.log("Email sent: " + info.response);
                return res.json({
                  message:
                    "Tutor approved successfully. Notification email sent to parent.",
                });
              });
            }
          );
        });
      });
    });
  });
};
