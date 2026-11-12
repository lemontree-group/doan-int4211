const notFound = (req, res, next) => {
    res.status(404).json({
        success: false,
        message: `API không tồn tại: ${req.originalUrl}`
    });
};

module.exports = notFound;