migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("mxxfon3ot0vkq58")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "6v92jz1q",
    "name": "url",
    "type": "url",
    "required": true,
    "unique": true,
    "options": {
      "exceptDomains": null,
      "onlyDomains": null
    }
  }))

  // update
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "e7tm6yni",
    "name": "desc",
    "type": "text",
    "required": true,
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
  collection.schema.removeField("6v92jz1q")

  // update
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "e7tm6yni",
    "name": "field",
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
})
