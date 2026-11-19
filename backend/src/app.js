const express = require('express');
const cors = require('cors');

const authRoutes = require('./routes/auth.routes');
const healthRoutes = require('./routes/health.routes');
const menuRoutes = require('./routes/menu.routes');

const notFound = require('./middleware/notFound');
const errorHandler = require('./middleware/errorHandler');

const app = express();

// Middleware cơ bản
app.use(cors());
app.use(express.json());

// API kiểm tra trạng thái Backend
app.get('/api/health', (req, res) => {
    res.json({
        success: true,
        message: 'Backend API is running'
    });
});

// API xác thực
app.use('/api/auth', authRoutes);

// API quản lý thực đơn
app.use('/api/menus', menuRoutes);

// Xử lý đường dẫn không tồn tại
app.use(notFound);

// Xử lý lỗi
app.use(errorHandler);

module.exports = app;