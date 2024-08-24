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

// Update category status
router.put('/update_category_status', (req, res) => {
    const { category_id, is_active } = req.body;
    let sql = `UPDATE table_categories SET is_active = ? WHERE category_id = ?`;
    console.log(`Executing SQL: ${sql}`); // Log the SQL query
    console.log(`Parameters: is_active = ${is_active}, category_id = ${category_id}`); // Log the parameters
    db.query(sql, [is_active, category_id], (err, results) => {
        if (err) {
            console.error(`SQL Error: ${err.sqlMessage}`); // Log the SQL error
            return res.status(500).send(err);
        }
        res.json(results);
    });
});

// Add a category
router.post('/add_category', (req, res) => {
    const { category_name, category_id, is_active } = req.body;
    let sql = `INSERT INTO table_categories (category_name, category_id, is_active) VALUES (?, ?, ?)`;
    console.log(`Executing SQL: ${sql}`); // Log the SQL query
    db.query(sql, [category_name, category_id, is_active], (err, results) => {
        if (err) {
            console.error(`SQL Error: ${err.sqlMessage}`); // Log the SQL error
            return res.status(500).send(err);
        }
        res.json(results);
    });
});





// tables related functions
// Get all tables
router.get('/tables_all', (req, res) => {
    let sql = `SELECT * FROM tables`;
    console.log(`Executing SQL: ${sql}`); // Log the SQL query
    db.query(sql, (err, results) => {
        if (err) {
            console.error(`SQL Error: ${err.sqlMessage}`); // Log the SQL error
            return res.status(500).send(err);
        }
        res.json(results);
    });
});


// Get a table
router.get('/table/:id', (req, res) => {
    let sql = `SELECT * FROM tables WHERE id = ${req.params.id}`;
    db.query(sql, (err, results) => {
        if (err) {
            return res.status(500).send(err);
        }
        res.json(results);
    });
});

// Update table status
router.put('/update_table_status', (req, res) => {
    const { table_id, is_active } = req.body;
    let sql = `UPDATE tables SET is_active = ? WHERE table_id = ?`;
    console.log(`Executing SQL: ${sql}`); // Log the SQL query
    console.log(`Parameters: is_active = ${is_active}, table_id = ${table_id}`); // Log the parameters
    db.query(sql, [is_active, table_id], (err, results) => {
        if (err) {
            console.error(`SQL Error: ${err.sqlMessage}`); // Log the SQL error
            return res.status(500).send(err);
        }
        res.json(results);
    });
});


// add a table
router.post('/add_table', (req, res) => {
    const { name, status } = req.body;
    let sql = `INSERT INTO tables (table_name, table_id, is_active) VALUES (?, ?, ?)`;
    console.log(`Executing SQL: ${sql}`); // Log the SQL query
    db.query(sql, [name, status], (err, results) => {
        if (err) {
            console.error(`SQL Error: ${err.sqlMessage}`); // Log the SQL error
            return res.status(500).send(err);
        }
        res.json(results);
    });
});






module.exports = router;