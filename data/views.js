// *********************************************************************
// Shoes
// *********************************************************************
{
   "_id": "_design/shoes",
   "_rev": "4-526c00b7c1f8f8e06e21db43f82999af",
   "language": "javascript",
   "views": {
       "inUse": {
           "map": "function (document) {\n            if (document.type === 'shoe' && document.inUse) {\n              return emit(document._id, document);\n            }\n          }"
       }
   }
}

// *********************************************************************
// Runs
// *********************************************************************
{
   "_id": "_design/runs",
   "_rev": "4-8219b5ad9367ad3c7b40dbe6d72dc503",
   "language": "javascript",
   "views": {
       "numberPerYear": {
           "map": "function(document) {\n    if(document.type === 'run') {\n        var date = new Date(document.date);\n        emit(date.getFullYear(), document._id);\n    }\n}",
           "reduce": "function(keys, values, rereduce) {\n  return values.length;\n}"
       }
   }
}