const { CosmosClient } = require("@azure/cosmos");

let cached;

function required(name) {
  const value = process.env[name];
  if (!value) {
    throw new Error(`Missing required setting: ${name}`);
  }
  return value;
}

function containers() {
  if (cached) return cached;

  const client = new CosmosClient({
    endpoint: required("COSMOS_ENDPOINT"),
    key: required("COSMOS_KEY")
  });

  const database = client.database(required("COSMOS_DATABASE"));
  cached = {
    stations: database.container(required("COSMOS_CONTAINER_STATIONS")),
    quadrats: database.container(required("COSMOS_CONTAINER_QUADRATS")),
    syncEvents: database.container(required("COSMOS_CONTAINER_SYNC"))
  };

  return cached;
}

function nowIso() {
  return new Date().toISOString();
}

function withMetadata(item, fallback) {
  const timestamp = nowIso();
  return {
    ...fallback,
    ...item,
    createdAt: item.createdAt || timestamp,
    updatedAt: timestamp
  };
}

async function queryAll(container, querySpec) {
  const { resources } = await container.items.query(querySpec).fetchAll();
  return resources;
}

async function upsertMany(container, items) {
  const results = [];
  for (const item of items) {
    const { resource } = await container.items.upsert(item);
    results.push(resource);
  }
  return results;
}

module.exports = {
  containers,
  nowIso,
  queryAll,
  upsertMany,
  withMetadata
};
