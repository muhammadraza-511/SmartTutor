module.exports = (io) => {
    io.on('connection', (socket) => {
        console.log('User connected:', socket.id);

        // Join a session (room)
        socket.on('joinSession', (sessionId) => {
            socket.join(sessionId);
            console.log(`User ${socket.id} joined session ${sessionId}`);

            // Notify others in the session
            socket.to(sessionId).emit('userJoined', socket.id);
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
        });
    });
};
