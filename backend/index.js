const express = require('express');
const app = express();
const dotenv = require('dotenv').config();
const cors = require("cors");
const {authDB,productsDB} = require('./src/config/dbConnection');

app.use(cors());

const PORT = process.env.PORT || 5001;

app.use(express.json());

const userRoutes = require('./src/routes/userRoutes');
app.use('/api/v1/auth',userRoutes);

app.get('/', (req, res) => {
    res.send('Server is running!');
});


app.listen(PORT,() => {
    console.log(`App running on port ${PORT}`);
})