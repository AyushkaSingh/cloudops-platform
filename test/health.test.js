const { test } = require("node:test");
const assert = require("node:assert");
const request = require("supertest");
const app = require("../server");

test("GET /health should return healthy status", async () => {
    const response = await request(app).get("/health");

    assert.strictEqual(response.statusCode, 200);
    assert.strictEqual(response.body.status, "healthy");
});