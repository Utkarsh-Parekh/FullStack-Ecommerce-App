const mongoose = require('mongoose');

const productSchema = mongoose.Schema({
    productName : {
        type:String,
        required: true,
        trim: true
    },

    productDescription:{
        type:String,
        required: true,
    
    },
    price:{
        type: Number,
        required: true,
        min: 0
    },
    category:{
        type: String,
    }
})