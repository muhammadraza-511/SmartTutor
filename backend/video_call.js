module.exports = (io, db) => {
    const sessionUsers = {}; // Store active users in sessions

    io.on('connection', (socket) => {
        console.log('User connected:', socket.id);

        socket.on('joinSession', async ({ sessionId, userId, userType }) => {
            socket.join(sessionId);
            console.log(`User ${socket.id} joined session ${sessionId}`);
    
            try {
                let userName = '';
    
                const query = userType === 'tutor'
                    ? 'SELECT Tutor_Name FROM tutor_table WHERE Tutor_ID = ?'
                    : 'SELECT Student_Name FROM student_table WHERE Student_ID = ?';
    
                db.query(query, [userId], (err, results) => {
                    if (err) {
                        console.error("Error fetching user name:", err);
                        return;
                    }
                    if (results.length > 0) {
                        userName = userType === 'tutor' ? results[0].Tutor_Name : results[0].Student_Name;
                    }
    
                    // Store user in session
                    if (!sessionUsers[sessionId]) {
                        sessionUsers[sessionId] = [];
                    }
    
                    sessionUsers[sessionId].push({ socketId: socket.id, userName, userId, userType });
    
                    // Notify all users in the session about the new user
                    io.to(sessionId).emit('userJoined', { userId: socket.id, userName, userType });
    
                    // Send the complete user list to everyone in the session
                    io.to(sessionId).emit('updateUserList', sessionUsers[sessionId]);
    
                    console.log(`Emitted user list for session ${sessionId}:`, sessionUsers[sessionId]);
                });
            } catch (error) {
                console.error("Error fetching user name:", error);
            }
        });
    

        // Forward signaling messages (for WebRTC)
        socket.on('signal', (data) => {
            io.to(data.target).emit('signal', {
                sender: socket.id,
                signal: data.signal
            });
        });

        // Handle user disconnection
        socket.on('disconnect', () => {
            console.log('User disconnected:', socket.id);

            // Remove user from session list
            for (const sessionId in sessionUsers) {
                sessionUsers[sessionId] = sessionUsers[sessionId].filter(user => user.socketId !== socket.id);
                io.to(sessionId).emit('updateUserList', sessionUsers[sessionId]);
                io.to(sessionId).emit('userLeft', socket.id); // Notify other users
            }
        });
    });
};