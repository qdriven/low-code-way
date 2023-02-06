migrate((db) => {
  const collection = new Collection({
    "id": "mxxfon3ot0vkq58",
    "created": "2023-02-01 06:16:01.945Z",
    "updated": "2023-02-01 06:16:01.945Z",
    "name": "repositories",
    "type": "base",
    "system": false,
    "schema": [
      {
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
      }
    ],
    "listRule": null,
    "viewRule": null,
    "createRule": null,
    "updateRule": null,
    "deleteRule": null,
    "options": {}
  });

  return Dao(db).saveCollection(collection);
}, (db) => {
  const dao = new Dao(db);
  const collection = dao.findCollectionByNameOrId("mxxfon3ot0vkq58");

  return dao.deleteCollection(collection);
})
