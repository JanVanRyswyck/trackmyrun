{
   "_id": "_design/shoes",
   "_rev": "3-decd6dea1dc265adcf4898e5ba8e23eb",
   "language": "javascript",
   "views": {
       "inUse": {
            "map": "function (document) {
                if (document.type === 'shoe' && document.inUse) {              
                    return emit(document._id, document);            
                }          
            }"
       }
   }
}