const express = require('express');
const cors = require('cors');

const healthRoutes = require('./routes/health.routes');
const notFound = require('./middleware/notFound');
const errorHandler = require('./middleware/errorHandler');

const app = express();

app.use(cors());
app.use(express.json());

// API Routes
app.use('/api/health', healthRoutes);

// Xử lý API không tồn tại
app.use(notFound);

// Xử lý lỗi máy chủ
app.use(errorHandler);

module.exports = app;