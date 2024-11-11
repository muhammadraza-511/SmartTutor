const express = require('express');
const multer = require('multer');
const path = require('path');
const fs = require('fs'); // To rename the file if needed

const app = express();
const PORT = 3000;

app.use(express.json());

module.exports = (app, db) => {
    // Set up storage for file uploads
    const storage = multer.diskStorage({
        destination: function (req, file, cb) {
            cb(null, 'tutor_degree'); // Folder for storing uploaded files
        },
        filename: function (req, file, cb) {
            cb(null, `${Date.now()}-${file.originalname}`); // Temporary filename
        }
    });

    const upload = multer({ storage: storage });

    // Route to handle profile creation data and file upload
    app.post('/api/tutor_profile_creation', upload.single('degree_upload'), (req, res) => {
        const profileData = req.body;
        const { email, roll_number, country, city, languages, university, degree_name, degree_type, specialization, start_year, end_year, subject, grade, session_type, self_introduction, teaching_experience, teaching_fee, availability_days, availability_time } = profileData;

        // Validate email and roll number in tutor_table
        db.query(
            'SELECT Tutor_ID FROM tutor_table WHERE Tutor_Email = ? AND Tutor_Roll_No = ?',
            [email, roll_number],
            (error, results) => {
                if (error) {
                    console.error('Database error:', error);
                    return res.status(500).json({ message: 'Server error. Please try again later.' });
                }

                // Check if a matching record is found
                if (results.length === 0) {
                    return res.json({
                        message: 'Please enter a valid email and roll number.',
                        redirect: '/tutor_profile_creation.html'
                    });
                }

                // If match is found, get Tutor_ID and proceed
                const tutorId = results[0].Tutor_ID;
                const uploadedFile = req.file;

                // Define the file name and link
                let degreeLink = null;

                if (uploadedFile) {
                    // New file name with Tutor_ID
                    const newFileName = `${tutorId}${path.extname(uploadedFile.originalname)}`;
                    const newFilePath = path.join(uploadedFile.destination, newFileName);

                    // Rename the file asynchronously
                    fs.rename(uploadedFile.path, newFilePath, (err) => {
                        if (err) {
                            console.error('File rename error:', err);
                            return res.status(500).json({ message: 'Error saving file.' });
                        }

                        // Store the new file name (not the full path) in the database
                        degreeLink = newFileName;
                        console.log("File uploaded and renamed to:", newFileName);

                        // After renaming the file, continue with the insertion or update process
                        insertOrUpdateProfileData(tutorId, profileData, degreeLink, res);
                    });
                } else {
                    // If no file is uploaded, just insert or update profile data without the file link
                    insertOrUpdateProfileData(tutorId, profileData, degreeLink, res);
                }
            }
        );
    });

    function insertOrUpdateProfileData(tutorId, profileData, degreeLink, res) {
        const { email, roll_number, country, city, languages, university, degree_name, degree_type, specialization, start_year, end_year, subject, grade, session_type, self_introduction, teaching_experience, teaching_fee, availability_days, availability_time } = profileData;

        // Check if data for the Tutor_ID already exists in tutor_profile_data_table
        const checkQuery = 'SELECT * FROM tutor_profile_data_table WHERE Tutor_ID = ?';
        db.query(checkQuery, [tutorId], (err, existingData) => {
            if (err) {
                console.error('Database check error:', err);
                return res.status(500).json({ message: 'Error checking existing data.' });
            }

            // If data exists, perform UPDATE, otherwise INSERT
            const query = existingData.length > 0
                ? `UPDATE tutor_profile_data_table SET 
                        tutor_email = ?, tutor_rollno = ?, tutor_country = ?, tutor_city = ?, tutor_language = ?, 
                        tutor_university = ?, tutor_degree_name = ?, tutor_degree_type = ?, tutor_specialization = ?, 
                        tutor_starting_year = ?, tutor_ending_year = ?, tutor_degree_link = ?, tutor_teaches_subject = ?, 
                        tutor_teaches_to_grade = ?, tutor_preferable_session = ?, tutor_introduction = ?, 
                        tutor_experience = ?, tutor_teaching_fee = ?, tutor_availability_days = ?, tutor_availability_time = ?
                    WHERE Tutor_ID = ?`
                : `INSERT INTO tutor_profile_data_table (
                        Tutor_ID, tutor_email, tutor_rollno, tutor_country, tutor_city, tutor_language, tutor_university, 
                        tutor_degree_name, tutor_degree_type, tutor_specialization, tutor_starting_year, tutor_ending_year, 
                        tutor_degree_link, tutor_teaches_subject, tutor_teaches_to_grade, tutor_preferable_session, 
                        tutor_introduction, tutor_experience, tutor_teaching_fee, tutor_availability_days, tutor_availability_time
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;

            const values = [
                email, roll_number, country, city, languages, university, degree_name, degree_type, specialization,
                start_year, end_year, degreeLink, subject, grade, session_type,
                self_introduction, teaching_experience, teaching_fee, availability_days, availability_time, tutorId
            ];

            db.query(query, values, (err, result) => {
                if (err) {
                    console.error('Database insertion/update error:', err);
                    return res.status(500).json({ message: 'Error saving profile data.' });
                }

                // After profile data is inserted/updated, update the status in tutor_profile_status_table
                const updateStatusQuery = 'UPDATE tutor_profile_status_table SET profile_status = ? WHERE Tutor_ID = ?';
                db.query(updateStatusQuery, ['pending', tutorId], (err, statusResult) => {
                    if (err) {
                        console.error('Status update error:', err);
                        return res.status(500).json({ message: 'Error updating profile status.' });
                    }

                    // Redirect to login page after successful operation
                    res.json({
                        message: 'Profile updated successfully, status set to pending. Redirecting to login page...',
                        redirect: '/loginpage.html'
                    });
                });
            });
        });
    }
};

