const fs = require('fs');
const crypto = require('crypto');

function readSecretFromFile(key) {
  const fileKey = `${key}_FILE`;
  const filePath = process.env[fileKey];

  if (!filePath) {
    return undefined;
  }

  try {
    return fs.readFileSync(filePath, 'utf8').trim();
  } catch (error) {
    throw new Error(`Unable to read ${key} from ${filePath}: ${error.message}`);
  }
}

function getEnvValue(key, fallback = undefined) {
  const fromFile = readSecretFromFile(key);
  if (fromFile !== undefined) {
    return fromFile;
  }

  const directValue = process.env[key];
  if (directValue !== undefined && directValue !== '') {
    return directValue;
  }

  return fallback;
}

function getRequiredEnvValue(key, description = key) {
  const value = getEnvValue(key);
  if (value === undefined || value === '') {
    throw new Error(`${description} is required`);
  }
  return value;
}

function getAllowedOrigins() {
  const configured = getEnvValue('CORS_ALLOWED_ORIGINS', 'http://localhost:3000,http://127.0.0.1:3000');
  return configured
    .split(',')
    .map((origin) => origin.trim())
    .filter(Boolean);
}

function getSessionSecret() {
  const configured = getEnvValue('SESSION_SECRET');
  if (configured) {
    return configured;
  }

  const generated = crypto.randomBytes(32).toString('hex');
  console.warn('SESSION_SECRET was not set. Generated an ephemeral secret for this process.');
  return generated;
}

module.exports = {
  getEnvValue,
  getRequiredEnvValue,
  getAllowedOrigins,
  getSessionSecret,
};
