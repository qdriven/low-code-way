migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("mxxfon3ot0vkq58")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "yt3urzpq",
    "name": "stars",
    "type": "number",
    "required": true,
    "unique": false,
    "options": {
      "min": 0,
      "max": null
    }
  }))

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "qhv17xft",
    "name": "categories",
    "type": "json",
    "required": false,
    "unique": false,
    "options": {}
  }))

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "8ouwwbil",
    "name": "summary",
    "type": "text",
    "required": false,
    "unique": false,
    "options": {
      "min": null,
      "max": null,
      "pattern": ""
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("mxxfon3ot0vkq58")

  // remove
  collection.schema.removeField("yt3urzpq")

  // remove
  collection.schema.removeField("qhv17xft")

  // remove
  collection.schema.removeField("8ouwwbil")

  return dao.saveCollection(collection)
})
