const jwt = require('jsonwebtoken');

const authMiddleware = (req,res,next) => {

    let token;

    let authHeader = req.headers.Authorization || req.headers.authorization;

    
    if(authHeader || authHeader.startsWith("Bearer")){
        token = authHeader.split(" ")[1];

        if(!token){
            res.status(401).json({
                message: "Missing Token...Autherization Failed"
            })
        }
        try {
           const decoded = jwt.verify(
            token,
            process.env.JWT_ACCESS_SECRET
           ) 

           req.user = decoded;
           next()
        } catch (error) {
             res.status(401).json({
                message: "Token is Expired"
            })
        }


    }
   
}


module.exports = authMiddleware;