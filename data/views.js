// *********************************************************************
// Shoes
// *********************************************************************
{
   "_id": "_design/shoes",
   "_rev": "4-526c00b7c1f8f8e06e21db43f82999af",
   "language": "javascript",
   "views": {
      "all": {
          "map": "function (document) {\n    if (document.type === 'shoe') {\n        emit([document.user, document.purchaseDate], document);\n    }\n}"
      },
      "inUse": {
          "map": "function (document) {\n    if (document.type === 'shoe' && document.inUse) {\n        emit([document.user, document.purchaseDate], document);\n    }\n}"
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
      "runCountPerYear": {
          "map": "function(document) {\n    if(document.type === 'run') {\n        var date = new Date(document.date);\n        emit([document.user, date.getFullYear()], document._id);\n    }\n}",
          "reduce": "function(keys, values, rereduce) {\n  return values.length;\n}"
      },
      "runsByYear": {
          "map": "function(document) {\n    if(document.type === 'run') {\n\tvar date = new  Date(document.date);\n\temit([document.user, date], document);\n    }\n  \t\n}"
      },
      "runsForShoes": {
          "map": "function(document) {\n    if(document.type === 'run') {\n\temit([document.user, document.shoes], document);\n    }\n}"
       }
   }
}

// *********************************************************************
// Options
// *********************************************************************
{
   "_id": "_design/options",
   "_rev": "1-592e40e3b3e6d4302aede1d4f37c8e57",
   "language": "javascript",
   "views": {
       "all": {
           "map": "function(document) {\n  if(document.type === 'options')  \t\n    emit([document.user, document._id], document);\n}"
       }
   }
}

// *********************************************************************
// Users
// *********************************************************************
{
   "_id": "_design/users",
   "_rev": "1-dfd98898fdcf061822396d4fe419ae77",
   "language": "javascript",
   "views": {
       "usersByName": {
           "map": "function(document) {\n  if(document.type === 'user')\n    emit([document.name, document.authority], document);\n}"
       }
   }
}