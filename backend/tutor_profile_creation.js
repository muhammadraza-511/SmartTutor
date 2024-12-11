const express = require('express');
const multer = require('multer');
const path = require('path');
const fs = require('fs');

const app = express();
const PORT = 3000;

app.use(express.json());

module.exports = (app, db) => {
    // Set up storage for degree and profile picture file uploads
    const storage = multer.diskStorage({
        destination: function (req, file, cb) {
            const isDegreeFile = file.fieldname === 'degree_upload';
            const folderPath = isDegreeFile ? 'tutor_degree' : 'tutor_pic';
            cb(null, folderPath);
        },
        filename: function (req, file, cb) {
            cb(null, `${Date.now()}-${file.originalname}`); // Temporary filename
        }
    });

    const upload = multer({ storage: storage });

    // Route to handle profile creation data and file uploads
    app.post('/api/tutor_profile_creation', upload.fields([{ name: 'degree_upload' }, { name: 'profile_picture' }]), (req, res) => {
        const profileData = req.body;

        const {
            email,
            roll_number,
            country,
            city,
            languages,
            university,
            degree_name,
            degree_type,
            specialization,
            start_year,
            end_year,
            subjects, // Comma-separated subjects from client-side
            grades,   // Comma-separated grades from client-side
            session_type,
            self_introduction,
            teaching_experience,
            teaching_fee,
            availability_days,
            availability_time,
        } = profileData;

        // Validate email and roll number in tutor_table
        db.query(
            'SELECT Tutor_ID FROM tutor_table WHERE Tutor_Email = ? AND Tutor_Roll_No = ?',
            [email, roll_number],
            (error, results) => {
                if (error) {
                    console.error('Database error:', error);
                    return res.status(500).json({ message: 'Server error. Please try again later.' });
                }

                if (results.length === 0) {
                    return res.json({
                        message: 'Please enter a valid email and roll number.',
                        redirect: '/tutor_profile_creation.html'
                    });
                }

                const tutorId = results[0].Tutor_ID;
                const uploadedDegreeFile = req.files['degree_upload'] ? req.files['degree_upload'][0] : null;
                const uploadedProfilePic = req.files['profile_picture'] ? req.files['profile_picture'][0] : null;

                // Define file names and links, initially set to null
                let degreeLink = null;
                let profilePicLink = null;

                const renameAndInsertData = () => {
                    // Insert data after renaming files
                    insertProfileData(tutorId, profileData, degreeLink, profilePicLink, res);
                };

                // Rename degree file if it exists
                if (uploadedDegreeFile) {
                    const newDegreeFileName = `${tutorId}${path.extname(uploadedDegreeFile.originalname)}`;
                    const newDegreeFilePath = path.join(uploadedDegreeFile.destination, newDegreeFileName);

                    fs.rename(uploadedDegreeFile.path, newDegreeFilePath, (err) => {
                        if (err) {
                            console.error('File rename error for degree:', err);
                            return res.status(500).json({ message: 'Error saving degree file.' });
                        }
                        degreeLink = newDegreeFileName;
                        console.log("Degree file uploaded and renamed to:", newDegreeFileName);

                        // Check if both files are renamed before inserting data
                        if (!uploadedProfilePic || profilePicLink) {
                            renameAndInsertData();
                        }
                    });
                } else {
                    degreeLink = null;
                }

                // Rename profile picture file if it exists
                if (uploadedProfilePic) {
                    const newProfilePicFileName = `${tutorId}${path.extname(uploadedProfilePic.originalname)}`;
                    const newProfilePicFilePath = path.join(uploadedProfilePic.destination, newProfilePicFileName);

                    fs.rename(uploadedProfilePic.path, newProfilePicFilePath, (err) => {
                        if (err) {
                            console.error('File rename error for profile picture:', err);
                            return res.status(500).json({ message: 'Error saving profile picture file.' });
                        }
                        profilePicLink = newProfilePicFileName;
                        console.log("Profile picture uploaded and renamed to:", newProfilePicFileName);

                        // Check if both files are renamed before inserting data
                        if (!uploadedDegreeFile || degreeLink) {
                            renameAndInsertData();
                        }
                    });
                } else {
                    profilePicLink = null;
                }

                // If no files were uploaded, proceed with insertion
                if (!uploadedDegreeFile && !uploadedProfilePic) {
                    renameAndInsertData();
                }
            }
        );
    });

    function insertProfileData(tutorId, profileData, degreeLink, profilePicLink, res) {
        const {
            email,
            roll_number,
            country,
            city,
            languages,
            university,
            degree_name,
            degree_type,
            specialization,
            start_year,
            end_year,
            subjects, // Comma-separated subjects
            grades,   // Comma-separated grades
            session_type,
            self_introduction,
            teaching_experience,
            teaching_fee,
            availability_days,
            availability_time,
        } = profileData;

        const deleteQuery = 'DELETE FROM tutor_profile_data_table WHERE Tutor_ID = ?';
        db.query(deleteQuery, [tutorId], (deleteErr, deleteResult) => {
            if (deleteErr) {
                console.error('Database deletion error:', deleteErr);
                return res.status(500).json({ message: 'Error deleting existing profile data.' });
            }

            const insertQuery = `
                INSERT INTO tutor_profile_data_table (
                    Tutor_ID, tutor_email, tutor_rollno, tutor_country, tutor_city, tutor_language, tutor_university, 
                    tutor_degree_name, tutor_degree_type, tutor_specialization, tutor_starting_year, tutor_ending_year, 
                    tutor_degree_link, tutor_teaches_subject, tutor_teaches_to_grade, tutor_preferable_session, 
                    tutor_introduction, tutor_experience, tutor_teaching_fee, tutor_availability_days, 
                    tutor_availability_time, tutor_profile_pic
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;

            const values = [
                tutorId,
                email,
                roll_number,
                country,
                city,
                languages,
                university,
                degree_name,
                degree_type,
                specialization,
                start_year,
                end_year,
                degreeLink,
                subjects, // Pass as-is (already comma-separated)
                grades,   // Pass as-is (already comma-separated)
                session_type,
                self_introduction,
                teaching_experience,
                teaching_fee,
                availability_days,
                availability_time,
                profilePicLink,
            ];

            db.query(insertQuery, values, (err, result) => {
                if (err) {
                    console.error('Database insertion error:', err);
                    return res.status(500).json({ message: 'Error saving profile data.' });
                }

                const updateStatusQuery = 'UPDATE tutor_profile_status_table SET profile_status = ? WHERE Tutor_ID = ?';
                db.query(updateStatusQuery, ['pending', tutorId], (err, statusResult) => {
                    if (err) {
                        console.error('Status update error:', err);
                        return res.status(500).json({ message: 'Error updating profile status.' });
                    }

                    res.json({
                        message: 'Profile created successfully, status set to pending. Redirecting to login page...',
                        redirect: '/loginpage.html',
                    });
                });
            });
        });
    }
};
