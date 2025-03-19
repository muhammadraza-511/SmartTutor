const nodemailer = require("nodemailer");

module.exports = (app, db) => {
  // Create a transporter using your SMTP server settings (Gmail example)
  const transporter = nodemailer.createTransport({
    service: "gmail", // You can use other services (e.g., SendGrid, SMTP server, etc.)
    auth: {
      user: "smarttutor253@gmail.com",
      pass: "pggl mteg guur hcjd", // Your email password or App-specific password for Gmail
    },
  });

  // Tutor creates a community
  app.post("/api/community/create", (req, res) => {
    const { name, description, subject, tutorId } = req.body;

    // Check if a community with the same name already exists
    const checkSql = "SELECT COUNT(*) AS count FROM communities WHERE name = ?";
    db.query(checkSql, [name], (err, results) => {
      if (err) {
        console.error(err);
        return res
          .status(500)
          .send({ error: "Failed to check existing communities" });
      }

      if (results[0].count > 0) {
        return res
          .status(400)
          .send({ error: "A community with this name already exists." });
      }

      // Insert the new community if no duplicate name is found
      const insertSql =
        'INSERT INTO communities (name, description, subject, created_by, status) VALUES (?, ?, ?, ?, "pending")';
      db.query(
        insertSql,
        [name, description, subject, tutorId],
        (err, results) => {
          if (err) {
            console.error(err);
            return res
              .status(500)
              .send({ error: "Failed to create community" });
          }
          res.status(200).send({
            message: "Community created successfully and is pending approval.",
          });
        }
      );
    });
  });

  // Admin approves or rejects a community
  app.post("/api/community/approve", (req, res) => {
    const { communityId, status } = req.body;

    if (!["approved", "rejected"].includes(status)) {
      return res
        .status(400)
        .send({ error: 'Invalid status. Use "approved" or "rejected".' });
    }

    // Fetch community details to get the tutor's email
    const sql = "SELECT * FROM communities WHERE id = ?";
    db.query(sql, [communityId], (err, results) => {
      if (err) {
        console.error(err);
        return res
          .status(500)
          .send({ error: "Failed to fetch community details" });
      }

      if (results.length === 0) {
        return res.status(404).send({ error: "Community not found" });
      }

      const community = results[0];
      const tutorId = community.created_by;

      // Fetch tutor's email address
      const tutorSql = "SELECT Tutor_Email FROM tutor_table WHERE Tutor_ID = ?";
      db.query(tutorSql, [tutorId], (err, tutorResults) => {
        if (err) {
          console.error(err);
          return res
            .status(500)
            .send({ error: "Failed to fetch tutor details" });
        }

        if (tutorResults.length === 0) {
          return res.status(404).send({ error: "Tutor not found" });
        }

        const tutorEmail = tutorResults[0].Tutor_Email;

        // Update community status to approved or rejected
        const updateSql = "UPDATE communities SET status = ? WHERE id = ?";
        db.query(updateSql, [status, communityId], (err, updateResults) => {
          if (err) {
            console.error(err);
            return res
              .status(500)
              .send({ error: "Failed to update community status" });
          }

          // Send email to the tutor about the status
          const mailOptions = {
            from: "smarttutor253@@gmail.com", // Sender address
            to: tutorEmail, // Recipient address (tutor's email)
            subject: "Your Community Status Update", // Subject line
            text: `Hello,\n\nYour community "${community.name}" has been ${status}.\n\nThank you for using our platform!`, // Plain text body
          };

          // Send email
          transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
              console.error(error);
              return res
                .status(500)
                .send({ error: "Failed to send notification email" });
            }

            // Send response back to the admin
            res.status(200).send({
              message: `Community has been ${status}. Email sent to tutor.`,
            });
          });
        });
      });
    });
  });

  // Admin fetches all pending communities
  app.get("/api/community/pending", (req, res) => {
    const sql = 'SELECT * FROM communities WHERE status = "pending"';
    db.query(sql, (err, results) => {
      if (err) {
        console.error(err);
        return res.status(500).send({ error: "Failed to fetch communities" });
      }
      res.status(200).send(results);
    });
  });
  // Search for communities by subject
  app.get("/api/community/search", (req, res) => {
    const { subject } = req.query;

    const sql =
      'SELECT * FROM communities WHERE subject LIKE ? AND status = "approved"';
    db.query(sql, [`%${subject}%`], (err, results) => {
      if (err) {
        console.error(err);
        return res.status(500).send({ error: "Failed to fetch communities" });
      }

      res.status(200).json(results);
    });
  });

  // Student joins a community
  app.post("/api/community/join", (req, res) => {
    const { studentId, communityId } = req.body;

    // Check if the community is approved
    const communitySql =
      'SELECT * FROM communities WHERE id = ? AND status = "approved"';
    db.query(communitySql, [communityId], (err, communityResults) => {
      if (err) {
        console.error(err);
        return res
          .status(500)
          .send({ error: "Failed to fetch community details" });
      }

      if (communityResults.length === 0) {
        return res
          .status(404)
          .send({ error: "Community not found or not approved" });
      }

      // Check if the student has already joined the community
      const checkSql =
        "SELECT * FROM community_members WHERE community_id = ? AND student_id = ?";
      db.query(checkSql, [communityId, studentId], (err, checkResults) => {
        if (err) {
          console.error(err);
          return res.status(500).send({ error: "Failed to check membership" });
        }

        if (checkResults.length > 0) {
          return res
            .status(400)
            .send({ error: "You have already joined this community" });
        }

        // Insert student into the community with joined_at
        const joinSql =
          "INSERT INTO community_members (community_id, student_id, joined_at) VALUES (?, ?, NOW())";
        db.query(joinSql, [communityId, studentId], (err, results) => {
          if (err) {
            console.error(err);
            return res.status(500).send({ error: "Failed to join community" });
          }

          // Fetch student details (email) for sending email notification
          const studentSql = "SELECT * FROM student_table WHERE Student_ID = ?";
          db.query(studentSql, [studentId], (err, studentResults) => {
            if (err) {
              console.error(err);
              return res
                .status(500)
                .send({ error: "Failed to fetch student details" });
            }

            if (studentResults.length === 0) {
              return res.status(404).send({ error: "Student not found" });
            }

            const studentEmail = studentResults[0].Student_Email;
            const studentName = studentResults[0].Student_Name;

            // Send email notification
            const mailOptions = {
              from: "smarttutor253@gmail.com", // Sender address
              to: studentEmail, // Recipient address (student's email)
              subject: "You have joined a community!", // Subject line
              text: `Hello ${studentName},\n\nYou have successfully joined the community: "${communityResults[0].name}".\n\nThank you for using our platform!`, // Plain text body
            };

            transporter.sendMail(mailOptions, (error, info) => {
              if (error) {
                console.error(error);
                return res
                  .status(500)
                  .send({ error: "Failed to send email notification" });
              }

              // Send success response
              res.status(200).send({
                message: "You have successfully joined the community!",
              });
            });
          });
        });
      });
    });
  });

  // Fetch members of a community
  app.get("/api/community/members/:communityId", (req, res) => {
    const { communityId } = req.params;

    const sql = `
        SELECT students.id AS student_id, students.name AS student_name, cm.joined_at
        FROM community_members cm
        JOIN students ON cm.student_id = students.id
        WHERE cm.community_id = ?
    `;
    db.query(sql, [communityId], (err, results) => {
      if (err) {
        console.error(err);
        return res
          .status(500)
          .send({ error: "Failed to fetch community members" });
      }

      res.status(200).json(results);
    });
  });

  // Route: /api/community/joined
  app.get("/api/community/joined", (req, res) => {
    const studentId = req.query.studentId;

    if (!studentId) {
      return res.status(400).json({ error: "Student ID is required." });
    }

    // Query to fetch communities joined by the student
    const query = `
      SELECT c.id, c.name, c.subject, c.description
      FROM communities AS c
      INNER JOIN community_members AS cm ON c.id = cm.community_id
      WHERE cm.student_id = ?
  `;

    db.query(query, [studentId], (err, results) => {
      if (err) {
        console.error("Database error:", err);
        return res.status(500).json({ error: "Database error." });
      }

      res.json(results);
    });
  });
  app.post("/get-communities", (req, res) => {
    const { tutorId } = req.body;

    // Validate the input
    if (!tutorId) {
      return res.status(400).json({ error: "Tutor ID is required." });
    }

    // Query the database to fetch communities created by the tutor
    const query = `
      SELECT id, name, description, subject, status, created_at FROM communities WHERE created_by = ? And status = "approved"`;

    db.query(query, [tutorId], (err, results) => {
      if (err) {
        console.error("Error fetching communities:", err);
        return res.status(500).json({ error: "Internal Server Error" });
      }

      // Send the communities as a response
      if (results.length > 0) {
        res.json({ communities: results });
      } else {
        res.status(404).json({ error: "No communities found for this tutor." });
      }
    });
  });
};
