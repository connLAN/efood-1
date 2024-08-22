const express = require('express');
const router = express.Router();
const mysql = require('mysql');

// Database connection
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'demo'
});

db.connect((err) => {
    if (err) {
        throw err;
    }
    console.log('MySQL Connected...');
});

// Middleware to log request information
router.use((req, res, next) => {
    console.log(`Request Method: ${req.method}`);
    console.log(`Request URL: ${req.url}`);
    console.log(`Request Headers: ${JSON.stringify(req.headers)}`);
    if (req.method === 'POST' || req.method === 'PUT') {
        console.log(`Request Body: ${JSON.stringify(req.body)}`);
    }
    next();
});

// Get a category
router.get('/table_category/:id', (req, res) => {
    let sql = `SELECT * FROM table_categories WHERE id = ${req.params.id}`;
    db.query(sql, (err, results) => {
        if (err) {
            return res.status(500).send(err);
        }
        res.json(results);

        console.log('res:', res);
    });
});

// Get all categories
router.get('/table_category_all', (req, res) => {
    let sql = `SELECT * FROM table_categories`;
    console.log(`Executing SQL: ${sql}`); // Log the SQL query
    db.query(sql, (err, results) => {
        if (err) {
            console.error(`SQL Error: ${err.sqlMessage}`); // Log the SQL error
            return res.status(500).send(err);
        }
        res.json(results);
    });
});

module.exports = router;