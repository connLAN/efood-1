const express = require('express');
const mysql = require('mysql');
const app = express();

app.use(express.json()); // For parsing application/json

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


// get food 
// Add a category
app.get('/food', (req, res) => {
    const { name } = req.body;
    let sql = `SELECT * FROM food`;
    db.query(sql, (err, result) => {
        if (err) {
            return res.status(500).send(err);
        }
        res.send('Category added...');
    });
});

// Add a category
app.post('/table_category', (req, res) => {
    const { category_name, category_id } = req.body;
    console.log(category_name, category_id);
    let sql = `INSERT INTO table_categories (category_name, category_id) VALUES (?, ?)`;
    db.query(sql, [category_name, category_id], (err, result) => {
        if (err) {
            return res.status(500).send(err);
        }
        console.log(result); // Log the result
        res.send('Category added...');
    });
});

// Get a category
app.get('/table_category/:id', (req, res) => {
    let sql = `SELECT * FROM table_categories WHERE id = ${req.params.id}`;
    db.query(sql, (err, results) => {
        if (err) {
            return res.status(500).send(err);
        }
        res.json(results);
    });
});

// Update a category
app.put('/table_category/:id', (req, res) => {
    const { category_name } = req.body;
    let sql = `UPDATE table_categories SET category_name = '${category_name}' WHERE id = ${req.params.id}`;
    db.query(sql, (err, result) => {
        if (err) {
            return res.status(500).send(err);
        }
        res.send('Category updated...');
    });
});

// // Delete a category by id
// app.delete('/table_category/:id', (req, res) => {
//     let sql = `DELETE FROM table_categories WHERE id = ${req.params.id}`;
//     db.query(sql, (err, result) => {
//         if (err) {
//             return res.status(500).send(err);
//         }
//         res.send('Category deleted...');
//     });
// });


// Delete a category by category_id
app.delete('/table_category/', (req, res) => {
    const { category_id } = req.body;
    console.log(category_id);

    let sql = `DELETE FROM table_categories WHERE category_id = '${category_id}'`;
    db.query(sql, (err, result) => {
        if (err) {
            return res.status(500).send(err);
        }
        res.send(`Category ${category_id} deleted...`);
    });
});


const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT} ... `);
});