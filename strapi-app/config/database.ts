import path from 'path';
import type { Core } from '@strapi/strapi';

const config = ({ env }: Core.Config.Shared.ConfigParams): Core.Config.Database => {
  // Determine client: use 'sqlite' for local dev, 'postgres' for production
  const client = env('DATABASE_CLIENT', 'sqlite');

  // Connection configurations
  const connections = {
    postgres: {
      connection: {
        host: env('DATABASE_HOST'),
        port: env.int('DATABASE_PORT', 5432),
        database: env('DATABASE_NAME', 'strapi'),
        user: env('DATABASE_USERNAME', 'strapiuser'),
        password: env('DATABASE_PASSWORD', 'strapi123!'),
        ssl:
          env.bool('DATABASE_SSL', true) && {
            rejectUnauthorized: env.bool('DATABASE_SSL_REJECT_UNAUTHORIZED', true),
          },
        schema: env('DATABASE_SCHEMA', 'public'),
      },
      pool: {
        min: env.int('DATABASE_POOL_MIN', 2),
        max: env.int('DATABASE_POOL_MAX', 10),
      },
    },
    sqlite: {
      connection: {
        filename: path.join(__dirname, '..', '..', env('DATABASE_FILENAME', '.tmp/data.db')),
      },
      useNullAsDefault: true,
    },
  };

  return {
    connection: {
      client,
      ...connections[client],
      acquireConnectionTimeout: env.int('DATABASE_CONNECTION_TIMEOUT', 60000),
    },
  };
};

export default config;
