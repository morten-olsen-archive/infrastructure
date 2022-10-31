import fastify from 'fastify';
import Container from 'typedi';
import { attachSecurity } from './security';

const createServer = async () => {
  const server = fastify({ logger: false });
  attachSecurity(server, {
    sharedSecret: 'secret',
  });
  await server.ready();
  return server;
};

const start = async () => {
  const server = await createServer();
  await server.listen({
    port: 3000,
  });
};

start().catch((err) => {
  console.error(err);
  process.exit(1);
});
